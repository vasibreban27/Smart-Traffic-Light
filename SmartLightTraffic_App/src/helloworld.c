/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xadcps.h"
#include "xgpio.h"
#include "sleep.h"

XAdcPs xadc; //pentru citire potentiometre
XGpio gpio_btns, gpio_sws, gpio_leds, gpio_time_ns, gpio_time_ew;
int leds,btns,sws;


int main()
{
    init_platform();

    XGpio_Initialize(&gpio_btns,XPAR_AXI_GPIO_BTNS_BASEADDR);
    XGpio_Initialize(&gpio_sws,XPAR_AXI_GPIO_SWS_BASEADDR);
    XGpio_Initialize(&gpio_leds,XPAR_AXI_GPIO_LEDS_BASEADDR);
    XGpio_Initialize(&gpio_time_ns,XPAR_AXI_GPIO_TIME_NS_BASEADDR);
    XGpio_Initialize(&gpio_time_ew,XPAR_AXI_GPIO_TIME_EW_BASEADDR);

    XGpio_SetDataDirection(&gpio_btns,1,0xFF); //pt butoane
    XGpio_SetDataDirection(&gpio_sws,1,0xFF); //switch-uri
    XGpio_SetDataDirection(&gpio_leds,1,0x00); //led-uri

    XGpio_SetDataDirection(&gpio_time_ns,1,0x00); //timpi nord-sud
    XGpio_SetDataDirection(&gpio_time_ew,1,0x00); //timpi est-vest

    print("Semaforul porneste...\n");

    XGpio_DiscreteWrite(&gpio_time_ns, 1, 0x07);   //timpi initial verde pt NS 7 secunde  
    XGpio_DiscreteWrite(&gpio_time_ew, 1, 0x07);   //timpi initial verde pt EW 7 secunde  

    while(1){
        leds =  XGpio_DiscreteRead(&gpio_leds,1);
        printf("Stare LED-uri : 0x%X \n",leds);    //afisare led in hexa    
        
        //btn0 pt simulare pietoni
        XGpio_DiscreteWrite(&gpio_btns, 1, 0x1);
        usleep(200000);
        XGpio_DiscreteWrite(&gpio_btns, 1, 0x0);
        

        usleep(200000);
    }
    
    cleanup_platform();
    return 0;
}
