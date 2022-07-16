class Toolbox < Formula
  desc "Tool for containerized command-line environments on Linux"
  homepage "https://containertoolbx.org/"
  url "https://github.com/containers/toolbox/releases/download/0.0.99.3/toolbox-0.0.99.3.tar.xz"
  sha256 "c385f180e640adbad35a0019613eb5cd8973426d68ade668ec004e6565712983"
  license ""
  # head "https://github.com/containers/toolbox.git", branch: "main"
  head "https://github.com/clashthebunny/toolbox.git", branch: "run_postinst"

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "bash-completion"

  def install
    mkdir "build" do
      puts "meson", "-Drun_postinst=false", "-Dprofile_dir=#{HOMEBREW_PREFIX}/etc/profile.d",
        "-Dtmpfiles_dir=#{HOMEBREW_PREFIX}/etc/tmpfiles.d/", *std_meson_args, ".."
      system "meson", "-Drun_postinst=false", "-Dprofile_dir=#{prefix}/etc/profile.d",
        "-Dtmpfiles_dir=#{HOMEBREW_PREFIX}/etc/tmpfiles.d", *std_meson_args, ".."
      system "ninja", "-v"
      system "meson", "install"
    end
  end

  def caveats
    <<~EOS
      tmpfiles.d config files have been put in #{HOMEBREW_PREFIX}/etc/tmpfiles.d/.
      Please copy them to your tmpfiles.d folder, often
          ~/.config/user-tmpfiles.d/ or /usr/lib/tmpfiles.d/
      (check: man tmpfiles.d)
       And then run `systemd-tmpfiles --create`
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test toolbox.rb`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
