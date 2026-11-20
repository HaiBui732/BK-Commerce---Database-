CREATE TABLE `Tài khoản` (
  `Mã tài khoản` int PRIMARY KEY AUTO_INCREMENT,
  `Tên đăng nhập` text UNIQUE NOT NULL,
  `Mật khẩu` text NOT NULL,
  `Trạng thái tài khoản` text NOT NULL,
  `Ngày tạo tài khoản` datetime NOT NULL,
  `Đăng nhập gần nhất` datetime
);

CREATE TABLE `Người dùng` (
  `Mã người dùng` int PRIMARY KEY AUTO_INCREMENT,
  `Họ` text NOT NULL,
  `Tên đệm` text,
  `Tên` text NOT NULL,
  `Số điện thoại` text UNIQUE NOT NULL,
  `Email` text UNIQUE NOT NULL,
  `Trạng thái hồ sơ` text NOT NULL,
  `Mã tài khoản` int UNIQUE NOT NULL
);

CREATE TABLE `Khách hàng` (
  `Mã người dùng` int PRIMARY KEY,
  `Điểm khả dụng` int NOT NULL DEFAULT 0,
  `Mã hạng` int NOT NULL
);

CREATE TABLE `Quản trị viên` (
  `Mã người dùng` int PRIMARY KEY
);

CREATE TABLE `Nhân viên chi nhánh` (
  `Mã người dùng` int PRIMARY KEY,
  `Mã chi nhánh` int NOT NULL
);

CREATE TABLE `Hạng hội viên` (
  `Mã hạng` int PRIMARY KEY AUTO_INCREMENT,
  `Tên hạng` text UNIQUE NOT NULL,
  `Mức chi tiêu tối thiểu` decimal NOT NULL,
  `Tỷ lệ tích điểm` decimal NOT NULL
);

CREATE TABLE `Địa chỉ nhận hàng` (
  `Mã địa chỉ` int PRIMARY KEY AUTO_INCREMENT,
  `Mã khách hàng` int NOT NULL,
  `Tên người nhận` text NOT NULL,
  `SDT người nhận` text NOT NULL,
  `Số nhà + đường` text NOT NULL,
  `Phường/Xã` text NOT NULL,
  `Quận/Huyện` text NOT NULL,
  `Tỉnh/TP` text NOT NULL,
  `Trạng thái mặc định` boolean NOT NULL DEFAULT false
);

CREATE TABLE `Giao dịch điểm` (
  `Mã giao dịch điểm` int PRIMARY KEY AUTO_INCREMENT,
  `Mã khách hàng` int NOT NULL,
  `Số điểm thay đổi` int NOT NULL,
  `Thời điểm giao dịch` datetime NOT NULL,
  `Nội dung` text NOT NULL,
  `Loại giao dịch` text NOT NULL,
  `Số dư sau giao dịch` int NOT NULL
);

CREATE TABLE `Chi nhánh` (
  `Mã chi nhánh` int PRIMARY KEY AUTO_INCREMENT,
  `Tên chi nhánh` text NOT NULL,
  `Số nhà + đường` text NOT NULL,
  `Phường/Xã` text NOT NULL,
  `Quận/Huyện` text NOT NULL,
  `Tỉnh/TP` text NOT NULL,
  `SDT hotline` text NOT NULL,
  `Trạng thái hoạt động` text NOT NULL
);

CREATE TABLE `Danh mục` (
  `Mã danh mục` int PRIMARY KEY AUTO_INCREMENT,
  `Mã danh mục cha` int,
  `Tên danh mục` text NOT NULL,
  `Mô tả` text,
  `Trạng thái` text NOT NULL
);

CREATE TABLE `Thương hiệu` (
  `Mã thương hiệu` int PRIMARY KEY AUTO_INCREMENT,
  `Tên thương hiệu` text UNIQUE NOT NULL,
  `Mô tả` text,
  `Trạng thái` text NOT NULL
);

CREATE TABLE `Nhà cung cấp` (
  `Mã nhà cung cấp` int PRIMARY KEY AUTO_INCREMENT,
  `Tên nhà cung cấp` text NOT NULL,
  `SDT` text NOT NULL,
  `Địa chỉ` text NOT NULL,
  `Trạng thái hợp tác` text NOT NULL
);

