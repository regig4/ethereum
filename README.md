# Ethereum smart contract

This repo contains smart contract implemented in Solidity and DApp written in Angular.

## Steps to run

1. Install [Metamask](https://metamask.github.io) Chrome Extension
2. Run `docker pull regig/eth:1.0`
3. Run `docker container run --publish 8545:8545 --publish 8000:4200 -d -t --name ether regig/eth:1.0` 
4. In Metamask set mnemonic "crowd lonely market egg fashion very secret half grow figure unfair exile" and connect to local blockchain on localhost:8545
5. Go to `localhost:8000` in Chrome, allow Metamask to access site, after that refreshing site might be required
6. Choose company Apple and paper with id:2 to buy stock



## Troubleshooting

In case of error resulting in empty list of companies try connecting to local blockchain with Metamask once again
