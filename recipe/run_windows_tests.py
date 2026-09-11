"""Provide upstream's local TLS 1.3 fixture while running Windows CTest."""
import os
from pathlib import Path
import socket
import subprocess
import sys
import time

root = Path(os.environ['SRC_DIR'])
resources = root / 'tests' / 'resources'
command = [
    sys.executable, '-u', str(root / 'tests' / 'tls_server' / 'tls_server.py'),
    '--port', '59443', '--min-tls', '1.3', '--max-tls', '1.3',
    '--cert', str(resources / 'mtls_server.pem.crt'),
    '--key', str(resources / 'mtls_server.key'),
    '--ca', str(resources / 'mtls_device_root_ca.pem.crt'),
]
with open('tls13-server.log', 'w+', encoding='utf-8') as log:
    server = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT)
    try:
        deadline = time.monotonic() + 30
        while True:
            if server.poll() is not None:
                raise RuntimeError('Upstream TLS server exited before becoming ready')
            try:
                with socket.create_connection(('127.0.0.1', 59443), timeout=1):
                    break
            except OSError:
                if time.monotonic() >= deadline:
                    raise RuntimeError('Upstream TLS server did not become ready')
                time.sleep(0.1)
        result = subprocess.run(['ctest', '--output-on-failure', '-C', 'Release'])
        if server.poll() is not None:
            raise RuntimeError('Upstream TLS server exited during CTest')
        sys.exit(result.returncode)
    finally:
        server.terminate()
        try:
            server.wait(timeout=10)
        except subprocess.TimeoutExpired:
            server.kill()
            server.wait()
        log.seek(0)
        print(log.read())
