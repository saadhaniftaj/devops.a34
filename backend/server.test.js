const request = require('supertest');
const app = require('./server');

describe('Backend API Tests', () => {
  test('GET /api/hello should return a message', async () => {
    const response = await request(app)
      .get('/api/hello')
      .expect(200);
    
    expect(response.body).toHaveProperty('message');
    expect(response.body.message).toBeTruthy();
  });

  test('GET /api/health should return health status', async () => {
    const response = await request(app)
      .get('/api/health')
      .expect(200);
    
    expect(response.body).toHaveProperty('status');
    expect(response.body.status).toBe('healthy');
    expect(response.body).toHaveProperty('uptime');
  });
});

