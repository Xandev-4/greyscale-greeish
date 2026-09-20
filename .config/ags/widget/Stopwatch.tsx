import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"

function formatTime(seconds: number): string {
  const m = Math.floor(seconds / 60)
    .toString()
    .padStart(2, "0")
  const s = (seconds % 60).toString().padStart(2, "0")
  return `${m}:${s}`
}

export default function Stopwatch(monitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor

  let elapsed = 0
  let running = false
  let intervalId: ReturnType<typeof setInterval> | null = null

  const time = createPoll(formatTime(0), 100, () => formatTime(elapsed))

  const start = () => {
    if (running) return
    running = true
    intervalId = setInterval(() => {
      elapsed++
    }, 1000)
  }

  const pause = () => {
    if (!running) return
    running = false
    if (intervalId) {
      clearInterval(intervalId)
      intervalId = null
    }
  }

  const reset = () => {
    pause()
    elapsed = 0
  }

  return (
    <window
      visible
      application={app}
      gdkmonitor={monitor}
      anchor={TOP | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      marginTop={280}
      marginRight={16}
      layer={Astal.Layer.TOP}
      namespace="stopwatch-widget"
      width_request={220}
    >
      <box css="padding: 12px;">
        <box
          class="stopwatch-widget"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={8}
        >
          <box halign={Gtk.Align.END}>
            <button
              class="stopwatch-close"
              onClicked={() => {
                reset()
                app.get_window("stopwatch-widget")!.visible = false
              }}
            >
              󰅖
            </button>
          </box>
          <label class="stopwatch-time" label={time} xalign={0.5} />
          <box
            class="stopwatch-controls"
            spacing={12}
            halign={Gtk.Align.CENTER}
          >
            <button
              class="stopwatch-btn"
              onClicked={() => (running ? pause() : start())}
            >
              󰐊 Start
            </button>
            <button class="stopwatch-btn" onClicked={reset}>
              󰦛 Reset
            </button>
          </box>
        </box>
      </box>
    </window>
  )
}
