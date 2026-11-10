class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/refs/tags/v1.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/brotli-1.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/brotli-1.2.1.tar.gz"
  sha256 "98d35d11a78dc453aebb7d10c3748f3f73ff78c8267c0dc697b8631f67bf7e8f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/google/brotli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/brotli-1.2.1-b117d15bbbdb5445f1aea8d53"
    sha256 cellar: :any, sequoia: "be7418a0bb76e9573f50ca02537440dd9d84017ccdfc42a92c9a1383fae5b724"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system bin/"brotli", "file.txt", "file.txt.br"
    system bin/"brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
