;;; rails-ui.el --- emacs-rails user interface

;; Copyright (C) 2006 Dmitry Galinsky <dima dot exe at gmail dot com>

;; Authors: Dmitry Galinsky <dima dot exe at gmail dot com>,
;;          Rezikov Peter <crazypit13 (at) gmail.com>

;; Keywords: ruby rails languages oop
;; $URL: svn://rubyforge.org/var/svn/emacs-rails/trunk/rails-ui.el $
;; $Id: rails-ui.el 139 2007-03-27 23:19:10Z dimaexe $

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


;;;;;;;;;; Some init code ;;;;;;;;;;

(define-keys rails-minor-mode-menu-bar-map

  ([rails] (cons "RubyOnRails" (make-sparse-keymap "RubyOnRails")))

  ([rails rails-customize] '(menu-item "Customize"
                                       (lambda () (interactive) (customize-group 'rails))
                                       :enable (rails-core:root)))
  ([rails separator0] '("--"))
  ([rails svn-status] '(menu-item "SVN status" rails-svn-status-into-root
                                  :enable (rails-core:root)))
  ([rails api-doc]           '("Rails API doc at point" . rails-browse-api-at-point))
  ([rails sql]               '("SQL Rails buffer"       . rails-run-sql))
  ([rails tag]               '("Update TAGS file"       . rails-create-tags))
  ([rails ri]                '("Search documentation"   . rails-search-doc))
  ([rails goto-file-by-line] '("Goto file by line"      . rails-goto-file-on-current-line))
  ([rails switch-file-menu]  '("Switch file menu..."    . rails-lib:run-secondary-switch))
  ([rails switch-file]       '("Switch file"            . rails-lib:run-primary-switch))
  ([rails separator1]        '("--"))

  ([rails log] (cons "Open log files" (make-sparse-keymap "Open log files")))
  ([rails log test]      '("test.log"         . rails-log:open-test))
  ([rails log pro]       '("production.log"   . rails-log:open-production))
  ([rails log dev]       '("development.log"  . rails-log:open-development))
  ([rails log separator] '("---"))
  ([rails log open]      '("Open log file..." . rails-log:open))

  ([rails config] (cons "Configuration" (make-sparse-keymap "Configuration")))
  ([rails config routes]      '("routes.rb" .
                                (lambda () (interactive)
                                  (rails-core:find-file "config/routes.rb"))))
  ([rails config environment] '("environment.rb" .
                                (lambda() (interactive)
                                  (rails-core:find-file "config/environment.rb"))))
  ([rails config database]    '("database.yml" .
                                (lambda() (interactive)
                                  (rails-core:find-file "config/database.yml"))))
  ([rails config boot]        '("boot.rb" .
                                (lambda() (interactive)
                                  (rails-core:find-file "config/boot.rb"))))

  ([rails config env] (cons "environments" (make-sparse-keymap "environments")))
  ([rails config env test]        '("test.rb" .
                                    (lambda() (interactive)
                                      (rails-core:find-file "config/environments/test.rb"))))
  ([rails config env production]  '("production.rb" .
                                    (lambda() (interactive)
                                      (rails-core:find-file "config/environments/production.rb"))))
  ([rails config env development] '("development.rb" .
                                    (lambda()(interactive)
                                      (rails-core:find-file "config/environments/development.rb"))))

  ([rails scr] (cons "Scripts" (make-sparse-keymap "Scripts")))

  ([rails scr gen] (cons "Generate" (make-sparse-keymap "Generate")))
  ([rails scr destr] (cons "Destroy" (make-sparse-keymap "Generators")))

  ([rails scr destr resource]   '("Resource"        . rails-script:destroy-resource))
  ([rails scr destr observer]   '("Observer"        . rails-script:destroy-observer))
  ([rails scr destr mailer]     '("Mailer"          . rails-script:destroy-mailer))
  ([rails scr destr plugin]     '("Plugin"          . rails-script:destroy-plugin))
  ([rails scr destr migration]  '("Migration"       . rails-script:destroy-migration))
  ([rails scr destr scaffold]   '("Scaffold"        . rails-script:destroy-scaffold))
  ([rails scr destr model]      '("Model"           . rails-script:destroy-model))
  ([rails scr destr controller] '("Controller"      . rails-script:destroy-controller))
  ([rails scr destr separator]  '("--"))
  ([rails scr destr run]        '("Run destroy ..." . rails-script:destroy))

  ([rails scr gen resource]   '("Resource"         . rails-script:generate-resource))
  ([rails scr gen observer]   '("Observer"         . rails-script:generate-observer))
  ([rails scr gen mailer]     '("Mailer"           . rails-script:generate-mailer))
  ([rails scr gen plugin]     '("Plugin"           . rails-script:generate-plugin))
  ([rails scr gen migration]  '("Migration"        . rails-script:generate-migration))
  ([rails scr gen scaffold]   '("Scaffold"         . rails-script:generate-scaffold))
  ([rails scr gen model]      '("Model"            . rails-script:generate-model))
  ([rails scr gen controller] '("Controller"       . rails-script:generate-controller))
  ([rails scr gen separator]  '("--"))
  ([rails scr gen run]        '("Run generate ..." . rails-script:generate))

  ([rails scr break]   '("Breakpointer"         . rails-script:breakpointer))
  ([rails scr console] '("Console"              . rails-script:console))
  ([rails scr rake]    '("Rake..."              . rails-rake:task))


  ([rails tests] (cons "Tests" (make-sparse-keymap "Tests")))
  ([rails tests integration]    '("Integration tests" . (lambda() (interactive) (rails-rake:test "integration"))))
  ([rails tests unit]           '("Unit tests"        . (lambda() (interactive) (rails-rake:test "units"))))
  ([rails tests functional]     '("Functional tests"  . (lambda() (interactive) (rails-rake:test "functionals"))))
  ([rails tests recent]         '("Recent tests"      . (lambda() (interactive) (rails-rake:test "recent"))))
  ([rails tests tests]          '("All"               . (lambda() (interactive) (rails-rake:test "all"))))
  ([rails tests separator]      '("--"))
  ([rails tests toggle]         '("Toggle output window"                 . rails-script:toggle-output-window))
  ([rails tests run-current]    '("Test current model/controller/mailer" . rails-rake:test-current))
  ([rails tests run]            '("Run tests ..."                        . rails-rake:test))



  ([rails ws] (cons "Web Server" (make-sparse-keymap "WebServer")))

  ([rails ws use-webrick]  '(menu-item "Use WEBrick" (lambda() (interactive)
                                                       (rails-ws:switch-default-server-type "webrick"))
                                       :button (:toggle . (rails-ws:default-server-type-p "webrick"))))
  ([rails ws use-lighttpd] '(menu-item "Use Lighty" (lambda() (interactive)
                                                      (rails-ws:switch-default-server-type "lighttpd"))
                                       :button (:toggle . (rails-ws:default-server-type-p "lighttpd"))))
  ([rails ws use-mongrel]  '(menu-item "Use Mongrel" (lambda() (interactive)
                                                       (rails-ws:switch-default-server-type "mongrel"))
                                       :button (:toggle . (rails-ws:default-server-type-p "mongrel"))))
  ([rails ws separator] '("--"))

  ([rails ws brows]      '(menu-item "Open browser..." rails-ws:open-browser-on-controller
                                     :enable (rails-ws:running-p)))
  ([rails ws auto-brows] '(menu-item "Open browser on current action" rails-ws:auto-open-browser
                                     :enable (rails-ws:running-p)))
  ([rails ws url]        '(menu-item "Open browser" rails-ws:open-browser
                                     :enable (rails-ws:running-p)))
  ([rails ws separator2] '("--"))

  ([rails ws test]        '(menu-item "Start test" rails-ws:start-test
                                      :enable (not (rails-ws:running-p))))
  ([rails ws production]  '(menu-item "Start production" rails-ws:start-production
                                      :enable (not (rails-ws:running-p))))
  ([rails ws development] '(menu-item "Start development" rails-ws:start-development
                                      :enable (not (rails-ws:running-p))))
  ([rails ws separator3] '("--"))

  ([rails ws status]  '(menu-item "Print status"                                     rails-ws:print-status))
  ([rails ws default] '(menu-item "Start/stop web server (with default environment)" rails-ws:toggle-start-stop))

  ([rails separator2] '("--"))

  ([rails goto-fixtures]    '("Go to fixtures"    . rails-nav:goto-fixtures))
  ([rails goto-plugins]     '("Go to plugins"     . rails-nav:goto-plugins))
  ([rails goto-migrate]     '("Go to migrations"  . rails-nav:goto-migrate))
  ([rails goto-layouts]     '("Go to layouts"     . rails-nav:goto-layouts))
  ([rails goto-stylesheets] '("Go to stylesheets" . rails-nav:goto-stylesheets))
  ([rails goto-javascripts] '("Go to javascripts" . rails-nav:goto-javascripts))
  ([rails goto-helpers]     '("Go to helpers"     . rails-nav:goto-helpers))
  ([rails goto-mailers]     '("Go to mailers"     . rails-nav:goto-mailers))
  ([rails goto-observers]   '("Go to observers"   . rails-nav:goto-observers))
  ([rails goto-models]      '("Go to models"      . rails-nav:goto-models))
  ([rails goto-controllers] '("Go to controllers" . rails-nav:goto-controllers)))

(setq rails-minor-mode-map (make-sparse-keymap))

(define-keys rails-minor-mode-map
  ([menu-bar] rails-minor-mode-menu-bar-map)
  ([menu-bar snippets] (cons "Snippets" (rails-snippets:create-keymap)))
  ;; Goto
  ((kbd "\C-c \C-c g m") 'rails-nav:goto-models)
  ((kbd "\C-c \C-c g c") 'rails-nav:goto-controllers)
  ((kbd "\C-c \C-c g o") 'rails-nav:goto-observers)
  ((kbd "\C-c \C-c g n") 'rails-nav:goto-mailers)
  ((kbd "\C-c \C-c g h") 'rails-nav:goto-helpers)
  ((kbd "\C-c \C-c g l") 'rails-nav:goto-layouts)
  ((kbd "\C-c \C-c g s") 'rails-nav:goto-stylesheets)
  ((kbd "\C-c \C-c g j") 'rails-nav:goto-javascripts)
  ((kbd "\C-c \C-c g g") 'rails-nav:goto-migrate)
  ((kbd "\C-c \C-c g p") 'rails-nav:goto-plugins)
  ((kbd "\C-c \C-c g f") 'rails-nav:goto-fixtures)

  ;; Switch
  ((kbd "\C-c <up>")      'rails-lib:run-primary-switch)
  ((kbd "\C-c <down>")    'rails-lib:run-secondary-switch)
  ((kbd "<M-S-up>")      'rails-lib:run-primary-switch)
  ((kbd "<M-S-down>")    'rails-lib:run-secondary-switch)
  ((kbd "<C-return>")    'rails-goto-file-on-current-line)

  ;; Scripts & SQL
  ((kbd "\C-c \C-c e")   'rails-script:generate)
  ((kbd "\C-c \C-c d")   'rails-script:destroy)
  ((kbd "\C-c \C-c s c") 'rails-script:console)
  ((kbd "\C-c \C-c s b") 'rails-script:breakpointer)
  ((kbd "\C-c \C-c s s") 'rails-run-sql)
  ((kbd "\C-c \C-c w s") 'rails-ws:toggle-start-stop)
  ((kbd "\C-c \C-c w d") 'rails-ws:start-development)
  ((kbd "\C-c \C-c w p") 'rails-ws:start-production)
  ((kbd "\C-c \C-c w t") 'rails-ws:start-test)
  ((kbd "\C-c \C-c w i") 'rails-ws:print-status)
  ((kbd "\C-c \C-c w a") 'rails-ws:auto-open-browser)

  ;; Rails finds
  ((kbd "\C-c \C-c f m") 'rails-find:models)
  ((kbd "\C-c \C-c f c") 'rails-find:controller)
  ((kbd "\C-c \C-c f h") 'rails-find:helpers)
  ((kbd "\C-c \C-c f l") 'rails-find:layout)
  ((kbd "\C-c \C-c f s") 'rails-find:stylesheets)
  ((kbd "\C-c \C-c f j") 'rails-find:javascripts)
  ((kbd "\C-c \C-c f g") 'rails-find:migrate)
  ((kbd "\C-c \C-c f b") 'rails-find:lib)
  ((kbd "\C-c \C-c f t") 'rails-find:tasks)
  ((kbd "\C-c \C-c f v") 'rails-find:view)
  ((kbd "\C-c \C-c f d") 'rails-find:db)
  ((kbd "\C-c \C-c f p") 'rails-find:public)
  ((kbd "\C-c \C-c f f") 'rails-find:fixtures)
  ((kbd "\C-c \C-c f o") 'rails-find:config)

  ;; Tests
  ((kbd "\C-c \C-c r")   'rails-rake:task)
  ((kbd "\C-c \C-c t")   'rails-rake:test)
  ((kbd "\C-c \C-c .")   'rails-rake:test-current)

  ;; Navigation

  ((kbd "\C-c \C-c l")    'rails-log:open)
  ;; Tags
  ((kbd "\C-c \C-c \C-t") 'rails-create-tags)

  ;; Documentation
  ([f1]                  'rails-search-doc)
  ((kbd "<C-f1>")        'rails-browse-api-at-point)
  ((kbd "\C-c <f1>")     'rails-browse-api)
  ((kbd "\C-c /")        'rails-script:toggle-output-window)

  ([f9]                  'rails-svn-status-into-root))

;; Global keys and menubar

(global-set-key (kbd "\C-c \C-c j") 'rails-script:create-project)

(when (lookup-key global-map  [menu-bar file])
  (define-key-after
    (lookup-key global-map  [menu-bar file])
    [create-rails-project]
    '("Create Rails Project" . rails-script:create-project) 'insert-file))

(provide 'rails-ui)