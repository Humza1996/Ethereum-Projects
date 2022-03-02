// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

contract escrow{
    

    //__________________________________________________Variables_____________________________________________//

    address buyer;
    address payable seller;
    uint256 budget;

    enum STATUSES {WAITING_FOR_DEPOSIT,DEPOSIT_CONFIRMED,SHIPMENT_IN_PROGRESS,SHIPMENT_RECEIVED,PAYMENT_RELEASED}
    STATUSES ProjectStatus;

    //__________________________________________________Methods_____________________________________________//

    event PaymentDeposit(uint256 P , string message);
    event PaymentReleased(string message);

    constructor(address _buyer,address payable _seller, uint256 _amount){
        buyer = _buyer;
        seller = _seller;
        budget = _amount;
        ProjectStatus = STATUSES.WAITING_FOR_DEPOSIT;
    }


    modifier onlyBuyer(){
        require(msg.sender==buyer,"You are not allowed to deposit.");
        _;
    }

    modifier onlySeller(){
        require(msg.sender==seller,"You are not Seller");
        _;
    }

    function deposit() payable external onlyBuyer{

        require(ProjectStatus==STATUSES.WAITING_FOR_DEPOSIT,"You Can't Deposit at This stage");
        require(msg.value == budget,"Your Deposit Amount is equal to Budget");
        
        ProjectStatus = STATUSES.DEPOSIT_CONFIRMED;
        emit PaymentDeposit(msg.value,"Payment has been deposit in contract");
    }

    function shipment_start() external onlySeller{

        require(ProjectStatus==STATUSES.DEPOSIT_CONFIRMED,"You Can't Shipment at This stage");
        ProjectStatus = STATUSES.SHIPMENT_IN_PROGRESS;
    }

    function shipment_arrived() external onlyBuyer payable{

        require(ProjectStatus==STATUSES.SHIPMENT_IN_PROGRESS,"You Can't Release Payment at This stage");
        ProjectStatus = STATUSES.SHIPMENT_RECEIVED;

        seller.transfer(address(this).balance);
        ProjectStatus = STATUSES.PAYMENT_RELEASED;
        emit PaymentReleased("Project is marked Completed");

    }

}
