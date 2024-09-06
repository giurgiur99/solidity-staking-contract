import dotenv from 'dotenv';
import { ethers, JsonRpcProvider } from 'ethers';
import fs from 'fs/promises';

dotenv.config();

const provider = new JsonRpcProvider(`https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`);
const contractAddress = process.env.STAKING_CONTRACT_ADDRESS;

export const fetchStakingDataByAddress = async (address: string) => {
    try {
        if (!contractAddress) {
            throw new Error('Staking contract address not found');
        }

        const abi = await fs.readFile('./abi.json', 'utf-8');
        const stakingContract = new ethers.Contract(contractAddress, abi, provider);
        const stakeData = await stakingContract.stakes(address);

        return {
            stakedAmount: BigInt(stakeData[0]).toString(),
            rewards: BigInt(stakeData[2]).toString(),
            stakedAt: BigInt(stakeData[1]).toString(),
        };
    } catch (error) {
        console.error('Error fetching staking data:', error);
        throw error;
    }
};