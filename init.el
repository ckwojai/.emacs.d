;;; package --- Summary
;;; Commentary:
;;; emacs-init.el --- Kin Chang's Emacs init file.
;;      ___           ___           ___           ___           ___           ___
;;     /  /\         /  /\         /__/\         /__/\         /  /\         /__/\          ___
;;    /  /:/        /  /::\       |  |::\       |  |::\       /  /:/_        \  \:\        /  /\
;;   /  /:/        /  /:/\:\      |  |:|:\      |  |:|:\     /  /:/ /\        \  \:\      /  /:/
;;  /  /:/  ___   /  /:/  \:\   __|__|:|\:\   __|__|:|\:\   /  /:/ /:/_   _____\__\:\    /  /:/
;; /__/:/  /  /\ /__/:/ \__\:\ /__/::::| \:\ /__/::::| \:\ /__/:/ /:/ /\ /__/::::::::\  /  /::\
;; \  \:\ /  /:/ \  \:\ /  /:/ \  \:\~~\__\/ \  \:\~~\__\/ \  \:\/:/ /:/ \  \:\~~\~~\/ /__/:/\:\
;;  \  \:\  /:/   \  \:\  /:/   \  \:\        \  \:\        \  \::/ /:/   \  \:\  ~~~  \__\/  \:\
;;   \  \:\/:/     \  \:\/:/     \  \:\        \  \:\        \  \:\/:/     \  \:\           \  \:\
;;    \  \::/       \  \::/       \  \:\        \  \:\        \  \::/       \  \:\           \__\/
;;     \__\/         \__\/         \__\/         \__\/         \__\/         \__\/
;;; Code:
;;      ___           ___          _____          ___
;;     /  /\         /  /\        /  /::\        /  /\
;;    /  /:/        /  /::\      /  /:/\:\      /  /:/_
;;   /  /:/        /  /:/\:\    /  /:/  \:\    /  /:/ /\
;;  /  /:/  ___   /  /:/  \:\  /__/:/ \__\:|  /  /:/ /:/_
;; /__/:/  /  /\ /__/:/ \__\:\ \  \:\ /  /:/ /__/:/ /:/ /\
;; \  \:\ /  /:/ \  \:\ /  /:/  \  \:\  /:/  \  \:\/:/ /:/
;;  \  \:\  /:/   \  \:\  /:/    \  \:\/:/    \  \::/ /:/
;;   \  \:\/:/     \  \:\/:/      \  \::/      \  \:\/:/
;;    \  \::/       \  \::/        \__\/        \  \::/
;;     \__\/         \__\/                       \__\/
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; ===================================================
;; Usepackage Configure below
;; ===================================================
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize)
  (menu-bar-mode -1)
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)
  (toggle-frame-maximized)
  (setq tab-width 4)
  )
;; ===================================================
;; BASIC UTILITIES
;; ===================================================
(setq backup-directory-alist '(("." . "~/emacs_backup")))
(delete-selection-mode 1)
(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'column)
  (setq highlight-indent-guides-responsive 'top)
  )
(use-package moody
  :config
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  )
(use-package nlinum-relative
    :config
    (nlinum-relative-setup-evil)
	(add-hook 'after-init-hook 'global-nlinum-relative-mode)
	(setq nlinum-relative-current-symbol "->")
    ;; (add-hook 'prog-mode-hook 'nlinum-relative-mode)
	)
(use-package spacemacs-theme
  :defer t
  :config
  (load-theme 'spacemacs-dark t)
  )

(use-package org :ensure org-plus-contrib :pin org)
;; Evil Set Up
(use-package evil
  :config
  (evil-mode 1)
  ;; Insert Mode with Emacs keybinding
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map
	(read-kbd-macro evil-toggle-key) 'evil-normal-state)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  )
(use-package vi-tilde-fringe
  :config
  (global-vi-tilde-fringe-mode)
)
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))
(use-package helm
  :bind (("M-x" . helm-M-x)
		 ("C-x r b" . helm-filtered-bookmarks)
		 ("C-x C-f" . helm-find-files)
		 ("C-x b" . helm-mini)
		 ("C-x C-b" . 'ibuffer)
		 )
  :config
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  (helm-mode 1)
  (setq helm-mini-default-sources '(helm-source-buffers-list
									helm-source-recentf
									helm-source-bookmarks
									helm-source-buffer-not-found))
  (recentf-mode 1)
  )
(use-package company
  :config
  (setq company-minimum-prefix-length 1)
  (add-hook 'after-init-hook 'global-company-mode)
  (use-package company-auctex)
  (company-auctex-init)
  (setq company-show-numbers t)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode)
  )
(use-package company-quickhelp
  :ensure t
  :init
  (company-quickhelp-mode 1)
  (use-package pos-tip
    :ensure t))

;; (use-package key-chord
;;   :config (key-chord-mode 1)
;;   )
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
		 ("C-<" . mc/mark-all-like-this)
		 )
  )
