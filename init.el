;---------------custom set variables----------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-python-flake8-executable "python3")
 '(flycheck-python-pycompile-executable "python3")
 '(flycheck-python-pylint-executable "python3")
 '(package-selected-packages
   '(lsp-haskell lsp-java org-latex-impatient org-download rustic web-mode pandoc pdf-tools ssh-agency ssh system-packages yasnippet all-the-icons-dired lsp-ui exec-path-from-shell org-roam corfu flycheck lsp-pyright tree-sitter treesit-auto cdlatex quelpa lsp-julia lsp-mode julia-repl julia-mode vterm adaptive-wrap neotree magithub undo-tree auctex cider))
 '(safe-local-variable-values '((flycheck-disabled-checkers emacs-lisp-checkdoc))))
;---------------------------------------------------------------------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;---------------------------------------------------------------------------------
;;---------------le global modes----------------
(global-corfu-mode)
(global-undo-tree-mode)
(setq electric-pair-pairs
      '((?\( . ?\))
        (?\[ . ?\])
        (?\" . ?\")
        (?' . ?')
        (?{ . ?})
        (?< . ?>)))
(electric-pair-mode 1)
(require 'server)
(unless (server-running-p)
    (server-start))
;(setenv "GIT_SSH_COMMAND" "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes")
;;---------------theme----------------
(setq use-package-verbose t)

;;; For packaged versions which must use `require'.

;; Add all your customizations prior to loading the themes
;(setq modus-themes-italic-constructs t
 ;     modus-themes-bold-constructs nil)

;; Load the theme of your choice.
(load-theme 'modus-operandi)

;;---------------Custom commands----------------
;hypa
(setq ns-option-modifier 'meta)
(setq ns-function-modifier 'hyper)

;quote provides for un-selfeval'd constant symbols&lists
(defun openf-emacs-config ()
  "A fn for kbd to open this file."
  (interactive)
  (find-file "~/.emacs")
  )

(global-set-key (kbd "H-e") 'openf-emacs-config)

(global-set-key (kbd "H-=")  (lambda () (interactive) (find-file "~/documents/noteserata2/noteserata/new words.txt")))

;;---------------make emacs sane----------------

; For performance
(setq gc-cons-threshold 100000000)

(global-display-line-numbers-mode)

(add-to-list 'image-types 'svg)

;;; Lockfiles unfortunately cause more pain than benefit
(setq create-lockfiles nil)


(setq inhibit-startup-screen t)           ; Disable startup screen
(setq initial-scratch-message "")         ; Make *scratch* buffer blank
(setq-default frame-title-format '("%b")) ; Make window title the buffer name

(fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
(show-paren-mode 1)                       ; Show closing parens by default
(setq linum-format "%4d ")                ; Line number format
(delete-selection-mode 1)                 ; Selected text will be overwritten when you start typing
(global-auto-revert-mode t)               ; Auto-update buffer if file has changed on disk

(add-hook 'before-save-hook
	  'delete-trailing-whitespace)    ; Delete trailing whitespace on save
(add-hook 'prog-mode-hook                 ; Show line numbers in programming modes
          (if (and (fboundp 'display-line-numbers-mode) (display-graphic-p))
              #'display-line-numbers-mode
            #'linum-mode))


;;; Fix this bug:
;;; https://www.reddit.com/r/emacs/comments/cueoug/the_failed_to_download_gnu_archive_is_a_pretty/
(when (version< emacs-version "26.3")
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(setq max-lisp-eval-depth 10000)

(setq read-process-output-max (* 1024 1024)) ;; 1mb

;;; Disable menu-bar, tool-bar, and scroll-bar.
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

; disable the binding that has backspace call "help"
; enable it do the same as delete
(global-set-key [?\C-x ?h] 'delete-backward-char)
;(global-set-key [?\C-x ?h] 'help-command) ;; overrides mark-whole-buffer


;disallow tabs    (setq-default indent-tabs-mode nil)
;set indenting to 4 places instead of default 2
(setq-default tab-width 4)
(setq-default tab-always-indent nil)

(defun my-backtab ()
  "Un-indent line or region by one tab stop."
  (interactive)
  (if (use-region-p)
      (let ((start (region-beginning))
            (end (region-end)))
        (indent-rigidly start end -4)
        (setq deactivate-mark nil))
    (indent-rigidly (line-beginning-position) (line-end-position) -4)))

(global-set-key (kbd "<S-tab>") 'my-backtab)

;bell off
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
;dimensions of window
(when window-system (set-frame-size (selected-frame) 155 60 ))

;;unicode
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)

;line wrapping
(global-visual-line-mode 1)
(require 'adaptive-wrap)
(add-hook 'visual-line-mode-hook 'adaptive-wrap-prefix-mode)

;python library
(add-to-list 'load-path "/opt/homebrew")

;; disable some emacs autosave features
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

;;---------------package shi---------------- ---------------package shi----------------


(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents     ; Unless a package archive already exists,
  (package-refresh-contents))        ; Refresh package contents so that Emacs knows which packages to load

;;; Setup use-packaged
(dolist (package '(use-package adaptive-wrap))
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(use-package use-package-ensure-system-package)


;--------------------------------

;ins llm workflow engine
;tree-sitter
(setq tree-sitter-load-path "/Users/sebastiansanchez/.emacs.d/tree-sitter")
;treesit-install-grammar to get new grammars

;haskell
;(add-to-list 'auto-mode-alist '("\\.hs\\'" . haskell-mode))

;latex
(pdf-loader-install)
;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
           #'TeX-revert-document-buffer)

(setq TeX-electric-sub-and-superscript 0) ;exponents, powers, subscripts, superscripts
(setq TeX-auto-save t) ; autosave
(setq TeX-parse-self t)
(global-prettify-symbols-mode)
;for one $ insert two $ and put cursor in middle
(add-hook 'LaTeX-mode-hook
          #'(lambda ()
              (define-key LaTeX-mode-map (kbd "$") 'self-insert-command)))
;cdlatex
(add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)
;make new latex file in own directory

;disable line numbers in pdf tools
(defun my-pdf-tools-hook ()
  (display-line-numbers-mode -1))

(add-hook 'pdf-view-mode-hook 'my-pdf-tools-hook)


;--------------------------------
;org-mode
;;hide funky syntax highlighting wrapping
(defun org-hide-src-block-delimiters()
  (interactive)
  (save-excursion (goto-char (point-max))
      (while (re-search-backward "#\\+BEGIN_SRC\\|#\\+END_SRC" nil t)
         (let ((ov (make-overlay (line-beginning-position)
             (1+ (line-end-position)))))
           (overlay-put ov 'invisible t)))))

(add-hook 'org-mode-hook 'org-hide-src-block-delimiters)

;pretty preview!
(setq org-preview-latex-default-process 'dvisvgm)

(defun auto-orgtex-preview ()
  "Custom function to run org-latex-preview with universal arguments."
  (interactive)
  ;0.5 is repeat-interval
  (run-at-time "0.5 sec" nil
			   (lambda() (setq current-prefix-arg '(16)) ; C-u C-u is equivalent to 16
					(call-interactively 'org-latex-preview))))

(add-hook 'org-mode-hook 'auto-orgtex-preview)

; make de previews bigger
(with-eval-after-load 'org ;ensures loads only after org is
   (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5)))

;instant latex previews
(use-package org-latex-impatient
  :defer t
  :after org-roam
  :init
  (setq org-latex-impatient-tex2svg-bin "~/node_modules/mathjax-node-cli/bin/tex2svg"))

;start it at will
(defun start-la-impat ()
  (local-set-key (kbd "H-p") 'org-latex-impatient-start))

(add-hook 'org-mode-hook 'start-la-impat)

;indenting for org
(setq org-startup-indented t)

;syntax highlighting
(setq org-src-fontify-natively t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

;todo functionality stuff
(setq org-log-done 'note)

;hide markup markers
(setq org-hide-emphasis-markers t)

;org-roam directory
(setq org-roam-directory (file-truename "~/org/org-roam"))
(add-hook 'org-mode-hook 'org-roam-db-autosync-mode)
(require 'org-roam-protocol)

;org-download
(use-package org-download
  :defer t
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))
;ohg proto-call
;(add-hook 'org-mode-hook (lambda () 'org-roam-protocol))

;--------------------------------
;elgot/python

;native compile enable
(setq python-shell-completion-native-enable nil)

;; Fix path
;(require 'exec-path-from-shell)
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
	(exec-path-from-shell-copy-env "DICPATH")
	(exec-path-from-shell-copy-env "SSH_AGENT_PID")
    (exec-path-from-shell-copy-env "SSH_AUTH_SOCK")))

; Open python files in tree-sitter mode.
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))
(add-to-list 'major-mode-remap-alist '(java-mode . java-ts-mode))
;(add-to-list 'major-mode-remap-alist '(haskell-mode . tree-sitter-hl-mode))


(add-hook 'python-ts-mode-hook
          (lambda ()
            (setq tab-width 4)
            (setq indent-tabs-mode nil)))
; make sure python 3 is used for these


;error by indenting
(setq python-indent-guess-indent-offset-verbose nil)


(use-package lsp-pyright
  :defer t
  :hook (python-ts-mode . (lambda () (require 'lsp-pyright)))
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3")))

(use-package eglot
  :ensure t
  :defer t
  :bind (:map eglot-mode-map
              ("C-c C-d" . eldoc)
              ("C-c C-e" . eglot-rename)
              ("C-c C-o" . python-sort-imports)
              ("C-c C-f" . eglot-format-buffer))
  :hook ((python-ts-mode . eglot-ensure)
         (python-ts-mode . flyspell-prog-mode)
         (python-ts-mode . superword-mode)
         (python-ts-mode . hs-minor-mode)
         (python-ts-mode . (lambda () (set-fill-column 88))))
  :config
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["flake8"]
                             :plugins (
                                       :pycodestyle (:enabled :json-false)
                                       :mccabe (:enabled :json-false)
                                       :pyflakes (:enabled :json-false)
                                       :flake8 (:enabled :json-false
                                                :maxLineLength 88)
                                       :ruff (:enabled t
                                              :lineLength 88)
                                       :pydocstyle (:enabled t
                                                    :convention "numpy")
                                       :yapf (:enabled :json-false)
                                       :autopep8 (:enabled :json-false)
                                       :black (:enabled t
                                               :line_length 88
                                               :cache_config t)))))))
;--------------------------------
;lsp-mode
(use-package lsp-mode
  :defer t
  :config
  (setq lsp-idle-delay 0.5
        lsp-enable-symbol-highlighting t
        lsp-enable-snippet nil  ;; Not supported by company capf, which is the recommended company backend
        lsp-pyls-plugins-flake8-enabled t)
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)

     ;; Disable these as they're duplicated by flake8
     ("pyls.plugins.pycodestyle.enabled" nil t)
     ("pyls.plugins.mccabe.enabled" nil t)
     ("pyls.plugins.pyflakes.enabled" nil t)))
  :hook
  ((python-ts-mode . lsp)
   (c++-ts-mode . lsp)
   (rust-ts-mode . lsp)
   (java-ts-mode . lsp)
   (haskell-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration)))
(use-package lsp-ui
  :defer t
  :config (setq lsp-ui-sideline-show-hover t
                lsp-ui-sideline-delay 0.5
                lsp-ui-doc-delay 5
                lsp-ui-sideline-ignore-duplicates t
                lsp-ui-doc-position 'bottom
                lsp-ui-doc-alignment 'frame
                lsp-ui-doc-header nil
                lsp-ui-doc-include-signature t
                lsp-ui-doc-use-childframe t))
;--------------------------------
;julia
(setq julia-repl-executable-records '((default "/Applications/Julia-1.9.app/Contents/Resources/julia/bin/julia")))

(use-package julia-mode
  :ensure t
  :defer t)

(add-to-list 'load-path "/Users/sebastiansanchez/.emacs.d/elpa/")
(add-hook 'julia-mode-hook 'julia-repl-mode) ;; always use minor mode

(use-package ssh-agency
  :ensure t
  :defer t)

(use-package julia-repl
  :defer t
  :ensure t
  :hook (julia-mode . julia-repl-mode)

  :init
  (setenv "JULIA_NUM_THREADS" "8")

  :config
  ;; Set the terminal backend
  (julia-repl-set-terminal-backend 'vterm)

  ;; Keybindings for quickly sending code to the REPL
  (define-key julia-repl-mode-map (kbd "<C-RET>") 'my/julia-repl-send-cell)
  (define-key julia-repl-mode-map (kbd "<M-RET>") 'julia-repl-send-line)
  (define-key julia-repl-mode-map (kbd "<S-return>") 'julia-repl-send-buffer))

(use-package lsp-julia
  :defer t
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.7"))
(add-hook 'julia-mode-hook #'lsp-mode)

(defun my/julia-repl-send-cell()
  "\"Send the current julia cell (delimited by ###) to the julia shell\"."
  (interactive)
  (save-excursion (setq cell-begin (if (re-search-backward "^###" nil t) (point) (point-min))))
  (save-excursion (setq cell-end (if (re-search-forward "^###" nil t) (point) (point-max))))
  (set-mark cell-begin)
  (goto-char cell-end)
  (julia-repl-send-region-or-line)
  (next-line))
;--------------------------------
;weB-dEv
(use-package web-mode
  :defer t
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;plain text html
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;apis and others
(add-to-list 'auto-mode-alist '("\\.api\\'" . web-mode))
(add-to-list 'auto-mode-alist '("/some/react/path/.*\\.js[x]?\\'" . web-mode))

(setq web-mode-content-types-alist
  '(("json" . "/some/path/.*\\.api\\'")
    ("xml"  . "/other/path/.*\\.api\\'")
    ("jsx"  . "/some/react/path/.*\\.js[x]?\\'")))
;--------------------------------
;rust
;;rustic
;;;keybinding for interactive run
(defun my-rustic-hook ()
  "Kbd w/ function keys, mouse button events, system events, or non-ASCII characters such as C-= or H-a can't be represented as strings; they have to be represented as vectors."
  (local-set-key (kbd "H-,") 'rustic-cargo-comint-run))

(add-hook 'rustic-mode-hook 'my-rustic-hook)

;--------------------------------

;vterm
(use-package vterm
  :ensure t
  :defer t)

;;magit
(use-package magit
  :defer t
  :after recentf-open-files
  :diminish magit-auto-revert-mode
  :diminish auto-revert-mode
  :bind (("C-c g" . #'magit-status))
  :custom
  (magit-diff-refine-hunk t)
  (magit-repository-directories '(("~/src" . 1)))
  (magit-list-refs-sortby "-creatordate")
  :config
  (defun pt/commit-hook () (set-fill-column 80))
  (add-hook 'git-commit-setup-hook #'pt/commit-hook)
  (add-to-list 'magit-no-confirm 'stage-all-changes))
(use-package magithub
  :after magit
  :ensure t
  :config (magithub-feature-autoinject t))

;neotree::
(use-package neotree
  :defer t
  :ensure t
  :bind (("H-i" . neotree-toggle)) ;; set a keybinding to toggle neotree
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)) ;; choose icons if you are in a GUI
  (setq neo-smart-open t)
  :config
  (add-hook 'neotree-mode-hook (lambda () (text-scale-decrease 1))))

(use-package undo-tree                    ; Enable undo-tree, sane undo/redo behavior
  :defer t
  :config (setq-default undo-tree-auto-save-history nil))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

(add-hook 'clojure-mode-hook 'cider-mode)

;Hooks are essentially lists of functions that get called when a specific event happens in Emacs

;;typeface, spacing
(set-face-attribute 'default nil :font "Menlo-13")
(set-face-attribute 'variable-pitch nil :font "SF Mono-12")

(let ((installed (package-installed-p 'all-the-icons)))
  (use-package all-the-icons
	:defer t
	)
  (unless installed (all-the-icons-install-fonts)))

;---------------custom commands----------------
;open windows/buffers the same everytime

(defun custom-split-window (direction size)
  "Split the window in a custom way.
DIRECTION should be 'horizontal or 'vertical.
SIZE is the number of lines or columns to shrink the window by."
  (delete-other-windows)
  (if (eq direction 'horizontal)
      (progn
        (split-window-horizontally)
        (other-window 1)
        (shrink-window-horizontally size))
    (progn ;progn is a special form that causes each of its arguments to be evaluated in sequence and then returns the value of the last one.
      (split-window-vertically)
      (other-window 1)
      (shrink-window size)))
  (other-window -1))

(defun custom-window-setup ()
  "Create a custom window setup."
  (custom-split-window 'horizontal 40))

(defun my-custom-split-window-horizontally ()
  "Custom function to split window horizontally."
  (interactive)
  (custom-split-window 'horizontal 40))

(defun my-custom-split-window-vertically ()
  "Custom function to split window vertically."
  (interactive)
  (custom-split-window 'vertical 10))

(defun my-custom-small-side-window ()
  "Create a small side window."
  (interactive)
  (custom-window-setup))

;idk sec
;(setenv "GIT_SSH_COMMAND" "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes")


(global-set-key (kbd "C-x 4") 'my-custom-small-side-window)
(global-set-key (kbd "C-x 2") 'my-custom-split-window-vertically)
(global-set-key (kbd "C-x 3") 'my-custom-split-window-horizontally)

;clean sidewindow function, then opens recents
(defun clean-side-window (&optional recursive)
   "\"RECURSIVE used to open recent files only after window setup\"."
  (interactive)
  (unless recursive
      (custom-window-setup)
      (other-window 1)
      (switch-to-buffer "*Messages*")
      (other-window -1)
      (clean-side-window t)))
(add-hook 'emacs-startup-hook 'clean-side-window)
(setq initial-frame-alist '((top . 0) (left . 0)))


;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
