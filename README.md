# Performance comparison for different sharding methods

Book properties:
- title (no index)
- author (with index)
- year (with index)
- category (base property for sharding, has index)

Methods of sharding:
- no sharding
- 3 shards on same server
- FDW shards on other containers
- Citus

Testing of all sharding methods:
1. Insert 1 million of generated books. Record how much time the script took.
2. Perform a search by author, title, time range and category.

Comparison table:

| Method | Script Time | Search by Author | Search by Title | Search by Time Range | Search by Category |
|--------|----------------------|-----------------------|----------------------|---------------------------|-------------------------|
| No sharding | 102.84 s | 108 ms | 125 ms | 48 ms | 42 ms |
| One DB server| 125.82 s | 95 ms | 129 ms | 44 ms | 42 ms |
| FDW sharding  | 278.67 s | 100 ms | 122 ms | 99 ms | 110 ms |
| Citus sharding  | 316.07 s | 192 ms | 261 ms | 94 ms | 48 ms |


## Conclusion
Citus sharding looks easier to implement but there is much less controll over how sharding happens. Moreover you need to have citus installed (using citus docker image in my case instead of plain postgres), `POSTGRES_SHARED_PRELOAD_LIBRARIES: citus` has to be added to container environment.
Also you cannot just use any column as a sharding base. It has to be a part of PRIMARY KEY.