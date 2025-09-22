class Libggmorse < Formula
    desc "Morse code decoding library"
    homepage "https://github.com/ggerganov/ggmorse"
    url "https://github.com/ggerganov/ggmorse/archive/8fb433d.tar.gz"
    version "0.1.0"
    sha256 "9cbb49c7b25bde8bcec2a6d18ab25772e78ac8ad8233a138d4ba389563f011c3"
    license "MIT"

    depends_on "cmake" => :build
    depends_on "pkg-config" => :test

    def install
        cmake_args = %W[
            -DCMAKE_POLICY_VERSION_MINIMUM=3.5
            -DGGMORSE_BUILD_EXAMPLES=OFF
            -DGGMORSE_SUPPORT_SDL2=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"

        # Generate a pkg-config file since upstream does not ship one.
        (buildpath/"libggmorse.pc").write <<~EOS
prefix=#{opt_prefix}
exec_prefix=${prefix}
libdir=${prefix}/lib
includedir=${prefix}/include

Name: libggmorse
Description: Morse code decoding library
Version: #{version}
Libs: -L${libdir} -lggmorse
Cflags: -I${includedir}
        EOS
        (lib/"pkgconfig").install "libggmorse.pc"
    end

    test do
        # Verify pkg-config registration and that we can compile and link.
        system "pkg-config", "--cflags", "--libs", "libggmorse"

        (testpath/"test.cpp").write <<~EOS
#include "ggmorse/ggmorse.h"

int main() {
    GGMorse ggm(GGMorse::getDefaultParameters());
    return 0;
}
        EOS
        flags = shell_output("pkg-config --cflags --libs libggmorse").split
        system ENV.cxx, "test.cpp", "-std=c++17", *flags, "-o", "test"
        system "./test"
    end
end
