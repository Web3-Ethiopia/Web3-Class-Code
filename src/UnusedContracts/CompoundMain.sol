// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "../compoundContracts/CometInterface.sol";
// import "../compoundContracts/CometMainInterface.sol";
// import "../compoundContracts/Configurator.sol";
// import "../../compoundContracts/CometConfiguration.sol";
// import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
// import {console} from "forge-std/Test.sol";

// contract LendingPoolSetup {
//     address public configurator;
//     address public cometProxy;
//     address public newCometImpl;
//     bool isDeployable;
//     Configurator configuratorMain;

//     constructor(address _cometProxy, address _configurator) payable {
//         configurator = _configurator;
//         cometProxy = _cometProxy;
//         // configuratorMain= new Configurator();
//         // co
//         payable(address(this)).transfer(msg.value);
//         // configuratorMain.initializeStorage(address(this));
//     }

//     receive() external payable {}

//     function setupLendingPool() public payable {
//         // Set the base token
//         address USDC = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
//         // configuratorMain.setGovernor(cometProxy, address(this));
//         // Configurator(configurator).setFactory(cometProxy, 0x91663d91795049C3D4afC85A7d0AdB15238750aa);
//         console.logAddress(msg.sender);
//         // Configurator(configurator).setGovernor(cometProxy, msg.sender);
//         // require(Configurator(configurator).transferGovernor(address(this)),"Not working");
//         // Configurator(configurator).getConfiguration(cometProxy);
//         // console.logAddress(configurato);

//         CometConfiguration.AssetConfig memory asset1 = CometConfiguration.AssetConfig({
//             asset: 0x2D5ee574e710219a521449679A4A7f2B43f046ad,
//             priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, // Set to valid price feed
//             decimals: 18,
//             borrowCollateralFactor: 650000000000000000, // 75%
//             liquidateCollateralFactor: 700000000000000000, // 85%
//             liquidationFactor: 920000000000000000, // 95%
//             supplyCap: 500000000000000000000000
//         });
//         // Set the list of accepted collateral assets
//         // Configurator(configurator).setCollateralAssets(cometProxy, collateralAssets);
//         CometConfiguration.AssetConfig[] memory assetArray = new CometConfiguration.AssetConfig[](1);
//         assetArray[0] = asset1;

//         CometConfiguration.Configuration memory MainConfig = CometConfiguration.Configuration({
//             governor: msg.sender,
//             pauseGuardian: 0x008a4C5448ac1Df676d6F39A0C6F13b21b189389,
//             baseToken: USDC,
//             baseTokenPriceFeed: 0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E,
//             extensionDelegate: 0xdCbDb7306c6Ff46f77B349188dC18cEd9DF30299,
//             supplyKink: 850000000000000000,
//             supplyPerYearInterestRateSlopeLow: 48000000000000000,
//             supplyPerYearInterestRateSlopeHigh: 1600000000000000000,
//             supplyPerYearInterestRateBase: 0,
//             borrowKink: 850000000000000000,
//             borrowPerYearInterestRateSlopeLow: 53000000000000000,
//             borrowPerYearInterestRateSlopeHigh: 53000000000000000,
//             borrowPerYearInterestRateBase: 15000000000000000,
//             storeFrontPriceFactor: 500000000000000000,
//             trackingIndexScale: 1000000000000000,
//             baseTrackingSupplySpeed: 11574074074,
//             baseTrackingBorrowSpeed: 1145833333333,
//             baseMinForRewards: 100000000,
//             baseBorrowMin: 1,
//             targetReserves: 5000000000000,
//             assetConfigs: assetArray
//         });

//         // Configurator(configurator).updateAssetConfig(cometProxy, assetConfig);
//         // configuratorMain.initialize(msg.sender);
//         // Configurator(configurator).setConfiguration(cometProxy, MainConfig);

//         // isDeployable=true;
//     }

//     // Deploy the new Comet implementation on proxy
//     function deploy() public {
//         // require(isDeployable,"Not updated with config");
//         Configurator(configurator).deploy(cometProxy);
//     }
// }
