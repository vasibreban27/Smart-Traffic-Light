#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xadcps.h"
#include "xgpio.h"
#include "sleep.h"
#include "xparameters.h"
#include "xuartps_hw.h"


#define GPIO_BTNS_ID    XPAR_AXI_GPIO_BTNS_BASEADDR
#define GPIO_SWS_ID     XPAR_AXI_GPIO_SWS_BASEADDR
#define GPIO_LEDS_ID    XPAR_AXI_GPIO_LEDS_BASEADDR
#define GPIO_NS_ID      XPAR_AXI_GPIO_TIME_NS_BASEADDR
#define GPIO_EW_ID      XPAR_AXI_GPIO_TIME_EW_BASEADDR
#define XADC_DEVICE_ID  0
#define HISTORY_SIZE 50

// canale XADC (VAUX14 si VAUX7 pentru Pmod JA pe Zybo)
#define XADC_CH_POT1    (1 << 30) // Canal 30
#define XADC_CH_POT2    (1 << 23) // Canal 23

XAdcPs xadc;
XGpio gpio_btns, gpio_sws, gpio_leds, gpio_time_ns, gpio_time_ew;


int val_leds, val_btns, val_sws;
int timp_ns, timp_ew;
int status;
int history_ew[HISTORY_SIZE];
int history_ns[HISTORY_SIZE];
int idx_ns=0,idx_ew = 0;
int mod = 0;

//functie de calcul timp - daca is conectati pinii la gnd
// int calculeaza_timp(int valoare_raw) {
//     // valoare_raw vine intre 0 si 4095 de la potentiometru  
//     int t_min = 5;  
//     int t_max = 31; 

//     // 4095 / 157 = 26 (adica max 26 peste t_min)
//     int secunde_extra = valoare_raw / 157;

//     int timp_final = t_min + secunde_extra;

//     if (timp_final > t_max) {
//         timp_final = t_max;
//     }

//     return timp_final;
// }

void init_history(){
    for(int i=0; i<HISTORY_SIZE; i++){
        history_ew[i] = 2000;//valoare medie raw de la potentiometru
        history_ns[i] = 2000; 
    }
}

int history_algo(int current_raw, int *history, int *idx){
    history[*idx] = current_raw;
    *idx = (*idx + 1) % HISTORY_SIZE; //buffer circular

    long sum = 0;
    for(int i=0; i<HISTORY_SIZE; i++){
        sum = sum + history[i];
    }
    int average = (int)(sum / HISTORY_SIZE);

    int smart_time = (current_raw * 2 + average * 8) / 10; //20% timpul curent si 80% istoric
    return smart_time;
}

void interractive_menu(){
    if(XUartPs_IsReceiveData(STDIN_BASEADDRESS)){
        char c = inbyte();
        printf("\r\n COMANDA PRIMITA: %c",c);

        switch(c){
            case '0':
                mod = 0;
                printf(">> MOD ACTIVAT: DIRECT FUZZY (Raw Input).\r\n");
                printf("   Descriere: Senzorul merge direct la Fuzzy_Accelerator(Hardware).\r\n");
                break;

            case '1':
                mod = 1;
                printf(">> MOD ACTIVAT: SMART FUZZY (Predictiv/Istoric).\r\n");
                printf("   Descriere: Semaforul foloseste media istorica pentru stabilitate.\r\n");
                break;
            
            case 'r':
                init_history();
                printf(">> ISTORIC RESETAT la valorile implicite.\r\n");
                break;

            default:
                printf("Meniu:\r\n");
                printf("  [0] - Mod DIRECT FUZZY(Potentiometru simplu)\r\n");
                printf("  [1] - Mod SMART FUZZY (Algoritm cu Istoric)\r\n");
                printf("  [r] - Resetare Istoric Trafic\r\n");
                break;
        }
        printf("---------------------------\r\n");
    }
}

int estimeaza_timp_fuzzy(int x) {
    return 5 + (x / 157); // aproximare liniara
}

