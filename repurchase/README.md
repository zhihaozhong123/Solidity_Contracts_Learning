# Repurchase 回购销毁合约

## 概念：

> 为了减少某种代币从而增加它的稀缺性使其价值升值。

## 目的：

> 添加USDT到CHE-USDT池子中，并销毁CHE-USDT池子到CHE。

## 步骤：
> 在合约中，先触发addCaller方法，添加caller。
> 
> 其次设置amountIn数量，这个数量是USDT的数量。
> 
> 最后触发swap方法将USDT添加到CHE-USDT池子中，并销毁CHE-USDT池子到CHE。

> 销毁的公式是：
> 
> amountIn * 997 * reserve0 / reserve1*1000+(amountIn * 997)
> 
> 备注：reserve0和reserve1在出发swap方法后的日志里有输出的金额，然后带入公式即可算出销毁的CHE的金额。


## 部署详细步骤

> 1.部署CHE（默认100个，给REPURCHASE授权）
> 
> 0x0d57285Ed72b1Db83f497bDBE95C25738D10a8E6

> 2.部署USDT（默认100个，给REPURCHASE授权）
> 
> 0x7f9Ee0245D3Be4bb8F79e9fCafeD81d34C8A623D

> 3.部署FACTORY （拿到init_code_hash给router02合约）0x3f65323e8FE950eD6b00c9ade89E32552e5A2b82
>
> 此时，CHE-USDT合约地址：
>
> 0x87B2Cc033901C512306F011A4CC70461584dcCd9

> 4.部署WETH
>
> 0x0DC5bbEDfEAEB24E266521C009A944FFE8357820

> 5.部署ROUTER
>
> 0xb7b51Abbeb753A5c5314c4C2f9104370fCf60995

> addLiquidity
>
> tokenA:0x0d57285Ed72b1Db83f497bDBE95C25738D10a8E6
>
> tokenB:0x7f9Ee0245D3Be4bb8F79e9fCafeD81d34C8A623D
>
> amountADesired: 1000000000000000000
>
> amountBDesired: 1000000000000000000
>
> amountAMin: 1
>
> amountBMin: 1
>
> To: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
>
> Deadline: 999999999999999

> 6.部署REPURCHASE(转10个USDT到合约内)
>
> 0xf2F511aA9Ae98d5dc806523f69Ba09dE568f88D1
>
> addCaller：0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
>
> setAmountIn：
>
> 1000000000000000000

￼
￼


