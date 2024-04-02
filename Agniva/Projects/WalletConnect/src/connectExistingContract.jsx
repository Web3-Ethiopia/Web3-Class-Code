import { ethers } from "ethers";
import { useEffect } from "react";

export const connectContract = async ({ address, abi, signer }) => {
  const ContractToConnect = new ethers.Contract(address, abi, signer);
  ContractToConnect.connect(signer);
  const decimals = ContractToConnect.currentDecimals();
  const transferFunc = Number(await ContractToConnect.registeredProducts(1));
  const divisionFactor = Number(await ContractToConnect.divisionFactor());

  const getCurrentPrice = Number(
    await ContractToConnect[
      "getCurrentPrice(address tokenPairAddress, uint8 productId)"
    ]("0xc59E3633BAAC79493d908e63626716e204A45EdF", 0)
  );

  const getCurrentPrice2 = Number(
    await ContractToConnect.getCurrentPrice(
      "0xc59E3633BAAC79493d908e63626716e204A45EdF",
      0
    )
  );
  // const finalPriceFloatValue = Number(transferFunc) / 10 ** 8;

  // const type = typeof transferFunc;

  //TokenPairAddress= 0xc59E3633BAAC79493d908e63626716e204A45EdF
  //ContractAdress=0x1D97b90899fD3B59F47D2FF61B7652177dCde8AC
  //ProductId=0

  // ContractToConnect.addListener("AnswerUpdated", (e) => {
  //   console.log(e);
  // }

  
  console.log(transferFunc, divisionFactor, String(getCurrentPrice) + "Link");
  console.log(ContractToConnect.interface);
};
