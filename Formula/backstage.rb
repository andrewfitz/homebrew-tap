class Backstage < Formula
  desc "Lets agents drive macOS apps on an invisible display, off the user's screen"
  homepage "https://github.com/andrewfitz/backstage"
  url "https://github.com/andrewfitz/backstage/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "46a19323989a7954ffdcc8b2ec49385b042cc685427e28cb05fdf18b9f63a490"
  head "https://github.com/andrewfitz/backstage.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/andrewfitz/homebrew-tap/releases/download/backstage-1.3.9"
    sha256 cellar: :any, arm64_tahoe:   "861c699c3782e0f29585f4bcc63db29660c1c71c77288d95815fbefa35117ce6"
    sha256 cellar: :any, arm64_sequoia: "d6d68fa68abb6f31e8043aaa78c525f5ddda4d9df75e2ed91d5901ffd140e3f8"
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
