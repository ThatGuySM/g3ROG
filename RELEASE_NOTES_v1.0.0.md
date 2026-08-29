# 🚀 g3ROG-actual v1.0.0 — Launch

This is the first public release of **g3ROG-actual**, my command-center PC build and its full audit repo.  
This repo will serve as a living record of hardware, benchmarks, health reports, and supporting scripts.

---

## 🔧 Highlights

- **Repo Scaffolding**  
  - Clean `README.md` with system overview and badges  
  - Full folder structure: `docs/`, `assets/`, `scripts/`, `logs/`, `benchmarks/`, `.github/`  
  - Contribution guidelines and MIT License  
  - GitHub Actions CI (`ci.yml`) with lint + validation  
  - Issue and PR templates ready to roll

- **System Health Docs**  
  - PDF + Markdown reports of complete hardware specs  
  - Benchmarks (AIDA64 CPU, FPU, memory)  
  - Thermal + voltage sensor snapshot  
  - Process, autostart, and security overview

- **Branding**  
  - Repo banner (`assets/banner.png`)  
  - Repo name & callsign updated to **g3ROG-actual**

---

## 💻 System Specs

- **CPU**: AMD Ryzen 7 9800X3D (8C/16T, 5.2GHz)  
- **Board**: ASUS ROG Strix B650E-F Gaming WiFi  
- **Memory**: 64GB DDR5-6200 (Corsair Dominator Titanium RGB)  
- **GPU**: NVIDIA GeForce RTX 4090 (23GB VRAM)  
- **Storage**: 7TB total (Crucial T705 NVMe Gen5 + Samsung EVO SSDs)  
- **Network**: Frontier Fiber 2.2Gbps/2.3Gbps  
- **Displays**: 2× LG UltraGear 49” (2024), 2× Sceptre 30” (2019)

---

## 📈 Benchmarks

- **Memory**: 105 GB/s read, 101 GB/s write, 99 GB/s copy, 66 ns latency  
- **CPU**: 1280 MB/s ZLib, 72 GB/s AES, 7900 MB/s SHA3  
- **FPU**: Mandel 43K it/s, FP32 Ray 6700 KRay/s, FP64 Ray 360 KRay/s

---

## 🔒 Security & Health

- Windows 11 Enterprise 24H2, patched through March 2025  
- Windows Defender active & up to date  
- Windows Firewall currently disabled (to review)  
- System sensors: CPU ~47°C, GPU ~33–44°C, NVMe up to 48°C  
- Fans & voltages stable

---

## ✅ Tag Info

- **Tag**: `v1.0.0`  
- **Commit**: Initial commit — repo structure, docs, and audit data

---

👉 Next steps:  

- Monitor workflows in **Actions** (CI badge will reflect status).  
- Expand `docs/` with new health reports as they’re generated.  
- Start tracking scripts, logs, and benchmarks under their folders.
