(defun load-relative (filename)
  (load
   (expand-file-name
    filename
    (if load-file-name
	(file-name-directory load-file-name)
      default-directory)))  
  )

(font-lock-add-keywords 'haskell-mode '(("undefined" . font-lock-warning-face)))

(load-relative
  ".emacs.d/aalekseyev-shared.el")

;; (require 'caml)

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

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
