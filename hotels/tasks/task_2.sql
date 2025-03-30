WITH CustomerBookings AS (
    SELECT 
        c.ID_customer,
        c.name AS customer_name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price) AS total_spent
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer, c.name
),
FilteredBookings AS (
    SELECT 
        ID_customer,
        customer_name,
        total_bookings,
        unique_hotels,
        total_spent
    FROM CustomerBookings
    WHERE total_bookings > 2 AND unique_hotels > 1
),
HighSpendingCustomers AS (
    SELECT 
        ID_customer,
        customer_name,
        total_spent,
        total_bookings
    FROM CustomerBookings
    WHERE total_spent > 500
)
SELECT 
    fb.ID_customer,
    fb.customer_name,
    fb.total_bookings,
    fb.total_spent,
    fb.unique_hotels
FROM FilteredBookings fb
JOIN HighSpendingCustomers hsc ON fb.ID_customer = hsc.ID_customer
ORDER BY fb.total_spent ASC;
