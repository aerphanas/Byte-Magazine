(ql:quickload '(dexador lquery))

(defvar *link* "https://vintageapple.org/byte/")
(defvar *output-file* "./url.txt")

(defvar *parsed-content*
  (lquery:$ (initialize (dex:get *link*))))

(defvar *list-links*
  (let ((vector-links (lquery:$  *parsed-content* "a" (attr :href))))
    (mapcar (lambda (x) (concatenate 'string *link* x))
	    (cddr (cddddr (coerce vector-links 'list))))))

(defun out-to-file (path)
  (with-open-file (stream path
			  :direction
			  :output
			  :if-exists :overwrite
			  :if-does-not-exist :create)
    (loop
      for i
	in *list-links*
      do (format stream i)
	 (terpri stream))))

(defun main ()
  (out-to-file *output-file*)
  (uiop:run-program
   (format nil "wget -i ~a -P output" *output-file*)
   :output :string))
