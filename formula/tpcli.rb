require "formula"
require_relative "lib/private_strategy"

class Tpcli < Formula
  homepage "https://github.com/jhamill34/solutions_engineering"
  url "https://github.com/jhamill34/solutions_engineering/releases/download/v0.1.1/tpcli-v0.1.1-aarch64-apple-darwin.tar.gz", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "7804e177d67c97978dfe2314e68f92a9ae63e353392e3202dfb0ceb37ab323a7"
  head "https://github.com/jhamill34/solutions_engineering.git"
  version "0.1.1"

  depends_on "fzf"
  depends_on "jq"

  def install
    bin.install "transpositd"
    bin.install "tpcli"
    bin.install Dir["scripts/*"]
    prefix.install "templates"

    inreplace "etc/tpcli-config.toml" do |s| 
      s.gsub! "/usr/local/tpcli", "#{prefix}"
    end

    inreplace "etc/transpositd-config.toml" do |s|
      s.gsub! "/usr/local/var" , "#{var}"
    end

    prefix.install Dir["etc/*"]
  end

  def caveats
    caveats = ""
    caveats += <<~EOS
      Before starting transpositd you will need to update the connector.path in the config file located at:
        #{prefix}/transpositd-config.toml

      Also, tpcli by default points to $HOME/.tplite/config.toml for configuration. 
      You will need to either:
      Create this file by hand  

        touch $HOME/.tplite/config.toml

      Copy the default config located at #{prefix}/tpcli-config.toml to $HOME/.tplite/config.toml 
        
        cp #{prefix}/tpcli-config.toml $HOME/.tplite/config.toml
  
      Or set the environment variable TPCLI_CONFIG_PATH to point to #{prefix}/tpcli-config.toml

        export TPCLI_CONFIG_PATH=#{prefix}/tpcli-config.toml
    EOS

    caveats
  end

  service do 
    run [opt_bin/"transpositd"]
    log_path var/"log/transpositd.log"
    error_log_path var/"log/transpositd.log"

    (var/"log/transpositd").mkpath 

    environment_variables :TRANSPOSITD_CONFIG_PATH => opt_prefix/"transpositd-config.toml"
  end

  # Homebrew requires tests.
  test do
    system "true"
  end
end
