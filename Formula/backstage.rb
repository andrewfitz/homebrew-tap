class Backstage < Formula
  desc "Lets agents drive macOS apps on an invisible display, off the user's screen"
  homepage "https://github.com/andrewfitz/backstage"
  url "https://github.com/andrewfitz/backstage/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "427cfcd2866d6a930972b97d9fc488ffeb5c813ad92c4ef56129e01909ccc23c"
  head "https://github.com/andrewfitz/backstage.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/andrewfitz/homebrew-tap/releases/download/backstage-1.4.0"
    sha256 cellar: :any, arm64_tahoe:   "dbd6117a865f8cc4876953551e1525a729b7cb30fdfa784dc17c781b4c78f9c5"
    sha256 cellar: :any, arm64_sequoia: "2276433a0b4b11d56912c35d7e6fd530f11734d3f3b9602d9c17679f3529d04d"
  end

  depends_on xcode: :build
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "backstage"
    bin_path = Utils.safe_popen_read("swift", "build", "-c", "release", "--show-bin-path").strip
    bin.install "#{bin_path}/backstage"

    # Injected into the dev builds and test runners `launch` starts, to make them inaudible.
    # Universal: an injected app's x86_64 (Rosetta) child would otherwise fail to start.
    # backstage finds it in ../lib/backstage relative to its resolved path.
    (lib/"backstage").mkpath
    system "xcrun", "clang", "-dynamiclib", "-O2", "-arch", "arm64", "-arch", "x86_64",
           "-mmacosx-version-min=14.0", "-framework", "CoreAudio",
           "-install_name", "@rpath/libbackstage-inaudible.dylib", "-Wl,-headerpad_max_install_names",
           "-o", lib/"backstage/libbackstage-inaudible.dylib",
           "Sources/BackstageInaudible/inaudible.c"
  end

  def caveats
    <<~EOS
      Grant whatever runs backstage (your terminal or agent host) these, in
      System Settings > Privacy & Security:
        - Accessibility
        - Screen & System Audio Recording
        - System Audio Recording Only (to measure app audio with --audio; muting works without it)

      Then check and install the agent skills:
        backstage doctor
        backstage install            # add --hooks for the hook too

      After `brew upgrade backstage`, restart the daemon so it runs the new version
      (this quits the apps agents have open backstage):
        backstage stop --all && backstage start
    EOS
  end

  test do
    assert_equal "backstage #{version}", shell_output("#{bin}/backstage version").strip
  end
end
