# SHAI changes

Based on Tecnativa upstream commit `2e118a0` (`v0.5.0`).

- Pinned the HAProxy base image by multi-platform manifest digest.
- Enabled only the read endpoints SHAI monitoring needs by default:
  containers, events, info, ping, and version.
- Permanently limited the HAProxy allowlist to GET/HEAD requests for containers,
  events, info, ping, and version. POST, exec, image, network, volume, system,
  swarm, service, secret, configuration, build, commit, authentication, and all
  lifecycle operations remain denied even if an environment variable is set.
- Added SHAI/Open Container Initiative image labels and a startup permission
  summary.
- Added SHAI tests for read-only monitoring, denied lifecycle/exec calls, and
  unknown-path default denial. CI runs the proxy with all capabilities dropped,
  a read-only root filesystem, constrained tmpfs mounts, no-new-privileges, and
  a read-only socket mount.
- SHAI deployment does not publish the listener to a host or LAN port.

The proxy remains a policy boundary, not a claim that the Docker API is safe.
Only trusted monitoring components may share its private network.
