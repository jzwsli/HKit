
Pod::Spec.new do |s|

  s.name         = "HKit"
  s.version      = "0.0.1"
  s.summary      = "for me"
  s.description  = <<-DESC
for me
                   DESC

  s.homepage     = "https://github.com/jzwsli/HKit"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "lzr" => "532028798@qq.com.com" }

    s.platform     = :ios, "8.0"

  s.source       = { :git => "http://github.com/jzwsli/HKit.git", :tag => "#{s.version}" }

  s.source_files  = "HKit", "HKit/**/*.{h,m}"

end
