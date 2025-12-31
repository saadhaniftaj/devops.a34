#!/bin/bash

echo "=========================================="
echo "Testing Docker Compose Setup"
echo "=========================================="
echo ""

cd /Users/applestore/Desktop/final

echo "1. Building and starting containers..."
docker-compose up -d --build

echo ""
echo "2. Waiting for services to start..."
sleep 5

echo ""
echo "3. Checking container status..."
docker-compose ps

echo ""
echo "4. Testing frontend (port 3000)..."
curl -s http://localhost:3000 | head -n 5

echo ""
echo "5. Testing backend health (port 5000)..."
curl -s http://localhost:5000/health

echo ""
echo "6. Testing backend API..."
curl -s http://localhost:5000/api/info

echo ""
echo "=========================================="
echo "Test Complete!"
echo "=========================================="
echo ""
echo "Access URLs:"
echo "  Frontend: http://localhost:3000"
echo "  Backend:  http://localhost:5000"
echo ""
echo "To stop: docker-compose down"
echo "To view logs: docker-compose logs -f"
