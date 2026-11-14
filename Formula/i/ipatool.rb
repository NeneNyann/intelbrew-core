class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "88704a28231ac0019016c1900edebc9dea0cf14de4e5bc90aa96fd594925bdc0"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/ipatool-2.8.1-b60f0041c5dc097ceab427d5d"
    sha256 cellar: :any_skip_relocation, sequoia: "0e2529a8b3d5b41157006768cc6cc8a45b492c7e0f2c597f11f6f6616f17f4b2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
