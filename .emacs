(font-lock-add-keywords 'haskell-mode '(("undefined" . font-lock-warning-face)))

(setq scroll-preserve-screen-position t)
(setq scroll-step 5)
(setq x-select-enable-clipboard t)

(load "/home/rotsor/.emacs.d/dup-line.elisp")

(require 'nix-mode)
(require 'haskell-mode-autoloads)
;; (require 'caml)

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda2-include-dirs (quote ("/home/rotsor/annex/agda/lib/src" "." "/home/rotsor/annex/agda/categories"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defmacro measure-time (&rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (message "%.06f" (float-time (time-since time)))))
(defun gogo (prefix x max)
  (interactive "sPrefix:\nnx:\nnmax:")
  (if (> x max) ()
  (message (format "%s %d" prefix x))
  (measure-time (agda2-compute-normalised-toplevel (format "%s %d" prefix x)))
  (gogo prefix (+ x 1) max))
)

(tool-bar-mode -1)

(global-auto-revert-mode t)
(setq visible-bell 1)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(menu-bar-mode -99)
(tool-bar-mode -1)

(custom-set-variables
   '(haskell-mode-hook '(turn-on-haskell-indentation)))

(setq read-quoted-char-radix 10)
