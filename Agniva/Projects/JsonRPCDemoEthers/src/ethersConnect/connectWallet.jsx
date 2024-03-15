import { ethers } from "ethers";
import { evmOut } from "../ContractAbi/MMultisigABI";

export const walletConnect = async () => {
  const provider1 = new ethers.BrowserProvider(window.ethereum);
  //   provider1.addListener()
  // // const provider2 = new ethers.JsonRpcProvider("http://127.0.0.1:8545/");
  const signer = await provider1.getSigner();
  const factoryDeploy = new ethers.ContractFactory(
    evmOut.abi,
    evmOut.bytecode,
    signer
  );

  const factoryDeployment = factoryDeploy.deploy(
    [
      "0x2e63dCfeFb818986d01ff5cfaE35905903A87913",
      "0x5cF10eE9797C7d6c60305F8B1bEa60cFf2EAD46e",
    ],
    2
  );
  return provider1;
};
