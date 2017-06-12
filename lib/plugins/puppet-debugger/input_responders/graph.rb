require 'puppet-debugger/input_responder_plugin'
require 'graphviz'
require 'webrick'
require 'fileutils'
module PuppetDebugger
  module InputResponders
    class Graph < InputResponderPlugin
      COMMAND_WORDS = %w(graph)
      SUMMARY = 'Graph out the catalog in GraphViz format'
      COMMAND_GROUP = :tools
      attr_accessor :status

      def run(args = [])
        toggle_status
      end

      def toggle_status
        status = !status
        if status
          add_hook(:after_output, :create_graph_content) do |code, debugger|
            # ensure we only start a single thread, otherwise they could stack up
            # and try to write to the same file.
            Thread.kill(@graph_thread) if @graph_thread
            @graph_thread = Thread.new { create_html(create_graph_content) }
          end
          out = "Graph mode enabled at #{get_url}"
        else
          delete_hook(:after_output, :create_graph_content)
          out = "Graph mode disabled"
        end
        out
      end

      def doc_root
        File.expand_path '/tmp/puppet-debugger'
      end

      def get_url
        server
        'http://localhost:12000/'
      end

      def server
        unless @server
          @server = WEBrick::HTTPServer.new( {DocumentRoot: doc_root,
            Logger: WEBrick::Log.new("/dev/null"), AccessLog: [],
            Port: 12000} )
          trap 'INT' do @server.shutdown end
          Thread.new { @server.start }
        end
        @server
      end

      def create_graph_content
        catalog = ::Puppet::Resource::Catalog.indirection.find(node.name, :use_node => node)
        dotfile  = catalog.to_ral.relationship_graph.to_dot

        # SVG rendition of the graph

        svg = ::GraphViz.parse_string(dotfile) do |graph|
          graph[:label] = 'Resource Relationships'
          # change the whits into something readable
          graph.each_node do |name, node|
            next unless name.start_with? 'Whit'
            newname = name.dup
            newname.sub!('Admissible_class', 'Starting Class')
            newname.sub!('Completed_class', 'Finishing Class')
            node[:style] = "filled",
            node[:fillcolor] = :lightblue,
            node[:label] = newname[5..-2]
          end
        end.output(:svg => String)
      end

      def create_html(svg_graph)
        content = <<-EOF
        <html>
        <head>
          <title>Relationship Graph</title>
          <meta http-equiv="refresh" content="10">
        </head>
          <body>
                <div class="relationships">#{svg_graph}</div>
          </body>
        </html>
        EOF
        FileUtils.mkdir_p(doc_root) unless File.exists?(doc_root)
        File.write(File.join(doc_root, 'index.html'), content)
        File.join(doc_root, 'index.html')
      end

    end
  end
end
