Pod::Spec.new do |s|
  s.name         = "FWTPieChart"
  s.version      = "0.2"
  s.summary      = "The simplest way to include rich pie chart graphics in your iOS app."
  s.description  = <<-DESC
                   The simplest way to include rich pie chart graphics in your iOS app.
                   DESC
  s.homepage     = "https://github.com/FutureWorkshops/FWTPieChart.git"
  s.license      = {
		:type => 'MIT',
		:text => <<-LICENSE
		Copyright (C) 2014 Future Workshops Ltd

		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE
		LICENSE
	}
  s.author       = { "Carlos Vidal" => "carlos@futureworkshops.com" }
  s.source       = { :git => "https://github.com/FutureWorkshops/FWTPieChart.git", :tag => "0.2" }
  s.platform     = :ios, '6.0'
  s.source_files = 'FWTPieChartView/FWTPieChartView/*.{h,m}'
  s.public_header_files = 'FWTPieChartView.h'
  s.requires_arc = true
  s.frameworks = 'QuartzCore', 'Foundation', 'UIKit', 'CoreGraphics'
end
