#!/bin/bash

# run ganache-cli with deployed contract
cd /home/eth/ethereum
truffle compile
#
ganache-cli -m "crowd lonely market egg fashion very secret half grow figure unfair exile" -p 8545 --host=0.0.0.0 &    
sleep 5
truffle migrate

# run angular client
cd /home/eth/ethereum/client
npm start
