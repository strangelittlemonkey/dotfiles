;; Auto load puppet-mode
(load "puppet-mode")

;; show trailing whitespace as red and lines that are too long
;; change colors at the point when they become too long
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; Tell emacs to load files that end in .pp with puppet-mode
(add-to-list 'auto-mode-alist '("\\.pp\\'" . puppet-mode))
(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces)
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.

;; DOS 2 UNIX
(defun dos2unix (buffer)
      "Automate M-% C-q C-m RET C-q C-j RET"
      (interactive "*b")
      (save-excursion
        (goto-char (point-min))
        (while (search-forward (string ?\C-m) nil t)
          (replace-match (string ?\C-j) nil t))))
 
;; Add support for marmalade
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(package-refresh-contents)
