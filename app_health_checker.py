#!/usr/bin/env python3
import requests
import sys
from datetime import datetime

# List of applications to check
apps = [
    "https://wisecow.local",  # Example, replace with real URL
]

for url in apps:
    try:
        response = requests.get(url, timeout=5, verify=False)  # verify=False for self-signed certs
        if response.status_code == 200:
            status = "UP"
        else:
            status = f"DOWN (HTTP {response.status_code})"
    except requests.exceptions.RequestException as e:
        status = f"DOWN ({e})"
    
    print(f"[{datetime.now()}] Application {url} is {status}")

