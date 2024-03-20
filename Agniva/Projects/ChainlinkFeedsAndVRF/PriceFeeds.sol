// SPDX-License-Identifier: MIT
pragma solidity 0.8.0-0.9.0;
import "hardhat/console.sol";
import {AggregatorV3Interface} from "@chainlink/contracts@0.8.0/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeedFetch{
    // struct productDetails{
    //     uint256 usdPrice
    // }

    AggregatorV3Interface public priceFeedContract;
    uint8 public currentDecimals;
    mapping(uint8=>uint256) public registeredProducts;
    mapping(uint8=>mapping(address=>uint256)) public registeredProductsPairs;
    int256 public divisionFactor=10000;
    //price feeds-> onRegister -> constant price-> pairToUsd-> transfer
    
    constructor(address pairAddress) {
        priceFeedContract= AggregatorV3Interface(pairAddress);
        currentDecimals=priceFeedContract.decimals();
    }

    function getLatestRoundData() public view returns(uint80,int,uint256){
        (uint80 roundId, int256 answer, uint256 startedAt, /*uint256 updatedAt*/, /*uint80 answeredInRound*/)=priceFeedContract.latestRoundData();
    
        return (roundId,answer,startedAt);
    }

    function registerProduct(uint8 prouductId, uint256 UsdPrice) public returns (bool){
        registeredProducts[prouductId]=UsdPrice*10**currentDecimals;
        return true;
    }

    function registerProduct(uint8 prouductId, uint256 UsdPrice, address tokenPair) public returns (bool){
        
        registeredProductsPairs[prouductId][tokenPair]=UsdPrice*10**currentDecimals;
        return true;
    }

    function getCurrentPrice(uint8 productId) public view returns (int256) {
         (/*uint80 roundId*/, int256 answer, /*uint256 startedAt*/, /*uint256 updatedAt*/, /*uint80 answeredInRound*/)=priceFeedContract.latestRoundData();
         uint256 fixedPrice=registeredProducts[productId];
         console.logInt(answer);
         int256 convertedPrice =  (int256(fixedPrice)*divisionFactor/answer);

         return  convertedPrice;
    }

    function getCurrentPrice(address tokenPairAddress, uint8 productId) public view returns(int256) {
        AggregatorV3Interface temporaryPriceFeeds;
        temporaryPriceFeeds=AggregatorV3Interface(tokenPairAddress);
    
        (/*uint80 roundId*/, int256 answer, /*uint256 startedAt*/, /*uint256 updatedAt*/, /*uint80 answeredInRound*/)=temporaryPriceFeeds.latestRoundData();
         uint256 fixedPrice=registeredProductsPairs[productId][tokenPairAddress];
         int256 convertedPrice =  int256(fixedPrice)*divisionFactor/answer;
         return  convertedPrice;
    }

    function getRoundDataOnID(uint80 _roundId) public view returns(uint80,int,uint80){
        (uint80 roundId, int256 answer, /*uint256 startedAt*/, /*uint256 updatedAt*/, uint80 answeredInRound)=priceFeedContract.getRoundData(_roundId);
    
        return (roundId,answer,answeredInRound);
    }

    function changePairAddress(address _pairAddress) public {
        priceFeedContract=AggregatorV3Interface(_pairAddress);
        currentDecimals=priceFeedContract.decimals();
    }

    function getDecimals()public view returns (uint8) {
         return currentDecimals;
    }

    function getActualPrice()public view returns(int256){
        (/*uint80 roundId*/, int256 answer, /*uint256 startedAt*/, /*uint256 updatedAt*/, /*uint80 answeredInRound*/)=priceFeedContract.latestRoundData();
        int256 bigDenominator=int256(10**(currentDecimals-2));
        int256 finalPrice=answer/bigDenominator;
        return finalPrice;
    }
}