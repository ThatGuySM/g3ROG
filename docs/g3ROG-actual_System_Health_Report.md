# g3ROG-actual - System Health Report

## Audit Snapshot

- Published snapshot date: 2026-04-16
- Canonical system name: `g3ROG-actual`
- Sources: AIDA64 full report, local Windows audit collection, desktop Speedtest.net result, eero Max 7 gateway test, and restored BIOS profile export
- Status: Published point-in-time snapshot, not live telemetry

## System Summary

- Computer: g3ROG-actual
- Operating system: Microsoft Windows 11 Enterprise 10.0.26200.8246 (Win11 25H2 2025 Update)
- DirectX: 12.0
- User/domain: Redacted for publication review

## CPU and Motherboard

- CPU: OctalCore AMD Ryzen 7 9800X3D, 5425 MHz (54.25 x 100)
- Board: ASUS ROG STRIX B650E-F GAMING WIFI
- Chipset: AMD B650E, AMD K1A.4 FCH, AMD K1A.4 IMC
- BIOS: AMI firmware dated 2026-03-11; board update completed 2026-04-16
- Restore note: The current BIOS profile was restored after the April 16, 2026 update from exported `.CMO` / `.CMOS` backups and checked against the 2026-04-15 settings export

## Memory

- Total: 64 GB installed (AIDA64 reports 63140 MB usable)
- Kit: 2 x 32 GB Corsair CMP64GX5M2B6000Z30
- Effective config: Dual DDR5-6000 at 30-36-36-76 CR1

## Graphics and Displays

- Discrete GPU: NVIDIA GeForce RTX 5090 (32607 MB), Asus ROG-Astral-RTX5090-O32G-White
- Integrated GPU: AMD Radeon(TM) Graphics
- Driver snapshot: NVIDIA 32.0.15.9597, AMD 32.0.21043.5001
- Monitors: 2 x LG UltraGear 49GR85DC-B 49-inch ultrawides, 2 x Sceptre C305B-200UN1 30-inch ultrawides

## Storage

- Internal SSDs: Crucial T705 2 TB, Crucial T705 1 TB, Samsung 860 EVO 2 TB x2
- SMART status: OK
- Formatted local capacity: 6519.8 GB total, 4053.3 GB free
- Removable USB storage was detected during collection and excluded from the primary internal inventory

## Network

- Provider: Frontier
- Active wired link: Intel I225-V Ethernet at 2.5 Gbps
- Desktop speed test: 2347.18 Mbps down / 2224.44 Mbps up
- Router speed test (`eero Max 7 gateway`): 2.36 Gbps down / 2.55 Gbps up
- Ping/location: 6 ms, Secaucus, NJ
- Router timestamp: Tested on April 15, 2026 at 20:17

## Sensors

- CPU: 44 C, CPU Diode 56 C, CPU Package 55 C, CCD #1 40 C
- GPU: RTX 5090 core 38 C, GPU memory 48 C; integrated GPU 39 C / SoC 41 C
- RAM: DIMM2 44 C, DIMM4 43 C
- Storage: CT2000T705SSD3 51 C, CT1000T705SSD3 35 C, Samsung 860 EVO drives 28 C
- Cooling: CPU fan 1076 RPM, Chassis #1 665 RPM, AIO Pump 1737 RPM, RTX 5090 fans 0 RPM (0%)
- Voltages: CPU Core 1.256 V, +3.3 V 3.313 V, +5 V 5.078 V, +12 V 11.922 V

## Benchmarks (AIDA64)

- Memory: Read 63748 MB/s, Write 85000 MB/s, Copy 61203 MB/s, Latency 80.8 ns
- CPU: ZLib 1458.2 MB/s, AES 86596 MB/s, SHA3 5595 MB/s
- FPU: Mandel 120774 it/s, FP32 Ray-Trace 49594 KRay/s, FP64 Ray-Trace 27022 KRay/s

## Observed Resident Apps

- Observed resident apps during capture included Adobe Acrobat/GC sync, AMD Noise Suppression, Corsair iCUE, Logitech G Hub, OneDrive, Slack, Notion, Signal, SteelSeries GG, and Elgato Stream Deck
- Note: This is a runtime/app-presence snapshot, not a startup-folder inventory

## Security

- Windows Update: Latest detected hotfix `KB5086672`, installed 2026-04-08
- Antivirus: Windows Defender 4.18.26030.3011, reported current on 2026-04-15

## BIOS Profile Snapshot

- Memory: EXPO I, DDR5-6000, FCLK 2000 MHz, memory context restore enabled
- PBO: Advanced with manual limits 162000 PPT / 120000 TDC / 180000 EDC
- CPU tuning: +200 MHz boost override, all-core negative curve optimizer of 10, ASUS Performance Enhancement enabled, Turbo Game Mode enabled
- Voltages: CPU SOC override 1.20000 V, DRAM VDD/VDDQ 1.35000 V
- PCIe / boot: Resize BAR enabled, CSM disabled, primary video device set to PCIe video
- Power / platform: ErP disabled, Native ASPM disabled, CPU PCIe ASPM disabled, Global C-state Control enabled, Power Supply Idle Control set to Typical Current Idle
- USB / controller notes: USB power delivery in S5 enabled, Intel Thunderbolt/USB4 controller enabled, ASM4242 USB4 controller disabled in the restored profile

## Final Takeaway

`g3ROG-actual` is currently documented as a high-end gaming and creator battlestation built around a Ryzen 7 9800X3D, RTX 5090, 64 GB of DDR5, and roughly 7 TB of internal SSD storage.

This markdown report is the source of truth for the published April 16, 2026 snapshot, and the PDF export is intended to match it.
