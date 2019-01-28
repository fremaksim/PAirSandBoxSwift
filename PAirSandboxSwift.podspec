#
#  Be sure to run `pod spec lint PAirSandboxSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  #Version
  spec.name          = "PAirSandboxSwift"
  spec.version       = "0.0.1"
  spec.swift_version = 4.2
  spec.summary       = "A Swift verson of PAirSandbox(https://github.com/music4kid/AirSandbox)."


  spec.description  = <<-DESC
                        A Swift verson of PAirSandbox(https://github.com/music4kid/AirSandbox).A simple class, enable you to view sandbox file system on iOS device, share files via airdrop, super convenient when you want to send log files from iOS device to Mac.
                   DESC

  spec.homepage     = "https://github.com/fremaksim/PAirSandBoxSwift"
  spec.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author             = { "慢从前" => "941725856@qq.com" }


  # Compatibility & Sources
  spec.platform     = :ios
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/fremaksim/PAirSandBoxSwift", :tag => {spec.version} }
  spec.source_files  = 'PAirSandboxSwift/*.swift'
  spec.requires_arc  = true



end
