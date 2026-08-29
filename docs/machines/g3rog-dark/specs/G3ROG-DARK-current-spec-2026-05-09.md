# G3ROG-DARK Spec

**Snapshot date:** 2026-05-09
**Source:** sanitized AIDA64 Report `AIDA64-Report-20260509_v2`
**Privacy posture:** repo-safe summary only; raw reports and private identifiers are not published.

## Executive Summary

G3ROG-DARK is the current AM5 flagship build centered on an ASUS ROG Crosshair X870E Dark Hero, an AMD Ryzen 7 9850X3D, an ASUS ROG Astral RTX 5090 White, 64 GB of Corsair DDR5, and a mixed Gen5 NVMe plus SATA SSD storage layout. The 2026-05-09 sanitized AIDA64 source confirms the corrected CPU topology: **8 physical cores / 16 logical processors**, with SMT restored and working.

The platform is running DDR5-6200 CL32 1T, the RTX 5090 is linked at PCIe 5.0 x16, Secure Boot is enabled, TPM 2.0 is present, and report-level SMART status is OK. The main follow-up items are validation tasks rather than current failures: memory stability at DDR5-6200, exact M.2 slot mapping, Samsung SATA CRC counter monitoring, and multi-display GPU attachment behavior.

## Core Hardware

| Component | Confirmed detail |
| --- | --- |
| Build name | G3ROG-DARK |
| CPU | AMD Ryzen 7 9850X3D, Granite Ridge, 8 cores / 16 threads, 120 W TDP |
| Motherboard | ASUS ROG Crosshair X870E Dark Hero, AM5, ATX |
| Chipset | AMD X870E |
| BIOS | AMI UEFI 0804, 2026-04-09, AGESA ComboAm5PI 1.3.0.1 |
| Memory | 64 GB Corsair CMP64GX5M2B6000Z30, 2 x 32 GB, SK hynix DRAM |
| Memory runtime | DDR5-6200, CL32-38-38-80, command rate 1T |
| Discrete GPU | ASUS ROG Astral RTX 5090 White, NVIDIA GB202, 32 GB GDDR7 |
| Integrated GPU | AMD Radeon(TM) Graphics, present and driver-loaded |
| Storage | Crucial T705 2 TB, Crucial T705 1 TB, 2 x Samsung 860 EVO 2 TB SATA SSD |
| Network | MediaTek Wi-Fi 7, Realtek RTL8127 10GbE, Realtek RTL8126 5GbE |
| Displays | 2 x LG UltraGear+ and 2 x Sceptre P30 |
| OS | Windows 11 Enterprise 25H2, build 10.0.26200.8328 |

## Platform Validation Notes

- CPU topology is now correct at **8 cores / 16 logical processors**.
- SMT had previously been disabled in BIOS and is now restored to Auto / enabled.
- UEFI boot and Secure Boot are active.
- TPM 2.0 is present.
- CPUID reports a hypervisor present, consistent with a virtualization-capable Windows environment.
- The report shows both the AMD iGPU and RTX 5090 active, but it does not explicitly map each monitor to a GPU.

## Graphics and Displays

| Item | Detail |
| --- | --- |
| RTX 5090 bus | PCIe 5.0 x16 @ x16 |
| RTX 5090 VRAM | 32 GB GDDR7, 512-bit |
| RTX 5090 memory bandwidth | 1750.1 GB/s reported |
| NVIDIA driver | 32.0.15.9636 / ForceWare 596.36, dated 2026-04-22 |
| AMD iGPU driver | 32.0.21036.18 / Radeon Software 25.10.36, dated 2025-11-11 |
| Runtime desktop snapshot | 5120 x 1440 @ 240 Hz |
| Monitor inventory | Four active logical displays, one primary |

## Storage and PCIe

| Device | Interface | Capacity class | Runtime note |
| --- | --- | ---: | --- |
| Crucial CT2000T705SSD3 | PCIe 5.0 x4 NVMe | 2 TB | Likely system / boot drive; 53 C snapshot |
| Crucial CT1000T705SSD3 | PCIe 5.0 x4 NVMe | 1 TB | Secondary NVMe; 43 C snapshot |
| Samsung SSD 860 EVO | SATA III | 2 TB | Data / auxiliary volume; 31 C snapshot |
| Samsung SSD 860 EVO | SATA III | 2 TB | Data / auxiliary volume; 31 C snapshot |

The report identifies two separate Phison PS5026 PCIe 5.0 x4 NVMe controllers. SMBIOS slot occupancy only marks M.2_1 as in use, so exact M.2 physical placement should be verified in BIOS, HWiNFO, or by physical inspection before relying on a lane-map diagram.

## Thermal Snapshot

These values are point-in-time report readings, not sustained stress-test results.

| Sensor | Reading |
| --- | ---: |
| Motherboard | 37 C |
| CPU | 50 C |
| CPU package | 60 C |
| CPU CCD #1 | 52 C |
| PCH diode #1 / #2 | 58 C / 61 C |
| VRM | 46 C |
| RTX 5090 GPU core | 33 C |
| RTX 5090 memory | 44 C |
| Integrated GPU / SoC | 40 C / 46 C |
| DIMM2 / DIMM4 | 42 C / 41 C |
| Crucial T705 2 TB / 1 TB | 53 C / 43 C |
| Samsung 860 EVO drives | 31 C / 31 C |

## Known Quirks / Verify Later

- Repeated boots should remain normal after the SMT restoration.
- DDR5-6200 CL32 1T needs long-session and cold-boot stability validation.
- Exact M.2 slot mapping needs manual confirmation because SMBIOS does not fully match the detected NVMe inventory.
- The 2 TB T705 should be watched under sustained sequential writes for thermal behavior and throttling margin.
- One Samsung 860 EVO has a high historical SMART C7 CRC Error Count; verify whether the counter is still increasing.
- Confirm the RTX 5090 remains PCIe 5.0 x16 under GPU load.
- Confirm the mixed iGPU + dGPU monitor layout does not affect game launch behavior, HDR behavior, or preferred-GPU selection.
- The 10GbE controller was linked at 2500 Mbps at capture; verify expected negotiation with the actual switch, router, or peer device.

## Related Documents

- [AIDA64 documentation and privacy notes](../../../aida64/README.md)
- [AIDA64 documentation notes](../../../aida64/README.md)
- [BIOS settings](../bios-settings.md)
- [Stability validation plan](../validation/stability-validation-2026-05-09.md)
- [Machine page](../README.md)
