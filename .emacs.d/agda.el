(load-file (let ((coding-system-for-read 'utf-8))
             (shell-command-to-string "agda-mode locate")))

(set 'agda2-program-args
     (quote
      ("--include-path=/home/rotsor/.nix-profile/share/agda")))