int main()
{
    init_platform();

    //dezactivam buffering-ul la printf ca sa apara textul instant
    setvbuf(stdout, NULL, _IONBF, 0);

    init_history();
    print("---Start Semafor Inteligent---\n");
    print("Apasa '0' pentru Mod Direct, '1' pentru Mod Smart\n\r");

    int status;

    XGpio_Initialize(&gpio_btns, GPIO_BTNS_ID);
    XGpio_Initialize(&gpio_sws, GPIO_SWS_ID);
    XGpio_Initialize(&gpio_leds, GPIO_LEDS_ID);
    XGpio_Initialize(&gpio_time_ns, GPIO_NS_ID);
    XGpio_Initialize(&gpio_time_ew, GPIO_EW_ID);


    XGpio_SetDataDirection(&gpio_btns, 1, 0xFF); //input
    XGpio_SetDataDirection(&gpio_sws, 1, 0xFF);  //input
    
  
    XGpio_SetDataDirection(&gpio_leds, 1, 0xFF); //input -> in ps doar citesc starea ledurilor

    XGpio_SetDataDirection(&gpio_time_ns, 1, 0x00); //output
    XGpio_SetDataDirection(&gpio_time_ew, 1, 0x00); //output


    // initializare xadc
    XAdcPs_Config *xadc_cfg = XAdcPs_LookupConfig(XADC_DEVICE_ID);
    if( NULL == xadc_cfg)
    {
         print("Configuratia a crapat \n\r");
         return XST_FAILURE;
    }

    status = XAdcPs_CfgInitialize(&xadc, xadc_cfg, xadc_cfg->BaseAddress);
    if(status != XST_SUCCESS) 
    {
          print("Statusul a crapat \n\r");
          return XST_FAILURE;
    }   
    XAdcPs_SetSequencerMode(&xadc, XADCPS_SEQ_MODE_CONTINPASS);
    XAdcPs_SetSeqChEnables(&xadc, XADC_CH_POT1 | XADC_CH_POT2);

    int mem_ns_raw = 0;
    int mem_ew_raw = 0;
    while(1){

        interractive_menu();

        //citire potentiometre 0-4095
        int raw_pot1 = XAdcPs_GetAdcData(&xadc, 30); // vaux14
        //int raw_pot2 = XAdcPs_GetAdcData(&xadc, 23); // vaux7
        
        int pot_corrected = 4095 - raw_pot1;
        if (pot_corrected < 0) pot_corrected = 0;

        //citire valoare switch pt potentiometru
        val_sws = XGpio_DiscreteRead(&gpio_sws,1);
        int is_sw_up = (val_sws & 0x02);        
        // calculare timpi
        //timp_ns = calculeaza_timp(raw_pot1);
        //timp_ew = calculeaza_timp(raw_pot2);
        //int timp_curent = calculeaza_timp(raw_pot1);
       // int timp_final_ns, timp_final_ew;


        if (is_sw_up == 0) {
            mem_ns_raw = pot_corrected;
            // mem_ew ramane neschimbat
        } 
        else {
            mem_ew_raw = pot_corrected;
            // mem_ns ramane neschimbat
        }

        //timp_ns = mem_ns;
        //timp_ew = mem_ew;


        int data_to_fpga_ns, data_to_fpga_ew;

        if (mod == 1) {
            // MOD SMART: Software-ul filtreaza zgomotul (Istoric)
            // Apoi trimite valoarea "curata" la Acceleratorul Fuzzy
            data_to_fpga_ns = history_algo(mem_ns_raw, history_ns, &idx_ns);
            data_to_fpga_ew = history_algo(mem_ew_raw, history_ew, &idx_ew);
        } else {
            // MOD DIRECT: Software-ul e doar "fir". Trimite direct la Accelerator.
            data_to_fpga_ns = mem_ns_raw;
            data_to_fpga_ew = mem_ew_raw;
            
            // Update fundal
            history_algo(mem_ns_raw, history_ns, &idx_ns);
            history_algo(mem_ew_raw, history_ew, &idx_ew);
        }

        // trimit timpi catre partea de pl
        XGpio_DiscreteWrite(&gpio_time_ns, 1, data_to_fpga_ns);
        XGpio_DiscreteWrite(&gpio_time_ew, 1, data_to_fpga_ew);

        // citire leduri, sw, btn
        val_leds = XGpio_DiscreteRead(&gpio_leds, 1);
        val_btns = XGpio_DiscreteRead(&gpio_btns, 1);
        //val_sws  = XGpio_DiscreteRead(&gpio_sws, 1);
        
        //afisare valori o data la 1.5 secunde
        static int counter = 0;
        if (counter++ > 15) { 
            //char *stare_noapte = (val_sws & 0x01) ? "(NIGHT)" : "";
            char *directie = (is_sw_up == 0) ? "[EDIT: NS]" : "[EDIT: EW]";
            char *mode_str = (mod == 1) ? "HW+SMART" : "HW DIRECT";
            
            // NOTA: "Time Est" este doar o estimare software pt display.
            // Timpul REAL este calculat in FPGA si nu il putem citi inapoi usor.
            int est_ns = estimeaza_timp_fuzzy(data_to_fpga_ns);
            int est_ew = estimeaza_timp_fuzzy(data_to_fpga_ew);

            printf("%s [%s] InputFPGA_NS:%4d (~%2ds) | InputFPGA_EW:%4d (~%2ds) | LED:0x%X\r\n", 
                   directie, mode_str,
                   data_to_fpga_ns, est_ns, 
                   data_to_fpga_ew, est_ew,
                   val_leds);
            
            counter = 0;
        }

        usleep(100000);
    }
    
    cleanup_platform();
    return 0;
}