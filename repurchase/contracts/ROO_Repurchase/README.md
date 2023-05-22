repurchase合约:
回购销毁合约规则:
     指定USDT数量,根据池子USDT-ROO的兑换价格来回购ROO的数量
     比如:合约指定USDT的数量为1,USDT-ROO的兑换比例为1:1.2,那么执行回购销毁合约方法就会主动将
1USDT存入USDT-ROO池子,而取出1.2ROO存入销毁地址.

回购销毁合约前提条件:
  对应主网链的USDT合约地址,
  拥有该主网链的USDT代币钱包账号
  ROO合约地址
  USDT-ROO池子合约地址
  dex平台是否有收取手续费
  回购地址,可以是黑洞合约地址,也可以指定某个钱包账号地址



部署步骤: 1. 找到对应链的USDT合约,用拥有对应的链的USDT的钱包账号去at Address,此时钱包账号就能操控这份合约.
               2. 给Repourchase合约转USDT代币
构造器:  
            amount: 指定USDT数量
            emergencyAddress: 紧急提取账户
               3. 调用addCaller方法,指定哪个钱包账号可以调用swap方法
               4. 调用swap方法

火币主网链USDT合约地址: 0xa71EdC38d189767582C38A3145b5873052c3e47a
okex测试链USDT合约地址: 0xe579156f9dEcc4134B5E3A30a24Ac46BB8B01281

火币主网链ROO合约地址: 0xADdEb3A8fB46DDc3feE55085b6AD8DaB4C4fC771
BXH去中心化交易所ROO_USDT池子的合约地址: 0xC05bb03bB7bFEB243EF364F544c81dD9a07040a2
  
==============================================


repurchase合约(改):
   规则: 不限制USDT的数量,由项目方主动输入USDT的数量去回购ROO代币
   比如: 输入1USDT回购ROO代币,输入10USDT回购ROO代币

部署步骤: 1. 找到对应链的USDT合约,用拥有对应的链的USDT的钱包账号去at Address,此时钱包账号就能操控这份合约.
               2. 给Repourchase合约转USDT代币
               3. 调用addCaller方法,指定哪个钱包账号可以调用swap方法
               4. 输入USDT的数量,调用swap方法
构造器:  
            emergencyAddress: 紧急提取账户