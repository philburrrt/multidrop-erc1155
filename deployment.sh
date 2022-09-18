source .env
forge script script/Deploy.s.sol:Deploy --rpc-url $RINKEBY_RPC_URL  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $MAINNET_ETHERSCAN_KEY -vvvv