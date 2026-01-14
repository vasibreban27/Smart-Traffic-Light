# 2025-11-26T17:07:13.100282400
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.get_component(name="platforma_semafor")
status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

