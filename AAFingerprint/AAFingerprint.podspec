Pod::Spec.new do |s|
  s.name         = "AAFingerprint"
  s.version      = "0.1.0"
  s.summary      = "iOS device fingerprint SDK"
  s.description  = <<-DESC
  AAFingerprint is a SDK for device fingerprint. 
  Generating device fingerprint based on the characteristic data of the device
                 DESC
  s.homepage     = "https://github.com/aozhimin/AAFingerprint"
  s.license      = "MIT"
  s.author       = { "Alex Ao" => "aozhimin0811@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/aozhimin/AAFingerprint.git", :tag => s.version.to_s }
  s.source_files = "AAFingerprint/**/*.{h,m}"

end
