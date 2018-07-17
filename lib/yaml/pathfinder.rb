require 'yaml/pathfinder/version'

module Yaml
  module Pathfinder
    class Pathfinder
      def initialize(yaml_lines)
        @yaml_lines = yaml_lines
        indent_char
        @yaml_lines.rewind if yaml_lines.is_a?(File)
      end

      def paths # rubocop:disable Metrics/AbcSize
        paths = []
        last_indent = 0
        last_path = []
        @yaml_lines.each do |line|
          if indent(line).zero?
            last_path.pop
            last_path.push token(line)
            last_indent = indent(line)

            paths.push token(line)
          elsif indent(line) == last_indent
            last_path.pop
            last_path.push token(line)
            last_indent = indent(line)

            paths.push last_path.join('.')
          elsif indent(line) > last_indent
            last_path.push token(line)
            paths.push last_path.join('.')
            last_indent = indent(line)
          elsif indent(line) < last_indent
            # binding.pry
            last_path.pop
            (last_indent - indent(line)).times { last_path.pop }
            last_path.push token(line)
            paths.push last_path.join('.')
            last_indent = indent(line)
          end
        end
        paths
      end

      private

      def indent_char
        @indent_char ||= @yaml_lines
                         .reject { |line| /^\w+/.match(line) }
                         .first
                         .scan(/\s/).reject { |c| c == "\n" }.join
      end

      def indent(line)
        line
          .scan(indent_char)
          .flatten(1)
          .reject { |match| match == "\n" }
          .count
      end

      def token(line)
        return '' if line =~ /^\s*$/
        line.match(/[^\s]+/).string.split(':').first.strip
      end
    end
  end
end
