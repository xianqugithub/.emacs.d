;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

(let ((minver "25.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "26.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;; Adjust garbage collection thresholds during startup, and thereafter

(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;; Bootstrap config

(setq custom-file (locate-user-emacs-file "custom.el"))
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;; display
(require 'init-display)

;; personal key bindings
(require 'init-keys)

;; window configurationd
(require 'init-window)

;; expand region
(require 'init-expand-region)

;; multiple curosrs
(require 'init-multiplecursor)

;; helm
(require 'init-helm)

;; git
(require 'init-git)

;; projectile
(require 'init-projectile)

(require 'init-file)

;; backup file setup
(require 'init-backup)

;; dired
(require 'init-dired)

;; yasnippet
(require 'init-yasnippet)

;; company mode
(require 'init-company)

;; point-undo
(require 'point-undo)

;; org setup
(require 'org-setup)

;; markdown setup
(require 'markdown-setup)

;; languages
(require 'init-javascript)
(require 'init-python)

;; amazon
(require 'init-amazon)
