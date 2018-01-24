# Package this module.
package MyHook;

# Return errors if Perl experiences problems.
use strict;
user warnings;

# Use cPanel's error logging module.
use Cpanel::Logger;
  
# Use the core Perl module with file-copying functionality.
use File::Copy;
  
# Properly decode JSON.
use JSON;

# Instantiate the cPanel logging object.
my $logger = Cpanel::Logger->new();

# Embed hook attributes alongside the action code.
sub describe {
    my $hooks = [
        {
            'category' => 'System',
            'event'    => 'upcp',
            'stage'    => 'pre',
            'hook'     => 'MyHook::copyfile',
            'exectype' => 'module',
        },{
            'category' => 'System',
            'event'    => 'upcp',
            'stage'    => 'post',
            'hook'     => 'MyHook::replacefile',
            'exectype' => 'module',
        }
    ];
    return $hooks;
}
