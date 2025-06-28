# FUND ME
this is a crowdsourcing contract to provide an opportunity for the community to contribute financiially to the project which will be withdrawen by the owner and then used for the core purpose of improving user experience and incentives
## Features
✅ Accepts ETH contributions from any user  
✅ Enforces a minimum contribution in USD terms using Chainlink oracles  
✅ Tracks contributors and amounts funded  
✅ Only the contract owner can withdraw collected funds  
✅ Includes unit and integration tests with Foundry  
## Contract Overview
The key functionality of the fundme contract are
- Price converter library

  - ` ` `getprice()` ` ` function to get the most recent price of the Token from a chainlink refrence contract
  - ` ` `getConvertionRate()` ` ` function to convert the Token ammount to be funded to its USD value
  
- Fundme Contract
  
  - ` ` `constructor()` ` `  function that set the owner address and pricefeed address
  - ` ` `fund()` ` ` function which is payable and pass the ` ` `msg.value` ` ` and ` ` `s_pricefeed` ` ` into the ` ` `getConvertionRate()` ` ` to enable user fund a value ` ` `>=5e15 wei` ` ` which will store their address inside a ` ` `funders` ` ` array and a mapping of ` ` `address to ammount funded` ` `
  - ` ` `onlyOwner()` ` ` function modifier sets the owner to be strictly equal to the ` ` `msg.sender` ` ` it modifies the withdraw function
  - ` ` `withdraw()` ` ` function allows the owner to withdraw all the ammount funded of all the funders and set the array and mapping to a zeroth address and ammount respectively
## Installation
**Clone the repo:**

` ` `bash
git clone https://github.com/Andrewgx/foundry-fund-me-f24
cd foundry-fund-me-f24
forge build
` ` `
<p></p>

**Install foundry:**

` ` `bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
` ` `
<p></p>

**Install dependencies:**

` ` `bash
forge install
` ` `

## Usage
### Deploy locally
**Start a local anvil node:**

` ` `bash
anvil
` ` `

**Deploy contract with foundry:**

` ` `bash
forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --broadcast -vvvv
` ` `
### Deploy to a Testnet(SEPOLIA)

**Set your .env file:**

` ` `bash
SEPOLIA_RPC_URL=YOUR_RPC_URL
SEPOLIA_PRIVATE_KEY=YOUR_PRIVATE_KEY
` ` `
<p></p>

Then:

` ` `bash
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast -vvvv
` ` `

## Security Notes
- Access control enforced with onlyOwner modifier

- Minimum funding validated with Chainlink oracles

- Well-tested with unit and integration tests
## Contributing
Pull requests and suggestions are welcome!

` ` `bash
git checkout -b feature/your-feature
git commit -m "Add feature"
git push origin feature/your-feature
` ` `

## License
MIT license uas used

## Author
You can reach out to the author of this project on X(Twitter)
https://x.com/bricks_chains 

## Aknoledgments
This project was made possible with the help of @PatrickAlphaC(https://github.com/PatrickAlphaC) a smartcontract engineer and educator 