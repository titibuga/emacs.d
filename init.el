
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-electric-math (quote ("\\(" . "\\)")))
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (avy auctex-latexmk typescript-mode magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; IDO Mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

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

;; (add-hook 'LaTeX-mode-hook
;; 	  (lambda () (set (make-variable-buffer-local 'TeX-electric-math)
;; 			  (cons "\\(" "\\)"))))
(add-hook 'before-save-hook 'time-stamp)


;; Misc stuff
(global-set-key (kbd "C-c q") 'auto-fill-mode)
(global-linum-mode 1)

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

;; Melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)


;; Avy config
(global-set-key (kbd "M-p") 'avy-goto-word-1) ;Jump to word which starts with the input chat
(global-set-key (kbd "M-g l") 'avy-goto-line) ;Jump to any visible line
(global-set-key (kbd "C-:") 'avy-goto-char) ;Jump to a char



