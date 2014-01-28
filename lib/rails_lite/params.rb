require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = {}
    if req.query_string
      parse_www_encoded_form(req.query_string)
    elsif req.body
      parse_www_encoded_form(req.body)
    end
  end

  def [](key)
    @params[key]
  end

  def to_s
    self.to_s
  end

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    ary = URI.decode_www_form(www_encoded_form)

    ary.each do |array|
      parsed = (parse_key(array[0]) << array[1])
      level = @params

      parsed.each.with_index do |value, i|
        unless parsed[i + 1] == parsed.last
          level[value] ||= {}
          level = level[value]
        else
          level[value] = parsed[i + 1]
          break
        end
      end
    end
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split("[").each {|string| string.gsub!("]","")}
  end
end