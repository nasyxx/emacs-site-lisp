;;; nasy-襍.el --- Nasy's 襍餘.  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Nasy

;; Author: Nasy <nasyxx@gmail.com>

;;; Commentary:

;; 所收集襍餘也

;;; Code:

;;;###autoload
(defun nasy/frame-recenter (&optional frame)
  "Center FRAME on the screen.
FRAME can be a frame name, a terminal name, or a frame.
If FRAME is omitted or nil, use currently selected frame."
  (interactive)
  (unless (eq 'maximised (frame-parameter nil 'fullscreen))
    (let* ((frame (or (and (boundp 'frame) frame) (selected-frame)))
           (frame-w (frame-pixel-width frame))
           (frame-h (frame-pixel-height frame))
            ;; frame-monitor-workarea returns (x y width height) for the monitor
           (monitor-w (nth 2 (frame-monitor-workarea frame)))
           (monitor-h (nth 3 (frame-monitor-workarea frame)))
           (center (list (/ (- monitor-w frame-w) 2)
                         (/ (- monitor-h frame-h) 2))))
      (apply 'set-frame-position (flatten-list (list frame center))))))

;;(provide 'nasy-襍)
;;; nasy-襍.el ends here
