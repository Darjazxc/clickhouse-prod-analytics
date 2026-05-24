SELECT
    date,
    DAU,
    WAU,
    MAU,
    round(DAU / MAU * 100, 1) AS stickiness_pct
FROM (
    SELECT
        date,
        uniq(user_id) AS DAU
    FROM (
        SELECT DISTINCT toDate(event_time) AS date, user_id FROM events
    )
    GROUP BY date
) d
LEFT JOIN (
    SELECT
        date,
        uniq(user_id) AS WAU
    FROM (
        SELECT DISTINCT toDate(event_time) AS date, user_id FROM events
    ) e
    JOIN (
        SELECT DISTINCT toDate(event_time) AS date FROM events
    ) d ON e.date BETWEEN d.date - 6 AND d.date
    GROUP BY d.date AS date
) w USING date
LEFT JOIN (
    SELECT
        date,
        uniq(user_id) AS MAU
    FROM (
        SELECT DISTINCT toDate(event_time) AS date, user_id FROM events
    ) e
    JOIN (
        SELECT DISTINCT toDate(event_time) AS date FROM events
    ) d ON e.date BETWEEN d.date - 29 AND d.date
    GROUP BY d.date AS date
) m USING date
ORDER BY date;