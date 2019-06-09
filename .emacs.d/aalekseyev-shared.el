(defun load-relative (filename)
  (load
   (expand-file-name
    filename
    (if load-file-name
	(file-name-directory load-file-name)
      default-directory)))  
  )

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
(set 'indent-tabs-mode nil)
(setq-default tab-width 4)
(global-auto-revert-mode t)
(setq read-quoted-char-radix 10)
(setq inhibit-startup-screen t)

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

;; maybe this should be taken from env. vars or something
(require 'package)
(add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")
(add-to-list 'load-path "~/.nix-profile/share/emacs/site-lisp")

(define-key global-map (kbd "RET") 'newline-and-indent)


(defun load-relative-optional (path)
  (condition-case err (load-relative path)
    (error (print (list "error loading" path err)) nil))
  )

(load-relative-optional "ocaml.el")
(load-relative-optional "agda.el")
(load-relative-optional "haskell.el")
