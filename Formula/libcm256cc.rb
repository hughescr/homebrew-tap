class Libcm256cc < Formula
  desc "Fast GF(256) Cauchy MDS Block Erasure Codec in C++"
  homepage "https://github.com/hughescr/cm256cc"
  url "https://github.com/hughescr/cm256cc/archive/be6b3e0.tar.gz"
  version "1.1.0"
  sha256 "93e20fe88f2250828d4553afb3611c39f8def4508e1d737dabf2c5d24ec65c27"
  license "GPL-3.0"

    depends_on "cmake" => :build
    depends_on "pkg-config" => :test

    def install
        cmake_args = %W[
          -DENABLE_DISTRIBUTION=ON
          -DCMAKE_BUILD_TYPE=Release
          -DBUILD_TOOLS=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"

        (lib/"pkgconfig").install buildpath/"build/libcm256cc.pc"
    end

    test do
        # Verify pkg-config registration and that we can compile and link.
        system "pkg-config", "--cflags", "--libs", "libcm256cc"

        (testpath/"test.cpp").write <<~EOS
#include "cm256.h"

int main() {
    CM256 cm256;
    return cm256.isInitialized();
}
        EOS
        flags = shell_output("pkg-config --cflags --libs libcm256cc").split
        system ENV.cxx, "test.cpp", *flags, "-o", "test"
        system "./test"
    end
end
