# 2025-12-11T12:00:42.316699
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.get_component(name="platforma_semafor")
status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../Semafor_Inteligent/design_1_wrapper.xsa")

status = platform.build()

vitis.dispose()

vitis.dispose()

