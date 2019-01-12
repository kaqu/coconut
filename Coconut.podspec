Pod::Spec.new do |s|

  s.name         = "Coconut"
  s.version      = "0.1.0"
  s.summary      = "iOS extensions with Futura"
  s.description  = ""
  s.homepage     = "https://github.com/kaqu/coconut/"
  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }
  s.author       = { "Kacper Kaliński" => "kaqukal@icloud.com" }
  s.source       = { :git => "https://github.com/kaqu/coconut.git", :tag => "#{s.version}" }
  s.source_files = "Sources/Coconut/*.swift"

  s.dependency :git => "https://github.com/miquido/futura.git, :branch => "feature/spm"
end