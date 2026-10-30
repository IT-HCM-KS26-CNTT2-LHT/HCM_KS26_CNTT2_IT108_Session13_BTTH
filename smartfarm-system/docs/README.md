# Hệ thống quản trị SmartFarm

Hệ thống giúp kỹ sư hạ tầng SmartFarm lọc nhật ký (log) máy chủ tự động và quản lý danh sách thiết bị của các trạm cảm biến.

## Cấu trúc thư mục

```text
smartfarm-system/
├── .env                      
├── docs/
│   └── README.md
├── scripts/
│   └── auto_report.ps1
├── data/
│   ├── log-he-thong.log
│   └── quan-ly-thiet-bi.xlsx
└── backup/
    └── bao-cao-su-co.txt
```

## Hướng dẫn chạy script

```powershell
cd ./smartfarm-system/scripts
.\auto_report.ps1

# Nếu bị chặn bởi ExecutionPolicy, chạy lệnh sau:
powershell -ExecutionPolicy Bypass -File .\auto_report.ps1
```

Kết quả được ghi vào `backup/bao-cao-su-co.txt`.

## Checklist kiểm tra thiết bị

- [x] Kiểm tra nguồn điện của trạm cảm biến
- [ ] Kiểm tra kết nối mạng và modem
- [ ] Kiểm tra dung lượng bộ nhớ lưu trữ
- [ ] Kiểm tra pin dự phòng của các trạm

## Bảng thông số phần cứng

| Tên thiết bị | Đơn giá (VNĐ) | Loại storage |
|--------------|--------------:|--------------|
| Raspberry Pi 4 Model B | 1.450.000 | SSD |
| Intel NUC i3 | 6.200.000 | SSD |
| Orange Pi 5 | 2.300.000 | SSD |
| Dell Optiplex Micro | 5.400.000 | HDD |
| Mini PC Fanless N100 | 4.200.000 | SSD |
| Synology DS220j NAS | 3.900.000 | HDD |

## Phân tích hệ thống

### Mô hình IPO của chức năng lọc log

| Thành phần | Nội dung |
|------------|----------|
| **Input** (Đầu vào) | File nhật ký `log-he-thong.log` |
| **Process** (Xử lý) | Đọc file bằng `Get-Content`, lọc các dòng chứa `CRITICAL` hoặc `ERROR` bằng `Select-String`, đếm số dòng lỗi bằng `Measure-Object` |
| **Output** (Đầu ra) | File `bao-cao-su-co.txt` gồm tiêu đề, các dòng lỗi và dòng `TONG SO SU CO:` |

### Phân loại 4 phát biểu theo DIKW

| Phát biểu | Tầng DIKW | Giải thích |
|-----------|-----------|------------|
| (b) "2026-10-12 08:15:01 [ERROR] sensor-03 Connection TIMEOUT after 30s" | **Data** (Dữ liệu) | Một dòng log thô, chưa được xử lý hay giải thích |
| (c) "Hôm nay hệ thống ghi nhận 8 sự cố, trong đó 4 sự cố đến từ trạm sensor-03." | **Information** (Thông tin) | Dữ liệu đã được đếm, tổng hợp và có ngữ cảnh |
| (d) "Trạm sensor-03 hay mất kết nối vào buổi chiều do sóng yếu, nên cần lắp thêm anten." | **Knowledge** (Tri thức) | Rút ra quy luật và nguyên nhân từ thông tin |
| (a) "Quyết định thay modem trạm sensor-03 trước thứ Sáu." | **Wisdom** (Trí tuệ) | Đưa ra quyết định hành động dựa trên hiểu biết |

Thứ tự tăng dần: **Data (b) -> Information (c) -> Knowledge (d) -> Wisdom (a)**.

## Bẫy phần cứng

Đề bài: tải file log 500 MB qua mạng 100 Mbps mất bao lâu?

- Mbps là **megabit** trên giây, còn dung lượng file tính bằng **megabyte (MB)**.
- 1 byte = 8 bit, nên **hệ số quy đổi là 8**.
- Quy đổi tốc độ: 100 Mbps ÷ 8 = **12,5 MB/s**
- Thời gian tải: 500 MB ÷ 12,5 MB/s = **40 giây**

**Kết quả: 40 giây** (trong điều kiện lý tưởng, chưa tính hao hụt đường truyền).
