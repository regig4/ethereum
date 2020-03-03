# Ethereum smart contract

This repo contains smart contract implemented in Solidity and DApp written in Angular.

## Steps to run

1. Install [Metamask](https://metamask.github.io) Chrome Extension
2. Run `docker pull regig/eth:1.0`
3. Run `docker container run --publish 8545:8545 --publish 8000:4200 -d -t --name ether regig/eth:1.0`
4. In Metamask connect to localhost:8545
5. Go to `localhost:8000` in Chrome
