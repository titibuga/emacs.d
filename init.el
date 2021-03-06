
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)

;; Melpa
(add-to-list 'package-archives
             '("melpa-packages" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (rust-mode dap-mode lsp-ui company-lsp projectile use-package treemacs lsp-java jupyter elpy ess company-auctex vue-mode ido-ubiquitous ido-vertical-mode flx-ido flymake-ruby smartparens company avy auctex-latexmk typescript-mode magit material-theme rainbow-delimiters flycheck))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Material theme
(load-theme 'material t)

;; Remove Menubar
(menu-bar-mode 0)
(tool-bar-mode 0)

;; Activate elpy for python files and change auto-completion engine
;; TODO: Load elpy lazily
(elpy-enable)
;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i --simple-prompt")
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))




;; Auto-installl packages in the package list
(package-install-selected-packages)


;; IDO Mode
(require 'flx-ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; IDO Vertical mode and more natural key bindings in the mini-buffer
(ido-vertical-mode 1)
(defun vsp-ido-define-keys () ;; C-n/p is more intuitive in vertical layout
    (define-key ido-completion-map (kbd "<down>") 'ido-next-match)
    (define-key ido-completion-map (kbd "<up>") 'ido-prev-match))
(add-hook 'ido-setup-hook 'vsp-ido-define-keys)


(flx-ido-mode 1)
;; IDO ubiquitous
(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)



;; Dictionary setting
(setq ispell-dictionary "en_US")

;; Latex-mode minor modes hooks
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'reftex-mode)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;; Latexmk with auctex
(require 'auctex-latexmk)
(auctex-latexmk-setup)

;; Auctex company-mode (Auto-complete) -- Temporarily removed
;; (add-to-list 'load-path "path/to/company-auctex.el")
;; (require 'company-auctex)
;; (company-auctex-init)


;; Before-saving hooks
(add-hook 'before-save-hook 'time-stamp)
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; Misc stuff
(global-set-key (kbd "C-c q") 'auto-fill-mode)

(if (version<= "26.0.50" emacs-version )
    (global-display-line-numbers-mode)
  (global-linum-mode 1) )

;;TODO: Fix this so it doesn't spit the output in emacs itself
(global-set-key (kbd "C-c p")
  (lambda () (interactive )(shell-command "latexmk -pdf")))


;; font size (from https://github.com/bbatsov/prelude)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


;; Disable C-x C-x to trigger region activation (from masteringemacs.org)
(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))
(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

;; Regex fix
(require 're-builder)
(setq reb-re-syntax 'string)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

;; Avy config
(global-set-key (kbd "M-p") 'avy-goto-word-1) ;Jump to word which starts with the input chat
(global-set-key (kbd "M-g l") 'avy-goto-line) ;Jump to any visible line
(global-set-key (kbd "C-:") 'avy-goto-char) ;Jump to a char

;; Company mode config
;; (global-company-mode t)

;; Syntax check for ruby
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; Org-mode stuff

;; Babel language loading
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
;;   (julia . t)
   (python . t)
   (jupyter . t)))

;; Set inline-images display as default
(setq org-startup-with-inline-images t)
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;; Configure org-image scaling (truncating the real scale value)
(setq vsp-org-image-scale-step 1.1)
(defun vsp-org-img-scale-increase ()
  (interactive)
  (setq-local vsp-image-width (* vsp-image-width
  vsp-org-image-scale-step))
  (setq-local org-image-actual-width (truncate vsp-image-width))
  (message "org-img-width: %f" org-image-actual-width)
  (org-redisplay-inline-images) )

(defun vsp-org-img-scale-decrease ()
  (interactive)
  (setq-local vsp-image-width (/ vsp-image-width
  vsp-org-image-scale-step))
  (setq-local org-image-actual-width (truncate vsp-image-width))
  (message "org-img-width: %f" org-image-actual-width)
  (org-redisplay-inline-images) )


(defun vsp-set-img-scale-config ()
  "Set commands to scale inline images in org-mode"
  (setq-local vsp-image-width (/ (display-pixel-width) 3))
  (setq-local org-image-actual-width (truncate vsp-image-width))
  (local-set-key (kbd "C-M-+") 'vsp-org-img-scale-increase)
  (local-set-key (kbd "C-M--") 'vsp-org-img-scale-decrease) )

(add-hook 'org-mode-hook 'vsp-set-img-scale-config)

;; Java Config
;; Copy and paste from jsp-java readme

(require 'cc-mode)

(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (require 'use-package)))

(use-package projectile :ensure t)
(use-package yasnippet :ensure t)
(use-package lsp-mode :ensure t)
(use-package hydra :ensure t)
(use-package company-lsp :ensure t)
(use-package lsp-ui :ensure t)
(use-package lsp-java :ensure t :after lsp
  :config (add-hook 'java-mode-hook 'lsp))

(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java :after (lsp-java))

(add-hook 'java-mode-hook 'flycheck-mode)
(add-hook 'java-mode-hook 'company-mode)