(use-package magit
  :bind (("C-x g" . magit-status))
  )
(use-package flycheck
  :config
  (global-flycheck-mode)

  )
(use-package projectile
  :config
  (projectile-mode)
  (setq projectile-mode-line
        '(:eval (format " Projectile[%s]"
                        (projectile-project-name))))
  )
(use-package tramp
  :config
  (custom-set-variables
   '(tramp-default-method "ssh" nil (tramp))
   '(tramp-default-user "kinc" nil (tramp))
   '(tramp-default-host "192.241.224.44" nil (tramp)))
  )
;; ===================================================
;; HOOKING UTILITIES
;; ===================================================
(use-package ggtags
  :hook ((js-mode python-mode c++-mode) . ggtags-mode)
  )
(use-package flyspell
  :hook ((org-mode) . flyspell-mode)
  )
(use-package yasnippet
  :config
  (yas-reload-all)
  :hook ((python-mode c-mode c++-mode) . yas-minor-mode)
  )
(use-package smartparens
  :config
  (show-smartparens-global-mode)
  :hook ((js-mode python-mode c++-mode TeX-mode) . smartparens-mode)
  )
;; ===================================================
;; Org TODO and Agneda
;; ===================================================
(setq org-agenda-files (list "~/org"))
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/org/inbox.org" "Tasks")
                               "* TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n")
                              ("T" "Tickler" entry
                               (file+headline "~/org/tickler.org" "Tickler")
                               "* %i%? \n %U"))
	  )
;; (define-key global-map "\C-cx"
;;   (lambda () (interactive) (org-capture nil "x")))
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '(("~/org/gtd.org" :maxlevel . 1)))
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)


(use-package org-gcal

  :init
  (add-hook 'emacs-startup-hook #'org-gcal-fetch)
  (defun fetch-calendar ()
    (when (internet-up-p) (org-gcal-fetch)))
  :config
  (setq org-gcal-client-id "3200543451-ind1kdbjhb621qt0g9uc7q88lkhckun6.apps.googleusercontent.com"
      org-gcal-client-secret "2Jf7wCLpviJ7oD8zQdohjJOe"
      org-gcal-file-alist '(("kinchang0811@gmail.com" .  "~/org/gcal.org")
                            ("kin.chang@jonajo.com" .  "~/org/jonajo.org")))
  (add-hook 'org-agenda-mode-hook (lambda () (define-key org-agenda-mode-map "g" 'org-gcal-fetch)))
			)
