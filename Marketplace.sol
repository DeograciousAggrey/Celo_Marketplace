//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 < 0.9.0;


    interface IERC20Token {
          function transfer(address, uint256) external returns (bool);
          function approve(address, uint256) external returns (bool);
          function transferFrom(address, address, uint256) external returns (bool);
          function totalSupply() external view returns (uint256);
          function balanceOf(address) external view returns (uint256);
          function allowance(address, address) external view returns (uint256);
        
          event Transfer(address indexed from, address indexed to, uint256 value);
          event Approval(address indexed owner, address indexed spender, uint256 value);
    }
    
    contract Marketplace  {
        
        struct Product {
            address payable owner;
            string name;
            string image;
            string description;
            string location;
            uint price;
            uint sold;
        }
        
        Product[] public products;
        mapping(uint => Product) internal productM;
        
        address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
        
        
        function addProduct(
            string memory _name,
            string memory _image,
            string memory _description,
            string memory _location,
            uint _price 
            
            ) public {
                uint _sold = 0;
                for (uint i = 0; i< products.length; i++) {
                    productM[i] = Product(
                        payable(msg.sender),
                        _name,
                        _image,
                        _description,
                        _location,
                        _price,
                        _sold
                        );
                        products.push(productM[i]);
                }
        }
        
        //Function that reads and displays the products
        function displayProducts() public view returns (
            string memory _name,
            string memory _image,
            string memory _description,
            string memory _location,
            uint _price,
            uint _sold
            ) {
            for (uint i = 0; i< products.length; i++) {
                Product memory _product = productM[i];
                return (_product.name, _product.image,_product.description, _product.location, _product.price, _product.sold);
            }
           
        }

        //Function that displays only one product when its index is passed as the parameter
         function viewProduct(uint _index) public view returns (
            string memory _name,
            string memory _image,
            string memory _description,
            string memory _location,
            uint _price,
            uint _sold
            ) {
                Product memory _product = productM[_index];
                return (
                    _product.name,
                    _product.image,
                    _product.description,
                    _product.location,
                    _product.price,
                    _product.sold
                );
        }    
                
        
        
        
        function buyProduct(uint _index) public payable {
            require(IERC20Token(cUsdTokenAddress).transferFrom(msg.sender,productM[_index].owner,productM[_index].price), "Transfer failed");
            
            productM[_index].sold++;
        }
        
        function getProductLength() public view returns(uint){
            return products.length;   
        }
        
}