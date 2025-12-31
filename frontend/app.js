const BACKEND_URL = window.location.hostname === 'localhost' 
    ? 'http://localhost:5000' 
    : `http://${window.location.hostname}:5000`;

async function fetchBackendData() {
    const apiResponse = document.getElementById('api-response');
    const backendStatus = document.getElementById('backend-status');
    const statusDot = document.getElementById('status-dot');
    const statusText = document.getElementById('status-text');
    
    try {
        apiResponse.textContent = 'Fetching data from backend...';
        
        const response = await fetch(`${BACKEND_URL}/api/info`);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }
        
        const data = await response.json();
        
        apiResponse.textContent = JSON.stringify(data, null, 2);
        backendStatus.textContent = '✅ Connected';
        statusDot.style.background = '#4ade80';
        statusText.textContent = 'All systems operational';
        
    } catch (error) {
        console.error('Backend error:', error);
        apiResponse.textContent = `Error: ${error.message}\n\nBackend might not be running yet.\nCheck: ${BACKEND_URL}/api/info`;
        backendStatus.textContent = '❌ Disconnected';
        statusDot.style.background = '#ef4444';
        statusText.textContent = 'Backend connection failed';
    }
}

document.addEventListener('DOMContentLoaded', () => {
    fetchBackendData();
    setInterval(fetchBackendData, 30000);
});
