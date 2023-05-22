const Web3 = require('web3');
const fs = require('fs');
const Tx = require("ethereumjs-tx");

const web3 = new Web3(new Web3.providers.HttpProvider('https://exchaintestrpc.okex.org'));

const cherryPairABI = JSON.parse(fs.readFileSync('../abi/cherryPairABI'));
const che_purchaseABI = JSON.parse(fs.readFileSync('../abi/CHE_purchaseABI'));

const poolContractAddr = '0x3E94409fe0B6fEaacaF145B7859A76a4b33d793F'; // USDT-CHE
const purchaseContractAddr = '0x099ee67dfaFdc5EA64b6374fBf4C972034b4aD78'; // purchase contract address  10usdt in

const poolContract = new web3.eth.Contract(cherryPairABI, poolContractAddr);
const purchaseContract = new web3.eth.Contract(che_purchaseABI, purchaseContractAddr);

let rate = {};

module.exports = {

    getReserves: async (req, res) => {
        await poolContract.methods.getReserves().call().then(function (result) {
            res.json({
                "msg": "ok",
                "getReserves": result,
                "result": result[1] / result[0],
            });
            rate = result[1] / result[0];
        })
    },

    swap: async (req, res) => {

        try {

            const val = req.body.value;
            const privateKey = new Buffer('d525368edf3915f1903e66d9eba5809d8a340809fc672c4110d3bc49c38951f1', 'hex') // wallet account privateKey

            const tokenData = await purchaseContract.methods
                .swap(val)
                .encodeABI();

            const gasLimit = await web3.eth.estimateGas({
                from: '0x5551e95Dfee66bb424c66A001d8e17b03B08ccd7', // wallet account
                to: purchaseContractAddr,
                data: tokenData
            });

            let gasPrice = web3.eth.getGasPrice().then(gasp => {
                gasPrice = Number(gasp);
            });

            const nonce = await web3.eth.getTransactionCount("0x5551e95Dfee66bb424c66A001d8e17b03B08ccd7", "pending");

            // 设置token转账参数
            const rawTx = {
                nonce: nonce,
                gasPrice: gasPrice,
                gasLimit: gasLimit,
                to: purchaseContractAddr, // 合约地址
                data: tokenData
            };

            const tx = new Tx(rawTx);
            tx.sign(privateKey);

            const serializedTx = tx.serialize();

            web3.eth.sendSignedTransaction("0x" + serializedTx.toString('hex'), function (err, hash) {
                if (!err) {
                    console.log(hash);
                    res.json({
                        "msg": "ok",
                        "hash": hash,
                        "rawTx":rawTx
                    });
                } else {
                    console.log(err);
                    res.json({
                        "msg": "failed",
                    });
                }
            })
        } catch (e) {
            return "转账失败"
        }
    },

}





