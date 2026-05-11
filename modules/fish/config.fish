# --- Path configuration ---
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin

# --- Global Settings ---
if status is-interactive
    # Standard Locale
    set -gx LANG en_US.utf-8
    set -gx LANGUAGE en_US
    set -gx LC_MESSAGES C

    # --- Abbreviations ---
    
    # Navigation & Editing
    abbr -a efc vim ~/.config/fish/config.fish
    abbr -a c clear
    
    # Theme
    abbr -a dark "set-theme dark"
    abbr -a light "set-theme light"

    # Network
    abbr -a kvn 'curl ipconfig.io/country; curl ifconfig.co/country; speedtest-cli --secure --no-upload --simple'

    # Git
    abbr -a gsw git switch

    # Laravel
    abbr -a a php artisan
    abbr -a solo php artisan solo
    abbr -a pint ./vendor/bin/pint --dirty
    abbr -a pest ./vendor/bin/pest --compact

    # Project Directories (DSE)
    abbr -a dse cd ~/Code/dse
    abbr -a env1 cd ~/Code/dse/env1
    abbr -a env2 cd ~/Code/dse/env2
    abbr -a mod modules.sh

    # Docker
    abbr -a dc docker compose
    abbr -a dcu docker compose up -d
    abbr -a dcd docker compose down --remove-orphans

    # Docker Exec/Artisan/Refresh
    abbr -a dce1 docker compose exec -it env1
    abbr -a dca1 docker compose exec -it env1 php artisan
    abbr -a dcr1 'docker exec -t env1 bash -c "php artisan o:clear && php artisan migrate:fresh --seed && php artisan module:migrate --seed --all" & npx gulp; wait'

    abbr -a dce2 docker compose exec -it env2
    abbr -a dca2 docker compose exec -it env2 php artisan
    abbr -a dcr2 'docker exec -t env2 bash -c "php artisan o:clear && php artisan migrate:fresh --seed && php artisan module:migrate --seed --all" & npx gulp; wait'
end

# --- Functions ---
function set-theme
    set -l theme_dir "$HOME/.config/kitty"

    if test "$argv[1]" = "dark"
        ln -sf "$theme_dir/theme-dark.conf" "$theme_dir/theme-current.conf"
    else
        ln -sf "$theme_dir/theme-light.conf" "$theme_dir/theme-current.conf"
    end

    # Reload kitty config safely
    set -l kitty_pid (pgrep -u $USER -x kitty)
    if test -n "$kitty_pid"
        kill -SIGUSR1 $kitty_pid
    end
end
