
DELIMITER $$

DROP FUNCTION IF EXISTS fn_TinhTongChiTieuKhachHang $$

CREATE FUNCTION fn_TinhTongChiTieuKhachHang(
    p_MaKhachHang INT
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    -- 1. Khai bao bien
    DECLARE v_TongChiTieu DECIMAL(15,2) DEFAULT 0;
    DECLARE v_MaDonHang INT;
    DECLARE v_SoThuTuDong INT;
    DECLARE v_SoLuong INT;
    DECLARE v_DonGia DECIMAL(15,2);
    DECLARE v_SoTienGiam DECIMAL(15,2);
    DECLARE v_ThanhTien DECIMAL(15,2);

    DECLARE v_HetDuLieu BOOLEAN DEFAULT FALSE;
    DECLARE v_TonTai INT DEFAULT 0;

    -- 2. Khai bao CURSOR
    DECLARE cur_ChiTietDonHang CURSOR FOR
        SELECT
            ct.`Mã đơn hàng`,
            ct.`Số thứ tự dòng`,
            ct.`Số lượng`,
            ct.`Đơn giá lúc mua`,
            ct.`Số tiền giảm`
        FROM `Đơn hàng` dh
        JOIN `Chi tiết đơn hàng` ct
            ON dh.`Mã đơn hàng` = ct.`Mã đơn hàng`
        WHERE dh.`Mã khách hàng` = p_MaKhachHang
          AND dh.`Trạng thái hiện tại` = 'Đã hoàn thành'
          AND NOT EXISTS (
              SELECT 1
              FROM `Yêu cầu bảo hành đổi trả` yc
              WHERE yc.`Mã đơn hàng` = ct.`Mã đơn hàng`
                AND yc.`Số thứ tự dòng` = ct.`Số thứ tự dòng`
                AND yc.`Loại yêu cầu` = 'Đổi trả'
                AND yc.`Trạng thái xử lý` = 'Đã chấp nhận'
          );

    -- 3. Handler khi CURSOR het du lieu
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_HetDuLieu = TRUE;

    -- 4. Kiem tra tham so dau vao
    IF p_MaKhachHang IS NULL OR p_MaKhachHang <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ma khach hang khong hop le';
    END IF;

    SELECT COUNT(*)
    INTO v_TonTai
    FROM `Khách hàng`
    WHERE `Mã người dùng` = p_MaKhachHang;

    IF v_TonTai = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Khach hang khong ton tai';
    END IF;

    -- 5. Mo CURSOR
    OPEN cur_ChiTietDonHang;

    -- 6. LOOP duyet tung dong chi tiet
    read_loop: LOOP

        FETCH cur_ChiTietDonHang
        INTO v_MaDonHang,
             v_SoThuTuDong,
             v_SoLuong,
             v_DonGia,
             v_SoTienGiam;

        -- Kiem tra het du lieu
        IF v_HetDuLieu = TRUE THEN
            LEAVE read_loop;
        END IF;

        -- 7. Tinh thanh tien tung dong
        SET v_ThanhTien =
            (v_SoLuong * v_DonGia) - v_SoTienGiam;

        -- 8. Kiem tra va cong don
        IF v_ThanhTien > 0 THEN
            SET v_TongChiTieu =
                v_TongChiTieu + v_ThanhTien;
        END IF;

    END LOOP;

    -- 9. Dong CURSOR
    CLOSE cur_ChiTietDonHang;

    -- 10. Tra ve tong chi tieu
    RETURN v_TongChiTieu;

END $$

DELIMITER ;




DELIMITER $$

DROP FUNCTION IF EXISTS fn_XacDinhHangHoiVien $$

CREATE FUNCTION fn_XacDinhHangHoiVien(
    p_MaKhachHang INT
)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    -- 1. Khai bao bien
    DECLARE v_TongChiTieu DECIMAL(15,2) DEFAULT 0;
    DECLARE v_MaHang INT;
    DECLARE v_TenHang VARCHAR(100);
    DECLARE v_MucChiTieu DECIMAL(15,2);

    DECLARE v_HangPhuHop VARCHAR(100) DEFAULT NULL;
    DECLARE v_HetDuLieu BOOLEAN DEFAULT FALSE;
    DECLARE v_TonTai INT DEFAULT 0;

    -- 2. Khai bao CURSOR
    -- Sap xep nguong chi tieu giam dan
    DECLARE cur_HangHoiVien CURSOR FOR
        SELECT
            `Mã hạng`,
            `Tên hạng`,
            `Mức chi tiêu tối thiểu`
        FROM `Hạng hội viên`
        ORDER BY `Mức chi tiêu tối thiểu` DESC;

    -- 3. Handler khi CURSOR het du lieu
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_HetDuLieu = TRUE;

    -- 4. Kiem tra tham so dau vao
    IF p_MaKhachHang IS NULL OR p_MaKhachHang <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ma khach hang khong hop le';
    END IF;

    SELECT COUNT(*)
    INTO v_TonTai
    FROM `Khách hàng`
    WHERE `Mã người dùng` = p_MaKhachHang;

    IF v_TonTai = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Khach hang khong ton tai';
    END IF;

    -- 5. Goi Function 1
    SET v_TongChiTieu =
        fn_TinhTongChiTieuKhachHang(p_MaKhachHang);

    -- 6. Mo CURSOR
    OPEN cur_HangHoiVien;

    -- 7. LOOP duyet cac hang hoi vien
    read_loop: LOOP

        FETCH cur_HangHoiVien
        INTO v_MaHang, v_TenHang, v_MucChiTieu;

        IF v_HetDuLieu = TRUE THEN
            LEAVE read_loop;
        END IF;

        -- 8. Kiem tra nguong chi tieu
        IF v_TongChiTieu >= v_MucChiTieu THEN

            SET v_HangPhuHop = v_TenHang;

            -- Da tim thay hang cao nhat phu hop
            LEAVE read_loop;

        END IF;

    END LOOP;

    -- 9. Dong CURSOR
    CLOSE cur_HangHoiVien;

    -- 10. Kiem tra ket qua
    IF v_HangPhuHop IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Chua co hang hoi vien phu hop voi tong chi tieu';
    END IF;

    -- 11. Tra ve ten hang
    RETURN v_HangPhuHop;

END $$

DELIMITER ;
