# G3ROG-DARK BIOS Settings

**Build:** G3ROG-DARK
**Board:** ASUS ROG Crosshair X870E Dark Hero
**BIOS:** AMI UEFI 0804, dated 2026-04-09
**AGESA:** ComboAm5PI 1.3.0.1
**Source:** sanitized AIDA64 Report `AIDA64-Report-20260509_v2`

## Current Confirmed State

| Setting / capability | Confirmed state |
| --- | --- |
| UEFI boot | Enabled |
| Secure Boot | Enabled |
| TPM | TPM 2.0 present, AMD vendor reported |
| SMT | Restored to Auto / enabled; OS sees 16 logical processors |
| CPU topology | Ryzen 7 9850X3D, 8 cores / 16 logical processors |
| Memory profile | DDR5-6200 effective |
| Primary memory timings | CL32-38-38-80, command rate 1T |
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

The current runtime memory profile is DDR5-6200 CL32-38-38-80 1T. This is above the kit's nominal DDR5-6000 profile and should be treated as a tuned configuration that needs long-session validation rather than a guaranteed default.

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
- Capture a new sanitized BIOS profile export after future tuning changes.
