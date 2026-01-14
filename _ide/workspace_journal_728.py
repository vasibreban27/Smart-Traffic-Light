# 2025-12-03T10:24:17.403635700
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.get_component(name="platforma_semafor")
status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

