## app-sensor-telemetry
This application demonstrates capturing sensor measurements on the blockchain using Ambrosus API.

## Installation 
1. Clone this repo and install dependencies
```
$ git clone https://github.com/ambrosus/app-sensor-telemetry
$ cd app-sensor-telemetry
$ npm install
```
2. In a separate shell, start testrpc
```
$ testrpc -u0 -u1 -u2 -u3
``` 

NOTE: If you don't have testrpc, you can install like so: `npm i -g ethereumjs-testrpc`

3. Deploy contracts to the network
```
$ truffle migrate
``` 

4. Start Web server
```
$ npm start
```
You should see something along the lines of:
```
$ npm start

> app-sensor-telemetry@1.0.0 start /home/ambrosus/app-sensor-telemetry
> DEBUG=api:* ./bin/api

  api:server API service started on 0.0.0.0:3000 +0ms

```

## Usage
1. Create an account at [https://dev.ambrosus.com](https://dev.ambrosus.com) and get an address and secret. 
2. Open a browser and send a shipment and sensor data like so:
```
http://localhost:3000/telemetry/send?
    owner=0x2EB...4474
    &secret=0xa0e13...456fd
    &shipmentId=123
    &name=Tylenol
    &temp=5
    &humiditiy=40
    &aipressure=1000
```

A shipment is created if it doesn't exist. all subsequent calls add sensor information to the given `shipmentId`.

