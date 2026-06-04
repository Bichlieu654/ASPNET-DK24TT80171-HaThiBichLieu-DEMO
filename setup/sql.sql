-- =====================================================
-- DATABASE: RecipeDB
-- Website Chia Se Cong Thuc Nau An
-- 4 Bang: Users, Recipes, Ingredients, Steps
-- =====================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'RecipeDB')
    DROP DATABASE RecipeDB;
GO

CREATE DATABASE RecipeDB
    COLLATE Vietnamese_CI_AS;
GO

USE RecipeDB;
GO

-- =====================================================
-- BANG 1: NGUOI DUNG (Users)
-- =====================================================
CREATE TABLE Users (
    UserID       INT PRIMARY KEY IDENTITY(1,1),
    Username     NVARCHAR(50)  NOT NULL UNIQUE,
    Email        NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    FullName     NVARCHAR(100),
    CreatedAt    DATETIME      DEFAULT GETDATE()
);
GO

-- =====================================================
-- BANG 2: CONG THUC NAU AN (Recipes)
-- Category: 'Mon chinh','Trang mieng','An chay','Khai vi','Do uong','An vat'
-- DietType : 'Thong thuong','Chay','Thuan chay','Low-carb','Keto'
-- Difficulty: 'De','Trung binh','Kho'
-- =====================================================
CREATE TABLE Recipes (
    RecipeID    INT PRIMARY KEY IDENTITY(1,1),
    UserID      INT            NOT NULL REFERENCES Users(UserID),
    Title       NVARCHAR(200)  NOT NULL,
    Description NVARCHAR(1000),
    ImagePath   NVARCHAR(255)  DEFAULT 'default-recipe.jpg',
    Category    NVARCHAR(50)   DEFAULT N'Món chính',
    DietType    NVARCHAR(50)   DEFAULT N'Thông thường',
    Difficulty  NVARCHAR(20)   DEFAULT N'Trung bình',
    PrepTime    INT            DEFAULT 0,
    CookTime    INT            DEFAULT 0,
    Servings    INT            DEFAULT 2,
    Tips        NVARCHAR(1000),
    ViewCount   INT            DEFAULT 0,
    CreatedAt   DATETIME       DEFAULT GETDATE()
);
GO

-- =====================================================
-- BANG 3: NGUYEN LIEU (Ingredients)
-- =====================================================
CREATE TABLE Ingredients (
    IngredientID INT PRIMARY KEY IDENTITY(1,1),
    RecipeID     INT            NOT NULL REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    Name         NVARCHAR(100)  NOT NULL,
    Quantity     NVARCHAR(50),
    Unit         NVARCHAR(30),
    SortOrder    INT            DEFAULT 0
);
GO

-- =====================================================
-- BANG 4: CAC BUOC THUC HIEN (Steps)
-- =====================================================
CREATE TABLE Steps (
    StepID      INT PRIMARY KEY IDENTITY(1,1),
    RecipeID    INT            NOT NULL REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    StepNumber  INT            NOT NULL,
    Description NVARCHAR(2000) NOT NULL
);
GO

-- =====================================================
-- DU LIEU MAU
-- Mat khau mac dinh: 123456 (Luu dang text thuong)
-- =====================================================
INSERT INTO Users (Username, Email, PasswordHash, FullName)
VALUES
(N'admin',     N'admin@recipe.vn',   '123456', N'Quản trị viên'),
(N'thanhnau',  N'thanh@email.com',   '123456', N'Thanh Nấu Ăn'),
(N'minhbep',   N'minh@email.com',    '123456', N'Minh Bếp'),
(N'lanbep',    N'lan@email.com',     '123456', N'Lan Bếp'),
(N'hoangbep',  N'hoang@email.com',   '123456', N'Hoàng Đầu Bếp'),
(N'anngon',    N'an@email.com',      '123456', N'An Ngon'),
(N'huongvi',   N'huong@email.com',   '123456', N'Hương Vị Việt'),
(N'thubep',    N'thu@email.com',     '123456', N'Thu Bếp');
GO

