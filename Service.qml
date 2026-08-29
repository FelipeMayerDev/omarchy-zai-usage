import QtQuick
import Quickshell.Io

// Headless producer for the built-in agents panel. The panel discovers any
// *.json in ~/.local/state/omarchy/agents/usage/, so this plugin ships no UI:
// it just runs the Z.ai collector on a cadence and lands the record where
// omarchy.agents already watches.
Item {
  id: root

  // Injected by omarchy-shell (the plugin loader).
  property var shell: null
  property var manifest: null

  readonly property string pluginDir: (manifest && manifest.__sourceDir) || ""

  // Matches the agents panel's default refreshIntervalSec; the panel's own
  // refresh only regenerates first-party collectors, so this record would
  // otherwise go stale.
  property int refreshIntervalSec: 900

  function refresh() {
    if (root.pluginDir === "" || refreshProcess.running) return
    refreshProcess.command = ["bash", root.pluginDir + "/refresh.sh"]
    refreshProcess.running = true
  }

  Timer {
    interval: root.refreshIntervalSec * 1000
    running: root.pluginDir !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Process {
    id: refreshProcess
    running: false

    stdout: StdioCollector { waitForEnd: true }

    stderr: StdioCollector {
      waitForEnd: true
      onStreamFinished: if (text.trim() !== "") console.warn("zai.agent-usage", text.trim())
    }
  }
}
