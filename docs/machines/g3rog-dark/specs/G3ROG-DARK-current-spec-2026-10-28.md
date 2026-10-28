# G3ROG-DARK Current Spec

**Snapshot date:** 2026-10-28

**Source:** live Windows inventory plus the verified firmware, driver, servicing, and health-maintenance session completed on the snapshot date

**Privacy posture:** public, share-safe summary; hostnames, account names, addresses, device identifiers, and raw logs are intentionally omitted

## Executive Summary

G3ROG-DARK remains the active AM5 flagship: an ASUS ROG Crosshair X870E Dark Hero, AMD Ryzen 7 9850X3D, ASUS ROG Astral RTX 5090 White, 64 GB of Corsair DDR5, dual Crucial T705 Gen5 NVMe drives, and paired Samsung 860 EVO SATA SSDs.

The October maintenance pass updated the board to BIOS 1103 and AMD Chipset Software 8.09.28.1124, refreshed the NVIDIA, WSL, developer-tool, and application baselines, repaired and cleaned the Windows component store, and verified that all present Plug and Play devices and physical disks report healthy. The RTX 5090 remains the primary GPU; the integrated AMD Radeon adapter remains enabled for part of the multi-monitor layout.

## Current Platform

| Component | Confirmed detail |
| --- | --- |
| CPU | AMD Ryzen 7 9850X3D, 8 cores / 16 logical processors |
| Motherboard | ASUS ROG Crosshair X870E Dark Hero |
| Chipset | AMD X870E; AMD Chipset Software 8.09.28.1124 |
| BIOS | ASUS / American Megatrends 1103, firmware date 2026-09-18; installed and profile-restored 2026-10-28 |
| Memory | 64 GB Corsair Dominator Titanium DDR5; May baseline observed at DDR5-6200 CL32-38-38-80 1T |
| Discrete GPU | ASUS ROG Astral GeForce RTX 5090 O32G White, primary rendering GPU |
| Integrated GPU | AMD Radeon(TM) Graphics, enabled and driving part of the monitor layout |
| Storage | Crucial T705 2 TB, Crucial T705 1 TB, 2 x Samsung 860 EVO 2 TB |
| Network | Realtek PCIe 10GbE controller, currently linked at 2.5 Gbps as expected for the 2 Gbps service path |
| OS | Windows 11 Enterprise, build 26300.9711 |
| Power profile | Ultimate Performance |

## Graphics and Driver State

| Item | Verified state |
| --- | --- |
| NVIDIA driver | 32.0.16.2101 / 621.01 |
| AMD Radeon driver | 32.0.21042.62 |
| RTX 5090 status | Device OK; primary GPU |
| AMD iGPU status | Device OK; retained for the mixed-GPU display layout |
| RTX 5090 link | PCIe 5.0 x16 @ x16 in the latest platform validation |

AMD's generic Radeon installer did not consider the integrated GPU eligible for replacement during the October audit, so the compatible board/OEM display driver was retained. This is intentional and is not an unresolved failed update.

## Storage and Platform Health

| Check | 2026-10-28 result |
| --- | --- |
| Present Plug and Play devices | All reported OK |
| Physical disks | All reported Healthy / OK |
| SSD TRIM | Enabled |
| Windows Update | No available updates at final scan |
| System file verification | SFC found no integrity violations |
| Windows component store | Repaired successfully; final DISM check found no corruption |
| Component cleanup | Actual component-store size reduced from 17.27 GB to 11.81 GB |
| Hardware error log | No WHEA hardware-error events found in the reviewed window |
| Crash dumps | No system memory dump or minidump backlog found |

The maintenance pass did not use registry cleaners, blanket filesystem compression, or forced generic drivers. Windows reported that CompactOS would not benefit this system.

## Software and Virtualization Notes

- Windows Subsystem for Linux is current at 2.7.14.0.
- Ubuntu is the sole retained WSL distribution and remains the default WSL 2 environment.
- The retired Kali WSL distribution and its Store package were removed, reclaiming approximately 29.84 GB.
- SteelSeries GG/Sonar/Prism, Corsair iCUE, Elgato Stream Deck, and Logitech G HUB remain required parts of the active peripheral stack.

## Historical Baseline and Remaining Validation

The May 2026 AIDA64-derived documents remain the detailed thermal, timing, and sensor baseline. This October snapshot supersedes them only for current firmware, drivers, software, health, and operating-state claims.

Long-duration stress validation remains separate from this maintenance gate:

- extended DDR5-6200 cold-boot and memory testing;
- sustained CPU and mixed-load testing;
- RTX 5090 link and temperature validation under load;
- sustained T705 write-temperature testing;
- monitoring of the historical Samsung SATA CRC counter;
- game, HDR, and preferred-GPU behavior across the mixed iGPU + RTX 5090 display layout.

## Related Documents

- [Machine page](../README.md)
- [BIOS settings](../bios-settings.md)
- [Stability validation plan](../validation/stability-validation-2026-05-09.md)
- [May 2026 AIDA64 source-of-truth spec](G3ROG-DARK-current-spec-2026-05-09.md)
- [AIDA64 source and privacy notes](../../../aida64/README.md)
