# Git syncer

To sync a git repository run

```
docker --rm kalbasit/git_syncer sync git@github.com:user/repo1.git git@github.com:user/repo2.git
```

If pushing to repo2 requires an SSH key, you can add an ssh key by
mounting it to `/root/.ssh/id_rsa` or by adding an SSH_KEY environment
variable.

The git_syncer mounts the volume `/data`. It's recommanded to mount
`/data` through a data only container.

```
docker run --name git_syncer_volumes -v /data busybox true 2>/dev/null || true
```
