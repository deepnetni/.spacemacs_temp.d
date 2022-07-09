;; #################### clean minor modes ###################
;(defvar hidden-minor-modes ; example, write your own list of hidden
;  '(helm-mode            ; minor modes
;    yas-minor-mode
;    company-mode
;    spacemacs-whitespace-cleanup-mode
;    flyspell-mode
;    ))
;;
;(defun purge-minor-modes ()
;  (interactive)
;  (dolist (x hidden-minor-modes nil)
;    (let ((trg (cdr (assoc x minor-mode-alist))))
;      (when trg
;        (setcar trg "")))))
;;
;(add-hook 'after-change-major-mode-hook 'purge-minor-modes)
;(add-hook 'after-init-hook 'spacemacs/toggle-centered-point-on)

;; ##############################################################
;; #################### lsp ####################
;; ##############################################################
;; use flycheck-verify-setup command to choose code check backends

;(with-eval-after-load 'c-c++-mode (add-hook 'c++-mode-hook 'lsp))
;(with-eval-after-load 'lsp-mode
;  (add-hook 'c-mode-hook '(lsp-mode nil)))
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))

;(add-hook 'python-mode-hook (lambda ()
;                               (set (make-local-variable 'company-backends)
;                                    '(company-anaconda company-dabbrev company-ispell))))

;; ##############################################################
;; #################### self minor mode part ####################
;; ##############################################################
(setq deepnetni-emacs-env--goto-center-hook
      #'(evil-goto-mark
         ;evil-ex-search-next
         ;evil-ex-search-previous
         evil-jump-backward
         evil-jump-forward
         pop-tag-mark))

;; define minor mode
(define-minor-mode deepnetni-mode
  "A minor mode for deepnetni to override conflict keymaps."
  :init-value t
  :lighter "")

;; ignore warning about cl is deprecated
(setq byte-compile-warnings '(cl-functions))
(eval-after-load 'dired-quick-sort '(setq dired-quick-sort-suppress-setup-warning t))
(setq python-indent-guess-indent-offset t)
(setq python-indent-guess-indent-offset-verbose nil)
(setq tags-add-tables nil)

(advice-add #'undo-tree-load-history :around #'deepnetni-emacs-env/suppress-undo-tree-load-history)
(advice-add #'undo-tree-save-history :around #'deepnetni-emacs-env/suppress-undo-tree-save-history)

;; override keybinds defined after deepnetni packages
(defvar deepnetni-mode-map
  (let ((map (make-sparse-keymap)))
    ;(define-key map (kbd "") 'some-function)
    map)
  "deepnet ni minor mode keybindings")

(add-hook 'deepnetni-mode-hook
          (lambda ()
             (deepnetni-emacs-env//goto-line-center
              deepnetni-emacs-env--goto-center-hook)))

(add-hook 'deepnetni-mode-hook
          (lambda ()
             (global-undo-tree-mode 1)
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

(add-hook 'minibuffer-setup-hook (lambda () (deepnetni-mode nil)))

;(with-eval-after-load 'c-mode
;  (lsp-diagnostics-mode nil)
;  (lsp-modeline-diagnostics-mode nil))
