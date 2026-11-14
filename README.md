# Price watch — Home Assistant add-on

Runs the Price watch price checks from your home internet connection, as a GitHub Actions self-hosted runner.
Shops like Amazon.es and KuantoKusta refuse checks from cloud servers, but accept normal visits from home.

1. Settings → Add-ons → Add-on Store → ⋮ → Repositories → add this repo's URL.
2. Install **Price watch runner**.
3. Configuration tab: paste a runner registration token (Repo → Settings → Actions → Runners → New self-hosted runner; valid 1 hour) → Save.
4. Start. The log should end with "Waiting for price checks…".

Needs a 64-bit system (aarch64 or amd64).
