;; hook for trailing white spaces
(add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)

(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'prog-mode)
    (delete-trailing-whitespace)))

;; file utilities
(defun xah-html-open-link-in-firefox (&optional @fullpath)
  "open url under cursor in Firefox browser.
Work in Windows, macOS. 2019-11-09 linux not yet.
Version 2019-11-09"
  (interactive)
  (let ($path)
    (if @fullpath
        (progn (setq $path @fullpath))
      (let (($inputStr
             (if (use-region-p)
                 (buffer-substring-no-properties (region-beginning) (region-end))
               (let ($p0 $p1 $p2
                         ($pathStops "^  \t\n\"`'‘’“”|[]{}「」<>〔〕〈〉《》【】〖〗«»‹›❮❯❬❭〘〙·。\\"))
                 (setq $p0 (point))
                 (skip-chars-backward $pathStops)
                 (setq $p1 (point))
                 (goto-char $p0)
                 (skip-chars-forward $pathStops)
                 (setq $p2 (point))
                 (goto-char $p0)
                 (buffer-substring-no-properties $p1 $p2)))))
        (setq $path (replace-regexp-in-string
                     "^file:///" "/"
                     (replace-regexp-in-string
                      ":\\'" "" $inputStr)))))
    (cond
     ((string-equal system-type "darwin")
      (shell-command (format "open -a 'Firefox.app' \"%s\"" $path)))
     ((string-equal system-type "windows-nt")
      ;; "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 2019-11-09
      (let ((process-connection-type nil))
        (start-process "" nil "powershell" "start-process" "firefox" $path )))
     ((string-equal system-type "gnu/linux")
      (shell-command (format "firefox \"%s\"" $path))))))

(defun xah-open-in-terminal ()
  "Open the current dir in a new terminal window.
on Microsoft Windows, it starts cross-platform PowerShell pwsh. You need to have it installed.

URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2020-11-21 2021-01-18"
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (let ((process-connection-type nil))
      (shell-command (concat "PowerShell -Command Start-Process pwsh -WorkingDirectory " (shell-quote-argument default-directory)))
      ;;
      ))
   ((string-equal system-type "darwin")
    (shell-command (concat "open -a terminal " (shell-quote-argument (expand-file-name default-directory )))))
   ((string-equal system-type "gnu/linux")
    (let ((process-connection-type nil))
      (start-process "" nil "x-terminal-emulator"
                     (concat "--working-directory=" default-directory))))))

(provide 'init-file)
