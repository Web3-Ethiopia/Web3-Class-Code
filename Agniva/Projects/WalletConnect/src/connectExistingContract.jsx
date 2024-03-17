import { ethers } from "ethers";

export const connectContract = async ({ address, abi, signer }) => {
  const ContractToConnect = new ethers.Contract(address, abi, signer);
  ContractToConnect.connect(signer);
  const transferFunc = ContractToConnect.balanceOf(signer.address);
  console.log(transferFunc);
  console.log(ContractToConnect.interface);
};
