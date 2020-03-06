# unix.confs

This is a meta-repository for various dotfiles, it builds and releases every week if anything has changed since the last time it built. In all honesty, it's half hoping that submodules have lost enough suck to work well for things like this since way back when they were first introduced, half wanting to have both fine- and large-grained control over configs, and half wanting to use actions for something.


Running `install` from this repo, or any of the repos it aggregates will symlink all the dotfiles tracked here into `$HOME`. Pre-existing files will be moved to `filename.bak` so we don't clobber anything. In general, where possible configs source an additional local configuration file and/or platform-specific ones at their end.


Issues/PRs for the child repos should be opened on their pages, but we'll still pay attention to them if they're opened here.
