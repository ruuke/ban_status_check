# User Security Check API

This API provides an endpoint to determine the ban status of a user based on multiple security checks. It's built using Ruby on Rails 7 as an API-only application, utilizing PostgreSQL for data persistence and Redis for caching.

## Features

- **CF-IPCountry Header Whitelisting**: Determines user ban status based on geographic location, relying on Cloudflare's CF-IPCountry header.
- **Rooted Device Check**: Identifies and bans users accessing from rooted devices.
- **VPN/Tor Detection**: Uses VPNAPI to detect and ban users accessing via VPN or Tor services.
- **Data Integrity Logging**: Logs all significant actions to ensure traceability and integrity.

## Getting Started

### Prerequisites

- Ruby on Rails 7
- PostgreSQL
- Redis

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/user-security-check-api.git
   cd user-security-check-api
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Setup the database and Redis:
   ```bash
   rails db:create db:migrate
   ```

4. Start the server:
   ```bash
   rails s
   ```

### Usage

To check the ban status of a user, send a POST request to `/v1/user/check_status` with the required JSON payload:

```bash
curl -X POST http://localhost:3000/v1/user/check_status \
-H "Content-Type: application/json" \
-H "CF-IPCountry: US" \
-d '{"idfa": "8264148c-be95-4b2b-b260-6ee98dd53bf6", "rooted_device": false}'
```

### API Endpoint

#### POST /v1/user/check_status

**Request Body:**

```json
{
  "idfa": "8264148c-be95-4b2b-b260-6ee98dd53bf6",
  "rooted_device": false
}
```

**Response:**

```json
{
  "ban_status": "not_banned" // Possible values: "banned", "not_banned"
}
```

## Running Tests

To run the RSpec tests, execute:

```bash
bundle exec rspec
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
