import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"

export default function Clock(monitor: Gdk.Monitor) {
  const time = createPoll("", 1000, `date "+%H:%M"`)
  const { TOP, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      application={app}
      gdkmonitor={monitor}
      anchor={TOP | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      marginTop={36}
      marginRight={16}
      layer={Astal.Layer.BACKGROUND}
      namespace="clock-widget"
    >
      <box css="padding: 12px;">
        <box orientation={Gtk.Orientation.VERTICAL} class="clock-widget">
          <label class="clock-time" label={time} />
          <label class="clock-subtitle" label="Local time" />
        </box>
      </box>
    </window>
  )
}
