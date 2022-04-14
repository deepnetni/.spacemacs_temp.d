(defun deepnetni-emacs-env//goto-line-center (hook-list)
  (dolist (tgt hook-list)
    (advice-add tgt :after (lambda (&rest _)
                             (evil-scroll-line-to-center (line-number-at-pos))))))
