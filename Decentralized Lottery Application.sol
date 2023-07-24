// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants; //Dynamic array
    constructor(){
        manager=msg.sender; //to make manager that address which deploys the contract
    }
    receive() external payable{
        require(msg.value==1 ether);  //Value of buying lottery
        participants.push(payable(msg.sender));  //storing the address of participant in the array
    }
    function checkBal() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
        /*This keyword as we know encodes any input to bytes but we need integers not hexadecimal
        so typecast to uint so it generates any random integer combinations.Basically used to generate
        random digits to select winner*/
    }   
    function SelectWinner() public returns(address){
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        uint index=r % participants.length;//random no.generated on taking mod with size will give random index based on remainder
        address payable winner;
        winner=participants[index];
        winner.transfer(checkBal());  //Transferring all Eth to winner account
        participants=new address payable[](0); //resetting the participants array for further 
        return winner;
    }
   
   
}