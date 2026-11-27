cask "redlight" do
  version "1.5.1"
  sha256 "cf2961370476071843f2948aa93b0a75bef116da48aa2b1e9c96c90e6862c1ae"

  url "https://github.com/andrewfitz/redlight/releases/download/v#{version}/Redlight-#{version}.dmg"
  name "Redlight"
  desc "Blue light screen filter with multi-monitor support"
  homepage "https://github.com/andrewfitz/redlight"

  livecheck do
    url "https://github.com/andrewfitz/redlight/releases/latest/download/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: :sonoma

  app "Redlight.app"

  uninstall quit: "com.redlight.app"

  zap trash: [
    "~/Library/Caches/com.redlight.app",
    "~/Library/Caches/com.redlight.app.sparkle",
    "~/Library/Containers/com.redlight.app.RedlightControl",
    "~/Library/HTTPStorages/com.redlight.app",
    "~/Library/HTTPStorages/com.redlight.app.binarycookies",
    "~/Library/Preferences/com.redlight.app.plist",
  ]
end
