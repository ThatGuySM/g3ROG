# G3ROG-DARK - Actual Detected Spec

Snapshot date: 2026-05-08 showcase baseline, refreshed with 2026-05-09 sanitized AIDA64 source notes
Audience: internal repo reference / maintenance

This page is the markdown companion to the detailed HTML export. It keeps the useful detected hardware facts visible in GitHub without requiring the PDF or HTML view. For the current SMT-confirmed source of truth, see [G3ROG-DARK current spec](G3ROG-DARK-current-spec-2026-05-09.md).

## Live Detected Core Hardware

| Component | Detected detail |
| --- | --- |
| Computer | G3ROG-DARK |
| Operating system | Microsoft Windows 11 Enterprise 10.0.26200.8328, Windows 11 25H2 |
| CPU | AMD Ryzen 7 9850X3D, 8 cores / 16 threads, 4.7 GHz base, up to 5.6 GHz boost, 96 MB L3 cache, 120 W TDP, AM5 |
| Motherboard | ASUS ROG Crosshair X870E Dark Hero, AMD X870E, AM5, ATX |
| BIOS | ASUS / American Megatrends 0804, release date 2026-04-09 |
| GPU | ASUS ROG Astral GeForce RTX 5090 O32G White, 32607 MB VRAM reported by AIDA64 |
| Integrated graphics | AMD Radeon Graphics detected and enabled |
| Memory | 64GB Corsair Dominator Titanium RGB, 2x32GB, SKU CMP64GX5M2B6000Z30 |
| Cooling | ASUS ROG Ryujin III White Edition detected over USB |
| Power supply | Corsair HX1500i Platinum, PSU fan reported 0 RPM in the baseline snapshot |

## Memory

| Field | Detail |
| --- | --- |
| DIMM slots | DIMM2 and DIMM4 populated |
| Installed | 2x 32GB DDR5 |
| Observed profile | DDR5-6200 |
| Active timings | 32-38-38-80, Command Rate 1T, Memory Bus 3100 MHz |
| Rated kit | DDR5-6000 / 6000 MT/s, CL30-36-36-76, 1.40 V, AMD EXPO and Intel XMP capable |

## Storage

| Device | Interface | Role / note |
| --- | --- | --- |
| CT2000T705SSD3 | NVMe / PCIe 5.0 x4 | 2TB Crucial T705, likely OS / high-speed primary volume |
| CT1000T705SSD3 | NVMe / PCIe 5.0 x4 | 1TB Crucial T705, high-speed secondary / scratch / workload drive |
| Samsung SSD 860 EVO 2TB | SATA III | 2TB SATA SSD |
| Samsung SSD 860 EVO 2TB | SATA III | 2TB SATA SSD |

| Volume | Size | Free space |
| --- | --- | --- |
| C: | 1861.9 GB | 1604.7 GB |
| R: | 931.5 GB | 458.0 GB |
| S: | 1863.0 GB | 746.4 GB |
| T: | 1863.0 GB | 1295.2 GB |
| Total | 6519.4 GB | 4104.3 GB |

## Display, Network, and USB

| Area | Detail |
| --- | --- |
| Display adapters | AMD Radeon Graphics plus NVIDIA GeForce RTX 5090 detected |
| Monitors | 2x LG UltraGear+ displays and 2x Sceptre P30 30-inch ultrawides detected |
| Network | Realtek 10GbE active; Realtek 5GbE and MediaTek Wi-Fi 7 also detected |
| USB loadout | Arctis Nova Pro Wireless, SteelSeries Alias Pro, SteelSeries Arena 9, Stream Deck+ dock, Logitech StreamCam, Ryujin III, AURA LED controller, VeriMark IT fingerprint key, multiple hubs, and mass-storage readers |
| Security | VeriMark IT Fingerprint Key detected; Secure Boot enabled and TPM 2.0 present in the 2026-05-09 sanitized source |

## Thermal and Power Baseline

This is not a stress-test result. It is a point-in-time AIDA64 sensor snapshot from the uploaded hardware report. Values below reflect the 2026-05-09 sanitized source refresh.

| Sensor | Reading |
| --- | --- |
| Motherboard | 37 C |
| CPU | 50 C |
| CPU package | 60 C |
| VRM | 46 C |
| RTX 5090 GPU | 33 C |
| RTX 5090 memory | 44 C |
| Crucial T705 2TB | 53 C |
| Crucial T705 1TB | 43 C |
| AIO pump | 3524 RPM |
| RTX 5090 fan #1 / #2 | 619 RPM / 620 RPM |
| Board-estimated system power | 274.02 W |

## Operational Notes

- The uploaded AIDA64 reports are the source of truth for the installed G3ROG-DARK build.
- The old g3ROG-actual spec sheet is now historical and should not be treated as current for this machine.
- SMT is restored to Auto / enabled; the 2026-05-09 sanitized source confirms 8 physical cores and 16 logical processors.
- Memory is running above the kit's original DDR5-6000 spec at DDR5-6200 CL32-38-38-80 1T. Keep stability notes with future updates.
- Exact M.2 physical slot mapping still needs verification because SMBIOS slot occupancy does not fully match the two detected Gen5 NVMe controllers.
- One Samsung 860 EVO has a high historical C7 CRC counter; check whether it is still increasing before treating it as drive failure.
- X870E Dark Hero M.2_2 shares bandwidth with rear USB4 40Gbps ports. Avoid filling that slot unless the tradeoff is intentional.
- Use the proper native high-power GPU cable path for the RTX 5090.
