cask "redlight" do
  version "2.0.0"
  sha256 "4b9251112f928b4f9990b74787184638d8ee0b4e866c166a5d371cbd3c3d0bbe"

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
