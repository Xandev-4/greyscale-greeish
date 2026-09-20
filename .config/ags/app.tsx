import app from "ags/gtk4/app"
import Clock from "./widget/Clock"
import Media from "./widget/Media"
import Stopwatch from "./widget/Stopwatch"
import style from "./style.scss"

app.start({
  css: style,
  main() {
    app.get_monitors().map(Clock)
    app.get_monitors().map(Media)
    // app.get_monitors().map(Stopwatch)
  },
})
