pragma solidity >=0.4.21 <0.7.0;

import "truffle/Assert.sol";
import "../contracts/Investment.sol";

contract TestInvestment {
    function testGetCompanies() public {
        Investment investment = new Investment();
        (address[] memory companyAddresses, bytes32[] memory companyNames) = investment.getCompanies();
        Assert.equal(companyAddresses.length, companyNames.length, "Company addresses and company names should contain same number of items.");
    }

    function testGetPapers() public {
        Investment investment = new Investment();
        address faceBookAddr = 0x21A4a0D1499A20D503969190C5D98E4Ab51ca4C4;
        (uint[] memory ids, address[] memory issuers, address[] memory owners, uint[] memory prices) = investment.getPapers(faceBookAddr);
        Assert.equal(ids.length, issuers.length, "Ids and issuers should contain same number of items.");
        Assert.equal(issuers.length, owners.length, "Issuers and owners should contain same number of items.");
        Assert.equal(owners.length, prices.length, "Owners and prices should contain same number of items.");
    }
}