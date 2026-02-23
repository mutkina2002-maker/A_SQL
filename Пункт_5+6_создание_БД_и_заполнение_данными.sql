-- Здесь представлен одиин скрипт для создания бд и внесения данных
-- СОЗДАНИЕ БД И ТАБЛИЦ

IF DB_ID('collection_db') IS NOT NULL
   DROP DATABASE collection_db;
GO

CREATE DATABASE collection_db;
GO

USE collection_db;
GO

-- Создаем таблицу Client (клиенты)
CREATE TABLE Client (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    last_name NVARCHAR(100) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    patronymic NVARCHAR(100),
    tel_number NVARCHAR(20),
    email NVARCHAR(100),
    ser_passport NVARCHAR(4),
    num_passport NVARCHAR(7)
);

-- Создаем таблицу Account (счета)
CREATE TABLE Account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    type_account NVARCHAR(50),
    currency NVARCHAR(10),
    balance DECIMAL(15,2),
    account_status NVARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

-- Создаем таблицу Staff  (сотрудники)
CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    last_name NVARCHAR(100),
    name NVARCHAR(100),
    patronymic NVARCHAR(100),
    tel_number NVARCHAR(20),
    email NVARCHAR(100),
    ser_passport NVARCHAR(4),
    num_passport NVARCHAR(7),
    INN NVARCHAR(12)
);

