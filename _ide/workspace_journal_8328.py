# 2025-11-22T21:27:24.158980300
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.get_component(name="platforma_semafor")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../Semafor_Inteligent/design_1_wrapper.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

vitis.dispose()

