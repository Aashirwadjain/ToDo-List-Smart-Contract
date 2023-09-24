// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract ToDo {

    enum PRIORITY { HIGH, MEDIUM, NORMAL }

    struct Item {
        uint itemId;
        string description;
        PRIORITY itemPriority;
        address createdBy;
    }

    uint public itemCount;
    mapping(uint => Item) private itemInfo;
    mapping(address => uint[]) private userItems;

    modifier onlyValidItem(uint itemId) {
        require(itemId != 0 && itemInfo[itemId].itemId == itemId, "Invalid Item");
        _;
    }

    modifier onlyOwner(uint itemId) {
        require(itemInfo[itemId].createdBy == msg.sender, "Insufficient Access");
        _;
    }

    function addItem(string memory _description, uint _priority) public {
        itemCount++;
        
        itemInfo[itemCount].itemId = itemCount;
        itemInfo[itemCount].description = _description;
        itemInfo[itemCount].itemPriority = _priority == 0 ? PRIORITY.HIGH : _priority == 1 ? PRIORITY.MEDIUM : PRIORITY.NORMAL;
        itemInfo[itemCount].createdBy = msg.sender;

        userItems[msg.sender].push(itemCount);
    }

    function deleteItem(uint itemId) public onlyValidItem(itemId) {

        require(itemInfo[itemId].createdBy == msg.sender, "Insufficient Access");

        delete itemInfo[itemId];

        uint len = userItems[msg.sender].length;
        for(uint i=0; i<len; i++) {
            if(userItems[msg.sender][i] == itemId) {
                userItems[msg.sender][i] = userItems[msg.sender][len-1];
                userItems[msg.sender].pop();
            }
        }
    }

    function updateItemPriority(uint itemId, uint priority) public onlyValidItem(itemId) onlyOwner(itemId) {

        itemInfo[itemCount].itemPriority = priority == 0 ? PRIORITY.HIGH : priority == 1 ? PRIORITY.MEDIUM : PRIORITY.NORMAL;

    }

    function updateItemDescription(uint itemId, string memory description) public onlyValidItem(itemId) onlyOwner(itemId) {
        
        itemInfo[itemCount].description = description;

    }

    function getItemInfo(uint itemId) public view onlyValidItem(itemId) onlyOwner(itemId) returns (uint _itemId, string memory description, string memory itemPriority) {

        string memory _itemPriority = itemInfo[itemId].itemPriority == PRIORITY.HIGH ? "HIGH" : itemInfo[itemId].itemPriority == PRIORITY.MEDIUM ? "MEDIUM" : "NORMAL";

        return (itemInfo[itemId].itemId, itemInfo[itemId].description, _itemPriority);

    }

    function getUserItemIds() public view returns (uint[] memory) {
        return userItems[msg.sender];
    }

}