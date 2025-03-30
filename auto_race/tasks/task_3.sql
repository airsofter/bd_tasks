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
        SUM(ap.race_count) AS total_races
    FROM AvgPositions ap
    GROUP BY ap.car_class
),
MinClassAvgPosition AS (
    SELECT MIN(class_avg_position) AS min_class_avg_position
    FROM ClassAvgPositions
)
SELECT 
    ap.car_name,
    ap.car_class,
    ap.average_position,
    ap.race_count,
    ap.car_country,
    cap.total_races
FROM AvgPositions ap
JOIN ClassAvgPositions cap ON ap.car_class = cap.car_class
JOIN MinClassAvgPosition mcap ON cap.class_avg_position = mcap.min_class_avg_position
ORDER BY ap.car_class, ap.average_position;