(use-package org-bullets
  :init
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; ===================================================
;; Angular 2
;; ===================================================
;; (use-package ng2-mode)
;; (use-package tide
;;   :init
;;   :ensure t
;;   :after (typescript-mode company flycheck)
;;   :hook ((typescript-mode . tide-setup)
;;          (typescript-mode . tide-hl-identifier-mode)
;;          (before-save . tide-format-before-save))
;;   :config
;;   ;; aligns annotation to the right hand side
;;   (setq company-tooltip-align-annotations t)
;;   ;; formats the buffer before saving
;;   (add-hook 'before-save-hook 'tide-format-before-save)
;;   )
;; (defun setup-tide-mode ()
;;   (interactive)
;;   (tide-setup)
;;   (flycheck-mode +1)
;;   (setq flycheck-check-syntax-automatically '(save mode-enabled))
;;   (eldoc-mode +1)
;;   (tide-hl-identifier-mode +1)
;;   ;; company is an optional dependency. You have to
;;   ;; install it separately via package-install
;;   ;; `M-x package-install [ret] company`
;;   (company-mode +1))
;; (use-package typescript-mode
;;   :ensure t
;;   :config
;;   (setq typescript-indent-level 4)
;;   (add-hook 'typescript-mode #'subword-mode)
;;   (add-hook 'typescript-mode-hook #'setup-tide-mode)
;;   )
;; (use-package web-mode
;;   :ensure t
;;   :mode (("\\.html?\\'" . web-mode)
;;          ("\\.tsx\\'" . web-mode)
;;          ("\\.jsx\\'" . web-mode)
;; 		 )
;;   :config
;;   (setq web-mode-markup-indent-offset 2
;;         web-mode-css-indent-offset 2
;;         web-mode-code-indent-offset 2
;;         web-mode-block-padding 2
;;         web-mode-comment-style 2
;;         web-mode-enable-css-colorization t
;;         web-mode-enable-auto-pairing t
;;         web-mode-enable-comment-keywords t
;;         web-mode-enable-current-element-highlight t
;;         )
;;   (add-hook 'web-mode-hook
;;             (lambda ()
;;               (when (string-equal "tsx" (file-name-extension buffer-file-name))
;; 				(setup-tide-mode))))
;;   ;; enable typescript-tslint checker
;;   (flycheck-add-mode 'typescript-tslint 'web-mode))
;; ===================================================
;; React
;; ===================================================
;; (use-package rjsx-mode
;;   :config
;;   ;; disable jshint since we prefer eslint checking
;;   (setq-default flycheck-disabled-checkers
;; 				(append flycheck-disabled-checkers
;; 						'(javascript-jshint)))
;;   ;; use eslint with web-mode for jsx files
;;   (flycheck-add-mode 'javascript-eslint 'rjsx-mode)
;;   ;; :mode (
;;   ;; 		 ("\\.js\\'" . rjsx-mode)
;;   ;; 		 ("\\.jsx\\'" . rjsx-mode)
;;   ;; 		 ("\\.ts\\'" . rjsx-mode)
;;   ;; 		 ("\\.tsx\\'" . rjsx-mode)
;;   ;; 		 )
;;   )
(use-package tide
  :init
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save))
  :config
  ;; Format Option
  (setq tide-format-options '(:indentSize 2))
  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)
  ;; formats the buffer before saving
  (add-hook 'before-save-hook 'tide-format-before-save)
  )
  (defun setup-tide-mode ()
	(interactive)
	(tide-setup)
	(flycheck-mode +1)
	(setq flycheck-check-syntax-automatically '(save mode-enabled))
	(eldoc-mode +1)
	(tide-hl-identifier-mode +1)
	;; company is an optional dependency. You have to
	;; install it separately via package-install
	;; `M-x package-install [ret] company`
	(company-mode +1))
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
		 )
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-block-padding 2
        web-mode-comment-style 2
        web-mode-enable-css-colorization t
        web-mode-enable-auto-pairing t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        )
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
				(setup-tide-mode))))
  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode))
(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode #'subword-mode)
  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  )

;; ===================================================
;; WEB DEVELPMENT
;; ===================================================
;; (use-package js2-mode
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;   (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
;;   :hook  ((js2-mode . js2-refactor-mode)
;; 		  (js2-mode . tern-mode)
;; 		  )
;;   )


;; (use-package web-mode
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . web-mode))  
;;   (setq web-mode-content-types-alist
;;   		'(("jsx" . "\\.js[x]?\\'")))  
;;   )
;; ===================================================
;; PYTHON
;; ===================================================

(use-package elpy
  :config
  (elpy-enable)
  (setq python-shell-interpreter "jupyter"
		python-shell-interpreter-args "console --simple-prompt")
  )
;; ===================================================
;; REVEAL.JS
;; ===================================================
(use-package ox-reveal
  )
;; ===================================================
;; osx-dictionary
;; ===================================================
(use-package osx-dictionary
  :config
  (global-set-key (kbd "C-c d") 'osx-dictionary-search-word-at-point)
  )

;; ===================================================
;; LaTeX
;; ===================================================
(use-package tex
  :ensure auctex
  )
;; (use-package pdf-tools
;;   :config
;;   (pdf-tools-install)
;;   )
(use-package auctex-latexmk
  :config
  (auctex-latexmk-setup)
  (add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer)
  (add-hook 'TeX-mode-hook '(lambda () (pdf-tools-install)))  
  (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-Show "LatexMk")))
  (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "LatexMk")))
  
  (setq TeX-view-program-selection '((output-pdf "pdf-tools"))
  		TeX-source-correlate-start-server t)
  (setq TeX-source-correlate-mode t)
  (setq TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  )
