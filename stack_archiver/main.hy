(require
  hyrule [unless])

(import
  datetime [datetime]
  re
  sys
  os
  errno
  json
  hyrule [inc parse-args]
  stackapi [StackAPI]
  stack-archiver)

(setv myfilter "J9AyJbBs)0ihSyjDgkoFO")
  ; http://api.stackexchange.com/2.2/filters/create?include=question.body_markdown;answer.body_markdown;comment.body_markdown;comment.body;question.share_link;answer.share_link;comment.link&unsafe=true
  ;
  ; We don't use comment.body, but if we don't include it,
  ; comment.body_markdown is omitted:
  ; http://stackapps.com/questions/4840

(defn main []

  (setv args (parse-args [
    ["FILE"
      :help "path to JSON file to save items in"]
    ["SITES"
      :help "comma-separated pairs of colon-separated site names and user IDs (e.g., 'stackoverflow:1451346,stats:14076')"]
    ["--save-every" :metavar "N" :type int :default 20
      :help "save after every N items"]
    ["-V" "--version" :action "version"
      :version (+ "stack_archiver " stack-archiver._version.__version__)]]))

  (setv sites (lfor
    x (.split args.SITES ",")
    :setv [name _ user] (.partition x ":")
    (dict :name name  :user user)))

  (setv data (try
    (with [o (open args.FILE)]
      (json.load o))
    (except [e IOError]
      (unless (= e.errno errno.ENOENT)
        (raise))
      [])))

  (setv last-data-len (len data))

  (defn save []
    (nonlocal data last-data-len)
    (when (= (len data) last-data-len)
      (return))
    (setv last-data-len (len data))
    (setv data (sorted data :key :creation_date))
    (with [o (open args.FILE "w")]
      (json.dump data o :sort-keys True
        :indent 2 :separators #("," ": ")
        :ensure-ascii False))
    (print "Saved."))

  (for [site sites]
    (setv api (StackAPI (:name site)))

    (setv fromdate (next
      (gfor
        x (reversed data)
        :if (.startswith (get x "U") (+ "https://" (:name site) "."))
        (inc (:creation_date x)))
      0))

    (for [
        tt ["question" "answer" "comment"]
        [item-i x] (enumerate (map dict (:items (.fetch api f"users/{(:user site)}/{tt}s"
          :fromdate fromdate :filter myfilter
          :order "asc" :sort "creation"))))]

      (print (:name site) tt)
      (setv d (dfor
        k ["creation_date" "last_activity_date" "title" "edited" "score"]
        :if (in k x)
        k (get x k)))
      (setv (get d "T") tt)
      (setv (get d "U") (if (= tt "comment")
        (re.sub r"/questions/(\d+)/[^#]+#" r"/q/\1#" (:link x))
        (:share-link x)))
      (setv (get d "body")
        (.replace (:body-markdown x) "\r\n" "\n"))
      (when (= (.get d "last_activity_date") (get d "creation_date"))
        (del (get d "last_activity_date")))

      (.append data d)

      (when (= (% item-i args.save-every) 0)
        (save))))

  (save))
