# 2026-01-13T20:41:53.351491800
import vitis

client = vitis.create_client()
client.set_workspace(path="Proiect")

platform = client.get_component(name="platforma_semafor")
status = platform.build()

comp = client.get_component(name="SmartLightTraffic_App")
comp.build()

vitis.dispose()

