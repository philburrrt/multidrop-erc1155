# Multidrop ERC1155

## TLDR

With this contract, you can create multiple 'drops', which have their own supply, price, and tokenURI.
This is useful for creating a 'curated' collection, which have multiple NFTs with different information. Though, there is no way to use multiple tokenURIs within a drop currently.

## Testing / Deploying

### Install forge

`curl -L https://foundry.paradigm.xyz | bash`

### Clone this repo

in your repository folder, run `foundryup` then `forge install`

### Run tests

`forge test`

### Deploy

First, fill out .env with your information.

Change $RINKBY_RPC_URL to $MAINNET_RPC_URL if you want to deploy to mainnet.

`deployment.sh`

## Creating a drop

On etherscan, you can call the `createDrop` function with the following parameters:
```
uint256 id,
uint256 price,
uint256 supplyAmt,
string memory tokenURI
```

*Note: price needs to be in Wei. You can convert here: https://eth-converter.com/*

You can edit any variable at any time, as long as you are not reducing the supplyAmt lower than the current supply.

## Minting

`devMint` allows you to send an NFT to any address or send multiple NFTs to multiple addresses.

`mintDrop` is what you will want to hookup on a frontend for users.

Call `activateSale` to allow users to purchase NFTs.