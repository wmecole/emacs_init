;;; package --- emacs init file
;;; Commentary:
;;; 
;;; Contents are almost entirely inspired by other people to the point
;;; In some cases, I've lost track of who inspired what parts.
;;;

;;; Code:

;;(server-start)

;; Make it easy to edit this file
(defun find-config ()
  "Edit .emacs.d/init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c I") 'find-config)

;;Turn of cl deprecation warning during startup.
(setq byte-compile-warnings '(cl-functions))

;; Initialize Package
(require 'package)
(setq package-archives '(("org" . "https://orgmode.org/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize )

;; Install 'use-package' if it is not installed.
;; https://github.com/suvratapte/dot-emacs-dot-d/blob/master/init.el
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;; Set custom setting to load in own temp file
(setq custom-file (make-temp-file "emacs-custom"))

;; Example of setting env var named “path”, by appending a new path to existing path
(setenv "PATH"  (concat  (getenv "PATH")    ))

;; Backups directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Versioning Backups
(setq version-control t ;; Use version numbers for backups
       kept-new-versions 16 ;; Number of newest versions to keep
       kept-old-versions 2 ;; Number of oldest versions to keep
       delete-old-versions t ;; Ask to delete excess backup versions?
       backup-by-copying-when-linked t) ;; Copy linked files, don't rename.
 (defun force-backup-of-buffer ()
   (let ((buffer-backed-up nil))
     (backup-buffer)))
 (add-hook 'before-save-hook  'force-backup-of-buffer)
(require 'dired-x)
(setq dired-omit-mode t)

;; Autosave History
(setq delete-old-versions -1)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;;Window, frame, and buffer settings

;; language
(setq current-language-environment "English")


;;Simplified and no distractions
(scroll-bar-mode 0)    ; Turn off scrollbars.
(tool-bar-mode 0)      ; Turn off toolbars.
(fringe-mode 0)        ; Turn off left and right fringe cols.
(menu-bar-mode 0)      ; Turn off menus.
(blink-cursor-mode 0)  ; Don't blink the cursor
(setq inhibit-startup-screen 1) ;Don't show the startup screen
(display-time-mode 1)  ; Display time
(setq visible-bell t)  ; turn system beap off 

;; Start in full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; display column indicator
(global-display-fill-column-indicator-mode 1)

; Show the current line and column numbers in the stats bar as well
(line-number-mode 1)
(column-number-mode 1)

;; wrap at column #
(setq-default fill-column 70)
;;wrap at word
(setq-default word-wrap t)

;; text-mode soft wrap at fill-column in visual line mode
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(add-hook 'visual-line-mode-hook #'visual-fill-column-mode)

;; for other modes than text each line of text gets one line
;; on the screen (i.e., text will run off the left instead of
;; wrapping around onto a new line)
(setq-default truncate-lines 1)
;; truncate lines even in partial-width windows
(setq truncate-partial-width-windows 1)

;; always use spaces, not tabs, when indenting
(setq-default indent-tabs-mode nil)

;; sentences end with single space
(setq sentence-end-double-space nil)

;; End of buffer behavior.
;; require final newlines in files when they are saved
(setq require-final-newline 1)
;; add a new line when going to the next line at the end of the buffer.
(setq next-line-add-newlines t)

;; Make *scratch* buffer blank.
(setq initial-scratch-message nil)

;; change default yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; ignore case when searching
(setq-default case-fold-search 1)

;; Theme settings
;(load-theme 'solarized-light t)
(load-theme 'solarized-dark t)

;font
;(set-face-attribute 'default nil :family "Inconsolata" :height 120)

;;-----------------------------------------------------;;
;;Custom global keys, aliases, and other helpful mods  ;;
;;-----------------------------------------------------;;

;;Ensure Meta works, fixes Alt-Shift mappings errors
(setq x-alt-keysym 'meta)

;;Short cuts for bookmark and more
;;From https://tech.tonyballantyne.com/emacs/workout/c-x-r/
(global-set-key (kbd "C-`") ctl-x-r-map)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; From https://sites.google.com/site/steveyegge2/effective-emacs;;
;;Invoke M-x without Alt key 
;;(global-set-key "\C-x\C-m" 'execute-extended-command)
;;(global-set-key "\C-c\C-m" 'execute-extended-command)

;;using counsel instead
(global-set-key "\C-x\C-m" 'counsel-M-x)
(global-set-key "\C-c\C-m" 'counsel-M-x)

;;Delete Word and Region
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; toggle line truncation
(global-set-key (kbd "C-c w") 'toggle-truncate-lines); wrap

;;Keyboard macros
(global-set-key [f5] 'call-last-kbd-macro)

;; Aliases
(defalias 'ts 'transpose-sentences)
(defalias 'tp 'transpose-paragraphs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modes                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Tramp mode
(setq tramp-default-method "ssh")
(define-key global-map (kbd "C-c s") 'counsel-tramp)

;; Word Count mode
(require 'wc-mode)
;; Suggested setting
(global-set-key "\C-cw" 'wc-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Evil Mode              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable Evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :custom (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spell checking       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Flyspell Mode
;; Requires Hunspell
(setq ispell-program-name "hunspell")

(use-package flyspell
  :config
  (setq ispell-program-name "hunspell"
        ispell-default-dictionary "en_US")
  :hook (text-mode . flyspell-mode))

;;Enable  Flyspell in all modes
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

(eval-after-load "flyspell"
  '(define-key flyspell-mode-map (kbd "C-;") 'flyspell-correct-wrapper))

(use-package flyspell-correct-ivy
  :after flyspell-correct)

;; Fly spell mode customizations
;; Evil appeared to be writing over flyspell-mode-map
(global-set-key (kbd "C-c f") 'flyspell-buffer)
(global-set-key (kbd "C-;") 'flyspell-correct-wrapper)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Helpful discovery and completion tools;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Key discovery in minibuffer
(use-package which-key
  :config
  (which-key-mode))

;; Ivy for generic completion in Emacs
(use-package ivy :demand
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "))

;; Various completion functions using Ivy
(use-package counsel
  :config
  (ivy-configure 'counsel-M-x :initial-input ""))

;; Intelligent sorting and filtering lists in Ivy
(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode 1)) 

;; Ivy mode customizations
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File tools                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DocView replacement with pdf view, search, and annotation capabilities
(pdf-tools-install)

;;Deft-Mode for text file manipulation functions
;;https://lucidmanager.org/productivity/taking-notes-with-emacs-org-mode-and-org-roam/
(use-package deft
  :config
  (setq deft-directory org-directory
        deft-recursive t
        deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
        deft-use-filename-as-title t)
  :bind
  ("C-c n d" . deft))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Org and friends                       ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Org Mode
;; Initial setup
(use-package org
  :hook
  (add-hook 'org-mode-hook 'turn-on-flyspell)
  :bind
  (("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)))

(setq org-directory (file-truename  "~/org/"))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))

;; Org Custom Key Bindings
;; https://orgmode.org/org.html#Installation
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;;  org-journal
;;  https://github.com/bastibe/org-journal
(use-package org-journal
  :ensure t
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir (file-truename "~/org/journal/")
        org-journal-date-format "%A, %d %B %Y"))

;; org-roam basic configuration
;; https://lucidmanager.org/productivity/taking-notes-with-emacs-org-mode-and-org-roam/
(use-package org-roam
    :after org
    :init (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
    :custom
    (org-roam-directory (file-truename "~/org/roam/"))
    :config
    (org-roam-setup)
    :bind (("C-c n f" . org-roam-node-find)
           ("C-c n r" . org-roam-node-random)		    
           (:map org-mode-map
                 (("C-c n i" . org-roam-node-insert)
                  ("C-c n o" . org-id-get-create)
                  ("C-c n t" . org-roam-tag-add)
                  ("C-c n a" . org-roam-alias-add)
                  ("C-c n l" . org-roam-buffer-toggle)))))

;;org-roam note templates
(setq org-roam-capture-templates '(("d" "default" plain "%?"
                                      :if-new
                                      (file+head "${slug}.org"
                                                 "#+title: ${title}\n#+date: %u\n#+lastmod: \n\n")
                                      :immediate-finish t))
        time-stamp-start "#\\+lastmod: [\t]*")

;; Org Babel, no config needed, part of core org-mode
;; languages for org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (gnuplot . t)
   (octave . t)
   (python . t)
   (screen . nil)
   (sql . t)
   (sqlite . t)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;programming related modes                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Company mode for completions
;; https://medium.com/helpshift-engineering/configuring-emacs-from-scratch-use-package-c30382297877
(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

;; Helpful for Auto-capping SQL
;; turn on abbrev mode globally
(setq-default abbrev-mode t)
;; stop asking whether to save newly added abbrev when quitting emacs
(setq save-abbrevs nil)

;; electric pair mode to balance parens 
(electric-pair-mode 1)

;;Rainbow delimiters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Highlight parentheses when the cursor is next to them
(show-paren-mode 1)

;; ToolTip Mode
;; custom colors
(custom-set-faces
 '(company-preview
   ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common
   ((t (:inherit company-preview))))
 '(company-tooltip
   ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-selection
   ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common
   ((((type x)) (:inherit company-tooltip :weight bold))
    (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection
   ((((type x)) (:inherit company-tooltip-selection :weight bold))
    (t (:inherit company-tooltip-selection)))))

;; Octave mode
(autoload 'octave-mode "octave-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(setq octave-help-files '("octave" "octave-LG"))

;; Geiser mode
(use-package geiser-mit :ensure t)

;;Racket mode
(setq geiser-racket-binary "/home/eric/opt/bin/racket")

;; SBCL, QuickLisp
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;; SLIME
;; Set your lisp system and, optionally, some contribs
(use-package slime
  :demand
  :config
  (slime-setup '(slime-fancy)))





;; ;---------------------------------------------------------------------
;; No  default.el after .emacs loads
;; (setq inhibit-default-init' t)

;; Resetting gc to default value
;; (setq gc-cons-threshold (* 1 1024 1024))

;; ;---------------------------------------------------------------------
;; Put auto 'custom' changes in a separate file (this is stuff like
;; custom-set-faces and custom-set-variables)

;;Path to custom.el
;; ;(setq custom-file "~/.emacs.d/custom.el")

;; ;(load custom-file)


; (eshell)

;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here;;;
;;;;;;;;;;;;;;;;;;;;;;;;
