module.exports = {

    networks: {
        net: {
            host: "https://exchaintestrpc.okex.org",
            network_id: "*",
        },
    },

    mocha: {
        // timeout: 100000
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.4.26",
        }
    }
};
