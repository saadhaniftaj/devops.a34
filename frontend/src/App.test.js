import { render, screen } from '@testing-library/react';
import App from './App';

test('renders DevOps CI/CD Assignment heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/DevOps CI\/CD Assignment/i);
  expect(headingElement).toBeInTheDocument();
});

test('renders React Frontend + Node.js Backend text', () => {
  render(<App />);
  const textElement = screen.getByText(/React Frontend \+ Node\.js Backend/i);
  expect(textElement).toBeInTheDocument();
});

