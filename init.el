;; ---------------------------------------
;; Buildin settings
;; ---------------------------------------
;; Do not create buckup file
(setq auto-save-default nil)
(setq make-backup-files nil)
;; Do not show startup memu
(setq inhibit-startup-message t)
;; Delete toolbar
(tool-bar-mode -1)
;; Sound off
(setq ring-bell-function 'ignore)
;; Delete scroolbar
(set-scroll-bar-mode nil)
;; Show in full path
(setq frame-title-format
      (format "%%f"(system-name)))
;; Show line
(global-linum-mode t)
(set-face-attribute 'linum nil)
;; Use space insted of tab
(setq-default indent-tabs-mode nil)
;; Yes or no -> y or n
(fset 'yes-or-no-p 'y-or-n-p)
;; Input '\' instead '¥' for windows
(define-key global-map [?¥] [?\\])
;; Display alpha
(set-frame-parameter (selected-frame) 'alpha '(1.00))
;; C-h attach Backspace
(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\C-h" nil)
;; Stop blinking cursor
(blink-cursor-mode 0)
;; Show space at end of line
(setq-default show-trailing-whitespace t)
;; Auto input ')', ']', '}'
(electric-pair-mode 1)
;; theme
(load-theme 'tango-dark t)
(show-paren-mode 1)
(set-face-background 'show-paren-match-face "grey")
(set-face-foreground 'show-paren-match-face "black")
;; .h -> c++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Input methods, use mozc
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

;; highlight line
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "#787878"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode t)

;; Highlight lines if number of character over 80 in c, c++, python
(add-hook 'c-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
      '(("^[^\n]\\{100\\}\\(.*\\)$" 1 font-lock-warning-face t)))))
(add-hook 'c++-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
      '(("^[^\n]\\{100\\}\\(.*\\)$" 1 font-lock-warning-face t)))))
(add-hook 'python-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
      '(("^[^\n]\\{100\\}\\(.*\\)$" 1 font-lock-warning-face t)))))

(load-file "~/.emacs.d/google-c-style.el")
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c++-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;---------------------------------------
;; Settings for el-get
;;---------------------------------------
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; Install packages
(el-get-bundle irony-mode)
(el-get-bundle company-mode/company-mode)
(el-get-bundle company-irony)
(el-get-bundle flycheck)
(el-get-bundle flycheck-irony)
(el-get-bundle company-quickhelp)
(el-get-bundle yasnippets)
(el-get-bundle cmake-mode)
(el-get-bundle pos-tip)
(el-get-bundle col-highlight)

;;---------------------------------------
;; Settings for irony-mode
;;---------------------------------------
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++11")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)))

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
;(defun my-irony-mode-hook ()
;  (define-key irony-mode-map [remap completion-at-point]
;    'irony-completion-at-point-async)
;  (define-key irony-mode-map [remap complete-symbol]
;    'irony-completion-at-point-async))
;(add-hook 'irony-mode-hook 'my-irony-mode-hook)
;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;;---------------------------------------
;; Settings for company-mode
;;---------------------------------------
(when (locate-library "company")
  (global-company-mode 1)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; Complete soon
  (setq company-idle-delay 0)
  ;; Move to next or previous
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
  ;; Search
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates)
  ;; Complete
  (define-key company-active-map (kbd "C-j")   'company-complete-selection))

;; Options
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)

;; Color setting
(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "orange")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")

;;---------------------------------------
;; Settings for company-irony
;;---------------------------------------
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;;---------------------------------------
;; Settings for flycheck
;;---------------------------------------
(add-hook 'after-init-hook #'global-flycheck-mode)
;; additional path for flycheck
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-include-path
                           (list (expand-file-name "/usr/include/eigen3")))))

;;---------------------------------------
;; Settings for flycheck-irony
;;---------------------------------------
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;;---------------------------------------
;; Settings for company-quickhelp
;;---------------------------------------
(company-quickhelp-mode 1)
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))


;;---------------------------------------
;; Settings for yasnippets
;;---------------------------------------
(yas-global-mode 1)
;; Insert snippet
(define-key yas-minor-mode-map (kbd "C-x y i") 'yas-insert-snippet)
;; Create new snippet
(define-key yas-minor-mode-map (kbd "C-x y n") 'yas-new-snippet)
;; Edit snippet
(define-key yas-minor-mode-map (kbd "C-x y e") 'yas-visit-snippet-file)

;; End of file
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(irony-additional-clang-options (quote ("-std=c++11")))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Mono" :foundry "GOOG" :slant normal :weight normal :height 143 :width normal)))))


;;---------------------------------------
;; Settings for column-maker
;;---------------------------------------
;;; col-highlight.el
(require 'col-highlight)
(column-highlight-mode 1)
;; Color setting
(custom-set-faces
 '(col-highlight((t (:background "dark slate gray")))))
