# 2025-12-11T15:22:16.878809200
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.get_component(name="platforma_semafor")
status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

vitis.dispose()

