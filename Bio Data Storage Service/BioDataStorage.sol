// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract BioData{

    struct USERDATA{
        string firstName;
        string lastName;
        uint8 age;
        uint id;
        address account; 
    }
    

    USERDATA[] private users;
    
    uint256 public ownerBalance;
    address payable owner;

    constructor(address payable _ownerAddress){
        owner = _ownerAddress;
        ownerBalance =0;
    }

    function setUserInfo(string calldata _firstName, string calldata _lastName, uint8 _age, uint _id) public payable
    {

        for(uint8 i=0; i<users.length;i++){
            if (_id==users[i].id){
                require(_id != users[i].id,"ID Already Taken. Try Differrent ID");
            }
        }
        
        USERDATA memory tempUser;
        ownerBalance+=msg.value;

        tempUser.firstName = _firstName;
        tempUser.lastName = _lastName;
        tempUser.age = _age;
        tempUser.account = msg.sender;
        tempUser.id = _id;

        users.push(tempUser);
    
    }

    function getUserInfo(uint _id) public view returns(string memory,string memory,uint8,address){

        for(uint8 i=0; i<users.length;i++){
            if (_id==users[i].id){
                return (users[i].firstName,users[i].lastName,users[i].age,users[i].account);
            }
        }
    } 

    function withdraw(address payable _ownerAddress) public payable{

        uint balance = address(this).balance;
        require(_ownerAddress==owner,"You are not owner.");
        owner.transfer(balance);
        ownerBalance = 0;
    }
}
