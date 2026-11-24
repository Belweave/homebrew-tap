cask "console-cast" do
  # Apple silicon gets the Apple silicon build, Intel Macs the universal build (both notarized).
  # Bump with packaging/homebrew/update-cask.sh as soon as a release's disk images go live:
  # until the site serves the version named in ?version=, the routes give the current release.
  on_arm do
    version "0.3.5"
    sha256 "96e9f444816b486cb3389cd2da988c93cfd9b9c32f0258121ba79048d064cac9"

    url "https://consolecast.app/download/mac?version=#{version}"
  end
  on_intel do
    version "0.3.5"
    sha256 "f564dde9e1c98f9bafbe7ef3a4e0fa7561b20312acc08cfc345207bcf1f5d6db"

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
