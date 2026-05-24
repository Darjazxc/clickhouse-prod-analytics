CREATE TABLE users (
    user_id        String,
    registered_at  DateTime,
    platform       LowCardinality(String),  -- ios / android / web
    country        LowCardinality(String),
    age_group      LowCardinality(String),  -- 18-24 / 25-34 / 35-44 / 45+
    channel        LowCardinality(String)   -- откуда пришёл: organic / paid / referral
)
ENGINE = MergeTree()
ORDER BY user_id;

CREATE TABLE events (
    event_id    String,
    user_id     String,
    session_id  String,
    event_type  LowCardinality(String),
    event_time  DateTime,
    platform    LowCardinality(String),
    country     LowCardinality(String),
    properties  String   -- JSON с доп. параметрами
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(event_time)
ORDER BY (user_id, event_time);

CREATE TABLE sessions (
    session_id    String,
    user_id       String,
    started_at    DateTime,
    ended_at      DateTime,
    duration_sec  UInt32,
    platform      LowCardinality(String),
    events_count  UInt16
)
ENGINE = MergeTree()
ORDER BY (user_id, started_at);