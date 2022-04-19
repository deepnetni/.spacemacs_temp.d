;; setq is only works for local variables,
;; while seq-default works for global variables.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default dotspacemacs-scratch-mode 'emacs-lisp-mode)
;; delete ^ in M-x
(setq ivy-initial-inputs-alist nil)

(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

(setq make-backup-files nil)
(setq indent-tabs-mode nil)
(setq c-default-style "k&r")
(setq auto-completion-enable-snippets-in-popup t)
(setq layouts-enable-autosave t)

(setq tags-table-list nil)
(setq debug-on-error nil)

;; #################### clean minor modes ###################
;(defvar hidden-minor-modes ; example, write your own list of hidden
;  '(lsp-mode            ; minor modes
;    helm-mode
;    projectile-mode))
;
;(defun purge-minor-modes ()
;  (interactive)
;  (dolist (x hidden-minor-modes nil)
;    (let ((trg (cdr (assoc x minor-mode-alist))))
;      (when trg
;        (setcar trg "")))))
;
;(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

;; #################### lsp ###################
;(with-eval-after-load 'c-c++-mode (add-hook 'c++-mode-hook 'lsp))
(with-eval-after-load 'lsp-mode
  (add-hook 'c-mode-hook '(lsp-mode nil)))
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  ;(require 'dap-cpptools)
  (yas-global-mode))

;; #################### company backends part ###################
(setq compandy-minimum-prefix-length 2)
(setq company-tooltip-align-annotations t)
(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))
(eval-after-load "company"
  '(add-to-list 'company-backends '(company-anaconda :with company-capf)))

;; items in the completion list are sorted by frequency of use
(setq company-transformers '(company-sort-by-occurrence))
(setq company-selection-wrap-around t)

;(add-hook 'python-mode-hook 'anaconda-mode)

;; enable emacs dameon to speed boot up
;(setq-default dotspacemacs-enable-server t)

;; #################### self minor mode part ####################
(setq deepnetni-emacs-env--goto-center-hook
      #'(evil-ex-search-next
         evil-ex-search-previous
         evil-goto-mark
         evil-jump-backward
         evil-jump-forward
         pop-tag-mark))


;; define minor mode
(define-minor-mode deepnetni-mode
  "A minor mode for deepnetni to override conflict keymaps."
  :init-value t
  :lighter "")

;; override keybinds defined after deepnetni packages
(defvar deepnetni-mode-map
  (let ((map (make-sparse-keymap)))
    ;(define-key map (kbd "") 'some-function)
    map)
  "deepnet ni minor mode keybindings")

(deepnetni-mode t)

(add-hook 'deepnetni-mode-hook '(lambda ()
                                        (deepnetni-emacs-env//goto-line-center
                                         deepnetni-emacs-env--goto-center-hook)))

(add-hook 'deepnetni-mode-hook
          '(lambda ()
             (global-undo-tree-mode 0)
             (setenv "LANG" "zh_CN.UTF-8")
             (when (eq system-type 'windows-nt)
               (setq-default process-coding-system-alist
                             '(("[pP][lL][iI][nN][kK]" utf-8-dos . gbk-dos)
                               ("[cC][mM][dD][pP][rR][oO][xX][yY]" utf-8-dos . gbk-dos)
                               ("cmd" gbk-dos . gbk-dos)
                               ("diff" utf-8-dos . gbk-dos)
                               ("*" utf-8-dos . gbk-dos))))
             (set-charset-priority 'unicode)
             ;(prefer-coding-system 'utf-8)
             ;(modify-coding-system-alist 'process "*" 'utf-8-unix)
             (setq-default buffer-file-coding-system 'utf-8-unix)
             (set-buffer-file-coding-system 'utf-8-unix)
             (set-file-name-coding-system 'utf-8-unix)
             (set-default-coding-systems 'utf-8-unix)
             (set-keyboard-coding-system 'utf-8-unix)
             (set-terminal-coding-system 'utf-8-unix)
             ;(set-language-environment 'Chinese-GBK)
             (set-language-environment "UTF-8")
             (setq locale-coding-system 'utf-8-unix)
             (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
             (setq default-buffer-file-coding-system 'utf-8)))

(add-hook 'minibuffer-setup-hook #'(lambda ()
                                     (deepnetni-mode nil)))

;(with-eval-after-load 'c-mode
;  (lsp-diagnostics-mode nil)
;  (lsp-modeline-diagnostics-mode nil))

;; ignore warning about cl is deprecated
(setq byte-compile-warnings '(cl-functions))
(eval-after-load 'dired-quick-sort '(setq dired-quick-sort-suppress-setup-warning t))
(setq python-indent-guess-indent-offset t)
(setq python-indent-guess-indent-offset-verbose nil)
