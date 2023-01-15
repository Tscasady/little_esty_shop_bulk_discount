class HolidayData
  def initialize(data = Apiservice.new)
    @data = data.get_data
  end

  def holidays(n = 3)
    @data.slice(0, n).map do |holiday_data|
      Holiday.new(holiday_data)
    end
  end
end