SELECT
    platform,
    count() AS total_sessions,
    round(avg(duration_sec) / 60, 1) AS avg_duration_min,
    round(avg(events_count), 1) AS avg_events_per_session,
    countIf(events_count = 1) AS bounce_sessions,
    round(countIf(events_count = 1) / count() * 100, 1) AS bounce_rate_pct
FROM sessions
GROUP BY platform
ORDER BY total_sessions DESC;