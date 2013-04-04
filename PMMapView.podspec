Pod::Spec.new do |s|
  s.name         = "PMMapView"
  s.version      = "0.0.0"
  s.summary      = "MKMapView + Zoomin/out button + here button."
  s.homepage     = "https://github.com/taktamur/PMMapView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Takafumi Tamura" => "taktamur@gmail.com" }
  s.source       = { :git => "https://github.com/taktamur/PMMapView.git", :tag => "0.0.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'PMMapView', 'PMMapView/*.{h,m}'
  s.requires_arc = true
  s.dependency 'BlocksKit'
end
