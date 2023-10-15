;;; lsp-pylance.el --- pylance lsp                   -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Nasy

;; Author: Nasy <nasyxx@gmail.com>
;; Keywords: tools, languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; LSP for pylance

;;; Code:

(require 'lsp-mode)

(defvar lsp-pylance-executable (executable-find "pylance")
  "Pylance executable.

    #!/bin/bash
    set -euo pipefail

    node $HOME/.vscode/extensions/ms-python.vscode-pylance-2020.7.1/server/server.bundle.js --stdio")

(lsp-register-custom-settings
 `(("python.analysis.typeCheckingMode" lsp-pyright-typechecking-mode)
   ("python.analysis.diagnosticMode" lsp-pyright-diagnostic-mode)
   ("python.analysis.stubPath" lsp-pyright-stub-path)
   ("python.analysis.autoSearchPaths" lsp-pyright-auto-search-paths t)
   ("python.analysis.extraPaths" lsp-pyright-extra-paths)
   ("python.analysis.useLibraryCodeForTypes" lsp-pyright-use-library-code-for-types t)
   ("python.analysis.indexing" t)
   ("python.analysis.autoImportCompletions" lsp-pyright-auto-import-completions t)
   ("python.analysis.inlayHints.variableTypes" t)
   ("python.analysis.inlayHints.callArgumentNames" "partial")
   ("python.analysis.autoFormatStrings" t)
   ("python.analysis.typeshedPaths" lsp-pyright-typeshed-paths)
   ("python.analysis.logLevel" lsp-pyright-log-level)
   ("python.pythonPath" lsp-pyright-locate-python)
   ;; We need to send empty string, otherwise  pyright-langserver fails with parse error
   ("python.venvPath" (lambda () (or lsp-pyright-venv-path "")))))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection (lambda () lsp-pylance-executable)
                                        (lambda () (f-exists? lsp-pylance-executable)))
  :major-modes '(python-mode python-ts-mode)
  :server-id 'pylance
  :priority 2
  :initialized-fn (lambda (workspace)
                    (with-lsp-workspace workspace
                      ;; we send empty settings initially, LSP server will ask for the
                      ;; configuration of each workspace folder later separately
                      (lsp--set-configuration
                       (make-hash-table :test 'equal))))
  :notification-handlers (lsp-ht ("pylance/beginProgress"  'ignore)
                                 ("pylance/reportProgress" 'ignore)
                                 ("pylance/endProgress"    'ignore))))



(provide 'lsp-pylance)
;;; lsp-pylance.el ends here
