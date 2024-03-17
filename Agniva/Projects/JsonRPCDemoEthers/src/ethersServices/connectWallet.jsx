import { ethers } from "ethers";
import { evmOut } from "../ContractAbi/MMultisigABI";
import contractJson from "../../artifacts/contracts/ModifiedMultisig.sol/EnhancedMultisigWallet.json";

export const walletConnect = async () => {
  const provider1 = new ethers.BrowserProvider(window.ethereum);
  //   provider1.addListener()
  // // const provider2 = new ethers.JsonRpcProvider("http://127.0.0.1:8545/");
  const signer = await provider1.getSigner();
  const existingContract = new ethers.Contract(
    "0x9b61879104d4A52ca3DED021Ecb4dADE5BBA711b",
    evmOut.abi,
    signer
  );

  console.log(contractJson);

  // const factoryDeployment = factoryDeploy
  //   .deploy(
  //     [
  //       "0x2e63dCfeFb818986d01ff5cfaE35905903A87913",
  //       "0x5cF10eE9797C7d6c60305F8B1bEa60cFf2EAD46e",
  //     ],
  //     2
  //   )
  //   .catch((e) => console.log(e.info.error.message));
  const contractInterface = existingContract.interface;

  const contractListener = existingContract
    .getBalance()
    .catch((e) => console.log("Transaction reverted: " + e.reason));

  console.log(contractListener);

  // const listeners = await factoryDeployment.listeners;

  console.log(contractListener, contractInterface);

  return provider1;
};
