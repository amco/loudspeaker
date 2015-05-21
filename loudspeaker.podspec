Pod::Spec.new do |s|
  s.name             = "loudspeaker"
  s.version          = "0.1.4"
  s.summary          = "An AVQueuePlayer-backed audio player with a modern, minimal UI"
  s.description      = <<-DESC
                       An audio player with a modern, minimal UI. Powered by AVQueuePlayer.

                       * Plays all file formats supported by iOS
                       * Auto Layout keeps it looking fiiiine however you jam it into your app
                       * Jump forward or backward with gestures
                       DESC
  s.homepage         = "https://github.com/amco/loudspeaker"
  s.screenshot       = "http://i.imgur.com/IOACIpO.png"
  s.license          = 'MIT'
  s.author           = { "Adam Yanalunas" => "adamy@yanalunas.com" }
  s.source           = { :git => "https://github.com/amco/loudspeaker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/adamyanalunas'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'loudspeaker' => ['Pod/Assets/*.png']
  }
  s.dependency 'Masonry', '~> 0.5'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation'
end
