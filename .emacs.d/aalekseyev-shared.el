;; things that seem crazy not to have by default
(setq x-select-enable-clipboard t)
(menu-bar-mode -99)
(tool-bar-mode -1)
(setq visible-bell 1)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(set 'column-number-mode t)

;; things that I think are good
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(load-relative "dup-line.el")

;; make backslash not destroy the parenthesis that follows it
;; (e.g. (\(x : int) -> y))
;; this is kind of wrong in elisp where '(\() is a valid expression,
;; but it's good in haskell-like languages
(modify-syntax-entry ?\\ "." (standard-syntax-table))

;; I was using smooth scrolling before, but it seems a bit buggy.
;; I'll try to use builtins for now
(setq use-smooth-scrolling-instead-of-builtins nil)
(if use-smooth-scrolling-instead-of-builtins
    (progn
      (setq scroll-preserve-screen-position t)
      (setq scroll-step 1) ;; this is ok, but smooth-scrolling is better
      (load "/home/rotsor/repos/smooth-scrolling/smooth-scrolling.el")
      (smooth-scrolling-mode 1)
      )
  (progn
    (setq scroll-step 1)
    (setq scroll-conservatively 10000)
    ;; I haven't seen this [auto-window-vscroll = nil] make a difference, but
    ;; they say it can help
    (setq auto-window-vscroll nil)
    (setq scroll-margin 5)
    (setq scroll-preserve-screen-position t)
    )
  )

(defalias 'yes-or-no-p 'y-or-n-p)

;; shell script mode
(set 'sh-basic-offset 2)
(set 'sh-indentation 2)
