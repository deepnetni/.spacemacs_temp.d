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
    ;; ggtags
    imenu-list
    javascript
    magit
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
                            'counsel-etags-virtual-update-tags 'append 'local))))
    :config
    (setq counsel-etags-update-interval 60)
    ;(modify-syntax-entry ?_ "w")
    (push "build" counsel-etags-ignore-directories)))

(defun deepnetni-emacs-env/pre-init-cc-mode ()
  (spacemacs|use-package-add-hook cc-mode
    :post-init
    (add-hook 'c-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))))

; (defun deepnetni-emacs-env/init-ggtags ()
;   (use-package ggtags
;     :defer t
;     :init
;     (add-hook 'c-mode-common-hook
;               (lambda ()
;                 (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;                   (ggtags-mode 1))))))

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

; :bind-keymap ("C-c p" . projectile-command-map)
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
