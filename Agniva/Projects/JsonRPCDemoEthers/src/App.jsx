import { useEffect, useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import { ethers } from "ethers";
import { evmOut } from "./ContractAbi/MMultisigABI";
import { walletConnect } from "./ethersServices/connectWallet";

function App() {
  // const [count, setCount] = useState(0);
  const [providerMain, setProvider] = useState(null);
  const [signer1, setSigner] = useState(null);

  // const factoryDeploy = new ethers.ContractFactory(
  //   evmOut.abi,
  //   evmOut.bytecode,
  //   signer
  // );

  // await provider2.send("eth_requestAccounts", []);

  // const contractDeploy = await factoryDeploy.deploy(
  //   [
  //     "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
  //     "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
  //   ],
  //   2
  // );

  // const estimateGas=provider2.estimateGas

  // contractDeploy.
  // );
  useEffect(() => {
    console.log(signer1);
  }, [signer1]);

  return (
    <div className="w-screen h-screen bg-black flex justify-center items-center">
      <div className="w-[40%] h-[40%] bg-white rounded-md shadow-lg shadow-white  flex justify-center items-center">
        <div
          className="p-4 py-2 h-max bg-black rounded-md text-white "
          onClick={async () => {
            if (!providerMain) {
              const provider = await walletConnect();
              const signer = await provider.getSigner();
              setProvider(provider);
              setSigner(signer);
            }

            // console.log(provider);
          }}
        >
          {!providerMain ? "Wallet Connect" : "DeployContract"}
        </div>
      </div>
    </div>
  );
}

export default App;
