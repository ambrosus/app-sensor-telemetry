## app-sensor-telemetry
This application demonstrates capturing sensor measurements on the blockchain using Ambrosus API.

It's composed of:
1. A local connection to our private Ethereum test network using testrpc
2. A local node.js app (bridge) that receives data from sensors and pushes it 
3. An ethereum smart contract that receives sensor data periodically and reacts if sensed data exceeds a predefined threshold

## Installation 
1. Clone this repo and install dependencies
```
$ git clone https://github.com/ambrosus/app-sensor-telemetry
$ cd app-sensor-telemetry
$ npm install
```
2. In a separate shell, start testrpc
```
$ npx testrpc 
``` 

3. Deploy contracts to the network
```
$ npx truffle migrate
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
2. Open a browser and create a shipment by going to:
```
http://localhost:3000/shipment?
    owner=0x2EB...4474
    &secret=0xa0e13...456fd
    &shipmentId=123
    &name=Tylenol
    &minTemp=0
    &maxTemp=10
    &minHumiditiy=40
    &maxHumiditiy=45
    &minAirPressure=980
    &maxAirPressure=1010
```
3. Then submit sensor data like so:
```
http://localhost:3000/telemetry?
    owner=0x2EB...4474
    &secret=0xa0e13...456fd
    &shipmentId=123
    &name=Tylenol
    &temp=5
    &humiditiy=40
    &aipressure=1000
```

Both shipment and sensor data are uploaded to the smart contract. After submitting a data from sensor, it's verified by smart contract to fulfill all requirements(e.g. temperature, humidity and air pressure). If it doesn't, the smart contract marks whole shipment as defective. To check the shipment status, go by URL:

```
http://localhost:3000/status?
    owner=0x2EB...4474
    &shipmentId=123
```
If the shipment's quality is too low, the owner may be punished in some way, for example by giving a rebate to the customer or by reducing the balance of shipment's owner in the Ambrosus Network.  
To further examine all events related to the shipment, you can check the  [Ambrosus Network](https://dev.ambrosus.com/).
