cask "console-cast" do
  # Apple silicon gets the Apple silicon build, Intel Macs the universal build (both notarized).
  # Bump with packaging/homebrew/update-cask.sh as soon as a release's disk images go live:
  # until the site serves the version named in ?version=, the routes give the current release.
  on_arm do
    version "0.3.3"
    sha256 "44d9b734cb13e7c6f2ef832f20e8e505db59501d1e23d62456609f8cbbe13876"

    url "https://consolecast.app/download/mac?version=#{version}"
  end
  on_intel do
    version "0.3.3"
    sha256 "6aa79b4e4a0ae5d4c1a4fa8fafb9b3d0ed95c97401193f7a9ede77a3d2db7665"

    url "https://consolecast.app/download/mac-x64?version=#{version}"
  end

  name "Console Cast"
  desc "Receive a game console's built-in broadcast in OBS without a capture card"
  homepage "https://consolecast.app/"

  livecheck do
    url "https://consolecast.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: :sonoma

  app "Console Cast.app"
  # The command line tool. It finds the bundled MediaMTX and FFmpeg next to its real path.
  binary "#{appdir}/Console Cast.app/Contents/Resources/consolecast"

  # Quitting the app also stops Console Cast's engine.
  uninstall quit: "app.consolecast.mac"

  # The Application Support folder holds Console Cast's settings, stream destinations
  # and activation.
  zap trash: [
    "~/Library/Application Support/Console Cast",
    "~/Library/Caches/app.consolecast.mac",
    "~/Library/HTTPStorages/app.consolecast.mac",
    "~/Library/Preferences/app.consolecast.mac.plist",
  ]

  caveats <<~EOS
    Console Cast keeps these in your login keychain, and `brew uninstall --zap` leaves them:
      app.consolecast.mac.activation  your subscription key
      app.consolecast.mac.cloud       your Console Cast Cloud sign-in
    Remove them in Keychain Access if you no longer want them. The keychain also keeps a
    record of when this Mac's free week started, so reinstalling does not start another.
  EOS
end
