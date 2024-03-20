import { ethers } from "ethers";
// import data from "../artifacts/contracts/ModifiedMultisig.sol/EnhancedMultisigWallet.json";

export const deployContract = async ({ signerInitial }) => {
  const NewContract = new ethers.ContractFactory(
    data.abi,
    data.bytecode,
    signerInitial
  );

  const factoryContract = await NewContract.deploy(
    [
      "0x2e63dCfeFb818986d01ff5cfaE35905903A87913",
      "0x5cF10eE9797C7d6c60305F8B1bEa60cFf2EAD46e",
    ],
    2
  ).catch((e) => console.log(e));
};
