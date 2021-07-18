require_relative "view"

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @request.env["simpler.route_params"].each { |param_name, param_value| @request.update_param(param_name, param_value) }
    end

    def make_response(action)
      @request.env["simpler.controller"] = self
      @request.env["simpler.action"] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match("(?<name>.+)Controller")[:name].downcase
    end

    def set_default_headers
      @response["Content-Type"] = "text/html"
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(options)
      if options.is_a?(Hash)
        headers["Content-Type"] = "text/plain"
        @request.env["simpler.text_plain"] = options[:plain]
      else
        @request.env["simpler.template"] = options
      end
    end

    def headers
      @response
    end

    def status(status_value)
      @response.status = status_value
    end
  end
end
