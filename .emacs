;; performance boosting
;; Without this Emacs starts a lot slower
(setq gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold 100000000)      ;performace
(setq file-name-handler-alist-original file-name-handler-alist) ;performance
(setq file-name-handler-alist nil)
(run-with-idle-timer                    ;reset
 5 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original)
   (setq file-name-handler-alist file-name-handler-alist-original)
   (makunbound 'gc-cons-threshold-original)
   (makunbound 'file-name-handler-alist-original)
   (message "gc-cons-threshold and file-name-handler-alist restored")))
;; end performance

;; Adjust system time to PST so org mode uses the time zone I care about
;; for me and not the one I care about for my servers
(set-time-zone-rule "/usr/share/zoneinfo/PST8PDT")

;; Show trailing whitespace as red and lines that are too long
;; Change colors at the point when they become too long
;; Delete trailing whitespace on save
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Tabs are the devil
(setq-default indent-tabs-mode nil)

;; Mutt support.
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))

;; Add a common package repo and initialize it
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lang-refactor-perl lsp-rust tide tss typescript-mode company-plsense protobuf-mode magit chess lsp-ruby rspec-mode flycheck-pyflakes flymake-python-pyflakes fish-completion fish-mode flycheck-rust rubocop rubocopfmt rustic salt-mode elpy highlight-indent-guides cargo flycheck-gometalinter flymake-go flymake-perlcritic flymake-puppet flymake-ruby go-autocomplete go-errcheck go-mode govet flymake-rust puppet-mode racer cm-mode cider)))
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; menu bar is relatively worthless
(menu-bar-mode -1)

;; DOS 2 UNIX
(defun dos2unix (buffer)
  "Automate M-% C-q C-m RET C-q C-j RET"
  (interactive "*b")
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (string ?\C-m) nil t)
      (replace-match (string ?\C-j) nil t))))

;; Save clock history across Emacs sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


(setq epg-gpg-program "gpg2")


(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))

(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(load-library "hideshow")
(global-set-key (kbd "C-c c") 'toggle-hiding)
(global-set-key (kbd "C-c r") 'toggle-selective-display)

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'rust-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

(setq tramp-default-method "ssh")

(setq ispell-list-command "--list")

;; Language specific actions

;; C
;;; This function switches C-mode so that it indents stuff according to
;;; our style(9) which is equivalent to FreeBSD's. Tested with emacs-22.3.
;;;
;;; Use "M-x bsd" in a C mode buffer to activate it.
;;;
;;; To make this the default, use a line like this, but you can't easily
;;; switch back to default GNU style, since the old state isn't saved.
;;;
;;; (add-hook 'c-mode-common-hook 'bsd)
;;;
;;; As long as you don't have this in the c-mode hook you can edit GNU
;;; and BSD style C sources within one emacs session with no problem.
;;;
;;; Posted to FreeBSD's cvs-all by DES (<867ifoaulz.fsf@ds4.des.no>).

(defun bsd ()
  (interactive)
  (c-set-style "bsd")

  ;; Basic indent is 8 spaces
  (setq c-basic-offset 8)
  (setq tab-width 8)

  ;; Continuation lines are indented 4 spaces
  (c-set-offset 'arglist-cont 4)
  (c-set-offset 'arglist-cont-nonempty 4)
  (c-set-offset 'statement-cont 4)
  (c-set-offset 'cpp-macro-cont 8)

  ;; Labels are flush to the left
  (c-set-offset 'label [0])

  ;; Fill column
  (setq fill-column 74))

;; Emails
(add-hook 'mail-mode-hook
          (lambda ()
            (flyspell-prog-mode)
            ))

;; HTML
(add-hook 'html-mode-hook
          (lambda ()
            ;; Default indentation is usually 2 spaces, changing to 4.
            (set (make-local-variable 'sgml-basic-offset) 4)))

;; Just
(add-to-list 'auto-mode-alist '("\\justfile$" . makefile-mode))

;; Perl
;; Make Perl tests load Perl mode
(add-to-list 'auto-mode-alist '("\\.t$" . perl-mode))
(add-hook 'perl-mode-hook
          (lambda ()
            (flyspell-prog-mode)
            (flycheck-mode)
            (rainbow-delimiters-mode)
            (highlight-parentheses-mode)
            (show-smartparens-mode)
            (show-paren-mode)
            ))

;; Puppet
(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(add-hook 'puppet-mode-hook
          (lambda()
            (flymake-puppet-load)
            (flycheck-mode)
            (rainbow-delimiters-mode)
            (highlight-parentheses-mode)
            (show-smartparens-mode)
            (show-paren-mode)
            ))

;; Python
(add-hook 'python-mode-hook
          (lambda ()
            (elpy-mode)
            (flymake-python-pyflakes-load)
            (rainbow-delimiters-mode)
            (highlight-parentheses-mode)
            (show-smartparens-mode)
            (show-paren-mode)
            ))

;; Ruby
(add-hook 'ruby-mode-hook
          (lambda ()
            (flycheck-mode)
            ))

;; Rust
(add-hook 'rust-mode-hook
          (lambda()
            (rainbow-delimiters-mode)
            (highlight-parentheses-mode)
            (show-smartparens-mode)
            (show-paren-mode)
            (flycheck-mode)
            (flymake-mode)
            (flymake-rust-load)
            ))
(require 'flymake-rust)
(setq rust-format-on-save t)

;; Shell
(add-hook 'shell-script-mode-hook
          (lambda()
            (setq indent-tabs-mode t)
            (setq tab-width 4)
            (setq c-basic-indent 4)
            (set (make-local-variable 'tab-stop-list)
                 (number-sequence 4 200 4))
            ))

;; End of language specific settings


(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . diff-mode))
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

(setq column-number-mode t)
