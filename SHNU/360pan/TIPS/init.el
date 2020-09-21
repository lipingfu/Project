
;;; init.el, ".emacs for xemacs" ;;;

; gnuclient save and exit - use for mails
(defalias 'save-and-quit-gnuserv (read-kbd-macro
"C-x C-s C-x #"))

; (require 'tex-site)

;(global-set-key [f1] 'delete-other-windows)
;(global-set-key [f2] `save-buffer)
(global-set-key [f3] 'advertised-undo)
(global-set-key [f4] `font-lock-fontify-buffer)
(global-set-key [f5] 'auto-fill-mode)
(global-set-key [f6] 'point-to-register)
(global-set-key [f7] 'jump-to-register)
(global-set-key [f1]  'compile)
(global-set-key [f2] 'next-error)
(global-set-key (kbd "M-g") 'goto-line)


(setq case-fold-search t) ; make searches case sensitive 

(fset 'upcase-letter
   [?\C-  right ?\M-w ?\C-x ?\C-u])
(global-set-key [delete] 'delete-char)
; (global-font-lock-mode t)  ; error with xemacs
(font-lock-mode t)
(setq font-lock-auto-fontify t)
(setq auto-fill-function t)
(setq default-major-mode-hook 'turn-on-auto-fill)
;(setq emacs-lisp-mode-hook 'turn-on-auto-fill)
(setq LaTeX-mode-hook 'turn-on-auto-fill)
(setq tex-mode-hook 'turn-on-auto-fill)
(setq line-number-mode t)
(setq c-tab-always-indent t)
(global-set-key [end] 'end-of-line)
(global-set-key [home] 'beginning-of-line)
(setq-default auto-fill-mode t)
(setq-default tool-bar-mode nil)


; when using mouse to yank, insert at cursor position as in xterm
(setq mouse-yank-at-point nil)
(setq cursor-type 'box)

(setq paren-sexp-mode 'mismatch)

;(custom-set-variables)
;(custom-set-faces
; '(default ((t (:size "8pt" :family nil))) t))

; the "§" is near the "$" on a german keyboard ...
(global-set-key "§" 'dollar)
(defalias 'dollar (read-kbd-macro
"$"))

(defalias 'save-some-buffers-no-quest (save-some-buffers 1))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        C                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; big c comment
(defalias 'comment (read-kbd-macro
"/* SPC ESC 6 0= SPC * RET * SPC ESC 6 0= SPC */ <up> RET * SPC"))

(defalias 'uncomment-line
  (read-kbd-macro "M-m C-d C-d C-d C-e <backspace> <backspace> <backspace>"))
(defalias 'comment-line
  (read-kbd-macro "M-m /* SPC C-e SPC */"))
(global-set-key (kbd "M-[") 'comment-line)
(global-set-key (kbd "M-]") 'uncomment-line)

(fset 'forw
   [tab ?f ?o ?r ?w ?a ?r ?d ?E ?r ?r ?o ?r ?( ?* ?e ?r ?r ?, ?  ?_ ?_ ?L ?I ?N ?E ?_ ?_ ?, ?) ?\;])

(fset 'quit
   [?q ?u ?i ?t ?O ?n ?E ?r ?r ?o ?r ?( ?* ?e ?r ?r ?, ?  ?_ ?_ ?L ?I ?N ?E ?_ ?_ ?, ?  ?s ?t ?d ?e ?r ?r ?) ?\; tab])

; inserts 'printf'
(fset 'printf
   [tab ?p ?r ?i ?n ?t ?f ?( ?" ?" ?, ?  ?) ?\; left left left left left ?\\ ?n left left])


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                      Latex                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; big tex comment (one line)
(defalias 'tex-comment (read-kbd-macro
"ESC 6 0% RET"))
(global-set-key [f5] 'tex-comment)

(fset 'map2
   [?\\ ?l ?a ?n ?g ?l ?e ?  ?M ?_ ?{ ?\\ ?r ?m ?  ?a ?p ?} ?^ ?2 ?  ?\\ ?r ?a ?n ?g ?l ?e])

(fset 'map3
   [?\\ ?l ?a ?n ?g ?l ?e ?  ?M ?_ ?{ ?\\ ?r ?m ?  ?a ?p ?} ?^ ?3 ?  ?\\ ?r ?a ?n ?g ?l ?e])

; equation
(defalias 'equ (read-kbd-macro
"\\begin{equation} RET RET \\end{equation} C-p"))

; eqnarray
(defalias 'eqn (read-kbd-macro
"\\begin{eqnarray} RET RET \\end{eqnarray} C-p"))

; minipage
(defalias 'mini (read-kbd-macro
"\\begin{minipage}[c]{\\textwidth} RET RET \\end{minipage} C-p C-p C-a C-f C-s \\ C-b"))

; itemize made easy
(defalias 'item
  (read-kbd-macro "\\begin{itemize} 2*RET \\end{itemize} <up>"))

(defalias 'verb
  (read-kbd-macro "\\begin{verbatim} 2*RET \\end{verbatim} <up>"))

; figure
(defalias 'fig (read-kbd-macro
"\\begin{figure}[!tb] RET TAB RET \\resizebox{0.8\\hsize}{!}{
TAB RET TAB RET } TAB RET TAB RET \\caption{} TAB RET \\label{fig:} TAB RET \\end{figure}"))

; ref for schatz
(defalias 'ref (read-kbd-macro
"{\\footnotesize []} C-b C-b"))

(defalias 'hsp (read-kbd-macro
"\\hspace{0.05\\textwidth} C-n"))

;; frame (for beamer latex)
(fset 'frame
   [?\\ ?b ?e ?g ?i ?n ?{ ?f ?r ?a ?m ?e ?} ?\\ ?f ?r ?a ?m ?e ?t ?i
	?t ?l ?e ?{ ?} return return return
        return ?\\ ?e ?n ?d ?{ ?f ?r ?a ?m ?e ?} up up up up ])

; align
(defalias 'align (read-kbd-macro
"\\begin{align} RET RET \\end{align} TAB C-p TAB"))

;; columns env (beamer latex)
(fset 'columns
   [tab ?\\ ?b ?e ?g ?i ?n ?{ ?c ?o ?l ?u ?m ?n ?s ?} return return tab ?\\ ?c ?o ?l ?u ?m ?n ?{ ?0 ?. ?5 ?\\ ?t ?e ?x ?t ?w ?i ?d ?t ?h ?} return return tab ?\\ ?c ?o ?l ?u ?m ?n ?{ ?0 ?. ?5 ?\\ ?t ?e ?x ?t ?w ?i ?d ?t ?h ?} return return ?\\ ?e ?n ?d ?{ ?c ?o ?l ?u ?m ?n ?s ?} tab up up up up ?\C-e return return tab])


; DOCUMENT comment for yorick
(defalias 'doc (read-kbd-macro
"TAB /* SPC DOCUMENT RET */ 3*<up> C-a M-f <right> C-SPC C-e M-w 2*<down> C-e SPC C-y RET TAB 2*SPC"))


(setq-default next-line-add-newlines nil)


; definiert Funktion fuer Euro-Symbol
(defun insert-general-currency-sign ()
   (interactive "*")
!  (insert (string 164))
)
; definiert Funktion fuer scharfes s
(defun insert-ss ()
   (interactive "*")
!  (insert (string 223))
)


;;;;;;;;;;;;;;;;;;; special keys ;;;;;;;;;;;;;;;;;;;


; europaeische Schriftzeichen
; (load "iso-insert")
;(standard-display-european 1)
;(global-set-key "\C-ce" 'insert-general-currency-sign)

; Tastenkombinationen fuer Umlaute
(global-set-key "\C-cau" 'insert-a-umlaut)
(global-set-key "\C-cuu" 'insert-u-umlaut)
(global-set-key "\C-cou" 'insert-o-umlaut)
(global-set-key "\C-cAu" 'insert-A-umlaut)
(global-set-key "\C-cUu" 'insert-U-umlaut)
(global-set-key "\C-cOu" 'insert-O-umlaut)
(global-set-key "\C-css" 'insert-ss)
; Skandinavisches o
(global-set-key "\C-cao" 'insert-a-ring)
(global-set-key "\C-cAo" 'insert-A-ring)
; französische Accents
(global-set-key "\C-cee" 'insert-e-acute)
(global-set-key "\C-cag" 'insert-a-grave)
(global-set-key "\C-ceg" 'insert-e-grave)
(global-set-key "\C-cog" 'insert-o-grave)
(global-set-key "\C-cug" 'insert-u-grave)
(global-set-key "\C-cac" 'insert-a-circumflex)
(global-set-key "\C-cec" 'insert-e-circumflex)
(global-set-key "\C-cic" 'insert-i-circumflex)
(global-set-key "\C-coc" 'insert-o-circumflex)
(global-set-key "\C-ccs" 'insert-c-cedilla)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(set-c-style ellementel)
(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'statement-block-intro 3)
  (c-set-offset 'defun-block-intro 3)
  (c-set-offset 'case-label 3)
  (c-set-offset 'statement-case-intro 3)
  (c-set-offset 'statement 0)
)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;(fset 'up-command-and-insert)

(defun up-command-and-insert ()
  (interactive "*")
  (self-insert-command 1)
;  (beginning-of-line)
  (kill-line 0)
  (comint-previous-prompt 1)
  (comint-copy-old-input)
;  (set-mark-command 0)
;  (beginning-of-line)

)

;(define-key shell-mode-map [up] 'up-command-and-insert)


(defun my-shell-mode-hook ()
  (define-key keymap <up> 'up-command-and-insert)
)
(add-hook 'shell-mode-hook 'my-shell-mode-hook)


;;;; yorick ;;;;
;(load "/usr/share/yorick/1.5/yorick.el" nil t)

(setq load-path (append (list (expand-file-name "~/.site-lisp")) load-path))


(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)


;(put 'set-goal-column 'disabled nil)

;(autoload 'server-edit "server" nil t)
;(server-edit)

(autoload 'server-edit "server" nil t)
; (server-start)    ; for emacs
;(gnuserv-start)  ; for xemacs






; t -> nil: Jans Nerven -> kaputt
(setq visible-bell t)

;; Go to the matching parenthesis when you press
;; % if on parenthesis otherwise insert %
(defun goto-matching-paren-or-insert (arg)
(interactive "p")
(cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
      ((looking-at "[])}]") (forward-char) (backward-sexp 1))
       (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'goto-matching-paren-or-insert)

(global-hl-line-mode 1)                   ;; High-light current line
(set-face-background 'hl-line "#fffacd")  ;; Set high-light color

;(set-face-font 'default "-adobe-courier-medium-r-normal--10-120-75-75-m-70-iso8859-9")
(set-face-font 'default "-apple-monaco-medium-r-normal--10-0-72-72-m-0-iso10646-1")
(setq mouse-wheel-mode t)


(defun scroll-up-n (event)
"Scroll up five lines."
(interactive "e")
(scroll-up 3))


(defun scroll-down-n (event)
"Scroll down five lines."
(interactive "e")
(scroll-down 3))

;(global-set-key 'button5 'scroll-up-n)
;(global-set-key 'button4 'scroll-down-n)


(put 'downcase-region 'disabled nil)

(setq ess-fancy-comments nil)


;(load "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/lilypond-init.el" nil t)
;(load "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/lilypond-words.el" nil t)
;(load "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/lilypond-font-lock.el" nil t)
;(load "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/lilypond-indent.el" nil t)
;(load "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/lilypond-mode.el" nil t)
;(load "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/lilypond-what-beat.el" nil t)

(autoload 'LilyPond-mode "lilypond-mode")
(setq auto-mode-alist
      (cons '("\\.ly$" . LilyPond-mode) auto-mode-alist))

(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))


; Set Alt (option key) as meta modifier
;(setq mac-option-modifier 'meta)

(setq auto-mode-alist (cons '("\\.F90$" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.gnu$" . shell-script-mode) auto-mode-alist))

(fset 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)

; end
