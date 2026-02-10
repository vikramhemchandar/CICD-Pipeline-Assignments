import pytest
from app import create_app

@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b"Hello, Jenkins CI/CD!" in response.data

def test_health(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert b"healthy" in response.data