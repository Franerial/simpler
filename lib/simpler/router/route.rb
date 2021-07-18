# frozen_string_literal: true

module Simpler
  class Router
    class Route
      ROUTE_PARAM_VALUE_REGEXP = %r{/\d+/*}.freeze
      ROUTE_PARAM_NAME_REGEXP = %r{/:\w+/*}.freeze
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        define_params(path)
        edited_path = define_edited_path(path) || path

        @method == method && edited_path == @path
      end

      private

      def define_params(path)
        route_params_values = []
        route_params_names = []

        path.scan(ROUTE_PARAM_VALUE_REGEXP).each { |param| route_params_values << (param.delete "/") }
        @path.scan(ROUTE_PARAM_NAME_REGEXP).each { |param| route_params_names << param.delete(":").delete("/").to_sym }

        @params = Hash[route_params_names.zip route_params_values]
      end

      def define_edited_path(path)
        str = path
        @params.each do |param_name, param_value|
          str = str.gsub param_value, ":#{param_name.to_s}"
        end

        str
      end
    end
  end
end
