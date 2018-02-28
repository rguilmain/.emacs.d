(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

(add-hook 'term-setup-hook
               #'(lambda () (w32-send-sys-command ?\xF030)))

(global-auto-revert-mode 1) ;; revert unmodified buffers that changed on disk

(fringe-mode '(0 . 0))  ; == no fringes

;; no backups:
(setq-default backup-inhibited t)
;;;
;;; auto inserted stuff (This goes at the very bottom of your init.el file.)
;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 2)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (magit grin exec-path-from-shell ag)))
 '(tab-width 4))

(global-set-key (kbd "M-0") 'delete-window) ; was digit-argument
(global-set-key (kbd "M-1") 'delete-other-windows) ; was digit-argument
(global-set-key (kbd "M-2") 'split-window-vertically) ; was digit-argument
(global-set-key (kbd "M-3") 'split-window-horizontally) ; was digit-argument

(defvar my-keys-minor-mode-map (make-keymap))
(define-key my-keys-minor-mode-map (kbd "C-<tab>") 'next-multiframe-window)
(define-key my-keys-minor-mode-map (kbd "C-S-<tab>")
'previous-multiframe-window)
(define-minor-mode my-keys-minor-mode t 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))
(server-start)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;; windows ini files:
(add-to-list 'auto-mode-alist '("\\.ini$" . conf-windows-mode))

(require 'grin)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x m") 'magit-status)

;; colors
(require 'color-theme)
(color-theme-initialize)
(color-theme-solarized-light)

;; fonts
(defun my-font () (interactive)
(set-default-font "DejaVu Sans Mono-13"))
(my-font)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq case-fold-search t)
(setq current-language-environment "Latin-1")
(setq current-input-method "latin-1-prefix")

(blink-cursor-mode 0)  ; Turn off blinking cursors
(column-number-mode 1)  ; Add column numbering to the status bar
(setq scroll-step 1)  ; Single line scrolling
(setq transient-mark-mode t)
(setq truncate-partial-width-windows nil)  ; default to line wrapping
(setq visible-bell t)  ; Use a visible instead of a beep when there's an error

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; etags stuff
(require 'etags-select)
(global-set-key (kbd "M-.") 'etags-select-find-tag)
(global-set-key (kbd "M-?") 'etags-select-find-tag-at-point)
(setq tags-add-tables nil)

(global-set-key (kbd "<f7>") '(lambda () (interactive)
                                (compile compile-command)))

(defalias 'qr 'query-replace)
(defalias 'qrr 'query-replace-regexp)

; map 'ff-find-other-file to C-c o for easy access
(add-hook 'c-mode-common-hook  (lambda()    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

; Use the google-c-style mode
(require 'google-c-style)(add-hook 'c-mode-common-hook 'google-set-c-style)

(setq python-indent 4)

(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))
(require 'protobuf-mode)
(defconst my-protobuf-style
 '((c-basic-offset . 2)
   (indent-tabs-mode . nil)))
(add-hook 'protobuf-mode-hook
         (lambda () (c-add-style "my-style" my-protobuf-style t)))

;; Hide splash-screen and startup-message
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(add-hook 'write-file-hooks 'delete-trailing-whitespace)
(delete-trailing-whitespace)

(defun add-python-template ()
  (interactive)
  (insert "#! /usr/bin/env python3\n")
  (newline)
  (insert "\"\"\"TODO(Rich): Add documentation.\n")
  (insert "\"\"\"\n")
  (newline)
  (insert "import argparse\n")
  (insert "import sys\n")
  (newline)
  (newline)
  (insert "def main(argv=None):\n")
  (insert "    if argv is not None:\n")
  (insert "        sys.argv = argv\n")
  (newline)
  (insert "    parser = argparse.ArgumentParser(description=__doc__)\n")
  (insert "    parser.add_argument('-todo', '--todo', help='todo')\n")
  (insert "    args = parser.parse_args()\n")
  (newline)
  (newline)
  (newline)
  (insert "if __name__ == '__main__':\n")
  (insert "    sys.exit(main())\n")
  (setq python-indent 4))
(global-set-key (kbd "C-c p") 'add-python-template)


;; Shell and buffer-named shell.
(global-set-key (kbd "C-c s") 'shell)
(global-set-key (kbd "C-c S") 'buffer-named-shell)

(defun buffer-named-shell ()
 "Create a shell with the name of the current buffer."
 (interactive)
 (if (not (eq major-mode 'shell-mode))
     (shell (concat "*shell-" (buffer-name) "*"))
   (message "Skipping shell creation (you're already in a shell).")))

(defun ushell (shell-buffer-name)
  "Unique Shell: Create a shell with a user specified buffer name prefix."
  (interactive "*sBuffer Name: ")
  (shell (concat "*shell-" shell-buffer-name "*")))

;; Custom mode line:
;; From https://github.com/martine/config/blob/master/emacs.d/init.el
(setq-default
mode-line-format
'(
  ;; line/col
  "%4l:%2c  "
  ;; dir + file name
  (:propertize (:eval (shorten-directory default-directory 30))
               face mode-line-directory-face)
  (:propertize "%b"
               face mode-line-filename-face)
  ;; mod state
  (:eval (when (buffer-modified-p) "*"))
  "  "
  (vc-mode vc-mode)
  "  "
  ;; major mode
  "[%m]"))

(setq default-directory "~/dev" )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq ring-bell-function 'ignore)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; This is necessary on Mac, and makes sure that Emacs uses the same path as
;; your shell. In order for this to work, though, you also need to install the
;; exec-path-from-shell package via Melpa.
(when (memq window-system '(mac ns))
 (exec-path-from-shell-initialize))