-- Cong thuc mau
INSERT INTO Recipes (UserID, Title, Description, ImagePath, Category, DietType, Difficulty, PrepTime, CookTime, Servings, Tips, ViewCount)
VALUES
(1, N'Phở Bò Hà Nội',        N'Phở bò truyền thống với nước dùng đậm đà từ xương hầm, thịt bò mềm tan, bánh phở mượt mà. Hương vị đặc trưng của ẩm thực Hà Nội.', N'phở bò.png', N'Món chính', N'Thông thường', N'Trung bình', 30, 180, 4, N'Hầm xương càng lâu nước phở càng ngon. Nướng gừng và hành trước khi cho vào nồi để nước trong và thơm hơn.', 128),
(2, N'Bánh Mì Thịt Nướng',   N'Bánh mì giòn rụm với thịt heo nướng thơm phức, rau thơm tươi mát và nước sốt đặc biệt. Món ăn sáng yêu thích của người Việt.', N'banh-mi-thit-nuong-1.jpg', N'Ăn vặt', N'Thông thường', N'Dễ', 20, 15, 2, N'Thịt ướp qua đêm sẽ ngấm gia vị và ngon hơn. Bánh mì nướng nhẹ trước khi ăn để giòn hơn.', 95),
(3, N'Canh Chua Cá Lóc',     N'Canh chua miền Nam đặc trưng với cá lóc tươi, me chua, cà chua, dọc mùng và các loại rau thơm. Vừa chua vừa ngọt rất kích thích vị giác.', N'canh chua cá.jfif', N'Món chính', N'Thông thường', N'Dễ', 20, 25, 4, N'Dùng me tươi sẽ ngon hơn me khô. Không nấu quá lâu để cá không bị nát.', 87),
(1, N'Chè Đậu Xanh Bánh Lọt',N'Chè đậu xanh mát lạnh với sợi bánh lọt xanh mướt, nước cốt dừa béo ngậy và đá bào mịn. Thức uống giải nhiệt tuyệt vời ngày hè.', N'chè bánh lọt.jfif', N'Tráng miệng', N'Chay', N'Dễ', 45, 30, 6, N'Đậu xanh ngâm trước 2 tiếng cho mau chín. Nước cốt dừa cho vào sau cùng để không bị vỡ.', 76),
(2, N'Cơm Chiên Dương Châu',  N'Cơm chiên vàng ươm với trứng, tôm, lạp xưởng, đậu hà lan. Món ăn nhanh đơn giản mà ngon miệng cho cả gia đình.', N'cơm chiên dương châu.jpg', N'Món chính', N'Thông thường', N'Dễ', 10, 15, 3, N'Dùng cơm nguội để hạt cơm không bị dính. Lửa to khi chiên cơm sẽ thơm và vàng đẹp hơn.', 112),
(3, N'Salad Rau Trộn Chay',   N'Salad tươi mát với nhiều loại rau củ, hạt dinh dưỡng và sốt mè rang đặc biệt. Tốt cho sức khỏe và giàu vitamin.', N'salad.jfif', N'Khai vị', N'Thuần chay', N'Dễ', 15, 0, 2, N'Rau phải tươi và ráo nước trước khi trộn. Sốt cho vào trước khi ăn 5 phút để thấm đều.', 54),
(1, N'Bún Bò Huế',            N'Bún bò Huế cay nồng đặc trưng với nước dùng đỏ au từ sả, ớt và ruốc tôm. Thịt bò mềm, chả cua thơm ngon đúng vị miền Trung.', N'bun-bo-hue.jpeg', N'Món chính', N'Thông thường', N'Khó', 45, 120, 6, N'Ruốc Huế là linh hồn của nồi bún. Sả đập dập phi thơm trước khi cho vào nước dùng.', 143),
(4, N'Bánh Tráng Trộn Tây Ninh', N'Món ăn vặt đường phố nổi tiếng với bánh tráng dai dai, bò khô cay nồng, xoài non chua ngọt, trứng cút bùi ngậy và muối tôm thơm ngon.', N'default-recipe.jpg', N'Ăn vặt', N'Thông thường', N'Dễ', 15, 0, 2, N'Trộn đều và ăn ngay để bánh tráng không bị nhũn nhão.', 240),
(5, N'Bột Chiên Trứng Giòn Rụm', N'Bột chiên vàng giòn bên ngoài, mềm dẻo bên trong kết hợp với trứng gà béo ngậy, đu đủ bào sợi giòn sần sật và nước tương pha ngọt dịu.', N'default-recipe.jpg', N'Ăn vặt', N'Thông thường', N'Dễ', 15, 15, 2, N'Chiên bột với lửa vừa để giòn đều mà không bị cháy. Ăn kèm đu đủ và hành lá.', 180),
(6, N'Bánh Tráng Nướng Đà Lạt', N'Được mệnh danh là pizza Việt Nam, bánh tráng giòn rụm nướng trên than hồng cùng trứng cút, hành lá, hành phi, ruốc khô và tương ớt béo cay.', N'default-recipe.jpg', N'Ăn vặt', N'Thông thường', N'Dễ', 10, 10, 2, N'Xoay bánh tráng liên tục trên bếp để không bị cháy sém. Nên nướng trên bếp than hoặc bếp hồng ngoại.', 310),
(1, N'Thạch Rau Câu Bắp', N'Món thạch mát lạnh, ngọt bùi vị bắp ngô hòa quyện cùng lớp nước cốt dừa béo ngậy, giòn dẻo sần sật cực kỳ hấp dẫn cho ngày hè.', N'thạch rau câu bắp.jpg', N'Tráng miệng', N'Chay', N'Dễ', 20, 20, 4, N'Khi đổ các lớp thạch, hãy đợi cho lớp thạch trước hơi đông nhẹ bề mặt rồi mới nhẹ nhàng đổ lớp tiếp theo để các lớp không bị hòa lẫn vào nhau hoặc bị tách rời.', 0);
GO

