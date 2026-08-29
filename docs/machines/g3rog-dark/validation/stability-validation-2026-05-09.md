# G3ROG-DARK Stability Validation

**Purpose:** track validation needed after the 2026-05-09 sanitized AIDA64 source confirmed the corrected SMT / CPU topology state.

## Current Baseline

The latest sanitized report shows G3ROG-DARK broadly healthy at capture time: SMT is working, Secure Boot is enabled, TPM 2.0 is present, the RTX 5090 is linked at PCIe 5.0 x16, report-level SMART status is OK, and major temperatures are reasonable for an idle or light-load snapshot.

This page is intentionally a validation plan, not a claim that every stress test has already passed.

## Validation Matrix

| Area | Tool / method | Status | Notes to capture |
| --- | --- | --- | --- |
| CPU quick sanity | Cinebench | Pending | Score, max CPU package temp, clock behavior |
| CPU + memory hard test | y-cruncher | Pending | Test profile, duration, pass/fail, WHEA events |
| Mixed system load | OCCT | Pending | CPU, memory, PSU/mixed profile, duration |
| Memory profile | MemTest, Karhu, or TM5 class test | Pending | Coverage / cycles, errors, DIMM temps |
| GPU platform behavior | 3DMark | Pending | Score, driver version, PCIe link under load |
| Gaming stability | Long gaming session | Pending | Game, duration, HDR / display behavior |
| Disk thermals | Sustained sequential write test | Pending | T705 temperatures, throttling behavior |
| Monitoring | HWiNFO logging | Pending | CPU-heavy, GPU-heavy, and disk-heavy sessions |

## Baseline Values to Recheck

| Item | Expected from sanitized source |
| --- | --- |
| CPU topology | 8 cores / 16 logical processors |
| Memory | DDR5-6200 CL32-38-38-80 1T |
| RTX 5090 link | PCIe 5.0 x16 @ x16 |
| Storage health | Report-level SMART status OK |
| 2 TB T705 temp snapshot | 53 C |
| 1 TB T705 temp snapshot | 43 C |
| Samsung SATA temp snapshot | 31 C on both drives |
| 10GbE link at capture | 2500 Mbps |

## Watch Items

- Memory stability at DDR5-6200 CL32 1T, especially after cold boots.
- Any WHEA events during CPU, memory, or mixed-load testing.
- T705 Gen5 NVMe temperatures during sustained writes.
- Whether the Samsung 860 EVO C7 CRC Error Count continues increasing.
- Game launch, HDR behavior, and preferred-GPU routing with the mixed iGPU + RTX 5090 display layout.
- RTX 5090 link width during actual GPU load, not just inventory capture.
- 10GbE link negotiation against the real switch, router, or peer device.

## Result Entry Template

Copy this block for each completed validation run.

```md
### YYYY-MM-DD - Test name

- Tool / version:
- Configuration:
- Duration / coverage:
- Result:
- Max CPU package temp:
- Max GPU temp:
- Max NVMe temp:
- WHEA / Event Viewer notes:
- Notes / follow-up:
```
