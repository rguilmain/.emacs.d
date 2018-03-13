;; python grin support for emacs. Based on ack support script from:
;; http://stackoverflow.com/questions/2322389/ack-does-not-work-when-run-from-grep-find-in-emacs-on-windows

(defvar grin-command-line "grin -d CVS,RCS,.svn,.hg,.bzr,.git --emacs ")
(defvar grin-history nil)
(defvar grin-host-defaults-alist nil)

(defun grin ()
  "Like ack, but using grin as the default"
  (interactive)
  ; Make sure grep has been initialized
  (if (>= emacs-major-version 22)
      (require 'grep)
    (require 'compile))
  ; Close STDIN to keep grin from going into filter mode
  (let ((null-device (format "< %s" null-device))
        (grep-command grin-command-line)
        (grep-history grin-history)
        (grep-host-defaults-alist grin-host-defaults-alist))
    (call-interactively 'grep)
    (setq grin-history             grep-history
          grin-host-defaults-alist grep-host-defaults-alist)))

(provide 'grin)
