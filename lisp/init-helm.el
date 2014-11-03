(require 'helm-config)

;; (helm-mode 1)

;; (setq helm-completing-read-handlers-alist
;;       '((describe-function . helm-completing-read-symbols)
;;         (describe-variable . helm-completing-read-symbols)
;;         (debug-on-entry . helm-completing-read-symbols)
;;         (find-function . helm-completing-read-symbols)
;;         (find-tag . helm-completing-read-with-cands-in-buffer)
;;         (ffap-alternate-file . nil)
;;         (tmm-menubar . nil)
;;         (dired-do-copy . nil)
;;         (dired-do-rename . nil)
;;         (dired-create-directory . nil)
;;         (find-file . helm-completing-read-symbols)
;;         (copy-file-and-rename-buffer . nil)
;;         (rename-file-and-buffer . nil)
;;         (w3m-goto-url . nil)
;;         (ido-find-file . helm-completing-read-symbols)
;;         (ido-switch-buffer . helm-completing-read-symbols)
;;         (ido-edit-input . nil)
;;         (mml-attach-file . ido)
;;         (read-file-name . nil)
;;         (yas/compile-directory . ido)
;;         (execute-extended-command . helm-completing-read-symbols)
;;         (minibuffer-completion-help . nil)
;;         (minibuffer-complete . nil)
;;         (c-set-offset . nil)
;;         (wg-load . ido)
;;         (rgrep . nil)
;;         (read-directory-name . ido)
;;         ))


;; ;; {{helm-gtags
;; ;; customize
;; (autoload 'helm-gtags-mode "helm-gtags" nil t)
;; (setq helm-c-gtags-path-style 'relative)
;; (setq helm-c-gtags-ignore-case t)
;; (setq helm-c-gtags-read-only t)
;; (add-hook 'c-mode-hook (lambda () (helm-gtags-mode)))
;; (add-hook 'c++-mode-hook (lambda () (helm-gtags-mode)))
;; ;; }}



;; ;; key bindings
;; (add-hook 'helm-gtags-mode-hook
;;           '(lambda ()
;;               (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
;;               (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
;;               (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
;;               (local-set-key (kbd "C-t") 'helm-gtags-pop-stack)
;;               (local-set-key (kbd "C-c C-f") 'helm-gtags-pop-stack)))
;; ;; ==end

;; (if *emacs24*
;;     (progn
;;       (autoload 'helm-c-yas-complete "helm-c-yasnippet" nil t)
;;       (global-set-key (kbd "C-x C-o") 'helm-find-files)
;;       (global-set-key (kbd "C-c f") 'helm-for-files)
;;       (global-set-key (kbd "C-c y") 'helm-c-yas-complete)
;;       (global-set-key (kbd "C-c i") 'helm-imenu)
;;       )
;;   (global-set-key (kbd "C-x C-o") 'ffap)
;;   )

;; (autoload 'helm-swoop "helm-swoop" nil t)
;; (autoload 'helm-back-to-last-point "helm-swoop" nil t)

;; ;; When doing isearch, hand the word over to helm-swoop
;; (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)


;; (autoload 'helm-ls-git-ls "helm-ls-git" nil t)
;; (autoload 'helm-browse-project "helm-ls-git" nil t)

(require 'helm-config)
(require 'helm-grep)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq
 helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
 helm-quick-update t ; do not display invisible candidates
 helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.
 helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
 helm-candidate-number-limit 500 ; limit the number of displayed canidates
 helm-ff-file-name-history-use-recentf t
 helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
 helm-buffers-fuzzy-matching t          ; fuzzy matching buffer names when non-nil
                                        ; useful in helm-mini that lists buffers

 )

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)

(global-set-key (kbd "C-c h C-c w") 'helm-wikipedia-suggest)

(global-set-key (kbd "C-c h x") 'helm-register)
;; (global-set-key (kbd "C-x r j") 'jump-to-register)

(define-key 'help-command (kbd "C-f") 'helm-apropos)
(define-key 'help-command (kbd "r") 'helm-info-emacs)
(define-key 'help-command (kbd "C-l") 'helm-locate-library)

;; use helm to list eshell history
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;;; Save current position to mark ring
(add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

;; show minibuffer history with Helm
(define-key minibuffer-local-map (kbd "M-p") 'helm-minibuffer-history)
(define-key minibuffer-local-map (kbd "M-n") 'helm-minibuffer-history)

(define-key global-map [remap find-tag] 'helm-etags-select)

(define-key global-map [remap list-buffers] 'helm-buffers-list)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; PACKAGE: helm-swoop                ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Locate the helm-swoop folder to your path
;; (require 'helm-swoop)

;; ;; Change the keybinds to whatever you like :)
;; (global-set-key (kbd "C-c h o") 'helm-swoop)
;; (global-set-key (kbd "C-c s") 'helm-multi-swoop-all)

;; ;; When doing isearch, hand the word over to helm-swoop
;; (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

;; ;; From helm-swoop to helm-multi-swoop-all
;; (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

;; ;; Save buffer when helm-multi-swoop-edit complete
;; (setq helm-multi-swoop-edit-save t)

;; ;; If this value is t, split window inside the current window
;; (setq helm-swoop-split-with-multiple-windows t)

;; ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
;; (setq helm-swoop-split-direction 'split-window-vertically)

;; ;; If nil, you can slightly boost invoke speed in exchange for text color
;; (setq helm-swoop-speed-or-color t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; PACKAGE: helm-gtags                ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
(helm-mode 1)
(provide 'init-helm)
