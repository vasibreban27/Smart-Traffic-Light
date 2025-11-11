# 2025-11-11T17:42:31.111269700
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.create_platform_component(name = "platforma_semafor",hw_design = "$COMPONENT_LOCATION/../Semafor_Inteligent/design_1_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0")

comp = client.create_app_component(name="SmartLightTraffic_App",platform = "$COMPONENT_LOCATION/../platforma_semafor/export/platforma_semafor/platforma_semafor.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

platform = client.get_component(name="platforma_semafor")
status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

status = platform.build()

comp.build()

