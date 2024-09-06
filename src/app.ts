import express from 'express';

import ethereumRoutes from './routes/ethRoutes';

const app = express();

app.use('/ethereum', ethereumRoutes);

export default app;