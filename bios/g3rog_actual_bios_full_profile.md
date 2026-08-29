# g3ROG-ACTUAL - BIOS Restore Snapshot (2026-04-15)

**Board**: ASUS ROG STRIX B650E-F  
**CPU**: Ryzen 7 9800X3D  
**Memory**: 64GB DDR5-6000 CL30 (EXPO I)

---

## Summary

This file reflects the BIOS profile that was restored after the March 11, 2026 BIOS update.
The settings below are based on the exported `20260415-bios-set_setting.txt` snapshot and should be treated as the current restored profile, not a hypothetical tuning wishlist.

---

## Restore Context

- Backup files were saved before the BIOS update as `.CMO` and `.CMOS`.
- After the BIOS update, the saved profile was restored and then verified against the text export.
- This document focuses on the most meaningful restored settings for public documentation.

---

## CPU / PBO / Thermals

- `Precision Boost Overdrive`: `Advanced`
- `PBO Limits`: `Manual`
- `PPT / TDC / EDC`: `162000 / 120000 / 180000`
- `CPU Boost Clock Override`: `+200 MHz`
- `Curve Optimizer`: `All Cores`, negative `10`
- `Platform Thermal Throttle Limit`: `85 C`
- `ASUS Performance Enhancement`: `Enabled`
- `Turbo Game Mode`: `Enabled`

---

## Memory / Fabric

- `Ai Overclock Tuner`: `EXPO I`
- `EXPO`: `DDR5-6000 30-36-36-76`
- `Memory Frequency`: `DDR5-6000MHz`
- `FCLK Frequency`: `2000 MHz`
- `Memory Context Restore`: `Enabled`
- `CPU SOC Voltage Override`: `1.20000`
- `DRAM VDD / VDDQ`: `1.35000 / 1.35000`

---

## Boot / PCIe

- `Resize BAR Support`: `Enabled`
- `Launch CSM`: `Disabled`
- `Primary Video Device`: `PCIE Video`
- `PCIEX16_1 Link Mode`: `GEN 4`
- `POST Delay Time`: `1 sec`

---

## USB / Power

- `USB power delivery in Soft Off state (S5)`: `Enabled`
- `ErP Ready`: `Disabled`
- `Native ASPM`: `Disabled`
- `CPU PCIE ASPM Mode Control`: `Disabled`
- `Global C-state Control`: `Enabled`
- `Power Supply Idle Control`: `Typical Current Idle`
- `Thunderbolt/USB4 (Intel JHL8540 controller) Support`: `Enabled`
- `USB4 (ASM4242 Controller) Support`: `Disabled`

---

## Fans

- `CPU Fan Profile`: `Manual`
- `CPU fan curve`: `22% at 20 C`, `40% at 45 C`, `70% at 65 C`, `100% at 70 C`
- `Chassis Fan 1-4 Profile`: `Turbo`
- `AIO Pump Profile`: `Full Speed`

---

## Notes

- This restored profile keeps the aggressive CPU tuning and EXPO memory profile.
- It does not exactly match the older "USB/Power optimized" checklist.
- The most notable differences versus the older note are:
  - `Global C-state Control` is `Enabled`
  - `USB4 (ASM4242 Controller) Support` is `Disabled`
  - `CPU SOC Voltage Override` is `1.20000` instead of `1.25000`
  - `POST Delay Time` is `1 sec`

## Backup Files

- Pre-update backups were exported as `.CMO` and `.CMOS` files on 2026-04-15.
- The text export is the easiest human-readable source for verifying what was restored.
