SELECT create_date, oc.office_id, address, SUM(total_cash), currency 
FROM Orders_cash as oc
JOIN Office AS o ON oc.office_id = o.office_id
-- В случае создания более автоматизированного отчета можно использовать MONTH и YEAR для текущей даты и добавить условия по тем годам и месяцам, которые мы достаем
-- Важно также указать статус заказа, чтобы оценить реальную нагрузку и в дальнейшем использовать это для построения моделей для оценки логистических и иных затрат
WHERE MONTH(create_date)='02' AND order_status='Закрыт'
GROUP BY create_date, oc.office_id, address, currency
