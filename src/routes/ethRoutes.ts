import express from 'express';

import { fetchStakingDataByAddress } from '../services/ethService';

const router = express.Router();

router.get('/staking-info/:address', async (req, res) => {
    const address = req.params.address;
    try {
        const stakingData = await fetchStakingDataByAddress(address);
        res.json(stakingData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error fetching staking data' });
    }
});

export default router;