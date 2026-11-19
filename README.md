# osl-nfs cookbook

Sets up an NFS server (through the upstream `nfs` cookbook's `nfs_server`) and opens its ports in the
firewall (through `osl_firewall_nfs`).

## Requirements

- AlmaLinux 8, 9 or 10
- Cinc / Chef >= 16
- Cookbooks: `nfs` (~> 6.0.0), `osl-firewall`

## Recipes

- `osl-nfs::default` declares `osl_nfs_server 'default'` with no allowed sources, so the NFS ports are
  open to OSL-managed ranges only (`osl_only`).
- `osl-nfs::homes` serves `/data/homes/` to the Milne workstation subnet and opens the NFS ports to
  `10.162.136.0/24` only.

## Resources

### osl_nfs_server

Installs and starts the NFS server and opens its ports (111, 2049, 32765-32769, tcp and udp).

```ruby
osl_nfs_server 'default' do
  allowed_ipv4 %w(192.0.2.0/24 198.51.100.10)
end
```

| Property | Type | Default | Description |
|---|---|---|---|
| `allowed_ipv4` | Array | `[]` | IPv4 addresses or CIDRs allowed to reach the NFS ports |
| `allowed_ipv6` | Array | `[]` | IPv6 addresses or CIDRs allowed to reach the NFS ports |

- With both lists empty, the ports go through `osl_only`, as `osl-nfs::default` has always done.
- With either list set, only the listed sources are accepted, and an empty list closes that family: set
  `allowed_ipv4` alone and IPv6 clients can't reach the NFS ports. Entries must parse as addresses of
  the list's family, or the converge fails.
- Declare one `osl_nfs_server` per node. A second one fails the converge, since it would leave the
  `osl_only` rules beside the limited ones. A node that needs limited sources declares the resource
  instead of including `osl-nfs::default`; use `edit_resource!(:osl_nfs_server, 'default')` where
  another recipe already includes it.
- Exports are declared by the caller with the `nfs` cookbook's `nfs_export`.

## Author

Author:: Oregon State University (<systems@osuosl.org>)
