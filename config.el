;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tingting.W"
      user-mail-address "wangtingting9071@iie.ac.cn")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "DejaVu Sans Mono" :size 14))
;; (setq doom-font (font-spec :family "Source Code Pro" :size 14))
(if (eq system-type 'windows-nt)
    (progn
      ;; Setting English Font
      (set-face-attribute 'default nil :font "DejaVu Sans Mono 14")
      ;; (set-face-attribute 'default nil :font "Ubuntu Mono 12")
      ;; (set-face-attribute 'default nil :font "Inconsolata 11")
      ;; Chinese Font
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
              (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "Microsoft Yahei" :size 28))))
    (progn
          ;; Setting English Font
          (set-face-attribute 'default nil :font "DejaVu Sans Mono 10")
          ;; Chinese Font
          ;; yay -S ttf-consolas-with-yahei
          ;; fc-list|grep -i yahei
          (dolist (charset '(kana han symbol cjk-misc bopomofo))
                  (set-fontset-font (frame-parameter nil 'font)
                                charset
                                (font-spec :family "Consolas-with-Yahei" :size 20)))
          )
    )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-nord-light)
(setq doom-theme 'doom-material)

(require 'highlight-indent-guides)
(set-face-background 'highlight-indent-guides-odd-face "darkgray")
(set-face-background 'highlight-indent-guides-even-face "dimgray")
(set-face-foreground 'highlight-indent-guides-character-face "gray25") ;; list-colors-display
(setq beacon-color "purple")
(shackle-mode t)
(beacon-mode 1)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/Cloud/Documents/Org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)


;; Here are some additional functions/macros that could help you configure Doom:

;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq org_notes (concat (getenv "HOME") "/Cloud/Documents/bib/Notes/")
      zot_bib (concat (getenv "HOME") "/Cloud/Documents/bib/zotLib.bib")
      org-directory org_notes
      deft-directory org_notes
      org-roam-directory org_notes)
(load! "gtd.el")
;; open files with default apps
;; C-h
(map! (:map (minibuffer-local-map
             minibuffer-local-ns-map
             minibuffer-local-completion-map
             minibuffer-local-must-match-map
             minibuffer-local-isearch-map
             read-expression-map)
        "C-h" #'backward-delete-char-untabify)

      (:after evil
        :map evil-ex-completion-map
        "C-h" #'backward-delete-char-untabify)

      ;; If you use :completion ivy
      (:after ivy
        :map ivy-minibuffer-map
        "C-h" #'backward-delete-char-untabify)


      ;; If you use :completion helm
      (:after helm
        :map helm-map
        "C-h" #'backward-delete-char-untabify)

      (:after org
        :map org-mode-map
        "C-h" #'backward-delete-char-untabify))

;; python configurations
(defun zxf/python-toggle-breakpoint ()
    (interactive)
    (let ((trace "__import__('pudb').set_trace()")
          (line (thing-at-point 'line)))
      (if (and line (string-match trace line))
          (kill-whole-line)
        (progn
          (back-to-indentation)
          (insert trace)
          (insert "\n")
          (python-indent-line)))))
(setq python-shell-interpreter "python"
      python-shell-interpreter-args "-m IPython --simple-prompt -i")
(setenv "WORKON_HOME" (expand-file-name "~/anaconda3/bin"))
(add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))


(defun org-agenda-show-my-agenda (&optional arg)
  (interactive "P")
  (org-agenda arg "z"))

;; keybindings
(map!
 ;; :nim "s-x" #'helm-M-x
 :nim "M-/" #'helm-resume
 :nim "M-." #'helm-M-x
 :nim "C-c !" #'org-time-stamp-inactive
 :nim "C-c a" #'org-agenda
 :nim "C-c b" #'ebuku
 :nim "C-c c" #'org-capture
 :nim "C-c d" #'zxf/python-toggle-breakpoint
 :nim "C-c f" #'=rss
 :nim "C-c l" #'org-cliplink
 :nim "C-c r" #'org-ref-helm-insert-cite-link
 :nim "C-c R" #'helm-bibtex-with-local-bibliography
 :nim "C-c t" #'org-pomodoro
 :nim "C-c T" #'+tmux/cd-to-here
 :nim "C-c z" #'org-agenda-show-my-agenda
 :nm "C-n" #'evil-next-line
 :nm "C-p" #'evil-previous-line
 :nm "C-x d" #'dired-jump
 ;; :nm "C-k" #'dired-jump
 ;; :nim "C-c t" #'org-pomodoro
 :nm "`" #'helm-resume
 :nim "C-x C-p" #'helm-projectile-switch-project
 :nm "C-f" #'+helm/projectile-find-file
 :nm "C-b" #'helm-mini
 ;; :nm "M-," #'helm-mini
 :nm "C-w C-c" #'+workspace/close-window-or-workspace
 :nim "C-x g g" #'magit-status
 :nim "C-x g t" #'git-timemachine-toggle
 :nm "C-a" #'evil-switch-to-windows-last-buffer
 :nm "C-e" #'evil-scroll-up
 :n "C-c C-k" #'kill-current-buffer
 :n "/" #'helm-swoop-without-pre-input
 :nim "M-j" #'move-text-down
 :nim "M-k" #'move-text-up
 :n "[r" #'parrot-rotate-next-word-at-point
 :n "]r" #'parrot-rotate-prev-word-at-point
 :nim "<scroll>" #'global-centered-cursor-mode
 :i "C-h" #'backward-delete-char-untabify
 :map helm-map
 "C-<tab>" #'helm-select-action
 ;; :map dired-mode-map
 :map biblio-selection-mode-map
  "j" #'biblio--selection-next
  "k" #'biblio--selection-previous)

;; elfeed rss
(use-package! elfeed-org
  :after elfeed
  :config
  (setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" "~/.doom.d"))
        elfeed-db-directory (expand-file-name "~/.elfeed"))
  (evil-define-key 'normal elfeed-search-mode-map (kbd "q") #'zxf/elfeed-save-db-and-bury)
  (evil-define-key 'normal elfeed-search-mode-map (kbd "R") #'elfeed-update)
  (evil-define-key 'normal elfeed-search-mode-map (kbd "f") #'elfeed-search-live-filter)
  ;; Feeds with proxy
  (setq-default elfeed-search-filter "@6-week-ago +unread ")
  (setf elfeed-curl-extra-arguments '("--socks5-hostname" "127.0.0.1:10808"))
  (elfeed-org)
  )

(setq dired-guess-shell-alist-user '(("\\.html\\'" "google-chrome-stable")
                                   ("\\.doc\\'" "libreoffice")
                                   ("\\.docx\\'" "libreoffice")
                                   ("\\.ppt\\'" "libreoffice")
                                   ("\\.pptx\\'" "libreoffice")
                                   ("\\.xls\\'" "libreoffice")
                                   ("\\.xlsx\\'" "libreoffice")
                                   ("\\.jpg\\'" "pinta")
                                   ("\\.png\\'" "pinta")
                                   ("\\.java\\'" "idea")))

;;write to disk when quiting
(defun zxf/elfeed-save-db-and-bury()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (elfeed-search-quit-window))

(evil-define-key 'normal pdf-view-mode-map (kbd "C-b") #'helm-mini)
(evil-define-key 'normal pdf-view-mode-map (kbd "C-e") #'evil-switch-to-windows-last-buffer)
(keyboard-translate ?\C-h ?\C-?)
(define-key evil-motion-state-map (kbd "C-w <DEL>") #'evil-window-left)
(define-key evil-motion-state-map (kbd "C-w C-?") #'evil-window-left)

(use-package shackle
  :ensure t
  :after helm
  :diminish
  :config
  (setq helm-display-function 'pop-to-buffer)
  ;; TODO
  (setq shackle-rules '(
                        ("\\`\\*helm.*?\\*\\'"
                         :regexp t
                         :align t
                         :size 0.45)
                        ))
  (shackle-mode t))

(after! helm
  :config
  (setq helm-swoop-split-with-multiple-windows nil
        helm-swoop-speed-or-color t
        helm-swoop-move-to-line-cycle nil
        ;; helm-display-function 'helm-display-buffer-in-own-frame
        ;; helm-swoop-split-window-function #'helm-display-buffer-in-own-frame
        helm-swoop-split-direction 'split-window-horizontally
        ;; helm-swoop-split-direction 'mouse-split-window-vertically
        helm-bibtex-full-frame nil
        helm-split-window-inside-p nil
        window-divider-default-places 'right
        )
  )

(after! bibtex
  :config
  (setq
    ;; org-ref-completion-library 'org-ref-ivy-cite
    org-latex-prefer-user-labels t
    org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
    org-ref-default-bibliography (list zot_bib)
    org-ref-bibliography-notes (concat org_notes "notes.org")
    org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
    org-ref-notes-directory org_notes
    org-ref-notes-function 'orb-edit-notes
    bibtex-completion-notes-path org_notes
    bibtex-completion-bibliography zot_bib
    bibtex-completion-pdf-field "file"
    bibtex-completion-additional-search-fields '(tags)
    bibtex-completion-notes-template-multiple-files (concat
                                                      "#+TITLE: ${title}\n"
                                                      "#+ROAM_KEY: cite:${=key=}\n"
                                                      "* TODO Notes\n"
                                                      ":PROPERTIES:\n"
                                                      ":Custom_ID: ${=key=}\n"
                                                      ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
                                                      ":AUTHOR: ${author-abbrev}\n"
                                                      ":JOURNAL: ${journaltitle}\n"
                                                      ":DATE: ${date}\n"
                                                      ":YEAR: ${year}\n"
                                                      ":DOI: ${doi}\n"
                                                      ":URL: ${url}\n"
                                                      ":END:\n\n"
                                                      )
  ;; bibtex-completion-display-formats
  ;;     '((article       . "${author:36} ${title:*} ${journal:40} ${year:4} ${=has-pdf=:1}${=has-note=:1} ${=type=:3}")
  ;;       (inbook        . "${author:36} ${title:*} Chapter ${chapter:32} ${year:4} ${=has-pdf=:1}${=has-note=:1} ${=type=:3}")
  ;;       (incollection  . "${author:36} ${title:*} ${booktitle:40} ${year:4} ${=has-pdf=:1}${=has-note=:1} ${=type=:3}")
  ;;       (inproceedings . "${author:36} ${title:*} ${booktitle:40} ${year:4} ${=has-pdf=:1}${=has-note=:1} ${=type=:3}")
  ;;       (t             . "${author:36} ${title:*} ${year:4} ${=has-pdf=:1}${=has-note=:1} ${=type=:3}"))

      ))


;; https://www.orgroam.com/manual/Installation-_00281_0029.html#Installation-_00281_0029
(use-package org-roam
  :hook (org-load . org-roam-mode)
  :custom (org-roam-directory org_notes)
  :commands (org-roam-buffer-toggle-display
             org-roam-find-file
             org-roam-graph
             org-roam-insert
             org-roam-switch-to-buffer
             org-roam-dailies-date
             org-roam-dailies-today
             org-roam-dailies-tomorrow
             org-roam-dailies-yesterday)
  :config
  (setq org-roam-directory (expand-file-name (or org-roam-directory "roam")
                                             org-directory)
        org-roam-verbose nil  ; https://youtu.be/fn4jIlFwuLU
        org-roam-buffer-no-delete-other-windows t ; make org-roam buffer sticky
        org-roam-graph-viewer "google-chrome-stable"
        org-roam-completion-system 'default)
  (setq org-roam-capture-templates
    (quote
      (("d" "default" plain
        (function org-roam-capture--get-point)
        "%?" :file-name "%<%Y%m%d%H%M%S>-${slug}"
        :head "#+LATEX_HEADER: \\usepackage[citestyle=authoryear-icomp,bibstyle=authoryear, hyperref=true,backref=true,maxcitenames=3,url=true,backend=bibtex,natbib=true] {biblatex}
#+LATEX_HEADER: \\addbibresource{~/Cloud/Documents/bib/zotLib.bib}
#+TITLE: ${title}" :unnarrowed t))))
  ;; Normally, the org-roam buffer doesn't open until you explicitly call
  ;; `org-roam'. If `+org-roam-open-buffer-on-find-file' is non-nil, the
  ;; org-roam buffer will be opened for you when you use `org-roam-find-file'
  ;; (but not `find-file', to limit the scope of this behavior).
  (add-hook 'find-file-hook
    (defun +org-roam-open-buffer-maybe-h ()
      (and +org-roam-open-buffer-on-find-file
           (memq 'org-roam-buffer--update-maybe post-command-hook)
           (not (window-parameter nil 'window-side)) ; don't proc for popups
           (not (eq 'visible (org-roam-buffer--visibility)))
           (with-current-buffer (window-buffer)
             (org-roam-buffer--get-create)))))
  (add-hook 'org-roam-buffer-prepare-hook #'hide-mode-line-mode)
  ;; Hide the mode line in the org-roam buffer, since it serves no purpose. This
  ;; makes it easier to distinguish among other org buffers.
  :bind (:map org-roam-mode-map
          (("C-c n n" . org-roam)
          ("C-c n f" . org-roam-find-file)
          ("C-c n o" . org-noter) ;; open
          ("C-c n g" . org-noter-sync-current-note)  ;; goto
          ("C-c n G" . org-noter-sync-current-page-or-chapter)
          ("C-c n v" . org-roam-server-open)  ;; view
          ("C-c n u" . org-roam-unlinked-references)  ;; unlinked
          ("C-c n j" . org-roam-jump-to-index)
          ("C-c n b" . org-roam-switch-to-buffer)
          ("C-c n d" . deft)
          ("C-c n s" . +default/org-notes-search)
          ("C-c n t" . org-roam-dailies-today)
          ("C-c n i" . org-roam-insert)))
          ("C-c n l" . org-roam-store-link)
  )

;; Since the org module lazy loads org-protocol (waits until an org URL is
;; detected), we can safely chain `org-roam-protocol' to it.
(use-package org-roam-protocol
  :after org-protocol)
(use-package company-org-roam
  :after org-roam
  :config
  (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

;; ;; ;; Windows PDF view
;; (after! tex
;;   (setq-default TeX-master 'dwim)
;;   (setq TeX-PDF-mode t
;;         TeX-source-correlate-mode t
;;         TeX-source-correlate-method 'synctex
;;         TeX-view-program-list
;;         '(("SumatraPDF" ("\"SumatraPDF.exe\" -reuse-instance"
;;                          (mode-io-correlate " -forward-search %b %n ") " %o")))
;;     )
;;     (assq-delete-all 'output-pdf TeX-view-program-selection)
;;     (add-to-list 'TeX-view-program-selection '(output-pdf "SumatraPDF"))
;;   )

;; ;; ;; Linux PDF view
(after! tex
  ;; Set Okular as the default PDF viewer.

;; Update PDF buffers after successful LaTeX runs
  (add-hook 'TeX-after-compilation-finished-functions
           #'TeX-revert-document-buffer)
  (setq TeX-PDF-mode t
    TeX-master 'dwim
    TeX-source-correlate-mode t
    TeX-source-correlate-method 'synctex
    TeX-source-correlate-start-server t
    ;; TeX-view-program-list '(("Okular" ("okular --unique %o" (mode-io-correlate "#src:%n%a"))))
    )
    (assq-delete-all 'output-pdf TeX-view-program-selection)
    ;; (add-to-list 'TeX-view-program-selection '(output-pdf "Okular"))
  )

;; (setq org-bullets-bullet-list '("🐳" "🐬" "🐠" "🐟"))
;; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; (add-hook 'org-mode-hook 'emojify-mode)

;; pdf default
(setq org-file-apps
      (quote
       ((auto-mode . emacs)
     ;;   ("\\.pdf\\'" . "\"SumatraPDF.exe\" -reuse-instance %s")
      )))

;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . fullheight))
(blink-cursor-mode)
(nyan-mode)
(parrot-mode)
(whitespace-cleanup)

(setq url-proxy-services
   '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
     ("http" . "127.0.0.1:10809")
     ("https" . "127.0.0.1:10809")))
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))


;; roam
 (use-package org-roam-bibtex
  :after (org-roam)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq org-roam-bibtex-preformat-keywords '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${slug}"
           :head "#+TITLE: ${=key=}: ${title}\n#+ROAM_KEY: ${ref}

- tags ::
- keywords :: ${keywords}

\n* ${title}\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :URL: ${url}\n  :AUTHOR: ${author-or-editor}\n  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n  :NOTER_PAGE: \n  :END:\n\n"

           :unnarrowed t)))
  (define-key org-roam-bibtex-mode-map (kbd "C-c n a") #'orb-note-actions)
  )


;; org-noter
(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   ;; org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list org_notes)
   )
)
;; deft search
(use-package deft
  :commands deft
  :init
  (setq deft-default-extension "org"
        ;; de-couples filename and note title:
        deft-use-filename-as-title nil
        deft-use-filter-string-for-filename t
        ;; disable auto-save
        deft-auto-save-interval -1.0
        ;; converts the filter string into a readable file-name using kebab-case:
        deft-file-naming-rules
        '((noslash . "-")
          (nospace . "-")
          (case-fn . downcase)))
  :config
  (add-to-list 'deft-extensions "tex")
)
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
;; (add-hook 'doc-view-mode-hook #'pdf-tools-enable-minor-modes)

(use-package pdf-tools
  :config
  (pdf-tools-install)
  (setq pdf-view-midnight-colors '( "#2e311f" . "#C7EDCC" ))
  ;; initialise
  (add-hook 'pdf-view-mode-hook (lambda () (pdf-view-midnight-minor-mode)))
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (evil-define-key 'normal pdf-view-mode-map (kbd "a") #'pdf-annot-attachment-dired)
  (evil-define-key 'normal pdf-view-mode-map (kbd "i") #'org-noter-insert-note)
  (evil-define-key 'normal pdf-view-mode-map (kbd "M") #'pdf-annot-add-markup-annotation)
  (evil-define-key 'normal pdf-view-mode-map (kbd "t") #'pdf-annot-add-text-annotation)
  (evil-define-key 'normal pdf-view-mode-map (kbd "l") #'pdf-annot-list-annotations)
  (evil-define-key 'normal pdf-view-mode-map (kbd "c") #'pdf-annot-add-highlight-markup-annotation) ;; color
  (evil-define-key 'normal pdf-view-mode-map (kbd "x") #'pdf-annot-delete)
  (evil-define-key 'normal pdf-view-mode-map (kbd "m") #'pdf-view-position-to-register)
  (evil-define-key 'normal pdf-view-mode-map (kbd "e") #'pdf-view-scroll-down-or-previous-page)
  (evil-define-key 'normal pdf-view-mode-map (kbd "d") #'pdf-view-scroll-up-or-next-page)
  (evil-define-key 'normal pdf-view-mode-map (kbd "C-e") #'pdf-view-scroll-down-or-previous-page)
  (evil-define-key 'normal pdf-view-mode-map (kbd "C-b") #'helm-mini)
  (evil-define-key 'normal pdf-view-mode-map (kbd "C-d") #'pdf-view-scroll-up-or-next-page)
  (evil-define-key 'normal pdf-view-mode-map (kbd "o") #'pdf-outline)
  (evil-define-key 'normal pdf-view-mode-map (kbd "O") #'org-noter-create-skeleton)
  (evil-define-key 'normal pdf-view-mode-map (kbd "r") #'pdf-view-midnight-minor-mode)
  (evil-define-key 'normal pdf-view-mode-map (kbd "p") #'pdf-view-goto-page)
  (evil-define-key 'normal pdf-view-mode-map (kbd "C-a") #'evil-switch-to-windows-last-buffer)
  (evil-define-key 'normal pdf-view-mode-map (kbd "C-o") #'better-jumper-jump-backward)
  (evil-define-key 'normal pdf-annot-minor-mode-map (kbd "x") #'pdf-annot-delete)
  (evil-define-key 'normal pdf-annot-minor-mode-map (kbd "M") #'pdf-annot-add-markup-annotation)
  (evil-define-key 'normal image-mode-map (kbd "d") #'image-scroll-up)
  (evil-define-key 'normal image-mode-map (kbd "e") #'image-scroll-down)
  (evil-define-key 'normal image-mode-map (kbd "-") #'image-decrease-size)
  (evil-define-key 'normal image-mode-map (kbd "+") #'image-increase-size)
  )

(after! ebuku
  :config
  (progn
    (evil-define-key 'normal ebuku-mode-map (kbd "*") #'ebuku-show-all)
    (evil-define-key 'normal ebuku-mode-map (kbd "RET") #'ebuku-open-url)
    (evil-define-key 'normal ebuku-mode-map (kbd "C-n") #'ebuku-next-bookmark)
    (evil-define-key 'normal ebuku-mode-map (kbd "C-p") #'ebuku-previous-bookmark)
    (evil-define-key 'normal ebuku-mode-map (kbd "R") #'ebuku-refresh)
    (evil-define-key 'normal ebuku-mode-map (kbd "u") #'ebuku-update-bookmarks-cache)
    (evil-define-key 'normal ebuku-mode-map (kbd "d") #'ebuku-delete-bookmark)
    (evil-define-key 'normal ebuku-mode-map (kbd "e") #'ebuku-edit-bookmark)
    (evil-define-key 'normal ebuku-mode-map (kbd "a") #'ebuku-add-bookmark)
    (evil-define-key 'normal ebuku-mode-map (kbd "f") #'ebuku-search-on-reg)
    (evil-define-key 'normal ebuku-mode-map (kbd "F") #'ebuku-search)
    (evil-define-key 'normal ebuku-mode-map (kbd "r") #'ebuku-search-on-recent)
    (evil-define-key 'normal ebuku-mode-map (kbd "/") #'helm-swoop-without-pre-input)
    )
  )

(defun org-pomodoro-notify (title message)
  "Temporary replacement for function of the same name which uses
the buggy alert.el package.  TITLE is the title of the MESSAGE."
  (let*
      ((toast "toast")
       (t-title (concat " -t \"" title))
       (t-message (concat "\" -m \"" message "\""))
       (t-image (concat " -p \"C:\\EXTRA\\emax64\\share\\icons\\hicolor\\128x128\\apps\\emacs.png\""))
       ;;(t-image (concat " -p \"C:\\Program Files\\emacs\\share\\icons\\hicolor\\128x128\\apps\\emacs.png\""))
       (my-command (concat toast t-title t-message t-image)))
    (call-process-shell-command my-command)))

(use-package org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 9090
        org-roam-server-export-inline-images t
        org-roam-server-authenticate nil
        org-roam-server-label-truncate t
        org-roam-server-label-truncate-length 60
        org-roam-server-label-wrap-length 20)
  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
    (org-roam-server-mode 1)
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))

(setq ebuku-buku-path (expand-file-name "~/anaconda3/bin/buku")
      ebuku-database-path (expand-file-name "~/.local/share/buku/bookmarks.db"))

(use-package org-download
  :after org
  :config
  (setq org-download-screenshot-method "convert clipboard: %s"
        org-download-method 'attach
        org-image-actual-width nil
        org-download-screenshot-file (expand-file-name "~/Documents/lightshot/Screenshot_1.png"))
  :bind
  (:map org-mode-map
        (("C-c Y" . org-download-screenshot)
         ("C-c y" . org-download-yank))))

;; (setq beacon-color "light sea green")
(setq beacon-color "purple")
(server-start)

(shackle-mode t)
(setq pdf-view-midnight-colors '( "#2e311f" . "#C7EDCC" ))
