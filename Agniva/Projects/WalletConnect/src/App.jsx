import { useEffect, useRef, useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import { connectWallet } from "./connectWallet";
import { ethers } from "ethers";
import { deployContract } from "./deployContract";
import { connectContract } from "./connectExistingContract";
import { evmOut } from "./contractAbis/dataObject";
import { FileUploader } from "./AppUploadPinata";

function App() {
  // let providerMock;
  const [providerMain, setProviderMain] = useState("");
  const [signerMain, setSignerMain] = useState("");
  const [balanceMain, updateBalance] = useState(0);
  const addressInput = useRef();

  console.log(providerMain, signerMain);

  useEffect(() => {
    console.log("provider is set");
  }, [providerMain]);

  return (
    <>
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <input
          type="text"
          id="addressBalance"
          placeholder="addressBalance"
          ref={addressInput}
        ></input>

        <button
          onClick={async () => {
            const addressBalance = addressInput.current.value;
            const [providerInitial, signerInitial, balance] =
              await connectWallet({ addressToCheck: addressBalance });

            setProviderMain(providerInitial);
            updateBalance(balance);
            setSignerMain(signerInitial);
          }}
        >
          Connect Wallet
        </button>

        {providerMain && (
          <button
            onClick={async () => {
              const deployedContract = await deployContract({
                signerInitial: signerMain,
              });

              console.log(deployedContract);
            }}
          >
            Deploy Contract
          </button>
        )}

        <form
          onSubmit={(e) => {
            e.preventDefault();
            connectContract({
              address: e.target[0].value,
              abi: evmOut.abi2,
              signer: signerMain,
            });
          }}
          className="py-2"
        >
          <input type="text"></input>

          <button type="submit" className="p-2">
            Submit
          </button>
        </form>

        <form
          onSubmit={async (e) => {
            e.preventDefault();
            // tx address 0x4ba9edd9d7064bdd3a74be9fbc8b7bacbd330ed16b17deda82c7ba83a62f686e
            const chainID = await providerMain.send(e.target[0].value, [
              "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
            ]);

            // const chainIDD= ethers.
            console.log(chainID);
          }}
        >
          <input type="text"></input>
          <button type="submit" className="p-2">
            Debug info
          </button>
        </form>

        <FileUploader />
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">{balanceMain}</p>
    </>
  );
}

export default App;
