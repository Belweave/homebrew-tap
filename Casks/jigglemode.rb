cask "jigglemode" do
  version "1.0.0-rc.1"
  sha256 "c72a61f60fc93decd274dd2c5f01c5de9c740135575e22fdb17461dd797e0237"

  url "https://jigglemode.com/download/JiggleMode-#{version}.dmg"
  name "Jiggle Mode"
  desc "Edit your iPhone or iPad Home Screen, or let an AI agent do it"
  homepage "https://jigglemode.com/"

  livecheck do
    url "https://jigglemode.com/download/"
    regex(/JiggleMode[._-]v?(\d+(?:\.\d+)+(?:-rc\.\d+)?)\.dmg/i)
  end

  depends_on macos: ">= :big_sur"

  app "Jiggle Mode.app"
  binary "#{appdir}/Jiggle Mode.app/Contents/Helpers/jigglemode"

  # Quitting lets a write that is on its way to the phone finish (and be checked) first.
  uninstall quit: "com.jigglemode.app"

  # Backups of your Home Screen layouts live in the Application Support folder; the skill
  # folders are what `jigglemode skill install` creates.
  zap trash: [
    "~/.agents/skills/jigglemode",
    "~/.claude/skills/jigglemode",
    "~/Library/Application Support/Jiggle Mode",
    "~/Library/Caches/com.jigglemode.app",
    "~/Library/HTTPStorages/com.jigglemode.app",
    "~/Library/Preferences/com.jigglemode.app.plist",
  ]

  caveats <<~EOS
    Open Jiggle Mode from Applications, or run `jigglemode` in Terminal.
    Try it first on a pretend iPhone: jigglemode --demo

    Let your AI agent use it (read-only until you allow writing; see https://jigglemode.com/agents/):
      claude mcp add --transport stdio --scope user jigglemode -- #{HOMEBREW_PREFIX}/bin/jigglemode mcp
      jigglemode skill install

    `brew uninstall --zap --cask jigglemode` also deletes your saved Home Screen backups.
  EOS
end
