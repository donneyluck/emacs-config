;;; config.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Abdelhak Bougouffa

;; Personal info
(setq user-full-name "donney.luck"
      user-mail-address (concat "abougouffa" "@" "fedora" "project" "." "org"))

;; Set the default GPG key ID, see "gpg --list-secret-keys"
;; (setq-default epa-file-encrypt-to '("XXXX"))

(setq
 ;; Set a theme for MinEmacs, supported themes include these from `doom-themes'
 ;; and `modus-themes'.
 minemacs-theme 'doom-xcode ; `doom-one' is a dark theme, `doom-one-light' is the light one
 ;; Set Emacs fonts, some good choices include:
 ;; - Cascadia Code
 ;; - Fira Code, FiraCode Nerd Font
 ;; - Iosevka, Iosevka Fixed Curly Slab
 ;; - IBM Plex Mono
 ;; - JetBrains Mono
 minemacs-fonts
 '(:font-family "Iosevka Fixed Curly Slab"
 ;;'(:font-family "Sarasa Gothic SC"
   :font-size 12
;;   :unicode-font-family "Sarasa Gothic SC"
;;   :unicode-font-size 12
   :variable-pitch-font-family "IBM Plex Serif"
   :variable-pitch-font-size 12))

(+deferred!
 ;; Auto enable Eglot in supported modes using `+eglot-auto-enable' (from the
 ;; `me-prog' module). You can use `+lsp-auto-enable' instead to automatically
 ;; enable LSP mode in supported modes (from the `me-lsp' module)r
 (+eglot-auto-enable))

;; If you installed Emacs from source, you can add the source code
;; directory to enable jumping to symbols defined in Emacs' C code.
;; (setq source-directory "~/Sources/emacs-git/")

;; I use Brave, and never use Chrome, so I replace chrome program with "brave"
(setq browse-url-chrome-program (or (executable-find "brave") (executable-find "chromium")))

;; Module: `me-natural-langs' -- Package: `spell-fu'
(with-eval-after-load 'spell-fu
  ;; We can use MinEmacs' helper macro `+spell-fu-register-dictionaries'
  ;; to enable multi-language spell checking.
  (+spell-fu-register-dictionaries "en" "cn"))

;; Module: `me-rss' -- Package: `elfeed'
(with-eval-after-load 'elfeed
  ;; Add news feeds for `elfeed'
  (setq elfeed-feeds
        '("https://itsfoss.com/feed"
          "https://lwn.net/headlines/rss"
          "https://linuxhandbook.com/feed"
          "https://www.omgubuntu.co.uk/feed"
          "https://this-week-in-rust.org/rss.xml"
          "https://planet.emacslife.com/atom.xml")))

;; Module: `me-email' -- Package: `mu4e'
(with-eval-after-load 'mu4e
  ;; Load personal aliases, a file containing aliases, for example:
  ;; alias gmail "Firstname Lastname <some.user.name@gmail.com>"
  ;; alias work  "Firstname Lastname <some.user.name@work.com>"

  ;; (setq mail-personal-alias-file (concat minemacs-config-dir "private/mail-aliases.mailrc"))

  (setq +mu4e-auto-bcc-address "always.bcc@this.email" ;; Add an email address always included as BCC
        +mu4e-gmail-accounts '(("account1@gmail.com" . "/gmail")
                               ("account@somesite.org" . "/gmail")))

  ;; Register email accounts with mu4e
  ;; Use MinEmacs' `+mu4e-register-account' helper function to register multiple accounts
  (+mu4e-register-account
   "Google mail" ;; Account name
   "gmail" ;; Maildir
   `((user-mail-address     . "account1@gmail.com")
     (mu4e-sent-folder      . "/gmail/Sent Mail")
     (mu4e-drafts-folder    . "/gmail/Drafts")
     (mu4e-trash-folder     . "/gmail/Trash")
     ;; These settings aren't mandatory if a `msmtp' config is used.
     (smtpmail-smtp-server  . "smtp.googlemail.com")
     (smtpmail-smtp-service . 587)
     ;; Define account aliases
     (+mu4e-account-aliases . ("account1-alias@somesite.org"
                               "account1-alias@othersite.org"))
     ;; Org-msg greeting and signature
     (org-msg-greeting-fmt  . "Hi%s,")
     ;; Generate signature
     (org-msg-signature     . ,(+org-msg-make-signature
                                "Regards," ;; Closing phrase
                                "Firstname" ;; First name
                                "Lastname" ;; Last name
                                "/R&D Engineer at Some company/")))))

;; Module: `me-org' -- Package: `org'
(with-eval-after-load 'org
  (setq org-hide-emphasis-markers t) ;; 隐藏折叠时生成的长黑条
  ;; Set Org-mode directory
  (setq org-directory "~/Org/" ; let's put files here
        org-default-notes-file (concat org-directory "inbox.org"))
  ;; Customize Org stuff
  (setq org-todo-keywords
        '((sequence "IDEA(i)" "TODO(t)" "NEXT(n)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "KILL(k)")
          (sequence "[ ](T)" "[✔](R)" "|" "[✘](W)")
          (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

  (setq org-export-headline-levels 5)

  ;; Your Org files to include in the agenda
  (setq org-agenda-files
        (mapcar
         (lambda (f) (concat org-directory f))
         '("inbox.org"
           "agenda.org"
           "projects.org"))))

;; Module: `me-notes' -- Package: `org-roam'
(with-eval-after-load 'org-roam
  (setq org-roam-directory (concat org-directory "slip-box/")
        org-roam-db-location (concat org-roam-directory "org-roam.db"))

  ;; Register capture template (via Org-Protocol)
  ;; Add this as bookmarklet in your browser
  ;; javascript:location.href='org-protocol://roam-ref?template=r&ref=%27+encodeURIComponent(location.href)+%27&title=%27+encodeURIComponent(document.title)+%27&body=%27+encodeURIComponent(window.getSelection())
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain "%?"
           :if-new (file+head "web/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+created: %U\n\n${body}\n")
           :unnarrowed t))))

