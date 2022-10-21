//run.js

const main = async() => {
  //コントラクトがコンパイル
  // コントラクトを扱うために必要なファイルが `artifacts` ディレクトリの直下に生成
  const nftContractFactory = await hre.ethers.getContractFactory("Web3Mint");
  //hardhatがローカルのethereumネットワークを生成
  const nftContract = await nftContractFactory.deploy();
  //コントラクトがmintされ、ローカルのブロックチェーンにデプロイされるのを待つ
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // makeAnEpicNFT関数を呼び出す NFTがmintされる
  let txn = await nftContract.makeAnEpicNFT();
  //mintingが仮装マイナーにより承認されるのを待つ
  await txn.wait();
  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
};

//エラー処理
const runMain = async() => {
  try {
    await main();
    process.exit(0);
  } catch(error){
    console.log(error);
    process.exit(1);
  }
};

runMain();