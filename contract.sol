
pragma solidity >=0.7.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
 
contract StorageTesting {

    uint256 public number;
    string public text;
    
    address public account;
    
    /**
     * @dev Store number in variable
     * @param num value to store
     */
    function storeNumber(uint256 num) public {
        number = num;
    }
        
    /**
     * @dev Store text in variable
     * @param txt value to store
     */
    function storeText(string memory txt) public {
        text = txt;
    }
    
    /**
     * @dev Store address in variable
     * @param acc value to store
     */
    function storeAccount(address acc) public {
        account = acc;
    }

}