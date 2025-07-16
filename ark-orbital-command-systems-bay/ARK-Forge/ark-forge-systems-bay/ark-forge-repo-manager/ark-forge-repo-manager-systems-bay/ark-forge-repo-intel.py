#!/usr/bin/env python3
import sys
import json

rom = sys.argv[1]
device = sys.argv[2]
branches = []

# Example data; expand with real device-source scraping as needed
if rom == "device-only":
    # Device-only mode: inventory all device trees, recoveries, etc.
    if device == "waffle":
        branches = [
            {"idx": 1, "branch": "device-waffle-main", "android": "15", "kernel": "5.15", "status": "device-source", "notes": "Stock device tree"},
            {"idx": 2, "branch": "twrp-waffle", "android": "N/A", "kernel": "5.15", "status": "recovery", "notes": "TWRP device tree for testing"},
        ]
    else:
        branches = [
            {"idx": 1, "branch": f"device-{device}-main", "android": "unknown", "kernel": "unknown", "status": "device-source", "notes": "Add more sources"}
        ]
elif rom == "yaap" and device == "waffle":
    branches = [
        {"idx": 1, "branch": "sixteen", "android": "16 (kernel 15)", "kernel": "5.15", "status": "active", "notes": "New branch, kernel not yet Android 16"},
        {"idx": 2, "branch": "fifteen-waffle", "android": "15", "kernel": "5.15", "status": "stable", "notes": "Device-specific"},
        {"idx": 3, "branch": "fifteen", "android": "14", "kernel": "5.15", "status": "legacy", "notes": "Universal"},
    ]
elif rom == "aio" and device == "waffle":
    branches = [
        {"idx": 1, "branch": "main", "android": "14", "kernel": "5.15", "status": "active", "notes": "AIO universal branch"},
    ]
else:
    branches = [{"idx": 1, "branch": "unknown", "android": "unknown", "kernel": "unknown", "status": "unknown", "notes": "No data"}]

print(json.dumps(branches, indent=2))
