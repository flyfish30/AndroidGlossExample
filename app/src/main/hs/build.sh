
cabal --with-ghc=aarch64-unknown-linux-android-ghc --with-ghc-pkg=aarch64-unknown-linux-android-ghc-pkg --with-ld=aarch64-linux-android-ld.gold --with-strip=aarch64-linux-android-strip configure

cabal build

#cp dist/build/libgloss-example.so/libgloss-example.so ../libs/arm64-v8a/libgloss-example.so

#cd .. ; ./gradlew installArmDebug ; cd hs

