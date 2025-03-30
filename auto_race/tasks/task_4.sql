WITH AvgPositions AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
ClassAvgPositions AS (
    SELECT
        ap.car_class,
        AVG(ap.average_position) AS class_avg_position,
        COUNT(*) AS car_count
    FROM AvgPositions ap
    GROUP BY ap.car_class
    HAVING COUNT(*) > 1
)
SELECT 
    ap.car_name,
    ap.car_class,
    ap.average_position,
    ap.race_count,
    ap.car_country
FROM AvgPositions ap
JOIN ClassAvgPositions cap ON ap.car_class = cap.car_class
WHERE ap.average_position < cap.class_avg_position
ORDER BY ap.car_class, ap.average_position;
