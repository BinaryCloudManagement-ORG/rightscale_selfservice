# Copyright (c) 2014 Ryan Geyer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require File.expand_path(File.join(File.dirname(__FILE__), 'base.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'execution.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'template.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'operation.rb'))

module RightScaleSelfService
  module Cli
    class Main < Base
      desc "execution", "Self Service Execution Commands"
      subcommand "execution", Execution

      desc "template", "Self Service Template Commands"
      subcommand "template", Template

      desc "operation", "Self Service Operation Commands"
      subcommand "operation", Operation

      desc "test <glob>", "Run a CAT Test suite consisting of files found in <glob>"
      def test(glob)
        client = get_api_client()
        suite = RightScaleSelfService::Test::Suite.new(client, glob)
        report = RightScaleSelfService::Test::ShellReport.new(suite)
        begin
          if suite.pump
            report.progress
            sleep(10)
          else
            break
          end
        end while true
        report.progress
        puts "\n\n"
        error_text = report.errors
        if error_text != ""
          puts "\n\n"
        end
        report.failures
      end
    end
  end
end
