import { Component, OnInit } from '@angular/core';
import { Web3Service } from '../util/web3.service';
import { Paper } from '../models/paper';
import { Company } from '../models/company';
import { Transaction } from '../models/transaction';


@Component({
  selector: 'app-investment',
  templateUrl: './investment.component.html',
  styleUrls: ['./investment.component.css']
})
export class InvestmentComponent implements OnInit {

  chosenPaperId: number;
  chosenPaper: Paper;
  papers: Paper[];
  chosenCompany: string;
  companies: Company[];
  error: string;
  balance: number;
  transactions: Transaction[] = [];


  constructor(private web3Service: Web3Service) { }

  ngOnInit() {
    this.web3Service.getCompanies().then(returned => this.companies = returned);
    this.web3Service.getBalance().then(returned => this.balance = returned);
    setTimeout(() => this.web3Service.setUpEvents(transaction => this.transactions.push(transaction)), 500);
  }

  async companySelectionChanged() {
    this.papers = await this.web3Service.getPapers(this.chosenCompany);
    console.log(this.papers);
  }

  async paperSelectionChanged() {
    this.chosenPaper = this.papers.find(p => p.id == this.chosenPaperId);
    this.balance = await this.web3Service.getBalance();
    console.log(this.chosenPaper);
  }

  async send() {
    try {
      await this.web3Service.buy(this.chosenPaper);
    }
    catch(e) {
      console.log("Error object: " + e);
      this.error = "Transaction failed, reason: " + e;
    }

  }

}
