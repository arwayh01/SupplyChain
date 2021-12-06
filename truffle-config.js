module.exports = {
networks: {
	development: {
	host: "127.0.0.1",	 // Localhost (default: none)
	port: 7545,		 // Standard Ethereum port (default: none)
	network_id: "*",	 // Any network (default: none)
	},
advanced: {
    gas: 7000000,           // Gas sent with each transaction (default: ~6700000)
    gasPrice: 1000 // 20 gwei (in wei) (default: 100 gwei)

}},
	contracts_build_directory: "./src/artifacts/",

// Configure your compilers
compilers: {
	solc: {

	// See the solidity docs for advice
	// about optimization and evmVersion
		optimizer: {
		enabled: false,
		runs: 200
		},
		evmVersion: "byzantium"
	}
}
};
