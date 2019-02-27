unlet b:current_syntax
syntax include @Ruby syntax/ruby.vim
syntax region rubyCode  start=+\~\{3\}\s*ruby+ keepend end=+\~\{3\}+  contains=@Ruby

unlet b:current_syntax
syntax include @Json syntax/json.vim
syntax region jsonCode  start=+\~\{3\}\s*json+ keepend end=+\~\{3\}+  contains=@Json
syntax region noCode  start=+\~\{3\}\s*$+ keepend end=+\~\{3\}+  contains=NONE

