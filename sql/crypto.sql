CREATE DATABASE BTC;
CREATE SCHEMA BTC_SCHEMA;
CREATE OR REPLACE STAGE BTC.BTC_SCHEMA.BTC_STAGE
  URL='s3://aws-public-blockchain/v1.0/btc/'
  FILE_FORMAT=(TYPE=PARQUET);

  LIST @BTC.BTC_SCHEMA.BTC_STAGE;

  CREATE OR REPLACE WAREHOUSE LARGE_WH
  WITH WAREHOUSE_SIZE = 'LARGE'
  AUTO_SUSPEND = 1;

  SELECT t.$1
  FROM @BTC.BTC_SCHEMA.BTC_STAGE/transactions/date=2026-02-15 t
  LIMIT 10;

  SELECT
  t.$1:hash as hashkey,
  t.$1:block_hash as block_hash,
  t.$1:block_number as block_number,
  t.$1:block_timestamp as block_timestamp,
  t.$1:fee as fee,
  t.$1:input_value as input_value,
  t.$1:output_value as output_btc,
  ROUND(t.$1:fee / t.$1:size, 12) as fee_per_byte,
  t.$1:is_coinbase as is_coinbase
  t.$1:outputs as outputs
  FROM @BTC.BTC_SCHEMA.BTC_STAGE/transactions/date=2026-02-15 t;

  CREATE OR REPLACE TABLE BTC.BTC_SCHEMA.BTC (
  hashkey STRING,
  block_hash STRING,
  block_number int,
  block_timestamp timestamp,
  fee FLOAT,
  input_value FLOAT,
  output_btc FLOAT,
  fee_per_byte FLOAT,
  is_coinbase BOOLEAN,
  outputs VARIANT
  );

-- ignore the summarize files
-- there we need a PATTERN
  COPY INTO BTC.BTC_SCHEMA.BTC
  FROM(
    SELECT
     t.$1:hash as hashkey,
     t.$1:block_hash as block_hash,
     t.$1:block_number as block_number,
     t.$1:block_timestamp as block_timestamp,
     t.$1:fee as fee,
     t.$1:input_value as input_value,
     t.$1:output_value as output_btc,
     ROUND(t.$1:fee / t.$1:size, 12) as fee_per_byte,
     t.$1:is_coinbase as is_coinbase,
     t.$1:outputs as outputs
     FROM @BTC.BTC_SCHEMA.BTC_STAGE/transactions t
  )
  PATTERN='.*/[0-9]{6,7}[.]snappy[.]parquet'
  ;

  CREATE OR REPLACE TASK BTC.BTC_SCHEMA.BTC_LOAD_TASK
  WAREHOUSE=LARGE_WH
  SCHEDULE='2 HOUR'
  AS
    COPY INTO BTC.BTC_SCHEMA.BTC
  FROM(
    SELECT
     t.$1:hash as hashkey,
     t.$1:block_hash as block_hash,
     t.$1:block_number as block_number,
     t.$1:block_timestamp as block_timestamp,
     t.$1:fee as fee,
     t.$1:input_value as input_value,
     t.$1:output_value as output_btc,
     ROUND(t.$1:fee / t.$1:size, 12) as fee_per_byte,
     t.$1:is_coinbase as is_coinbase,
     t.$1:outputs as outputs
     FROM @BTC.BTC_SCHEMA.BTC_STAGE/transactions t
  )
  PATTERN='.*/[0-9]{6,7}[.]snappy[.]parquet'
  ;

  ALTER TASK BTC.BTC_SCHEMA.BTC_LOAD_TASK RESUME;

  ALTER TASK BTC.BTC_SCHEMA.BTC_LOAD_TASK SUSPEND;

EXECUTE TASK BTC.BTC_SCHEMA.BTC_LOAD_TASK;