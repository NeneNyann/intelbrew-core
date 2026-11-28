class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/12.2.1/fmt-12.2.1.zip"
  sha256 "870a49acec5bcdab236aeea834ebd7f0b8548a7d8cea33c996b6873a37f2d50c"
  license "MIT"
  compatibility_version 2
  head "https://github.com/fmtlib/fmt.git", branch: "main"

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/fmt-12.2.1-b1dd62a9c4ae4b4c738204690"
    sha256 cellar: :any, sequoia: "0ebbdb56e4e9adc74f27eae5db9a5514207b17a350164d5576bd7f1e3729ff5d"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
