import { ethers } from "ethers";
import { evmOut } from "./contractAbis/dataObject";
// import { viteRequire } from ;
// import { forward } from "@ngrok/ngrok";
import { stableTokenABI } from "@celo/abis";

const STABLE_TOKEN_ADDRESS = "0x765DE816845861e75A25fCA122bb6898B8B1282a";

const { Contract, utils, providers } = ethers;
// const { formatEther } = utils;

async function checkCUSDBalance(provider, address) {
  const StableTokenContract = new Contract(
    STABLE_TOKEN_ADDRESS,
    stableTokenABI,
    provider
  );

  let balanceInBigNumber = await StableTokenContract.balanceOf(address);

  let balanceInWei = balanceInBigNumber.toString();

  let balanceInEthers = balanceInWei; // Ether is a unit = 10 ** 18 wei

  return balanceInEthers;
}

// const provider = new providers.JsonRpcProvider("https://forno.celo.org"); // Mainnet

// In Ether unit

export const connectWallet = async () => {
  if (window.ethereum && window.ethereum.isMinipay) {
  }
  const provider1 = new ethers.BrowserProvider(window.ethereum);
  const signerInitial = await provider1.getSigner();

  let balance = await checkCUSDBalance(
    provider1,
    "0x5cf10ee9797c7d6c60305f8b1bea60cff2ead46e"
  );
  // const authState = await forward({
  //   addr: 5173,
  //   authtoken: import.meta.env.NGROK_KEY,
  // });
  console.log(balance);

  // const url = await connect(5174);
  // console.log(authState);
  return [provider1, signerInitial];
};

export const deployContract = () => {};