CREATE TABLE `Sản phẩm` (
  `Mã sản phẩm` int PRIMARY KEY AUTO_INCREMENT,
  `Tên sản phẩm` text NOT NULL,
  `Mô tả` text,
  `Giá cơ sở` decimal NOT NULL,
  `Trạng thái kinh doanh` text NOT NULL
);

CREATE TABLE `Phân loại sản phẩm` (
  `Mã sản phẩm` int,
  `Mã danh mục` int,
  PRIMARY KEY (`Mã sản phẩm`, `Mã danh mục`)
);

CREATE TABLE `Gắn thương hiệu` (
  `Mã thương hiệu` int,
  `Mã sản phẩm` int,
  PRIMARY KEY (`Mã thương hiệu`, `Mã sản phẩm`)
);

CREATE TABLE `Cung cấp` (
  `Mã nhà cung cấp` int,
  `Mã sản phẩm` int,
  PRIMARY KEY (`Mã nhà cung cấp`, `Mã sản phẩm`)
);

CREATE TABLE `Hình ảnh sản phẩm` (
  `Mã sản phẩm` int,
  `Hình ảnh sản phẩm` text,
  PRIMARY KEY (`Mã sản phẩm`, `Hình ảnh sản phẩm`)
);

CREATE TABLE `Biến thể sản phẩm` (
  `Mã biến thể` int PRIMARY KEY AUTO_INCREMENT,
  `Mã sản phẩm` int NOT NULL,
  `Màu sắc` text,
  `Kết quả xử lý` text,
  `Dung lượng` text,
  `Kích thước` text,
  `Giá bán` decimal NOT NULL,
  `Trạng thái khả dụng` text NOT NULL
);

CREATE TABLE `Tồn kho` (
  `Mã chi nhánh` int,
  `Mã biến thể` int,
  `Số lượng tồn` int NOT NULL DEFAULT 0,
  `Cập nhật gần nhất` datetime,
  PRIMARY KEY (`Mã chi nhánh`, `Mã biến thể`)
);

CREATE TABLE `Giỏ hàng` (
  `Mã giỏ hàng` int PRIMARY KEY AUTO_INCREMENT,
  `Mã khách hàng` int UNIQUE NOT NULL,
  `Ngày tạo` datetime NOT NULL,
  `Cập nhật gần nhất` datetime,
  `Trạng thái` text NOT NULL
);

CREATE TABLE `Chi tiết giỏ hàng` (
  `Mã giỏ hàng` int,
  `Mã biến thể` int,
  `Số lượng` int NOT NULL,
  `Trạng thái lựa chọn` boolean NOT NULL DEFAULT true,
  PRIMARY KEY (`Mã giỏ hàng`, `Mã biến thể`)
);

CREATE TABLE `Đơn hàng` (
  `Mã đơn hàng` int PRIMARY KEY AUTO_INCREMENT,
  `Mã khách hàng` int NOT NULL,
  `Mã chi nhánh` int NOT NULL,
  `Ngày đặt hàng` datetime NOT NULL,
  `Trạng thái hiện tại` text NOT NULL,
  `Phương thức thanh toán` text NOT NULL,
  `Phí vận chuyển` decimal NOT NULL DEFAULT 0,
  `Tên người nhận` text NOT NULL,
  `SDT` text NOT NULL,
  `Số nhà + đường` text NOT NULL,
  `Phường/Xã` text NOT NULL,
  `Quận/Huyện` text NOT NULL,
  `Tỉnh/TP` text NOT NULL
);

CREATE TABLE `Chi tiết đơn hàng` (
  `Mã đơn hàng` int,
  `Số thứ tự dòng` int,
  `Mã biến thể` int NOT NULL,
  `Số lượng` int NOT NULL,
  `Đơn giá lúc mua` decimal NOT NULL,
  `Số tiền giảm` decimal NOT NULL DEFAULT 0,
  PRIMARY KEY (`Mã đơn hàng`, `Số thứ tự dòng`)
);

CREATE TABLE `Lịch sử trạng thái đơn hàng` (
  `Mã đơn hàng` int,
  `Thời điểm cập nhật` datetime,
  `Trạng thái` text NOT NULL,
  `Ghi chú` text,
  `Mã nhân viên` int,
  PRIMARY KEY (`Mã đơn hàng`, `Thời điểm cập nhật`)
);

