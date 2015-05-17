(defun play (audio)
	"Play a mp3 file given the name. This function use afplay command
   present on MAC OSX."
	(interactive (list (completing-read "Noise name: " (audios (directory-files "~/audios/" t "\.mp3$")))))
	(let* (buf (get-buffer-create "playnoise"))
		(start-process-shell-command 
		 "play" buf (concat (format "afplay ~/audios/%s" audio) ".mp3"))))

(defun audios (files) 	
	"Returns a list of names for all files (audios)"
	(let (values)
		(dolist (elt files values)
			(setq values (cons (replace-regexp-in-string "\\..*" "" (file-name-nondirectory elt)) values)))))


(global-set-key (kbd "C-n") 'play) 

(provide 'enoise)
