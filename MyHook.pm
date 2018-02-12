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
# This piece is the actual hook
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

# Set the file to preserve and the temp file location.
my $preserve = "/usr/local/cpanel/base/horde/turba/config/backends.php";
my $temp = "/usr/local/cpanel/base/horde/turba/config/backends.php.temp";

#Before upcp, copy the file to the temp file. 
sub copyfile {
  #Get the data that the system passes to the hook
  my ( $context, $data ) = @_;
  
  #Add a log entry for debugging.
  $logger->info("***** Copy my file before upcp *****");
 
  # Copy my file.
  copy($preserve,$temp) or die "Copy failed: $!";
};

# After upcp, copy the file back into place.
sub replacefile {
    # Get the data that the system passes to the hook.
    my ( $context, $data ) = @_;
 
    # Add a log entry for debugging.
    $logger->info("***** Replace the temp file *****");
 
    # Replace my file.
    copy($temp,$preserve) or die "Replacement failed: $!";
 
    # Add a log entry for debugging.
    $logger->info("***** Delete the temp file *****");
 
    # Delete the temp file to keep cruft off my system.
    unlink($temp) or die "Cruft removal failed: $!";
};

