require 'multi_json'

module Octokit
  module Request
    def get(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:get, path, options, version, authenticate, raw, force_urlencoded)
    end

    def post(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:post, path, options, version, authenticate, raw, force_urlencoded)
    end

    def put(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:put, path, options, version, authenticate, raw, force_urlencoded)
    end

    def delete(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:delete, path, options, version, authenticate, raw, force_urlencoded)
    end

    private

    def request(method, path, options, version, authenticate, raw, force_urlencoded)
      response = connection(authenticate, raw, version, force_urlencoded).send(method) do |request|
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          if version >= 3 && !force_urlencoded
            request.body = MultiJson.encode(options) unless options.empty?
          else
            request.body = options.to_query unless options.empty?
          end
        end
      end
      raw ? response : response.body
    end
  end
end
