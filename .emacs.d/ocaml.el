(global-set-key (kbd "C-c ;") 'merlin-locate)

(require 'ocp-indent)
(require 'merlin)

(custom-set-variables
 '(merlin-command "ocamlmerlin"))

(add-hook 'tuareg-mode-hook 'merlin-mode t)
