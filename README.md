# OperationTask
This app consists of four major components:
1. Rest API server
2. Rest API client
3. WebSocket server
4. WebSocket client

## REST API server

The API server has two endpoints:

1. `/api/companies` which lists all the available companies
2. `api/companies/:timestamp` which `list/array` all the companies whose inserted_at is greater or equal to the timestamp given. Kindly note that the inserted_at is in the `UTC` timezone. Also worth noting is timestamp should DateTime string in this format `2022-12-28T04:13:11`.

####  Response body 
In case of success
`{"data":[{"category":"Music","country":"USA","currency":"USD","inserted_at":"2022-12-28T01:57:33","name":"Collins - Purdy","stock_market":"Ergonomic","stock_price":626.77,"symbol":"Col","timestamp":"2022-12-28T00:31:11.988Z"}]`.
In case `api/companies/:timestamp` request is made with an invalid timestamp `422` code will be returned with the body
`{"error":"invalid_date_time_format"}`

## REST API client

The rest client periodically(after every 4 hours) make requests to the stock market endpoint. Timestamp to make sure all new companies are fetched i.e companies whose timestamps are greater or equal to the time the last request was made.

## Websocket Server
It  send push notifications to clients each time new companies are received from either the rest endpoint or WebSocket.
This push are available on the endpoint  `socket/new_companies`.The pushed message will be in this format

`{"companies":[{"category":"Music","country":"USA","currency":"USD","inserted_at":"2022-12-28T01:57:33","name":"Collins - Purdy","stock_market":"Ergonomic","stock_price":626.77,"symbol":"Col","timestamp":"2022-12-28T00:31:11.988Z"}]`

##  Websocket Client
This receives a push notification each time there are new companies to be pushed.

## Dependencies
- Erlang `25.1.2`
- Elixir  `1.4.2`
- Database: Postgres

## Installations and setting up

[Erlang](https://www.erlang.org/downloads)
[Elixir Installation Guide](https://elixir-lang.org/install.html)

[Postgres Download](https://www.postgresql.org/download/)

For erlang and elixir, you can use [asdf](https://asdf-vm.com/guide/getting-started.html) for installation and version management

 ### Cloning the this 

`git clone https://github.com/okothkongo/operation_task`

### Up and running 

  * copy the `cp .example_env .env`.You can use [mock app]() to test locally.
  * Install dependencies with `mix setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/api/companies`](http://localhost:4000/api/companies) 

If you decide to use the Mock app kindly populate your `.env` file with these
```bash
export API_URL=http://localhost:3000/api
export WEBSOCKET_URL=ws://localhost:5000
```
## The Mock Application
The mock application is [here](https://github.com/okothkongo/mock_stock_provider_and_client)

## Assumptions
These are some assumptions made:
1. All companies received from the servers at any given moment will be unique, especially the company name.
2. Companies received from WebSocket and rest API are also unique and will never contradict.

## What could be made better
1. The first and second assumptions can be cured by adding a unique constraint to the name, therefore if a company is received contradicting this and some data is other attributes have changed it will be viewed as an update and therefore new data by design.
2. Authencation mechanism was not implemented.