# smoke tests of the function member
#
# puppet apply --noop --modulepath='..' tests/member_regex.pp

$myhash = loadyaml('tests/member_regex.yaml')

info("member_regex([$myhash['array'],'d'):", member_regex(['a','b',$myhash['array']],'d'))
info('member_regex([\'a\',\'b\'],\'c\'):', member_regex(['a','b'],'d'))
