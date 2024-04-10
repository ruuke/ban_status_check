# frozen_string_literal: true

class VpnCheck
  include Dry::Monads[:result]

  CACHE_TIME = 24 * 3600 # Cache for 24 hours

  def call(ip:)
    cached_response = RedisClient.client.get("ip_check:#{ip}")
    response = cached_response ? JSON.parse(cached_response) : query_and_cache_vpnapi(ip)

    is_vpn_or_tor = check_vpn_or_tor_status(response)

    Success(
      is_vpn_or_tor:,
      vpn: response.dig('security', 'vpn') || false,
      proxy: response.dig('security', 'proxy') || false
    )

  rescue StandardError => e
    Rails.logger.error("VPNAPI check failed: #{e.message}")
    Success(is_vpn_or_tor: false)
  end

  private

  def query_and_cache_vpnapi(ip)
    response = query_vpnapi(ip)
    RedisClient.client.set("ip_check:#{ip}", response.to_json, ex: CACHE_TIME) if response.key?('security')
    response
  end

  def query_vpnapi(ip)
    uri = URI.parse("https://vpnapi.io/api/#{ip}?key=#{ENV['VPNAPIIO_API_KEY']}")
    response = Net::HTTP.get_response(uri)
    raise "VPNAPI check error: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def check_vpn_or_tor_status(response)
    response.dig('security', 'vpn') || response.dig('security', 'tor')
  end
end
