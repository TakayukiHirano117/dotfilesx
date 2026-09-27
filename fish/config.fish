if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_user_key_bindings
	for mode in default insert visual
		fish_default_key_bindings -M $mode
	end
	fish_vi_key_bindings --no-erase
	if test "$__fish_active_key_bindings" = fish_vi_key_bindings
		bind -M insert -m default jk force-repaint
end


end

set -Ux PATH $PATH $HOME/go/bin
set -gx PATH $HOME/go/bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $HOME/.bun/bin $PATH
set -Ux AWS_PROFILE hirano-ta
# set -Ux AWS_DEFAULT_REGION hirano-ta
# set -Ux AWS_ACCESS_KEY_ID hirano-ta
# set -Ux AWS_SECRET_ACCESS_KEY hirano-ta
alias sail='sh (test -f sail; and echo sail; or echo vendor/bin/sail)'

alias pest='/usr/local/opt/php@8.2/bin/php ./vendor/bin/pest'
function vi
nvim $argv
end

function vim
nvim $argv
end

function nvim
command nvim $argv
end

set -Ux PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and rbenv init - fish | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/takayukihirano117/google-cloud-sdk/path.fish.inc' ]; . '/Users/takayukihirano117/google-cloud-sdk/path.fish.inc'; end

# Atom One Dark（nvim の onedark.nvim / Cursor の workbench.colorTheme）に合わせる。
# 色は onedark.nvim の lua/onedark/palette.lua の dark から取った。
# conf.d/*.fish（fish 4.3 が作る fish_frozen_theme.fish を含む）は config.fish より
# 先に読まれるので、ここで書けば上書きできる。
# https://fishshell.com/docs/current/language.html#variable-scope
set -g fish_color_normal          abb2bf
set -g fish_color_command         61afef
set -g fish_color_keyword         c678dd
set -g fish_color_quote           98c379
set -g fish_color_redirection     c678dd
set -g fish_color_end             c678dd
set -g fish_color_error           e86671
set -g fish_color_param           abb2bf
set -g fish_color_option          d19a66
set -g fish_color_comment         5c6370
set -g fish_color_operator        56b6c2
set -g fish_color_escape          56b6c2
set -g fish_color_autosuggestion  5c6370
set -g fish_color_cwd             61afef
set -g fish_color_cwd_root        e86671
set -g fish_color_user            98c379
set -g fish_color_host            61afef
set -g fish_color_host_remote     e5c07b
set -g fish_color_status          e86671
set -g fish_color_cancel          --reverse
set -g fish_color_valid_path      --underline
set -g fish_color_history_current --bold
set -g fish_color_match           --background=3e4451
set -g fish_color_search_match    --background=3e4451
set -g fish_color_selection       abb2bf --bold --background=3e4451

set -g fish_pager_color_progress            5c6370
set -g fish_pager_color_prefix              56b6c2 --bold
set -g fish_pager_color_completion          abb2bf
set -g fish_pager_color_description         5c6370
set -g fish_pager_color_selected_background --background=3e4451

# 既定では SSH 時しかユーザー名を出さない。
# https://github.com/oh-my-fish/theme-bobthefish
set -g theme_display_user yes
set -g theme_display_ruby no
set -g theme_display_git_default_branch yes

# bobthefish は __bobthefish_colors のあとに bobthefish_colors を呼ぶ。
# 値は「背景 前景 [フラグ]」の順。-S が無いと set が関数スコープに閉じて効かない。
function bobthefish_colors -S -d 'Atom One Dark colors for bobthefish'
    set -l bg0      282c34
    set -l bg2      393f4a
    set -l visual   3e4451
    set -l fg       abb2bf
    set -l grey     5c6370
    set -l lgrey    848b98
    set -l red      e86671
    set -l dark_red 993939
    set -l green    98c379
    set -l yellow   e5c07b
    set -l orange   d19a66
    set -l blue     61afef
    set -l purple   c678dd
    set -l cyan     56b6c2

    set -x color_initial_segment_exit    $red $bg0 --bold
    set -x color_initial_segment_private $bg2 $fg
    set -x color_initial_segment_su      $green $bg0 --bold
    set -x color_initial_segment_jobs    $blue $bg0 --bold

    # パスはターミナル背景 (#282c34) より一段明るい #3e4451（nvim Visual）
    set -x color_path                    $visual $lgrey
    set -x color_path_basename           $visual $fg --bold
    set -x color_path_nowrite            $dark_red $fg
    set -x color_path_nowrite_basename   $dark_red $fg --bold

    set -x color_repo                    $green $bg0
    set -x color_repo_work_tree          $bg2 $fg --bold
    set -x color_repo_dirty              $yellow $bg0
    set -x color_repo_staged             $orange $bg0

    set -x color_vi_mode_default         $grey $bg0 --bold
    set -x color_vi_mode_insert          $green $bg0 --bold
    set -x color_vi_mode_visual          $purple $bg0 --bold

    set -x color_vagrant                 $blue $bg0 --bold
    set -x color_k8s                     $blue $bg0 --bold
    set -x color_aws_vault               $bg2 $orange --bold
    set -x color_aws_vault_expired       $bg2 $red --bold
    set -x color_username                $blue $bg0 --bold
    set -x color_hostname                $blue $bg0
    set -x color_screen                  $cyan $bg0 --bold
    set -x color_rvm                     $dark_red $fg --bold
    set -x color_node                    $green $bg0 --bold
    set -x color_virtualfish             $cyan $bg0 --bold
    set -x color_virtualgo               $cyan $bg0 --bold
    set -x color_desk                    $blue $bg0 --bold
    set -x color_nix                     $blue $bg0 --bold
end
