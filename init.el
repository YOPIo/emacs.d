(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; ---------------------------------------
;; el-get
;; ---------------------------------------
(el-get-bundle yasnippet)
(el-get-bundle company-mode/company-mode)
(el-get-bundle irony-mode)
(el-get-bundle flycheck)
(el-get-bundle flycheck-irony)
(el-get-bundle emoji-fontset)

;; ---------------------------------------
;; yasnippet
;; ---------------------------------------
(yas-global-mode 1)
;; insert snippet
(define-key yas-minor-mode-map (kbd "C-x y i") 'yas-insert-snippet)
;; create new snippet
(define-key yas-minor-mode-map (kbd "C-x y n") 'yas-new-snippet)
;; edit snippet
(define-key yas-minor-mode-map (kbd "C-x y v") 'yas-visit-snippet-file)

;; ---------------------------------------
;; company-mode
;; ---------------------------------------
(when (locate-library "company")
  (global-company-mode 1)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; (setq company-idle-delay nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-j") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t)
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
  )

;; ---------------------------------------
;; irony-mode
;; ---------------------------------------
(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++1y")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)))

;; ---------------------------------------
;; flycheck
;; ---------------------------------------
(when (require 'flycheck nil 'noerror)
  (custom-set-variables
   '(flycheck-display-errors-function
     (lambda (errors)
       (let ((messages (mapcar #'flycheck-error-message errors)))
         (popup-tip (mapconcat 'identity messages "\n")))))
   '(flycheck-display-errors-delay 0.5))
  (define-key flycheck-mode-map (kbd "C-M-n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-M-p") 'flycheck-previous-error)
  (add-hook 'c-mode-common-hook 'flycheck-mode)
  (add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++14"))))


;; ---------------------------------------
;; flycheck-irony
;; ---------------------------------------
(eval-after-load "flycheck"
  '(progn
     (when (locate-library "flycheck-irony")
       (flycheck-irony-setup))))

;; ---------------------------------------
;; other
;; ---------------------------------------
;; do not create buckup file
(setq make-backup-files 0)
(setq auto-save-default 0)
;; do not show startup memu
(setq inhibit-startup-message t)
;; delete toolbar
(tool-bar-mode -1)
;; sound off
(setq ring-bell-function 'ignore)
;; delete scroolbar
(set-scroll-bar-mode nil)
;; show in full path
(setq frame-title-format
      (format "%%f"(system-name)))
;; show line
(global-linum-mode t)
(set-face-attribute 'linum nil)
;; use space insted of tab
(setq-default indent-tabs-mode nil)
;; yes or no -> y or n
(fset 'yes-or-no-p 'y-or-n-p)
;; input \ instead ¥
(define-key global-map [?¥] [?\\])
;; alpha
(set-frame-parameter (selected-frame) 'alpha '(1.00))
;; C-h attach Backspace
(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\C-h" nil)
;; stop blinking cursor
(blink-cursor-mode 0)
;; show space at end of line
(setq-default show-trailing-whitespace t)
;; auto input ) ] }
(electric-pair-mode 1)

;; c++
;; .h -> c++-mode
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(setq default-tab-width 4)
;; theme
(load-theme 'tango-dark t)
(show-paren-mode 1)
(set-face-background 'show-paren-match-face "grey")
(set-face-foreground 'show-paren-match-face "black")
;; highlight
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
