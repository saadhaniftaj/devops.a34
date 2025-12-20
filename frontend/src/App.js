import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [message, setMessage] = useState('');
  const [backendStatus, setBackendStatus] = useState('Checking...');

  useEffect(() => {
    // Fetch message from backend
    const backendUrl = process.env.REACT_APP_BACKEND_URL || 'http://localhost:4000';
    
    axios.get(`${backendUrl}/api/hello`)
      .then(response => {
        setMessage(response.data.message);
        setBackendStatus('Connected');
      })
      .catch(error => {
        setBackendStatus('Disconnected');
        console.error('Error fetching from backend:', error);
      });
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>DevOps CI/CD Assignment</h1>
        <p>React Frontend + Node.js Backend</p>
        <div className="status">
          <p>Backend Status: <span className={backendStatus === 'Connected' ? 'connected' : 'disconnected'}>{backendStatus}</span></p>
          {message && <p className="message">{message}</p>}
        </div>
        <div className="info">
          <p>Environment: {process.env.NODE_ENV || 'development'}</p>
          <p>Version: 1.0.0</p>
        </div>
      </header>
    </div>
  );
}

export default App;

