VERSION = "0.1.0"

class MediaListener < Formula
  desc "macOS system-wide media playback monitor with UNIX socket API"
  homepage "https://github.com/jhamill34/media_listener"
  url "https://github.com/jhamill34/media_listener/archive/refs/tags/#{VERSION}.tar.gz"

  head "https://github.com/jhamill34/media_listener.git"
  version VERSION

  depends_on :macos

  def install
    # Create headers directory in build
    (buildpath/"headers").mkpath

    # Copy headers
    cp "Sources/media_listener/MediaRemote.h", "headers/"
    cp "Sources/media_listener/BridgingHeader.h", "headers/"

    # Build using Makefile
    system "make", "clean"
    system "make"

    # Install binary
    bin.install "media_listener"

    # Install headers for reference
    (prefix/"include").install Dir["headers/*"]
  end

  def caveats
    <<~EOS
      media_listener monitors system-wide media playback on macOS.

      Socket API:
        Path: /tmp/media_listener.sock
        Format: JSON (newline-delimited)

      To start the service:
        brew services start media-listener

      To connect and view events:
        nc -U /tmp/media_listener.sock

      The service publishes these event types:
        - now_playing_info_changed: Track changes and playback events
        - application_changed: Active media app switched
        - current_state: Initial state on client connect

      For integration examples, see:
        https://github.com/yourusername/media_listener
    EOS
  end

  service do
    run [opt_bin/"media_listener"]
    keep_alive true
    working_dir var
    log_path var/"log/media_listener.log"
    error_log_path var/"log/media_listener.error.log"
  end

  test do
    assert_predicate bin/"media_listener", :exist?
    assert_predicate bin/"media_listener", :executable?
  end
end