-- Nguyen lieu Pho Bo (RecipeID=1)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(1,N'Xương bò ống','1',N'kg',1),(1,N'Bánh phở tươi','400',N'g',2),
(1,N'Thịt bò tái','300',N'g',3),(1,N'Hành tím','3',N'củ',4),
(1,N'Gừng','1',N'củ',5),(1,N'Quế','2',N'thanh',6),
(1,N'Hoa hồi','4',N'cái',7),(1,N'Nước mắm','3',N'muỗng canh',8),
(1,N'Muối, đường','',N'vừa đủ',9),(1,N'Hành lá, ngò gai, giá đỗ','',N'tươi',10);

-- Nguyen lieu Banh Mi (RecipeID=2)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(2,N'Bánh mì','2',N'ổ',1),(2,N'Thịt heo nạc','200',N'g',2),
(2,N'Sả','2',N'cây',3),(2,N'Tỏi','3',N'tép',4),
(2,N'Nước mắm, đường','',N'vừa đủ',5),(2,N'Dầu hào','1',N'muỗng',6),
(2,N'Rau thơm, dưa leo','',N'tươi',7),(2,N'Pa-tê, mayonnaise','',N'tuỳ thích',8);

-- Nguyen lieu Canh Chua (RecipeID=3)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(3,N'Cá lóc','500',N'g',1),(3,N'Me tươi','50',N'g',2),
(3,N'Cà chua','2',N'trái',3),(3,N'Dọc mùng','100',N'g',4),
(3,N'Giá đỗ','100',N'g',5),(3,N'Nước mắm, muối','',N'vừa đủ',6),
(3,N'Đường','1',N'muỗng',7),(3,N'Rau mùi, hành lá','',N'tươi',8);

-- Nguyen lieu Che Dau Xanh (RecipeID=4)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(4,N'Đậu xanh','200',N'g',1),(4,N'Bột năng (bánh lọt)','100',N'g',2),
(4,N'Nước cốt dừa','200',N'ml',3),(4,N'Đường','150',N'g',4),
(4,N'Màu thực phẩm xanh lá','',N'1 ít',5),(4,N'Đá bào','',N'vừa đủ',6);

-- Nguyen lieu Com Chien (RecipeID=5)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(5,N'Cơm nguội','3',N'chén',1),(5,N'Trứng gà','2',N'quả',2),
(5,N'Tôm khô','50',N'g',3),(5,N'Lạp xưởng','1',N'cây',4),
(5,N'Đậu hà lan','50',N'g',5),(5,N'Nước tương, muối','',N'vừa đủ',6),
(5,N'Hành lá','2',N'cây',7);

