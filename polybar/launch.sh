 
#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar


echo "Bars launched..."

for MONITOR in $(polybar --list-monitors | cut -d":" -f1);
do
	polybar demo -r &
done