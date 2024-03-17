import { ethers } from "ethers";
import { evmOut } from "./contractAbis/dataObject";

export const connectWallet = async () => {
  const provider1 = new ethers.BrowserProvider(window.ethereum);
  const signerInitial = await provider1.getSigner();
  return [provider1, signerInitial];
};

export const deployContract = () => {};
