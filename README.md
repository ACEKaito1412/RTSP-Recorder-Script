# EZVIZ RTSP Recorder (Dynamic IP Support)

This script continuously records an RTSP stream from a compatible IP camera in 15-minute segments, even if the camera's IP address changes within a known subnet. It was designed to make use of an old laptop as a lightweight, always-on recorder—no need for bulky or resource-heavy software.

---

## ✅ Features

- Automatically **scans a subnet** to find the camera if its IP changes  
- Records in **15-minute chunks**, aligned with the hour  
- Uses `ffmpeg` for efficient video encoding  
- Creates output in `$HOME/cctv_recordings`  
- Auto-retries when the camera is temporarily offline  

---

## 🖥️ System Requirements

- Linux system (tested on Ubuntu)  
- [`ffmpeg`](https://ffmpeg.org/) installed  
- `nc` (Netcat) installed  

Install both with:

```bash
sudo apt install ffmpeg netcat
```

## 🔧 Configuration (in ezviz_recorder.sh)

```bash
SUBNET="192.168.1"           # Subnet to scan
START=2                      # Starting host address
END=20                       # Ending host address
PORT=554                     # RTSP port (default for EZVIZ)
USERNAME="admin"             # Camera username
PASSWORD=""                  # Camera password
CHANNEL_PATH="/Streaming/Channels/102"  # Substream path (e.g. /101 or /102)
RECORD_DURATION=900          # 15 minutes = 900 seconds
OUTPUT_DIR="$HOME/cctv_recordings"     # Where files will be saved
```

## 🏃 Usage
Make it executable and run:

```bash
chmod +x ezviz_recorder.sh
./ezviz_recorder.sh
```

It will:

- Scan the IP range 192.168.1.2 to 192.168.1.20

- Connect to the first reachable RTSP stream

- Start recording in 15-minute segments

- Loop continuously, aligning to the top of the hour

## 📁 Output Format
Files will be saved as:

```bash
192_168_1_10_2025-06-08 03:00:00_part_1.mp4
192_168_1_10_2025-06-08 03:00:00_part_2.mp4
...
```

## ⚠️ Notes
- This script assumes only one camera will be active at a time within the given subnet.

- The script loops infinitely and should be run as a background process or service.

### 🪪 License

```css
MIT License

Copyright (c) 2024 ACEKaito1412

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```