import os
from jupyter_server.auth import passwd
psw = os.environ.get("PASSWORD")
if psw:
    psw = f"\nc.ServerApp.password = '{passwd(psw)}'"
else:
    psw = ""
with open("/root/.jupyter/jupyter_lab_config.py","w") as f:
    f.write(f"{psw}\nc.ServerApp.root_dir = '/workspace'")