#!/usr/bin/with-contenv sh
export HOME=/config
export APPDIR=/app/joplin
exec /app/joplin/AppRun --no-sandbox
