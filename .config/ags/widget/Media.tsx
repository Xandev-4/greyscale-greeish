import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"
import { execAsync } from "ags/process"

export default function Media(monitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor

  const safePoll = (cmd: string) => `sh -c '${cmd} 2>/dev/null || true'`

  const title = createPoll("", 1000, safePoll("playerctl metadata title"))
  const artist = createPoll("", 1000, safePoll("playerctl metadata artist"))

  return (
    <window
      visible
      application={app}
      gdkmonitor={monitor}
      anchor={TOP | RIGHT}
      exclusivity={Astal.Exclusivity.IGNORE}
      marginTop={180}
      marginRight={16}
      layer={Astal.Layer.BACKGROUND}
      namespace="media-widget"
      width_request={220}
    >
      <box css="padding: 12px;">
        <box class="media-widget" orientation={Gtk.Orientation.VERTICAL}>
          <label
            class="media-title"
            label={title}
            ellipsize={3}
            maxWidthChars={24}
            xalign={0}
          />
          <label
            class="media-artist"
            label={artist}
            ellipsize={3}
            maxWidthChars={24}
            xalign={0}
          />
          <box class="media-controls" spacing={12} halign={Gtk.Align.CENTER}>
            <button onClicked={() => execAsync("playerctl previous")}>󰒮</button>
            <button onClicked={() => execAsync("playerctl play-pause")}>
              󰐎
            </button>
            <button onClicked={() => execAsync("playerctl next")}>󰒭</button>
          </box>
        </box>
      </box>
    </window>
  )
}
