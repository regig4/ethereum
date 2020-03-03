const Migrations = artifacts.require("Investment");
  
module.exports = function(deployer) {
  deployer.deploy(Migrations);
};