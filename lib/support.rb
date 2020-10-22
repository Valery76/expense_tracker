module Support
  def self.valid_date?(date_str)
    Date.iso8601(date_str)
    true
  rescue ArgumentError
    false
  end
end
