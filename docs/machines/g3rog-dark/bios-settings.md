# G3ROG-DARK BIOS Settings

**Build:** G3ROG-DARK
**Board:** ASUS ROG Crosshair X870E Dark Hero
**Current BIOS:** AMI UEFI 1103, firmware date 2026-09-18; installed 2026-10-28

**Current source:** live Windows firmware inventory and verified profile-restore workflow

**Detailed settings baseline:** sanitized AIDA64 Report `AIDA64-Report-20260509_v2` from BIOS 0804

## October 2026 Firmware Update

- BIOS 1103 was installed successfully on 2026-10-28.
- The saved BIOS profile was restored from the dedicated USB backup after the update.
- Windows subsequently enumerated the Ryzen 7 9850X3D as 8 cores / 16 logical processors, both display adapters as healthy, and all present Plug and Play devices as OK.
- The RTX 5090 remained the primary GPU while the integrated AMD Radeon adapter continued supporting part of the multi-monitor layout.
- A fresh public AGESA string and full post-update settings export were not captured, so this page does not infer them from the earlier BIOS 0804 report.

## Current Confirmed State

| Setting / capability | Confirmed state |
| --- | --- |
| UEFI boot | Enabled |
| Secure Boot | Enabled |
| TPM | TPM 2.0 present, AMD vendor reported |
| SMT | Restored to Auto / enabled; OS sees 16 logical processors |
| CPU topology | Ryzen 7 9850X3D, 8 cores / 16 logical processors |
| Memory profile | BIOS profile restored; DDR5-6200 was the May 2026 observed baseline |
| Primary memory timings | CL32-38-38-80, command rate 1T in the May 2026 observed baseline |
| GPU link | RTX 5090 at PCIe 5.0 x16 @ x16 |
| Hypervisor flag | Present in CPUID |

## What Changed

The important corrected setting is SMT. A previous BIOS-side configuration left SMT disabled, but the 2026-05-09 sanitized AIDA64 report confirms that SMT is working again: the operating system enumerates CPU #1 through CPU #16 on the 8-core Ryzen 7 9850X3D.

## Boot and Security Notes

- Keep UEFI boot enabled.
- Keep Secure Boot enabled unless a troubleshooting step explicitly requires disabling it.
- Keep TPM 2.0 enabled for Windows 11 platform security features.
- If virtualization features are intentionally used, preserve the current hypervisor-compatible posture and document any future SVM / Hyper-V changes.

## Memory Notes

The May 2026 runtime profile was DDR5-6200 CL32-38-38-80 1T. The saved profile was restored after BIOS 1103, but a new public timing capture was not collected during the October maintenance pass. Treat the May values as the detailed baseline until the next sanitized AIDA64 or HWiNFO capture.

Recommended validation after BIOS changes:

1. Cold boot several times.
2. Run memory-focused validation from [the stability validation plan](validation/stability-validation-2026-05-09.md).
3. Confirm no WHEA events or application crashes appear during normal gaming and workstation use.
4. Recheck DIMM temperatures during extended load.

## Lane and Slot Notes

- RTX 5090 lane state looks correct at PCIe 5.0 x16 @ x16.
- The board inventory reports two PCIe x16 slots and five M.2 slots.
- SMBIOS reports PCIEX16_1 and M.2_1 in use, but the device inventory clearly sees two Gen5 NVMe controllers and two Crucial T705 drives.
- Do not treat the SMBIOS slot list as the final physical M.2 map; verify in BIOS, HWiNFO, or by physical inspection if exact lane routing matters.

## Known BIOS Follow-Ups

- Confirm repeated boots remain normal after the SMT fix.
- Confirm DDR5-6200 CL32 1T is stable across cold boots and long sessions.
- Confirm the RTX 5090 remains at PCIe 5.0 x16 under GPU load.
- Confirm the 10GbE controller negotiates at the intended link rate with the network equipment.
- Capture a new sanitized BIOS/AGESA and memory-timing export for BIOS 1103.
