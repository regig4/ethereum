import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';
import { Company } from '../models/company';
import { Paper } from '../models/paper';
declare let require: any;
const Web3 = require('web3');
const contract = require('@truffle/contract');
const investment_artifacts = require('../../../build/contracts/Investment.json');

declare let window: any;

@Injectable()
export class Web3Service {
  private web3: any;
  private accounts: string[];
  public ready = false;

  public accountsObservable = new Subject<string[]>();

  constructor() {
    window.addEventListener('load', (event) => {
      this.bootstrapWeb3();
    });
  }

  public bootstrapWeb3() {
    if (typeof window.ethereum !== 'undefined') {
      window.ethereum.enable().then(() => {
        this.web3 = new Web3(window.ethereum);
      });
    } else {
      Web3.providers.HttpProvider.prototype.sendAsync = Web3.providers.HttpProvider.prototype.send;
      this.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
    }

    setInterval(() => this.refreshAccounts(), 100);
  }

  public async artifactsToContract(artifacts) {
    if (!this.web3) {
      const delay = new Promise(resolve => setTimeout(resolve, 100));
      await delay;
      return await this.artifactsToContract(artifacts);
    }

    const contractAbstraction = contract(artifacts);
    contractAbstraction.setProvider(this.web3.currentProvider);
    return contractAbstraction;

  }

  public async setUpEvents(callbackForTransactionOccured) {
    let contract = await this.createContract();
    console.log(contract);
    console.log(contract.events);
    contract.contract.events.TransactionOccured({ fromBlock: 0 }, function (error, event) { console.log(error) })
      .on('data', (log) => {
        let { returnValues: { from, to, value }, blockNumber } = log
        callbackForTransactionOccured({ from, to, value });
      })
      .on('changed', (log) => {
        console.log(`Changed: ${log}`)
      })
      .on('error', (log) => {
        console.log(`error:  ${log}`)
      })
  }

  private async refreshAccounts() {
    const accs = await this.web3.eth.getAccounts();
    console.log('Refreshing accounts');

    if (accs.length === 0) {
      console.warn('Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.');
      return;
    }

    if (!this.accounts || this.accounts.length !== accs.length || this.accounts[0] !== accs[0]) {
      console.log('Observed new accounts');

      this.accountsObservable.next(accs);
      this.accounts = accs;
    }

    this.ready = true;
  }

  public hexToString(hex): string {
    return this.web3.utils.toUtf8(hex);
  }

  public hexToNumber(hex): number {
    return this.web3.utils.hexToNumber(hex);
  }

  public async createContract() {
    let abstraction = await this.artifactsToContract(investment_artifacts);
    let contract = await abstraction.deployed();
    return contract;
  }

  public async getBalance() {
    if (!this.web3) {
      const delay = new Promise(resolve => setTimeout(resolve, 500));
      await delay;
      return await this.getBalance();
    }
    await this.refreshAccounts();
    let myBalanceWei = await this.web3.eth.getBalance(this.accounts[0]);
    console.log("balance in Wei " + myBalanceWei);
    let myBalance = this.web3.utils.fromWei(myBalanceWei.toString(), 'ether');
    return myBalance;
  }

  public async getCompanies(): Promise<Company[]> {
    let contract = await this.createContract();
    let response = await contract.getCompanies.call();

    let result: Company[] = new Array<Company>();
    for (let i = 0; i < response[0].length; i++) {
      let company = new Company();
      company.addr = response[0][i];
      company.name = this.hexToString(response[1][i]);
      result.push(company);
    }
    console.log(result);
    return result;
  }

  public async getPapers(companyAddress: string): Promise<Paper[]> {
    let contract = await this.createContract();
    let response = await contract.getPapers.call(companyAddress);
    console.log(response);
    let result: Paper[] = new Array<Paper>();
    for (let i = 0; i < response[0].length; i++) {
      let paper = new Paper();
      paper.id = this.hexToNumber(response[0][i]);
      paper.issuer = response[1][i];
      paper.owner = response[2][i];
      paper.price = this.hexToNumber(response[3][i]);
      result.push(paper);
    }
    console.log(result);
    return result;
  }

  public async buy(paper: Paper) {
    this.web3.eth.defaultAccount = this.accounts[0];
    let priceInWei = this.web3.utils.toWei(paper.price.toString(), 'ether');

    console.log("id" + paper.id);
    console.log(paper.price);
    console.log(this.accounts[0]);
    let contract = await this.createContract();
    let response = await contract.buy(paper.id, { value: priceInWei, from: this.accounts[0], gas: 91000 });
  }
}