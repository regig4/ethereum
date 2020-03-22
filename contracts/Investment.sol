pragma solidity >=0.4.21 <0.7.0;


contract Investment {

    struct Paper {
        uint id;
        address issuer;
        address payable owner;
        PaperState state;
        uint price;
    }

    enum PaperState { Issued, Trading, Redeemed }

    struct Company {
        bytes32 name;
        address addr;
    }

    Company[] companies;
    Paper[] papers;
    mapping (address => Paper[]) paperIssuedByCompany;


    event TransactionOccured(address payable from, address payable to, uint value);

    constructor() public {
        initData();
    }

    function initData() private {
        address appleAddress = 0xF661B71BeC9a6dAac0bd5E897c3d242dF18eDc11;
        address googleAddress = 0x94FB29447e4b8FBA43e90eA46a2f51C2191f4Fea;
        address facebookAddress = 0x21A4a0D1499A20D503969190C5D98E4Ab51ca4C4;

        companies.push(Company({
            name: "Apple",
            addr: appleAddress
        }));

        companies.push(Company({
            name: "Google",
            addr: googleAddress
        }));

        companies.push(Company({
            name: "Facebook",
            addr: facebookAddress
        }));

        Paper memory paper1 = Paper({
            id: 1,
            issuer: appleAddress,
            owner: address(uint160(appleAddress)),
            state: PaperState.Issued,
            price: 200
        });
        paperIssuedByCompany[appleAddress].push(paper1);
        papers.push(paper1);

        Paper memory paper2 = Paper({
            id: 2,
            issuer: appleAddress,
            owner: address(uint160(googleAddress)),
            state: PaperState.Trading,
            price: 60
        });
        paperIssuedByCompany[appleAddress].push(paper2);
        papers.push(paper2);

        Paper memory paper3 = Paper({
            id: 3,
            issuer: googleAddress,
            owner: address(uint160(appleAddress)),
            state: PaperState.Trading,
            price: 150
        });
        paperIssuedByCompany[googleAddress].push(paper3);
        papers.push(paper3);

        Paper memory paper4 = Paper({
            id: 4,
            issuer: facebookAddress,
            owner: address(uint160(appleAddress)),
            state: PaperState.Trading,
            price: 30
        });
        paperIssuedByCompany[facebookAddress].push(paper4);
        papers.push(paper4);

        Paper memory paper5 = Paper({
            id: 5,
            issuer: facebookAddress,
            owner: address(uint160(facebookAddress)),
            state: PaperState.Issued,
            price: 40
        });
        paperIssuedByCompany[facebookAddress].push(paper5);
        papers.push(paper5);

        Paper memory paper6 = Paper({
            id: 6,
            issuer: googleAddress,
            owner: address(uint160(googleAddress)),
            state: PaperState.Issued,
            price: 10
        });
        paperIssuedByCompany[googleAddress].push(paper6);
        papers.push(paper6);

        Paper memory paper7 = Paper({
            id: 7,
            issuer: appleAddress,
            owner: address(uint160(googleAddress)),
            state: PaperState.Trading,
            price: 7000000
        });
        paperIssuedByCompany[appleAddress].push(paper7);
        papers.push(paper7);

        Paper memory paper8 = Paper({
            id: 8,
            issuer: facebookAddress,
            owner: address(uint160(appleAddress)),
            state: PaperState.Trading,
            price: 50
        });
        paperIssuedByCompany[facebookAddress].push(paper8);
        papers.push(paper8);
    }


    function getCompanies() public view returns (address[] memory, bytes32[] memory) {
        address[] memory companyAddresses = new address[](companies.length);
        bytes32[] memory companyNames = new bytes32[](companies.length);
        for (uint i = 0; i < companies.length; i++) {
            Company memory company = companies[i];
            companyAddresses[i] = company.addr;
            companyNames[i] = company.name;
        }
        return (companyAddresses, companyNames);
    }

    function getPapers(address owner) public view returns (uint[] memory, address[] memory, address[] memory, uint[] memory) {
        Paper[] memory paperOfCompany = paperIssuedByCompany[owner];
        uint[] memory ids = new uint[](paperOfCompany.length);
        address[] memory issuerAddr = new address[](paperOfCompany.length);
        address[] memory ownerAddr = new address[](paperOfCompany.length);
        uint[] memory prices = new uint[](paperOfCompany.length);

        for (uint i = 0; i < paperOfCompany.length; i++) {
            Paper memory p = paperOfCompany[i];
            ids[i] = p.id;
            issuerAddr[i] = p.issuer;
            ownerAddr[i] = p.owner;
            prices[i] = p.price;
        }

        return (ids, issuerAddr, ownerAddr, prices);
    }

    function buy(uint paperId) public payable {
        Paper memory paper = papers[paperId - 1];

        if(paper.price > msg.value) {
            revert("Insufficient funds sent.");
        }

        if(paper.state != PaperState.Trading) {
            revert("Paper is not in trading state.");
        }

        emit TransactionOccured(msg.sender, paper.owner, msg.value);
        paper.owner.transfer(msg.value);
        paper.owner = address(uint160(msg.sender));
    }
}
