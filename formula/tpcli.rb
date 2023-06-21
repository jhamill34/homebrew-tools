require "formula"
require_relative "lib/private_strategy"

class Tpcli < Formula
  homepage "https://github.com/jhamill34/solutions_engineering"
  url "https://github.com/jhamill34/solutions_engineering/releases/download/v0.1.0/tpcli-v0.1.0-aarch64-apple-darwin.tar.gz", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "96066eed5be293b0fb9adcc73c9b15b093e78ab865c238964ab1f41da5898429"
  head "https://github.com/jhamill34/solutions_engineering.git"
  version "0.1.0"

  depends_on "fzf"
  depends_on "jq"

  def install
    bin.install "transpositd"
    bin.install "tpcli"
    bin.install Dir["scripts/*"]

    prefix.install "templates"
  end

  service do 
    run [opt_bin/"transpositd"]
    log_path var/"log/transpositd.log"
    error_log_path var/"log/transpositd.log"
    environment_variables CONNECTOR_HOME: ENV["HOMEBREW_CONNECTOR_HOME"],
                          TPLITE_LOG_PATH: ENV["HOMEBREW_TPLITE_LOG_PATH"]
  end

  # Homebrew requires tests.
  test do
    system "true"
  end
end