CREATE TABLE `Đánh giá` (
  `Mã đánh giá` int PRIMARY KEY AUTO_INCREMENT,
  `Mã đơn hàng` int NOT NULL,
  `Số thứ tự dòng` int NOT NULL,
  `Số sao (1-5)` int NOT NULL,
  `Nội dung nhận xét` text,
  `Thời điểm đánh giá` datetime NOT NULL,
  `Trạng thái hiển thị` text NOT NULL
);

CREATE TABLE `Hình ảnh đánh giá` (
  `Mã đánh giá` int,
  `Hình ảnh đánh giá` text,
  PRIMARY KEY (`Mã đánh giá`, `Hình ảnh đánh giá`)
);

CREATE TABLE `Yêu cầu bảo hành đổi trả` (
  `Mã yêu cầu` int PRIMARY KEY AUTO_INCREMENT,
  `Mã đơn hàng` int NOT NULL,
  `Số thứ tự dòng` int NOT NULL,
  `Mã chi nhánh` int NOT NULL,
  `Loại yêu cầu` text NOT NULL,
  `Lý do` text NOT NULL,
  `Xử lý mong muốn` text NOT NULL,
  `Ngày tạo` datetime NOT NULL,
  `Trạng thái xử lý` text NOT NULL,
  `Lý do từ chối` text
);

CREATE TABLE `Hình ảnh minh chứng` (
  `Mã yêu cầu` int,
  `Hình ảnh minh chứng` text,
  PRIMARY KEY (`Mã yêu cầu`, `Hình ảnh minh chứng`)
);

CREATE TABLE `Voucher` (
  `Mã voucher` int PRIMARY KEY AUTO_INCREMENT,
  `Loại giảm giá` text NOT NULL,
  `Giá trị giảm` decimal NOT NULL,
  `Mức giảm tối đa` decimal,
  `Đơn tối thiểu` decimal NOT NULL,
  `Tổng lượt sử dụng` int NOT NULL,
  `Ngày bắt đầu` datetime NOT NULL,
  `Ngày kết thúc` datetime NOT NULL,
  `Trạng thái` text NOT NULL
);

CREATE TABLE `Áp dụng voucher` (
  `Mã đơn hàng` int,
  `Mã voucher` int,
  `Số tiền giảm thực tế` decimal NOT NULL,
  PRIMARY KEY (`Mã đơn hàng`, `Mã voucher`)
);

ALTER TABLE `Người dùng` ADD FOREIGN KEY (`Mã tài khoản`) REFERENCES `Tài khoản` (`Mã tài khoản`);

ALTER TABLE `Khách hàng` ADD FOREIGN KEY (`Mã người dùng`) REFERENCES `Người dùng` (`Mã người dùng`);

ALTER TABLE `Quản trị viên` ADD FOREIGN KEY (`Mã người dùng`) REFERENCES `Người dùng` (`Mã người dùng`);

ALTER TABLE `Nhân viên chi nhánh` ADD FOREIGN KEY (`Mã người dùng`) REFERENCES `Người dùng` (`Mã người dùng`);

ALTER TABLE `Giỏ hàng` ADD FOREIGN KEY (`Mã khách hàng`) REFERENCES `Khách hàng` (`Mã người dùng`);

ALTER TABLE `Đánh giá` ADD FOREIGN KEY (`Mã đơn hàng`) REFERENCES `Chi tiết đơn hàng` (`Mã đơn hàng`);

ALTER TABLE `Khách hàng` ADD FOREIGN KEY (`Mã hạng`) REFERENCES `Hạng hội viên` (`Mã hạng`);

ALTER TABLE `Địa chỉ nhận hàng` ADD FOREIGN KEY (`Mã khách hàng`) REFERENCES `Khách hàng` (`Mã người dùng`);

ALTER TABLE `Giao dịch điểm` ADD FOREIGN KEY (`Mã khách hàng`) REFERENCES `Khách hàng` (`Mã người dùng`);

ALTER TABLE `Danh mục` ADD FOREIGN KEY (`Mã danh mục cha`) REFERENCES `Danh mục` (`Mã danh mục`);

ALTER TABLE `Biến thể sản phẩm` ADD FOREIGN KEY (`Mã sản phẩm`) REFERENCES `Sản phẩm` (`Mã sản phẩm`);

ALTER TABLE `Nhân viên chi nhánh` ADD FOREIGN KEY (`Mã chi nhánh`) REFERENCES `Chi nhánh` (`Mã chi nhánh`);