;; ===================================================
;; BackUp Code
;; ===================================================
;; (use-package org
;;   :config
;;   (setq org-directory "~/Dropbox/org")
;;   (setq org-mobile-inbox-for-pull "~/Dropbox/org/inbox.org")
;;   (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
;;   (setq org-mobile-files '("~/Dropbox/org"))
;;   (setq org-mobile-force-id-on-agenda-items nil)
;; )
;; (use-package doom-themes
;;   :config
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;; 	doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   (load-theme 'doom-one t)
;;   (doom-themes-visual-bell-config)
;;   (doom-themes-neotree-config)  ; all-the-icons fonts must be installed!
;;   (doom-themes-org-config)
;;   )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-indent-level 4)
 '(LaTeX-item-indent 4)
 '(TeX-brace-indent-level 4)
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#373b41" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#c5c8c6"))
 '(beacon-color "#cc6666")
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
	("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "233bb646e100bda00c0af26afe7ab563ef118b9d685f1ac3ca5387856674285d" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(esv-key "c3b0d636e138cd80cff4b2f2f055a70cb9fb3fb9")
 '(fci-rule-color "#373b41")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(frame-background-mode (quote dark))
 '(indent-tabs-mode t)
 '(org-agenda-files (quote ("~/org")))
 '(org-icalendar-include-todo (quote all))
 '(package-selected-packages
   (quote
	(org-bullets vi-tilde-fringe-mode evil-surround web-mode powerline powerline-evil sml-mode pdf-tools auctex)))
 '(pdf-view-incompatible-modes nil)
 '(sml/mode-width
   (if
	   (eq
		(powerline-current-separator)
		(quote arrow))
	   (quote right)
	 (quote full)))
 '(sml/pos-id-separator
   (quote
	(""
	 (:propertize " " face powerline-active1)
	 (:eval
	  (propertize " "
				  (quote display)
				  (funcall
				   (intern
					(format "powerline-%s-%s"
							(powerline-current-separator)
							(car powerline-default-separator-dir)))
				   (quote powerline-active1)
				   (quote powerline-active2))))
	 (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
	(""
	 (:propertize " " face powerline-active1)
	 (:eval
	  (propertize " "
				  (quote display)
				  (funcall
				   (intern
					(format "powerline-%s-%s"
							(powerline-current-separator)
							(cdr powerline-default-separator-dir)))
				   (quote powerline-active1)
				   (quote sml/global))))
	 (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
	(""
	 (:propertize " " face sml/global)
	 (:eval
	  (propertize " "
				  (quote display)
				  (funcall
				   (intern
					(format "powerline-%s-%s"
							(powerline-current-separator)
							(car powerline-default-separator-dir)))
				   (quote sml/global)
				   (quote powerline-active1))))
	 (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
	(""
	 (:propertize " " face powerline-active2)
	 (:eval
	  (propertize " "
				  (quote display)
				  (funcall
				   (intern
					(format "powerline-%s-%s"
							(powerline-current-separator)
							(cdr powerline-default-separator-dir)))
				   (quote powerline-active2)
				   (quote powerline-active1))))
	 (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes)))
 '(tab-width 4)
 '(tramp-default-host "192.241.224.44" nil (tramp))
 '(tramp-default-method "ssh" nil (tramp))
 '(tramp-default-user "kinc" nil (tramp))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
	((20 . "#cc6666")
	 (40 . "#de935f")
	 (60 . "#f0c674")
	 (80 . "#b5bd68")
	 (100 . "#8abeb7")
	 (120 . "#81a2be")
	 (140 . "#b294bb")
	 (160 . "#cc6666")
	 (180 . "#de935f")
	 (200 . "#f0c674")
	 (220 . "#b5bd68")
	 (240 . "#8abeb7")
	 (260 . "#81a2be")
	 (280 . "#b294bb")
	 (300 . "#cc6666")
	 (320 . "#de935f")
	 (340 . "#f0c674")
	 (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