;; Module: `me-media' -- Package: `empv'
(with-eval-after-load 'empv
  ;; Set the radio channels, you can get streams from radio-browser.info
  (setq empv-radio-channels
        '(("El-Bahdja FM" . "http://webradio.tda.dz:8001/ElBahdja_64K.mp3")
          ("El-Chaabia" . "https://radio-dzair.net/proxy/chaabia?mp=/stream")
          ("Quran Radio" . "http://stream.radiojar.com/0tpy1h0kxtzuv")
          ("Algeria International" . "https://webradio.tda.dz/Internationale_64K.mp3")
          ("JOW Radio" . "https://str0.creacast.com/jowradio")
          ("Europe1" . "http://ais-live.cloud-services.paris:8000/europe1.mp3")
          ("France Iter" . "http://direct.franceinter.fr/live/franceinter-hifi.aac")
          ("France Info" . "http://direct.franceinfo.fr/live/franceinfo-hifi.aac")
          ("France Culture" . "http://icecast.radiofrance.fr/franceculture-hifi.aac")
          ("France Musique" . "http://icecast.radiofrance.fr/francemusique-hifi.aac")
          ("FIP" . "http://icecast.radiofrance.fr/fip-hifi.aac")
          ("Beur FM" . "http://broadcast.infomaniak.ch/beurfm-high.aac")
          ("Skyrock" . "http://icecast.skyrock.net/s/natio_mp3_128k"))
        ;; See: docs.invidious.io/instances/
        empv-invidious-instance "https://invidious.projectsegfau.lt/api/v1"))

;; Module: `me-ros' -- Package: `ros'
(with-eval-after-load 'ros
  (setq ros-workspaces
        (list
         (ros-dump-workspace
          :tramp-prefix "/docker:ros@ros-machine:"
          :workspace "~/ros_ws"
          :extends '("/opt/ros/noetic/"))
         (ros-dump-workspace
          :tramp-prefix "/docker:ros@ros-machine:"
          :workspace "~/ros2_ws"
          :extends '("/opt/ros/foxy/")))))

(use-package csharp-mode
  :straight t
  :mode "\\.cs\\'"
  :custom
  (csharp-ts-mode-indent-offset 2) ; customize variables
  (imenu-generic-expression
   '(("Variables" "^\\s-*[a-zA-Z0-9._ ]* \\([a-zA-Z0-9_]*\\)\\( = \\sw*\\|\\s-*\\);$" 1)
     ("Functions" "^\\s-*[^/]* \\([a-zA-Z0-9_]+\\)(.*)\\(\\s-*.*\n\\|\\ *\\)\\s-*{" 1)
     ("Classes" "^\\s-*\\(.*\\)class +\\([a-zA-Z0-9_]+\\)" 2)
     ("Namespaces" "^namespace +\\([a-z0-9_]*\\)" 1)))
  :init
  :config)


(defun g-screenshot-on-buffer-creation ()
  (setq display-fill-column-indicator-column nil)
  (setq line-spacing nil))

(use-package screenshot
  :straight (:type git :host github :repo "tecosaur/screenshot")

  :config
  (setq screenshot-line-numbers-p nil)

  (setq screenshot-min-width 120)
  (setq screenshot-max-width 300)
  (setq screenshot-truncate-lines-p nil)

  (setq screenshot-text-only-p nil)

  (setq screenshot-font-size 10)

  (setq screenshot-border-width 16)
  ;;(setq screenshot-radius 0)

  ;; (setq screenshot-shadow-radius 0)
  ;; (setq screenshot-shadow-offset-horizontal 0)
  ;; (setq screenshot-shadow-offset-vertical 0)

  :hook
  ((screenshot-buffer-creation . g-screenshot-on-buffer-creation)))
;;(use-package screenshot
;;  :straight (:host github :repo "donneyluck/screenshot")
;;  :config (setq screenshot-upload-fn "curl -F'file=@%s' https://0x0.st 2>/dev/null"))
(setq-default major-mode 'org-mode)

(with-eval-after-load 'org
  (setq org-export-in-background nil))

(setq project-ignores '("*.meta" "*.prefab" "*.dll" "*.png" "*.asset"))

;; 获取当前主题的背景色
(defun get-theme-background-color ()
  (cdr (assoc 'background-color (frame-parameters))))

(defun set-org-block-end-line-color ()
  "Set org-src-block face background color to current theme's background color."
  (interactive)
  (let ((background-color (get-theme-background-color))) ; 获取当前主题的背景色
    (set-face-attribute 'org-block-end-line nil :background background-color))) ; 设置 org-src-block face 的背景色属性

(advice-add 'consult-theme :after (lambda (&rest args) (set-org-block-end-line-color)))
