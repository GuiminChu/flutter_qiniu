#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_qiniu'
  s.version          = '0.1.3'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/GuiminChu/flutter_qiniu'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'GuiminChu' => 'icodd.cn@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Qiniu'

  s.ios.deployment_target = '9.0'
end

