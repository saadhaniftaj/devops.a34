// Manual mock for axios
const mockGet = jest.fn(() => Promise.resolve({
  data: {
    message: 'Hello from Node.js Backend! CI/CD Pipeline is working.',
    timestamp: '2025-12-20T00:00:00.000Z',
    environment: 'test'
  }
}));

const axios = {
  get: mockGet
};

// Export as both default and named
export default axios;
export { axios };