-- Nguyen lieu Salad Chay (RecipeID=6)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(6,N'Xà lách xanh','100',N'g',1),(6,N'Cà chua bi','10',N'trái',2),
(6,N'Dưa leo','1',N'trái',3),(6,N'Cà rốt','1',N'củ',4),
(6,N'Hạt điều rang','30',N'g',5),(6,N'Mè rang','1',N'muỗng',6),
(6,N'Dầu ô liu','2',N'muỗng canh',7),(6,N'Giấm, đường, muối','',N'vừa đủ',8);

-- Nguyen lieu Bun Bo Hue (RecipeID=7)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(7,N'Bún tươi','500',N'g',1),(7,N'Xương bò','500',N'g',2),
(7,N'Thịt bò bắp','300',N'g',3),(7,N'Chả cua','200',N'g',4),
(7,N'Sả','3',N'cây',5),(7,N'Ruốc tôm Huế','2',N'muỗng',6),
(7,N'Ớt bột','1',N'muỗng',7),(7,N'Nước mắm, muối','',N'vừa đủ',8),
(7,N'Rau sống, bắp chuối','',N'tươi',9);

-- Nguyen lieu Banh Trang Tron (RecipeID=8)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(8,N'Bánh tráng sợi','100',N'g',1),(8,N'Bò khô xé sợi','30',N'g',2),
(8,N'Xoài non bào sợi','50',N'g',3),(8,N'Trứng cút','5',N'quả',4),
(8,N'Muối tôm Tây Ninh','1',N'muỗng',5),(8,N'Tép khô','20',N'g',6),
(8,N'Hành phi, mỡ hành','',N'vừa đủ',7),(8,N'Rau răm, đậu phộng','',N'vừa đủ',8),
(8,N'Quất (tắc)','2',N'quả',9);

-- Nguyen lieu Bot Chien (RecipeID=9)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(9,N'Bột gạo, bột năng','200',N'g',1),(9,N'Trứng gà','2',N'quả',2),
(9,N'Hành lá','2',N'cây',3),(9,N'Đu đủ non bào sợi','100',N'g',4),
(9,N'Tỏi băm','1',N'muỗng',5),(9,N'Nước tương, đường, giấm','',N'vừa đủ',6);

-- Nguyen lieu Banh Trang Nuong (RecipeID=10)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(10,N'Bánh tráng tròn','2',N'cái',1),(10,N'Trứng cút','4',N'quả',2),
(10,N'Hành lá cắt nhỏ','2',N'muỗng',3),(10,N'Bơ nhạt, sốt mayonnaise','',N'vừa đủ',4),
(10,N'Tương ớt, tương cà','',N'vừa đủ',5),(10,N'Ruốc sấy','20',N'g',6),
(10,N'Xúc xích thái mỏng','1',N'cây',7);

-- Nguyen lieu Thạch Rau Câu Bắp (RecipeID=11)
INSERT INTO Ingredients (RecipeID, Name, Quantity, Unit, SortOrder) VALUES
(11,N'Bắp ngọt (ngô ngọt)','2',N'trái',1),(11,N'Bột rau câu dẻo','1',N'gói (10g)',2),
(11,N'Nước cốt dừa','200',N'ml',3),(11,N'Đường cát','150',N'g',4),
(11,N'Sữa đặc','50',N'ml',5),(11,N'Nước lọc','1',N'lít',6);
GO

-- Cac buoc Pho Bo (RecipeID=1)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(1,1,N'Xương bò rửa sạch, chần qua nước sôi 5 phút rồi vớt ra, rửa lại với nước lạnh để loại bỏ bọt bẩn.'),
(1,2,N'Nướng gừng và hành tím trên lửa trực tiếp đến khi cháy xém bên ngoài. Cạo vỏ, rửa sạch.'),
(1,3,N'Cho xương vào nồi lớn, đổ 3 lít nước. Thêm gừng, hành nướng, quế, hồi. Đun sôi rồi hạ nhỏ lửa, hầm 2-3 tiếng. Vớt bọt thường xuyên.'),
(1,4,N'Nêm nước dùng với nước mắm, muối, đường vừa ăn. Lọc qua rây cho nước trong.'),
(1,5,N'Trụng bánh phở qua nước sôi, cho vào tô. Thái thịt bò thật mỏng xếp lên trên. Chan nước dùng đang sôi lên. Rắc hành lá, ngò. Dùng kèm rau sống và tương.');

