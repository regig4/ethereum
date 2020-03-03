export class Transaction {
    constructor(from, to, value) {
        this.from = from;
        this.to = to;
        this.value = value;
    }

    from: string;
    to: string;
    value: string 
}