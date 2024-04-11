import { ethers } from "ethers";
import { evmOut } from "./contractAbis/dataObject";
// import { viteRequire } from ;
// import { forward } from "@ngrok/ngrok";
import { stableTokenABI, iCeloTokenABI } from "@celo/abis";

const STABLE_TOKEN_ADDRESS = "0xF194afDf50B03e69Bd7D057c1Aa9e10c9954E4C9";

const { Contract, utils, providers } = ethers;
// const { formatEther } = utils;

async function checkCUSDBalance(provider, address) {
  const StableTokenContract = new Contract(
    STABLE_TOKEN_ADDRESS,
    stableTokenABI,
    provider
  );

  let balanceInBigNumber = await StableTokenContract.balanceOf(address);
  balanceInBigNumber = Number(balanceInBigNumber) / 10 ** 18;

  let balanceInWei = balanceInBigNumber.toString();

  let balanceInEthers = balanceInWei; // Ether is a unit = 10 ** 18 wei

  return balanceInEthers;
}

// const provider = new providers.JsonRpcProvider("https://forno.celo.org"); // Mainnet

// In Ether unit

export const connectWallet = async ({
  addressToCheck: addressToCheckBalance,
}) => {
  if (window.ethereum && window.ethereum.isMiniPay) {
    const provider1 = new ethers.BrowserProvider(window.ethereum);
    const signerInitial = await provider1.getSigner();

    const bigInter = BigInt(10 ** 100);

    let balance = await checkCUSDBalance(provider1, addressToCheckBalance);

    // const authState = await forward({
    //   addr: 5173,
    //   authtoken: import.meta.env.NGROK_KEY,
    // });

    // const url = await connect(5174);
    // console.log(authState);
    return [provider1, signerInitial, balance];
  } else {
    return [0, 0, 10];
  }
};

export const deployContract = () => {};
