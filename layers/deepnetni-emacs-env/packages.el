;;; packages.el --- deepnetni-emacs-env layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author:  <niyel@DESKTOP-QKNA44S>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `deepnetni-emacs-env-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `deepnetni-emacs-env/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `deepnetni-emacs-env/pre-init-PACKAGE' and/or
;;   `deepnetni-emacs-env/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

;; Each package should be owned by one layer only.
;; The layer that owns the package should define its init function.
;; Other layers should rely on pre-init or post-init functions.
(defconst deepnetni-emacs-env-packages
  '(counsel-etags
    cc-mode
    counsel
    ;ggtags
    helm-ag
    hl-todo
    imenu-list
    javascript
    ;magit
    ;org-bullets
    ;org-projectile
    projectile
    python
    yard-mode)
  "The list of Lisp packages required by the deepnetni-emacs-env layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

;; In Spacemacs, layers are loaded in order of inclusion in the dotfile,
;; and packages are loaded in alphabetical order.


(defun deepnetni-emacs-env/init-counsel-etags ()
  (use-package counsel-etags
    :defer t
    :ensure t
    :bind (:map evil-motion-state-map ("C-]" . counsel-etags-find-tag-at-point))
    :init
    (add-hook 'prog-mode-hook
              (lambda ()
                (add-hook 'after-save-hook
                          'counsel-etags-virtual-update-tags 'append 'local)))
    ;; auto update tags file
    ;; Don't ask before rereading the TAGS files if they have changed
    (progn
      (setq tags-revert-without-query t)
      ;; Don't warn when TAGS files are large
      (setq large-file-warning-threshold nil)
      ;; Setup auto update now
      (add-hook 'prog-mode-hook
                (lambda ()
                  (add-hook 'after-save-hook
                            'counsel-etags-virtual-update-tags 'append 'local)))
      (global-set-key (kbd "C-c C-t") 'counsel-etags-list-tag)
      ; the following method will show c-mode-map as a variable is void error
      ; (define-key c-mode-map (kbd "C-c C-u") 'counsel-etags-update-tags-force)
      ; using eval-after-load or add-hook to bind key
      ; eval-after-load means run the second parameter while load cc-mode.el file
      (eval-after-load 'cc-mode
        '(define-key c-mode-map (kbd "C-c C-u") 'counsel-etags-update-tags-force))
      (advice-add 'counsel-etags-find-tag-at-point :after
                  (lambda () (evil-scroll-line-to-center (line-number-at-pos))))
      (advice-add 'counsel-etags-list-tag :after
                  (lambda () (evil-scroll-line-to-center (line-number-at-pos)))))
    :config
    (setq counsel-etags-update-interval 60)
    ;; counsel-etags-ignore-directories does NOT support wildcast
    (push "build" counsel-etags-ignore-directories)
    (push "build_clang" counsel-etags-ignore-directories)
    ;; counsel-etags-ignore-filenames supports wildcast
    (push "*.json" counsel-etags-ignore-filenames)
    (push "TAGS" counsel-etags-ignore-filenames)))

(defun deepnetni-emacs-env/pre-init-cc-mode ()
  (spacemacs|use-package-add-hook cc-mode
    :post-init
    (add-hook 'c-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))))

(defun deepnetni-emacs-env/pre-init-counsel ()
  (spacemacs|use-package-add-hook counsel
    :post-init
    (progn
      (add-hook 'c-mode-hook #'(lambda ()
                                 (define-key c-mode-map (kbd "C-c C-c") 'counsel-ag)))
      ;(global-set-key (kbd "C-c j") 'counsel-git-grep)
      ; use projectile to get file C-p
      ;(global-set-key (kbd "C-c f") 'counsel-git)
      )))

; (defun deepnetni-emacs-env/init-ggtags ()
;   (use-package ggtags
;     :defer t
;     :init
;     (add-hook 'c-mode-common-hook
;               (lambda ()
;                 (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;                   (ggtags-mode 1))))))

(defun deepnetni-emacs-env/init-helm-ag ()
  (use-package helm-ag
    :defer t
    :ensure t
    :init
    (progn
      ;(modify-coding-system-alist 'process "ag" '(utf-8 . chinese-gbk-dos))
      (custom-set-variables
       ; enable helm-follow-mode which will disable the helm-resume function
       ;'(helm-follow-mode-persistent t)
       '(helm-ag-insert-at-point 'symbol)
       '(helm-ag-base-command "ag --nocolor --nogroup -w")
       ;'(helm-ag-command-option "--all-text")
       '(helm-ag-insert-at-point 'symbol)
       ;'(helm-ag--ignore-case)
       '(helm-ag-ignore-buffer-patterns '("\\.txt\\'" "\\.mkd\\'")))
      (global-set-key (kbd "C-c a") 'helm-ag)
      (global-set-key (kbd "C-l") 'helm-ag-project-root)
      (global-set-key (kbd "C-j") 'helm-resume)
      (add-hook 'c-mode-hook 'helm-mode)
      )
    :config
    (advice-add 'helm-ag :after
                (lambda (&optional basedir query) (evil-scroll-line-to-center (line-number-at-pos))))
    ; &reset _ means don't care about the args
    (advice-add 'helm-ag-project-root :after
                (lambda (&rest _) (evil-scroll-line-to-center (line-number-at-pos))))))

(defun deepnetni-emacs-env/pre-init-hl-todo ()
  (spacemacs|use-package-add-hook hl-todo
    :post-config
    (define-key hl-todo-mode-map (kbd "C-c i") 'hl-todo-insert)
    (define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)))

(defun deepnetni-emacs-env/init-imenu-list ()
  (use-package imenu-list
    :defer t
    :init
    (global-set-key (kbd "C-'") #'imenu-list-smart-toggle)
    (setq imenu-list-focus-after-activation t)
    (setq imenu-list-auto-resize t)))

(defun deepnetni-emacs-env/pre-init-javascript ()
  (spacemacs|use-package-add-hook javascript
    :post-init
    (add-hook 'js2-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))))

(defun deepnetni-emacs-env/init-magit ()
  (use-package magit
    :defer t
    ))

(defun deepnetni-emacs-env/init-org-bullets ()
  (use-package org-bullets
    :ensure t
    :defer t
    :init
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))))

(defun deepnetni-emacs-env/pre-init-org-projectile ()
  (spacemacs|use-package-add-hook org-projectile
    :post-config
    (progn
      (org-projectile-per-project)
      (setq org-projectile-per-project-filepath "todos.org")
      (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
      (global-set-key (kbd "C-c c") 'org-capture)
      (global-set-key (kbd "C-c n p") 'org-projectile-project-todo-completing-read))))

;:bind-keymap ("C-c p" . projectile-command-map)
(defun deepnetni-emacs-env/pre-init-projectile ()
  (spacemacs|use-package-add-hook projectile
    :post-config
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (define-key evil-normal-state-map (kbd "C-p") 'counsel-projectile-find-file)))

(defun deepnetni-emacs-env/pre-init-python ()
  (spacemacs|use-package-add-hook python
    :post-init
    (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))))

(defun deepnetni-emacs-env/init-yard-mode ()
    (use-package yard-mode
      :defer t
      :init
      (progn
        (add-hook 'ruby-mode-hook 'yard-mode)
        (add-hook 'ruby-mode-hook 'eldoc-mode))))
