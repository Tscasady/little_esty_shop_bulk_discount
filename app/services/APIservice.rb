class Apiservice
  def initialize(url = "https://date.nager.at/api/v3/NextPublicHolidays/US")
    @url = url
  end

  def get_data
    response = HTTParty.get(@url)
    JSON.parse(response.body, symbolize_names: true)
  end
end