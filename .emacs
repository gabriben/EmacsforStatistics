;;; package --- Summary

;;; Commentary:

; Each section in this file is introduced by a
; line beginning with four semicolons; and each
; entry is introduced by a line beginning with
; three semicolons.


;;; Code:

;;;; install and load packages

;; allow access to the whole melpa library through install.package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; do M-x package-refresh-contents, if melpa doesn't find stuff
(package-initialize)

;; (add-to-list 'load-path "~/.emacs.d/packages/")
;; (let ((default-directory  "~/.emacs.d/packages/"))
;;   (normal-top-level-add-subdirs-to-load-path))​

(add-to-list 'load-path "~/.emacs.d/")



;;;; Allow programming in R

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

;;;; spellchecking and syntax highlighting

;; check for spelling mistakes, requires the installation of aspell
;; (aspell is generally, built in most machines)
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; Detect too long lines (not working)
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)
(custom-set-faces
 '(whitespace-line ((t (:foreground "firebrick4" :background "gray10"))))
 )

;; Flycheck: On the fly syntax checking
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
; stronger error display
(defface flycheck-error
  '((t (:foreground "red" :underline (:color "Red1" :style wave) :weight bold)))
  "Flycheck face for errors"
  :group "flycheck")

; syntax highlighting everywhere
(global-font-lock-mode 1)

;; autocomplete but not on buffer
(require 'auto-complete)
(global-auto-complete-mode t)
(defun auto-complete-mode-maybe ()
  "No maybe for you. Only AC!"
  (unless (minibufferp (current-buffer))
    (auto-complete-mode 1)))

;; get synonyms (not working)
;(require 'synosaurus)
;(synosaurus-mode)

;;;; visual aspects

;; font theme (change theme with M-x load-theme)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'leuven)

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; disable the scroll bar
(scroll-bar-mode 0)

;; move from window to window with meta + super + arrow keys
(global-set-key (kbd "<M-s-left>")  'windmove-left)
(global-set-key (kbd "<M-s-right>") 'windmove-right)
(global-set-key (kbd "<M-s-up>")    'windmove-up)
(global-set-key (kbd "<M-s-down>")  'windmove-down)

;; switch cursor to new window
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; create new windows vertically by default
(split-window-right)

; Add proper word wrapping
(global-visual-line-mode t)

;; line wrapping at window with indicators
(global-visual-line-mode t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

;; simple modeline
(setq-default mode-line-format
              '(list mode-line-modified
                     mode-line-buffer-identification)
              )

;; change the cursor to a line and stop blinking
(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

;; remember the cursor position of files when reopening them
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;; Show column number on the bottom status bar. (doesnt work)
(require 'fill-column-indicator)

;; smooth scrolling
;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3)))
;; one line at a time (faster when holding shift)
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; replace highlighted text with what I type
(delete-selection-mode 1)

;; highlight matched parentheses
(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;; hide warnings
(setq warning-minimum-level :emergency)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; M-arrows to select to begin / end of line
(global-set-key (kbd "M-<left>") 'move-beginning-of-line)
(global-set-key (kbd "M-<right>") 'move-end-of-line)


;; display useful information in the frame title
(setq-default frame-title-format '("%f"))

;; blink instead of beeping
(setq visible-bell t)

;;;; Indentation and spacing

;; auto-indent all my code
(global-set-key (kbd "<?\\t>") 'indent-code-rigidly)

;; stop indenting comments weirdly in lisp
(defun foo () (setq comment-indent-function (lambda () 0)))
(add-hook 'emacs-lisp-mode-hook 'foo 'APPEND)

;; Tabs yields 2 spaces, use tab key to tab
; force it everywhere
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default js2-basic-offset 2)
(setq ess-default-style 'DEFAULT)
(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 2
                  sh-indentation 2)))
(setq ess-indent-level 2)

;; automatic tabs
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'css-mode-hook #'aggressive-indent-mode)
(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode 'buffer-mode)

;; automatic spacing in R
(add-hook 'ess-mode-hook #'electric-operator-mode)


;;;; RStudio style

;; object navigator for R ("v" for values, "p" for plot and "d" to delete)
(autoload 'ess-rdired "ess-rdired"
  "View *R* objects in a dired-like buffer." t)
(global-set-key (kbd "C-0") 'ess-rdired)


;;;; auto-completion

;; completion help for everything in the command line
(ido-mode 1)
(ido-everywhere 1)
(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)

;;;; org-mode

;; install org-mode
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
(package-install 'org-plus-contrib)

;; allow shift select in org mode
(setq shift-select-mode t)
(setq org-support-shift-select t)

;; get the right scientific notation for org to latex
(setq org-latex-table-scientific-notation nil)


;; colour coding R output
(require 'ox-latex)
;; requires sudo apt-get install python-pygments
(setq org-latex-prefer-user-labels t)
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      ;; modify margins in TeX generated from org-mode (not working)
;org-latex-packages-alist '(("margin=2cm" "geometry" nil))
      org-latex-minted-options
      '(("bgcolor" "lightgray")
        ("fontsize" "\\scriptsize"))
      ;; org-latex-packages-alist '(("" "color"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(add-to-list 'org-latex-minted-langs '(R "r"))
; tricking emacs to allow colour coding of a script appendix with noweb
(add-to-list 'org-latex-minted-langs '(text "r"))

;; Compile org file to latex, then to pdf and open the pdf
(setq org-confirm-babel-evaluate nil)
(setq ess-ask-for-ess-directory nil)
(fset 'org-latex-pdf
      [?\C-c ?\C-e ?l ?o ?y ?e ?s])
(global-set-key (kbd "M-n") 'org-latex-pdf)

;; display all pages of pdf preview by scrolling
(setq doc-view-continuous t)

;; pdfview is supposed to be better than the base pdf viewer (can't make it work
;; though)
;; (eval-after-load 'org '(require 'org-pdfview))

;; (add-to-list 'org-file-apps
;;              '("\\.pdf\\'" . (lambda (file link)
;;                                      (org-pdfview-open link))))

;;;; saving

;; backups
(setq backup-directory-alist `(("." . "~/.saves"))) ; setup backup folder
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; save session for reopen
;(require 'desktop)
(desktop-save-mode 1)

;; save minibuffer history
(savehist-mode 1)

; save the current macro as reusable function.
(defun save-current-kbd-macro-to-dot-emacs (name)
  "Save the current macro as named function definition inside
your initialization file so you can reuse it anytime in the
future."
  (interactive "SSave Macro as: ")
  (name-last-kbd-macro name)
  (save-excursion
    (find-file-literally user-init-file)
    (goto-char (point-max))
    (insert "\n\n;; Saved macro\n")
    (insert-kbd-macro name)
    (insert "\n")))


;;;; Miscellanous

;; show unused key bindings
(require 'free-keys)

;; find and replace dynamically with C-;
(require 'iedit)

(use-package csv-mode)
;;   :mode ("\\.csv$" . csv-mode))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(bind-keys ("M-<up>" . move-line-up)
           ("M-<down>" . move-line-down))

;;;; delete?

(add-hook 'rmail-show-message-hook 'icalendar-import-buffer)

;; fontify code in code blocks
;(setq org-src-fontify-natively t)

(comint-redirect-send-command "s()\n"  (get-buffer-create "*svg output*") nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (iedit use-package treemacs spacemacs-theme rudel py-smart-operator
           pdf-tools org-plus-contrib on-screen julia-mode ido-completing-read+
           hemisu-theme flycheck fill-column-indicator electric-operator
           company-statistics company-math auto-complete async synosaurus))))
