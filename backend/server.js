const express = require('express');
const cors = require('cors');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/info', (req, res) => {
    res.json({
        message: 'CS423 DevOps Assignment 4 - Backend API',
        status: 'running',
        timestamp: new Date().toISOString(),
        hostname: os.hostname(),
        platform: os.platform(),
        nodeVersion: process.version,
        uptime: process.uptime(),
        environment: process.env.NODE_ENV || 'development',
        database: {
            host: process.env.DB_HOST || 'not configured',
            name: process.env.DB_NAME || 'not configured',
            status: 'connected'
        }
    });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Backend server running on port ${PORT}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
