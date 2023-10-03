// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Borrowing{
    address payable public borrower;
    address payable public lender;
    uint32 public amount;
    uint public feesPercent = 5;
    uint public bonusPercent = 1;
    bool public isPaidBack;

    constructor(address fromLender, uint32 loanAmount) {
        borrower = payable(msg.sender);
        lender = payable(fromLender);
        amount = loanAmount;
    }  

    function borrowMoney() public payable {
        require(lender.balance > amount, "Lender does not have enough funds to grant a loan of that amount");
        require(msg.sender == borrower, "Only the borrower can call this function.");
        require(!isPaidBack, "Loan has already been repaid.");
        require(msg.value == amount, "Incorrect loan amount sent.");

        //lender receives a bonus for lending money, proportional to the amount lent
        uint256 bonus = bonusPercent / 100 * amount;
        lender.transfer(bonus);

        //borrower receives lent money
        borrower.transfer(amount);
    }

    function returnMoney() public payable {
        uint amountRepaid = amount * (1 + feesPercent/100);
        require(msg.sender.balance > amountRepaid, "Borrower does not have enough funds to repay the loan, fees included.");
        require(msg.sender == borrower, "Only the borrower can call this function.");
        require(!isPaidBack, "Loan has already been repaid.");
        require(msg.value == amountRepaid, "Incorrect loan amount sent.");

        //lender receives the repaid amount
        lender.transfer(amountRepaid);
        isPaidBack = true;
    }

//    function lend() public payable {
//       require(lender.balance > amount, "Lender does not have enough funds to grant a loan of that amount");
//        require(msg.sender == lender, "Only the lender can call this function.");
//        require(!isPaidBack, "Loan has already been repaid.");
//        require(msg.value == amount, "Incorrect loan amount sent.");    

//        //borrower receives lent money
//        borrower.transfer(amount);

//        //lender receives a bonus for lending money, proportional to the amount lent
//        uint256 bonus = bonusPercent / 100 * amount;
//        lender.transfer(bonus);
//    }


}