;;; keybindings.el --- Vinegar Layer keybindings File for Spacemacs
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
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

;;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; =================== evil =====================
(define-key evil-normal-state-map (kbd "C-i") 'evil-jump-forward)
;(define-key evil-normal-state-map (kbd "W") 'evil-forward-word-begin)
;(define-key evil-normal-state-map (kbd "B") 'evil-backward-word-begin)
;(define-key evil-normal-state-map (kbd "E") 'evil-forward-word-end)

;;(define-key evil-normal-state-map (kbd "w") 'evil-forward-WORD-begin)
;;(define-key evil-normal-state-map (kbd "e") 'evil-forward-WORD-end)
;;(define-key evil-normal-state-map (kbd "b") 'evil-backward-WORD-begin)

(define-key evil-insert-state-map (kbd "C-h") 'evil-backward-char)
(define-key evil-insert-state-map (kbd "C-l") 'evil-forward-char)
(define-key evil-insert-state-map (kbd "C-j") 'evil-next-line)
(define-key evil-insert-state-map (kbd "C-k") 'evil-previous-line)
(define-key evil-insert-state-map (kbd "TAB") 'yas-expand)
(define-key evil-insert-state-map (kbd "M-i") 'tab-to-tab-stop)

(define-key evil-normal-state-map (kbd "M-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "M-l") 'evil-window-right)
(define-key evil-normal-state-map (kbd "M-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "M-k") 'evil-window-up)

;(define-key evil-visual-state-map (kbd "C-c") (progn ()))

;; (global-set-key [f8] 'neotree-toggle)

; =================== counsel-etags ===============
(define-key evil-motion-state-map (kbd "C-t") 'pop-tag-mark)