ALTER TABLE `Đơn hàng` ADD FOREIGN KEY (`Mã khách hàng`) REFERENCES `Khách hàng` (`Mã người dùng`);

ALTER TABLE `Đơn hàng` ADD FOREIGN KEY (`Mã chi nhánh`) REFERENCES `Chi nhánh` (`Mã chi nhánh`);

ALTER TABLE `Chi tiết đơn hàng` ADD FOREIGN KEY (`Mã đơn hàng`) REFERENCES `Đơn hàng` (`Mã đơn hàng`);

ALTER TABLE `Chi tiết đơn hàng` ADD FOREIGN KEY (`Mã biến thể`) REFERENCES `Biến thể sản phẩm` (`Mã biến thể`);

ALTER TABLE `Lịch sử trạng thái đơn hàng` ADD FOREIGN KEY (`Mã đơn hàng`) REFERENCES `Đơn hàng` (`Mã đơn hàng`);

ALTER TABLE `Lịch sử trạng thái đơn hàng` ADD FOREIGN KEY (`Mã nhân viên`) REFERENCES `Nhân viên chi nhánh` (`Mã người dùng`);

ALTER TABLE `Yêu cầu bảo hành đổi trả` ADD FOREIGN KEY (`Mã đơn hàng`) REFERENCES `Chi tiết đơn hàng` (`Mã đơn hàng`);

ALTER TABLE `Yêu cầu bảo hành đổi trả` ADD FOREIGN KEY (`Mã chi nhánh`) REFERENCES `Chi nhánh` (`Mã chi nhánh`);

ALTER TABLE `Hình ảnh sản phẩm` ADD FOREIGN KEY (`Mã sản phẩm`) REFERENCES `Sản phẩm` (`Mã sản phẩm`);

ALTER TABLE `Hình ảnh đánh giá` ADD FOREIGN KEY (`Mã đánh giá`) REFERENCES `Đánh giá` (`Mã đánh giá`);

ALTER TABLE `Hình ảnh minh chứng` ADD FOREIGN KEY (`Mã yêu cầu`) REFERENCES `Yêu cầu bảo hành đổi trả` (`Mã yêu cầu`);

ALTER TABLE `Phân loại sản phẩm` ADD FOREIGN KEY (`Mã sản phẩm`) REFERENCES `Sản phẩm` (`Mã sản phẩm`);

ALTER TABLE `Phân loại sản phẩm` ADD FOREIGN KEY (`Mã danh mục`) REFERENCES `Danh mục` (`Mã danh mục`);

ALTER TABLE `Gắn thương hiệu` ADD FOREIGN KEY (`Mã thương hiệu`) REFERENCES `Thương hiệu` (`Mã thương hiệu`);

ALTER TABLE `Gắn thương hiệu` ADD FOREIGN KEY (`Mã sản phẩm`) REFERENCES `Sản phẩm` (`Mã sản phẩm`);

ALTER TABLE `Cung cấp` ADD FOREIGN KEY (`Mã nhà cung cấp`) REFERENCES `Nhà cung cấp` (`Mã nhà cung cấp`);

ALTER TABLE `Cung cấp` ADD FOREIGN KEY (`Mã sản phẩm`) REFERENCES `Sản phẩm` (`Mã sản phẩm`);

ALTER TABLE `Tồn kho` ADD FOREIGN KEY (`Mã chi nhánh`) REFERENCES `Chi nhánh` (`Mã chi nhánh`);

ALTER TABLE `Tồn kho` ADD FOREIGN KEY (`Mã biến thể`) REFERENCES `Biến thể sản phẩm` (`Mã biến thể`);

ALTER TABLE `Chi tiết giỏ hàng` ADD FOREIGN KEY (`Mã giỏ hàng`) REFERENCES `Giỏ hàng` (`Mã giỏ hàng`);

ALTER TABLE `Chi tiết giỏ hàng` ADD FOREIGN KEY (`Mã biến thể`) REFERENCES `Biến thể sản phẩm` (`Mã biến thể`);

ALTER TABLE `Áp dụng voucher` ADD FOREIGN KEY (`Mã đơn hàng`) REFERENCES `Đơn hàng` (`Mã đơn hàng`);

ALTER TABLE `Áp dụng voucher` ADD FOREIGN KEY (`Mã voucher`) REFERENCES `Voucher` (`Mã voucher`);
