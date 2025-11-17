// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ShareSphere {
    struct Content {
        uint256 id;
        address creator;
        string title;
        string description;
        string contentUrl;
        string contentType; // "video", "audio", "image", "link"
        uint256 timestamp;
        uint256 likes;
        bool isActive;
    }
    

 

struct User {
        address userAddress;
        string username;
        uint256 totalShares;
        bool isRegistered;
    }

struct User {
        address userAddress;
        string username;
        uint256 totalShares;
        bool isRegistered;
    }
struct User {
        address userAddress;
        string username;
        uint256 totalShares;
        bool isRegistered;
    }
struct User {
        address userAddress;
        string username;
        uint256 totalShares;
        bool isRegistered;
    }
struct User {
        address userAddress;
        string username;
        uint256 totalShares;
        bool isRegistered;
    }

    
    mapping(uint256 => Content) public contents;
    mapping(address => User) public users;
    mapping(uint256 => mapping(address => bool)) public hasLiked;
    mapping(address => uint256[]) public userContents;
    
    uint256 public nextContentId = 1;
    uint256 public totalUsers = 0;
    
    event UserRegistered(address indexed user, string username);
    event ContentShared(uint256 indexed contentId, address indexed creator, string title);
    event ContentLiked(uint256 indexed contentId, address indexed liker);
    event ContentRemoved(uint256 indexed contentId, address indexed creator);
    
    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "User not registered");
        _;
    }
    
    modifier contentExists(uint256 _contentId) {
        require(_contentId > 0 && _contentId < nextContentId, "Content does not exist");
        require(contents[_contentId].isActive, "Content is not active");
        _;
    }
    
    // Core Function 1: Register User
    function registerUser(string memory _username) external {
        require(!users[msg.sender].isRegistered, "User already registered");
        require(bytes(_username).length > 0, "Username cannot be empty");
        
        users[msg.sender] = User({
            userAddress: msg.sender,
            username: _username,
            totalShares: 0,
            isRegistered: true
        });
        
        totalUsers++;
        emit UserRegistered(msg.sender, _username);
    }
    
    // Core Function 2: Share Content
    function shareContent(
        string memory _title,
        string memory _description,
        string memory _contentUrl,
        string memory _contentType
    ) external onlyRegistered returns (uint256) {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_contentUrl).length > 0, "Content URL cannot be empty");
        
        uint256 contentId = nextContentId++;
        
        contents[contentId] = Content({
            id: contentId,
            creator: msg.sender,
            title: _title,
            description: _description,
            contentUrl: _contentUrl,
            contentType: _contentType,
            timestamp: block.timestamp,
            likes: 0,
            isActive: true
        });
        
        userContents[msg.sender].push(contentId);
        users[msg.sender].totalShares++;
        
        emit ContentShared(contentId, msg.sender, _title);
        return contentId;
    }
    
    // Core Function 3: Like Content
    function likeContent(uint256 _contentId) external onlyRegistered contentExists(_contentId) {
        require(!hasLiked[_contentId][msg.sender], "Already liked this content");
        require(contents[_contentId].creator != msg.sender, "Cannot like your own content");
        
        hasLiked[_contentId][msg.sender] = true;
        contents[_contentId].likes++;
        
        emit ContentLiked(_contentId, msg.sender);
    }
    
    // Additional utility functions
    function getContent(uint256 _contentId) external view contentExists(_contentId) returns (
        uint256 id,
        address creator,
        string memory title,
        string memory description,
        string memory contentUrl,
        string memory contentType,
        uint256 timestamp,
        uint256 likes
    ) {
        Content memory content = contents[_contentId];
        return (
            content.id,
            content.creator,
            content.title,
            content.description,
            content.contentUrl,
            content.contentType,
            content.timestamp,
            content.likes
        );
    }
    
    function getUserContents(address _user) external view returns (uint256[] memory) {
        return userContents[_user];
    }
    
    function removeContent(uint256 _contentId) external contentExists(_contentId) {
        require(contents[_contentId].creator == msg.sender, "Only creator can remove content");
        
        contents[_contentId].isActive = false;
        emit ContentRemoved(_contentId, msg.sender);
    }
    
    function getTotalContents() external view returns (uint256) {
        return nextContentId - 1;
    }
}
