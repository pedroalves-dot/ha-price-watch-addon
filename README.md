# Price watch — Home Assistant add-on

Checks your Price watch prices from your home internet connection. Shops like Amazon.es and KuantoKusta
refuse checks from cloud servers but accept normal visits from home.

It's a small Node program (no GitHub runner): it reads your products from the Price watch repo, checks them at
the times you set, sends the Telegram message and saves the prices back to the repo. "Check now" in the web app
and `/check` in Telegram are picked up within a minute. Uses about 50–80 MB of memory while checking.

1. Settings → Add-ons → Add-on Store → ⋮ → Repositories → add this repo's URL (already there if you installed v1).
2. Install or update **Price watch checker**.
3. Configuration tab:
   - `github_token` — fine-grained token, only the price-watch repo, **Contents: read & write**
   - `telegram_bot_token` — from @BotFather
   - `telegram_chat_id` — your chat id (the same one Netlify uses)
   - `check_times` — local times, e.g. `08:00,20:00`
4. Save → Start. The first start checks straight away and sends every price; then the log says "Waiting…".

Works on 32- and 64-bit Raspberry Pi (armhf, armv7, aarch64) and amd64.