-- Cac buoc Banh Mi (RecipeID=2)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(2,1,N'Thịt heo thái miếng mỏng. Trộn đều với sả băm, tỏi băm, nước mắm, đường, dầu hào. Ướp ít nhất 30 phút.'),
(2,2,N'Nướng thịt trên chảo nóng hoặc vỉ than đến khi chín vàng thơm cả hai mặt.'),
(2,3,N'Bánh mì cắt đôi theo chiều dài, nướng nhẹ cho giòn. Phết pa-tê và mayonnaise vào. Xếp thịt nướng, rau thơm, dưa leo vào. Ăn ngay khi còn nóng.');

-- Cac buoc Canh Chua (RecipeID=3)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(3,1,N'Cá lóc làm sạch, cắt khúc vừa ăn. Ướp nhẹ với muối và tiêu 10 phút cho thấm.'),
(3,2,N'Ngâm me với nước ấm, lọc lấy nước cốt me. Phi thơm tỏi với dầu, cho cà chua vào xào mềm.'),
(3,3,N'Đổ 1,5 lít nước vào nồi, thêm nước cốt me và cà chua đã xào. Đun sôi, nêm nước mắm, đường vừa ăn.'),
(3,4,N'Cho cá và dọc mùng vào nồi, đun thêm 10 phút cho cá chín. Tắt bếp, thêm giá đỗ và rau thơm. Múc ra tô dùng nóng.');

-- Cac buoc Che Dau Xanh (RecipeID=4)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(4,1,N'Đậu xanh ngâm 2 tiếng, vớt ra hấp hoặc luộc chín mềm. Trộn với ½ lượng đường.'),
(4,2,N'Pha bột năng với nước, thêm vài giọt màu xanh lá. Đun sôi nước rồi ép bột qua khuôn lỗ nhỏ tạo thành sợi bánh lọt. Vớt ra ngâm nước lạnh.'),
(4,3,N'Nấu nước đường với lượng đường còn lại cho tan. Để nguội.'),
(4,4,N'Cho vào ly theo thứ tự: đậu xanh, bánh lọt, nước đường, nước cốt dừa, đá bào. Dùng ngay.');

-- Cac buoc Com Chien (RecipeID=5)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(5,1,N'Lạp xưởng thái lát. Tôm khô ngâm mềm. Đánh tan trứng với chút muối.'),
(5,2,N'Phi thơm tỏi, cho lạp xưởng và tôm vào xào chín. Thêm đậu hà lan vào đảo đều.'),
(5,3,N'Đẩy hết sang một bên chảo, đổ trứng vào chảo, khuấy nhanh tay rồi trộn chung với các nguyên liệu.'),
(5,4,N'Cho cơm nguội vào, dùng lửa to đảo đều tay đến khi cơm tơi vàng đều. Nêm nước tương, muối vừa ăn. Rắc hành lá lên, tắt bếp.');

-- Cac buoc Salad Chay (RecipeID=6)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(6,1,N'Rau xà lách rửa sạch, ngâm nước muối loãng 5 phút, vớt ra để thật ráo nước.'),
(6,2,N'Cà chua bi cắt đôi. Dưa leo thái lát. Cà rốt bào sợi hoặc cắt hoa.'),
(6,3,N'Pha sốt: trộn dầu ô liu, giấm, đường, muối và mè rang theo tỉ lệ 3:1:1:½.'),
(6,4,N'Cho tất cả rau củ vào tô lớn, rưới sốt lên, trộn nhẹ tay. Rắc hạt điều rang lên trên. Dùng ngay.');

-- Cac buoc Bun Bo Hue (RecipeID=7)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(7,1,N'Xương bò và thịt bò bắp chần qua nước sôi, vớt ra rửa sạch.'),
(7,2,N'Đập dập sả, phi thơm với dầu và ớt bột cho màu đỏ đẹp. Phi riêng ruốc tôm cho thơm.'),
(7,3,N'Cho xương vào nồi với 2 lít nước. Thêm sả và ruốc đã phi vào. Hầm 1,5-2 tiếng. Vớt thịt bắp ra, thái lát.'),
(7,4,N'Nêm nước dùng với nước mắm, muối vừa ăn. Lọc nước cho trong.'),
(7,5,N'Trụng bún qua nước sôi, xếp vào tô. Xếp thịt bò, chả cua lên. Chan nước dùng đang sôi vào. Dùng kèm rau sống và bắp chuối bào.');

