VERSION = "0.1.4"

class SketchybarMediaListener < Formula
  desc "SketchyBar integration for media_listener"
  homepage "https://github.com/jhamill34/media_listener"
  url "https://github.com/jhamill34/media_listener/archive/refs/tags/#{VERSION}.tar.gz"
  head "https://github.com/jhamill34/media_listener.git"
  version VERSION


  depends_on "media-listener"
  depends_on "jq"
  depends_on "sketchybar"

  def install
    # Install the sketchybar service script
    bin.install "sketchybar_media_listener_service.sh" => "sketchybar-media-listener"
  end

  def caveats
    <<~EOS
      SketchyBar media listener integration installed.

      This service connects to media_listener's UNIX socket and triggers
      SketchyBar updates with media information.

      Setup:
        1. Make sure media-listener is running:
           brew services start media-listener

        2. Start this service:
           brew services start sketchybar-media-listener

        3. Configure your SketchyBar plugin to handle the 'custom_media_change' event:
           sketchybar --add event custom_media_change

      The service triggers SketchyBar with:
        sketchybar --trigger custom_media_change MEDIA_INFO="<json>"

      View logs:
        tail -f #{var}/log/sketchybar_media_listener.log

      The service will automatically reconnect if media_listener restarts.
    EOS
  end

  service do
    run [opt_bin/"sketchybar-media-listener"]
    keep_alive true
    working_dir var
    log_path var/"log/sketchybar_media_listener.log"
    error_log_path var/"log/sketchybar_media_listener.error.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_predicate bin/"sketchybar-media-listener", :exist?
    assert_predicate bin/"sketchybar-media-listener", :executable?
  end
end
