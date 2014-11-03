;; -*- coding: utf-8 -*-
(setq emacs-load-start-time (current-time))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *macbook-pro-support-enabled* t)
(setq *is-a-mac* (eq system-type 'darwin))
(setq *is-carbon-emacs* (and *is-a-mac* (eq window-system 'mac)))
(setq *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))
(setq *win32* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *linux-x* (and window-system *linux*) )
(setq *xemacs* (featurep 'xemacs) )
(setq *emacs23* (and (not *xemacs*) (or (>= emacs-major-version 23))) )
(setq *emacs24* (and (not *xemacs*) (or (>= emacs-major-version 24))) )
(setq *no-memory* (cond
                   (*is-a-mac*
                    (< (string-to-number (nth 1 (split-string (shell-command-to-string "sysctl hw.physmem")))) 4000000000))
                   (*linux* nil)
                   (t nil)
                   ))

;----------------------------------------------------------------------------
; Functions (load all files in defuns-dir)
; Copied from https://github.com/magnars/.emacs.d/blob/master/init.el
;----------------------------------------------------------------------------
(setq defuns-dir (expand-file-name "~/.emacs.d/defuns"))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
      (load file)))
;----------------------------------------------------------------------------
; Load configs for specific features and modes
;----------------------------------------------------------------------------
(require 'init-modeline) ;; Compact modeline

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
(require 'cl-lib) ;; forward compatible library that provides newer emacs functions to older
(require 'init-compat) ;; map cl-lib functions to older. newer packages now compat with old
(require 'init-utils) ;; convenience functions
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el

;; win32 auto configuration, assuming that cygwin is installed at "c:/cygwin"
(condition-case nil
    (when *win32*
      (setq cygwin-mount-cygwin-bin-directory "c:/cygwin/bin")
      (require 'setup-cygwin)
      ;; better to set HOME env in GUI
      ;; (setenv "HOME" "c:/cygwin/home/someuser")
      )
  (error
   (message "setup-cygwin failed, continue anyway")
   ))

(require 'idle-require)

(require 'init-elpa) ;; install packages depending on emacs version, also logic to filter out certain packages.  TODO uncomment the filter to get the latest and greatest
(require 'init-exec-path) ;; Set up $PATH
(require 'init-frame-hooks) ;; provide utility function to run functions after frame created
;; any file use flyspell should be initialized after init-spelling.el
;; actually, I don't know which major-mode use flyspell.
(require 'init-spelling) ;; uses flyspell (engine aspell) on comments
(require 'init-xterm) ;; hooks to console enabling xterm arrow keys
(require 'init-osx-keys) ;; set meta key and M-` for frame switching
(require 'init-gui-frames) ;; supress dialog and startup, disable toolbar and scrollbar, opacity
;; (require 'init-ido) ;; allow recent file list M-<f11>, C-ci for imenu
(require 'init-maxframe) ;; functions and hook to maximize frame
(require 'init-proxies) ;; MAC only, uses external prog to get and set proxy variables
(require 'init-dired) ;; dired interactive git, also set default program for filetypes (images, videos, etc)
(require 'init-isearch) ;; search at cursor (TODO take), kill cursor to search
(require 'init-uniquify) ;; Nicer naming of buffers for files with identical names
(require 'init-ibuffer) ;; ibuffer list, grouped, and readibe size
(require 'init-flymake) ;; fix flymake when in ruby-mode
(require 'init-recentf) ;; fix performance of and enable recent file listing
;; (require 'init-smex) ;; enable IDO completion for M-x
(if *emacs24* (require 'init-helm)) ;; a lot of helm is disabled, TODO look into this!
(require 'init-hippie-expand) ;; trys to expand text at cursor.  added function to expand tags.  i like the c mode demo more TODO
(require 'init-windows) ;; useful split function, and WINNER mode TODO it's a nice function
(require 'init-sessions) ;; TODO session doesn't actually seem to be loading ;FIXME: 
(require 'init-fonts) ;; C-M-= and C-M-- increase and decrease font
;; (require 'init-git)

;;----------------------------------------------------------------------------
;; Auto load various file types and customize
;;----------------------------------------------------------------------------
(require 'init-crontab)
(require 'init-textile)
(require 'init-markdown)
(require 'init-csv)
(require 'init-erlang)
(require 'init-javascript)
(when *emacs24*
  (require 'init-org)
  (require 'init-org-mime))
(require 'init-css)
(require 'init-haml)
(require 'init-python-mode)
(require 'init-haskell)
(require 'init-ruby-mode)
(require 'init-elisp)
(if *emacs24* (require 'init-yasnippet))
;; Use bookmark instead
;; (require 'init-zencoding-mode) ;; web snippets
(require 'init-cc-mode) ;; TODO update to match multi line style that we follow
(require 'init-gud) ;; grand unified debugger
(require 'init-cmake-mode)
(require 'init-csharp-mode)
(require 'init-linum-mode) ;; inhibit line numbering in some modes
(require 'init-which-func) ;; todo doesn't seem to work
(require 'init-move-window-buffer) ;; allows you to move windows within frame
;; (require 'init-gist)
(require 'init-moz) ;; lazy load mozilla browser
(require 'init-gtags) ;; functions to create tags if needed TODO bind?
;; use evil mode (vi key binding)
(require 'init-evil) ;; map certain modes evil and leader key TODO try out
(require 'init-sh) ;; uses sh-mode for all shell related extensions
(require 'init-ctags) ;; standard, on mac changes ctags-command
(require 'init-ace-jump-mode) ;; bind to C-c SPC, SPC (in evil normal mode)
;; (require 'init-bbdb) ;; email contacts integration
;; (require 'init-gnus) ;; email and usenet reader
(require 'init-lua-mode) ;; set safe indent levels for parsing(?)
(require 'init-workgroups2) ;; manage windows, save sessions ;TODO: study
(require 'init-term-mode) ;; keybinds for terminal, setting default to bash
(require 'init-web-mode) ;; init flymake-html for web files ;TODO: study, interesting way to separate filetypes that already have modes into another subset and provide functionality
(require 'init-sr-speedbar) ;; C-c j s/r (toggle/refresh)
(require 'init-slime) ;; TODO dependency SBCL
(when *emacs24* (require 'init-company))
(require 'init-stripe-buffer) ;; alternate cell bg colors for dired and org mode
;; (require 'init-eim) ;;  cannot be idle-required, chinese input

;; color theme
(require 'color-theme)
(require 'color-theme-molokai)
(color-theme-molokai)
;; misc has some crucial tools I need immediately
(require 'init-misc) ;; settings, customizations, grep ignore folders, lots of clutter ;TODO: 

;;----------------------------------------------------------------------------
;; MY CUSTOM SETTINGS, KEYBINDINGS, ETC
;;----------------------------------------------------------------------------
(require 'init-my-misc)

(setq idle-require-idle-delay 3)
(setq idle-require-symbols '(init-lisp
                             init-keyfreq
                             init-elnode
                             init-doxygen
                             init-pomodoro
                             init-emacspeak
                             init-artbollocks-mode
                             init-emacs-w3m
                             init-semantic))
(idle-require-mode 1) ;; starts loading

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(if (file-exists-p "~/.custom.el") (load-file "~/.custom.el"))

(when (require 'time-date nil t)
   (message "Emacs startup time: %d seconds."
    (time-to-seconds (time-since emacs-load-start-time)))
   )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(company-auto-complete t)
 '(safe-local-variable-values (quote ((emacs-lisp-docstring-fill-column . 75) (ruby-compilation-executable . "ruby") (ruby-compilation-executable . "ruby1.8") (ruby-compilation-executable . "ruby1.9") (ruby-compilation-executable . "rbx") (ruby-compilation-executable . "jruby"))))
 '(session-use-package t nil (session)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold))) t))
;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)