-- Создаем таблицу Collectors (Бригады инкассации) 
CREATE TABLE Collectors (
    team_collectors_id INT IDENTITY(1,1) PRIMARY KEY,
    coll_status NVARCHAR(50),
    staff_id INT,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Создаем таблицу Office (отделения)
CREATE TABLE Office (
    office_id INT IDENTITY(1,1) PRIMARY KEY,
    address NVARCHAR(255),
    tel NVARCHAR(20)
);

-- Создаем таблицу Box_office (кассовая точка)
CREATE TABLE Box_office (
    box_office_id INT IDENTITY(1,1) PRIMARY KEY,
    office_id INT,
    staff_id INT,
    FOREIGN KEY (office_id) REFERENCES Office(office_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Создаем основную (центральную) таблицу Order (заказ) 
CREATE TABLE Orders_cash (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT,
    box_office_id INT,
    office_id INT,
    team_collectors_id INT,
    account_id INT,
    total_cash DECIMAL(15,2),
    create_date DATETIME,
    order_status NVARCHAR(50),
    close_date DATETIME NULL,
    comment NVARCHAR(255),
    plan_date_delivery DATETIME,
    issue_code NVARCHAR(20),
    currency NVARCHAR(10),
    commission DECIMAL(10,2),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (box_office_id) REFERENCES Box_office(box_office_id),
    FOREIGN KEY (office_id) REFERENCES Office(office_id),
    FOREIGN KEY (team_collectors_id) REFERENCES Collectors(team_collectors_id),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Создаем таблицу Notification (уведомления)
CREATE TABLE Notification_cash (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT,
    notif_type NVARCHAR(50),
    notif_comment NVARCHAR(255),
    notif_dispatch_date DATETIME,
    notif_status NVARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

-- ДОБАВЛЕНИЕ ДАННЫХ В ТАБЛИЦЫ

-- Клиенты (заполнение начинаем с фамилии в виду автоматического проставления id)
INSERT INTO Client VALUES
(N'Иванов',N'Иван',N'Иванович',N'+7 912 345-67-01',N'ivanov@mail.ru',N'4510',N'123456'),
(N'Петров',N'Пётр',N'Сергеевич',N'+7 913 456-78-02',N'petrov@mail.ru',N'4511',N'223456'),
(N'Сидоров',N'Алексей',N'Игоревич',N'+7 914 567-89-03',N'sidorov@mail.ru',N'4512',N'323456'),
(N'Кузнецова',N'Мария',N'Андреевна',N'+7 915 678-90-04',N'kuz@mail.ru',N'4513',N'423456'),
(N'Смирнов',N'Дмитрий',N'Олегович',N'+7 916 789-01-05',N'smirnov@mail.ru',N'4514',N'523456'),
(N'Васильева',N'Елена',N'Викторовна',N'+7 917 890-12-06',N'vas@mail.ru',N'4515',N'623456'),
(N'Фёдоров',N'Никита',N'Романович',N'+7 918 901-23-07',N'fedor@mail.ru',N'4516',N'723456'),
(N'Морозова',N'Анна',N'Павловна',N'+7 919 012-34-08',N'moroz@mail.ru',N'4517',N'823456'),
(N'Новиков',N'Артём',N'Максимович',N'+7 920 123-45-09',N'nov@mail.ru',N'4518',N'923456'),
(N'Захарова',N'Ольга',N'Ильинична',N'+7 921 234-56-10',N'zah@mail.ru',N'4519',N'103456');

-- Счета 
INSERT INTO Account VALUES
(1,N'Дебетовый',N'RUB',15000,N'Активен'),
(2,N'Кредитный',N'USD',2000,N'Активен'),
(3,N'Дебетовый',N'EUR',3500,N'Заблокирован'),
(4,N'Кредитный',N'RUB',42000,N'Активен'),
(5,N'Дебетовый',N'USD',5000,N'Активен'),
(6,N'Дебетовый',N'RUB',22000,N'Закрыт'),
(7,N'Кредитный',N'EUR',7000,N'Активен'),
(8,N'Дебетовый',N'RUB',9100,N'Активен'),
(9,N'Кредитный',N'USD',11000,N'Просрочка'),
(10,N'Дебетовый',N'EUR',2600,N'Активен');

-- Сотрудники (здесь не очень продумала, что один и тот же человек вряд ли может быть и на кассе, и в бригаде инкассации, но сделала ставку на общую картинку)
INSERT INTO Staff VALUES
(N'Орлов',N'Сергей',N'Петрович',N'+7 922 111-22-11',N'orlov@mail.ru',N'4601',N'654321',N'770123456789'),
(N'Егоров',N'Андрей',N'Владимирович',N'+7 922 222-33-22',N'egorov@mail.ru',N'4602',N'654322',N'770223456789'),
(N'Николаев',N'Роман',N'Игоревич',N'+7 922 333-44-33',N'nik@mail.ru',N'4603',N'654323',N'770323456789'),
(N'Громова',N'Ирина',N'Сергеевна',N'+7 922 444-55-44',N'grom@mail.ru',N'4604',N'654324',N'770423456789'),
(N'Лебедев',N'Максим',N'Алексеевич',N'+7 922 555-66-55',N'leb@mail.ru',N'4605',N'654325',N'770523456789'),
(N'Павлов',N'Денис',N'Олегович',N'+7 922 666-77-66',N'pavlov@mail.ru',N'4606',N'654326',N'770623456789'),
(N'Крылова',N'Наталья',N'Ивановна',N'+7 922 777-88-77',N'krylova@mail.ru',N'4607',N'654327',N'770723456789'),
(N'Беляев',N'Константин',N'Викторович',N'+7 922 888-99-88',N'belyaev@mail.ru',N'4608',N'654328',N'770823456789'),
(N'Титова',N'Светлана',N'Павловна',N'+7 922 999-00-99',N'titova@mail.ru',N'4609',N'654329',N'770923456789'),
(N'Соловьёв',N'Александр',N'Михайлович',N'+7 922 000-11-00',N'sol@mail.ru',N'4610',N'654330',N'771023456789'),
(N'Орлова',N'Наталия',N'Петровна',N'+7 922 111-23-11',N'orlov@mail.ru',N'4501',N'674321',N'770128456789');

-- Отделения
INSERT INTO Office VALUES
(N'г. Москва, ул. Тверская, д. 15',N'+7 495 123-45-01'),
(N'г. Санкт-Петербург, Невский проспект, д. 28',N'+7 812 234-56-02'),
(N'г. Казань, ул. Баумана, д. 10',N'+7 843 345-67-03'),
(N'г. Екатеринбург, ул. Ленина, д. 50',N'+7 343 456-78-04'),
(N'г. Новосибирск, Красный проспект, д. 12',N'+7 383 567-89-05'),
(N'г. Самара, ул. Куйбышева, д. 80',N'+7 846 678-90-06'),
(N'г. Нижний Новгород, ул. Большая Покровская, д. 5',N'+7 831 789-01-07'),
(N'г. Краснодар, ул. Северная, д. 100',N'+7 861 890-12-08'),
(N'г. Ростов-на-Дону, ул. Пушкинская, д. 22',N'+7 863 901-23-09'),
(N'г. Владивосток, ул. Светланская, д. 3',N'+7 423 012-34-10');

-- Бригада инкассации
INSERT INTO Collectors VALUES
(N'Активен',1),
(N'Активен',2),
(N'Неактивен',3),
(N'Активен',4),
(N'Активен',5),
(N'Неактивен',6),
(N'Активен',7),
(N'Активен',8),
(N'Неактивен',9),
(N'Активен',10);

-- Кассовая точка
INSERT INTO Box_office VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Заказ (дата не совсем реальные, но смысл сохраняется)
INSERT INTO Orders_cash
(client_id,box_office_id,office_id,team_collectors_id,account_id,total_cash,
 create_date,order_status,close_date,comment,plan_date_delivery,issue_code,currency,commission)
VALUES
(1,1,1,1,1,15000,DATEADD(day,10,GETDATE()),N'Открыт',NULL,N'Доставка наличных',DATEADD(day,20,GETDATE()),N'IC001',N'RUB',750),
(2,2,2,2,2,2000,GETDATE(),N'Закрыт',GETDATE(),N'Инкассация',DATEADD(day,7,GETDATE()),N'IC002',N'USD',100),
(3,3,3,3,3,3500,DATEADD(day,121,GETDATE()),N'Открыт',NULL,N'Перевозка средств',DATEADD(day,131,GETDATE()),N'IC003',N'EUR',150),
(4,4,4,4,4,42000,DATEADD(day,37,GETDATE()),N'Открыт',NULL,N'Доставка в офис',DATEADD(day,47,GETDATE()),N'IC004',N'RUB',2100),
(5,5,5,5,5,5000,DATEADD(day,1,GETDATE()),N'Закрыт',GETDATE(),N'Плановая инкассация',DATEADD(day,2,GETDATE()),N'IC005',N'USD',250),
(6,6,6,6,6,22000,DATEADD(day,79,GETDATE()),N'Открыт',NULL,N'Срочная доставка',DATEADD(day,89,GETDATE()),N'IC006',N'RUB',1100),
(7,7,7,7,7,7000,DATEADD(day,5,GETDATE()),N'Закрыт',GETDATE(),N'Контрольный выезд',DATEADD(day,7,GETDATE()),N'IC007',N'EUR',300),
(8,8,8,8,8,9100,DATEADD(day,56,GETDATE()),N'Открыт',NULL,N'Выезд к клиенту',DATEADD(day,60,GETDATE()),N'IC008',N'RUB',455),
(9,9,9,9,9,11000,DATEADD(day,10,GETDATE()),N'Закрыт',GETDATE(),N'Инкассация банкомата',DATEADD(day,15,GETDATE()),N'IC009',N'USD',500),
(10,10,10,10,10,2600,DATEADD(day,48,GETDATE()),N'Открыт',NULL,N'Доставка документов',DATEADD(day,53,GETDATE()),N'IC010',N'EUR',120);

-- Уведомления
INSERT INTO Notification_cash VALUES
(1,N'SMS',N'Напоминание о заказе',GETDATE(),N'Отправлено'),
(2,N'Email',N'Подтверждение операции',GETDATE(),N'Отправлено'),
(3,N'SMS',N'Изменение статуса',GETDATE(),N'В ожидании'),
(4,N'Email',N'Заказ принят',GETDATE(),N'Отправлено'),
(5,N'SMS',N'Доставка запланирована',GETDATE(),N'Отправлено'),
(6,N'Email',N'Заказ закрыт',GETDATE(),N'Отправлено'),
(7,N'SMS',N'Требуется подтверждение',GETDATE(),N'В ожидании'),
(8,N'Email',N'Платёж обработан',GETDATE(),N'Отправлено'),
(9,N'SMS',N'Выезд инкассатора',GETDATE(),N'Отправлено'),
(10,N'Email',N'Отчёт по заказу',GETDATE(),N'Отправлено');