-- Cac buoc Banh Trang Tron (RecipeID=8)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(8,1,N'Trứng cút luộc chín, bóc vỏ. Xoài non gọt vỏ, bào sợi nhỏ. Rau răm cắt nhỏ. Đậu phộng rang chín giã dập.'),
(8,2,N'Cho bánh tráng sợi vào tô lớn. Thêm muối tôm, tép khô, hành phi, mỡ hành và vắt nước quất (tắc) vào trộn đều.'),
(8,3,N'Cho xoài non, bò khô, trứng cút và rau răm vào trộn nhẹ tay cho thấm gia vị.'),
(8,4,N'Cho ra dĩa, rắc đậu phộng lên trên và thưởng thức.');

-- Cac buoc Bot Chien (RecipeID=9)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(9,1,N'Pha bột gạo với nước và chút dầu ăn, đem hấp chín rồi để nguội cho đông lại, sau đó cắt khối vuông vừa ăn.'),
(9,2,N'Cho ít dầu vào chảo phẳng, chiên các khối bột đến khi vàng giòn đều các mặt.'),
(9,3,N'Đập 2 quả trứng gà rưới lên phần bột đang chiên, rắc hành lá cắt nhỏ xung quanh, lật mặt chiên chín trứng.'),
(9,4,N'Pha nước chấm: nước tương, đường, nước ấm và giấm khuấy đều. Cho bột chiên ra dĩa, ăn kèm đu đủ bào và nước tương pha.');

-- Cac buoc Banh Trang Nuong (RecipeID=10)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(10,1,N'Đặt bánh tráng tròn lên vỉ nướng trên bếp than hồng hoặc chảo chống dính ở lửa nhỏ.'),
(10,2,N'Phết một chút bơ nhạt, hành lá cắt nhỏ và đập trứng cút trực tiếp lên bánh tráng, dùng cọ quét đều trứng trên mặt bánh.'),
(10,3,N'Rắc ruốc sấy, xúc xích lên trên. Khi thấy viền bánh giòn cong lên và trứng đã chín se lại, rưới tương ớt, mayonnaise lên.'),
(10,4,N'Gập đôi bánh hoặc để nguyên, cắt thành từng miếng vừa ăn khi bánh còn nóng giòn.');

-- Cac buoc Thạch Rau Câu Bắp (RecipeID=11)
INSERT INTO Steps (RecipeID, StepNumber, Description) VALUES
(11,1,N'Tách hạt bắp ngọt, rửa sạch rồi xay nhuyễn với 200ml nước lọc. Lọc qua rây hoặc khăn vắt để lấy nước cốt bắp nguyên chất.'),
(11,2,N'Trộn đều bột rau câu với đường cát trong một bát nhỏ. Hòa tan hỗn hợp này vào 800ml nước lọc còn lại trong nồi, ngâm khoảng 15 phút cho bột rau câu nở đều.'),
(11,3,N'Đặt nồi nước rau câu lên bếp, đun sôi với lửa vừa. Khuấy đều tay để bột rau câu không bị vón cục và lắng dưới đáy nồi. Khi nước rau câu sôi và trong suốt thì hạ nhỏ lửa.'),
(11,4,N'Chia nước rau câu trong nồi thành 2 phần bằng nhau. Phần 1: Cho nước cốt bắp và sữa đặc vào, khuấy đều đun sôi nhẹ rồi tắt bếp. Phần 2: Cho nước cốt dừa vào, đun sôi nhẹ rồi tắt bếp.'),
(11,5,N'Đổ một lớp thạch bắp (màu vàng) vào khuôn, đợi khoảng 3-5 phút cho bề mặt thạch hơi đông và se lại. Sau đó dùng thìa/muôi nhẹ nhàng múc đổ tiếp một lớp thạch cốt dừa (màu trắng) lên trên.'),
(11,6,N'Lặp lại xen kẽ các lớp thạch cho đến hết. Để nguội hoàn toàn ở nhiệt độ phòng rồi cho vào ngăn mát tủ lạnh từ 2 tiếng trở lên trước khi thưởng thức.');
GO

PRINT N'=== Tao database RecipeDB thanh cong! ===';
PRINT N'4 bang: Users, Recipes, Ingredients, Steps';
PRINT N'Mat khau mac dinh tat ca tai khoan: 123456';
GO
