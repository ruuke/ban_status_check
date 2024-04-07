class VpnCheck
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  CACHE_TIME = (24 * 3600).freeze
  private_constant :CACHE_TIME

  def call(ip:)
    cached_result = @redis.get("ip_check:#{ip}")
    return Success(true) if cached_result == 'true'
    return Success(false) if cached_result == 'false'

    response = yield query_vpnapi(ip)
    is_vpn = response['security']['vpn'] || response['security']['proxy']

    @redis.set("ip_check:#{ip}", is_vpn.to_s, ex: CACHE_TIME)
    Success(is_vpn)
  rescue => e
    Rails.logger.error("VPNAPI check failed: #{e.message}")
    Success(false) # Assume non-VPN if there's an error, as per requirements
  end

  private

  def query_vpnapi(ip)
    uri = URI.parse("https://vpnapi.io/api/#{ip}?key=YOUR_API_KEY")
    response = Net::HTTP.get_response(uri)

    raise "VPNAPI check error: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    Success(JSON.parse(response.body))
  end
end
