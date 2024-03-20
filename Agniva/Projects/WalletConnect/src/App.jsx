import { useEffect, useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import { connectWallet } from "./connectWallet";
import { ethers } from "ethers";
import { deployContract } from "./deployContract";
import { connectContract } from "./connectExistingContract";
import { evmOut } from "./contractAbis/dataObject";

function App() {
  // let providerMock;
  const [providerMain, setProviderMain] = useState("");
  const [signerMain, setSignerMain] = useState("");

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
        <button
          onClick={async () => {
            const [providerInitial, signerInitial] = await connectWallet();

            setProviderMain(providerInitial);
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
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  );
}

export default App;
