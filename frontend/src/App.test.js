import { render, screen } from '@testing-library/react';
import App from './App';

// Simple approach: mock axios at module level
jest.mock('axios', () => ({
  __esModule: true,
  default: {
    get: () => Promise.resolve({
      data: {
        message: 'Test message',
        timestamp: '2025-12-20T00:00:00.000Z',
        environment: 'test'
      }
    })
  }
}));

test('renders DevOps CI/CD Assignment heading', () => {
  const { container } = render(<App />);
  expect(container).toBeTruthy();
  const headingElement = screen.getByText(/DevOps CI\/CD Assignment/i);
  expect(headingElement).toBeInTheDocument();
});

test('renders React Frontend + Node.js Backend text', () => {
  render(<App />);
  const textElement = screen.getByText(/React Frontend \+ Node\.js Backend/i);
  expect(textElement).toBeInTheDocument();
});

test('renders version information', () => {
  render(<App />);
  const versionText = screen.getByText(/Version:/i);
  expect(versionText).toBeInTheDocument();
});
