class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.12.1.tar.xz"
  sha256 "c40062022a1963c80573d48f6070792297cecd7c6bffe3aefcac0d8b9bee8913"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/libzip-1.12.1-ba6dbdf7bc8cb3cd823fd55c2"
    sha256 cellar: :any, sequoia: "0d8b11bb5068e466c8d6b72e1470f1633415bc1cff6e986a7b69cfe6ee5ca141"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
      -DBUILD_REGRESS=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
