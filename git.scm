; Licence: same as geda-gaf
; Author:  Vladimir Zhbanov vzhbanov@gmail.com

; In order to redefine the 'schdiff' command you can add to your
; ~/.gEDA/gschemrc a line like this:
;    (define schdiff-command "~/bin/schdiff")
; where ~/bin/schdiff is my locally tweaked version of schdiff
(define schdiff-command
  (if (defined? 'schdiff-command)
    schdiff-command ; user-defined value
    "schdiff"       ; default value
    ))

(define (git:run-cmd cmd)
  (let ([command (string-join (cmd) " " 'infix)])
    (gschem-log (string-append "Run: " command "\n"))
    (if (not (= (apply system* (cmd)) 0))
      (begin
        (gschem-msg (string-append "Command\n\t" command "\nfailed.\n"))
        (gschem-log (string-append "Command \"" command "\" failed.\n")))
      (gschem-log (string-append "Command \"" command "\" completed successfully.\n")))
    ))

(define (git-add)
  (list "git" "add" (get-selected-filename)))

; To edit commit messages for 'git commit' in your preferred
; editor you can add a line like the following in your
; ~/.gitconfig:
;     [core]
;         editor = gvim --nofork
(define (git-commit)
  (list "git" "commit" "-v"))

(define (git-edit)
  (list "gvim" (get-selected-filename)))

(define (git-diff)
  (begin
    (file-save)
    (list "git" "difftool" "-y" "-x" schdiff-command (get-selected-filename))))

(define (git-diff-head)
  (begin
    (file-save)
    (list "git" "difftool" "-y" "-x" schdiff-command "HEAD" (get-selected-filename))))

(define (git-reset)
  (list "git" "reset" (get-selected-filename)))


(define (git:git-commit)
  (begin
    (git:run-cmd git-add)
    (git:run-cmd git-commit)))

(define (git:git-add)
  (begin
    (file-save)
    (git:run-cmd git-add)))

(define (git:git-edit)
  (begin
    (file-save)
    (git:run-cmd git-edit)))

(define (git:git-diff)
  (git:run-cmd git-diff))

(define (git:git-diff-head)
  (git:run-cmd git-diff-head))

(define (git:git-reset)
  (git:run-cmd git-reset))

(define git:menu-items
;;      menu item name    menu action   hotkey action   menu stock icon
  `(
     (,(N_ "git _add")              git:git-add       "gtk-add")
     (,(N_ "git _commit...")        git:git-commit    "gtk-save")
     (,(N_ "git _edit")             git:git-edit      "gtk-edit")
     (,(N_ "git _diff")             git:git-diff      "search")
     (,(N_ "git _Diff HEAD")        git:git-diff-head "search")
     (,(N_ "git _Reset")            git:git-reset     "gtk-cancel")
     ))

(add-menu (N_ "_git") git:menu-items)

(global-set-key "G A" 'git:git-add)
(global-set-key "G E" 'git:git-edit)
(global-set-key "G C" 'git:git-commit)
(global-set-key "G D" 'git:git-diff)
(global-set-key "G <Shift>D" 'git:git-diff-head)
(global-set-key "G R" 'git:git-reset)
