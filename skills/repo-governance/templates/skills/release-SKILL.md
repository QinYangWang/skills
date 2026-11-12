<!-- FILL: instantiate this template. Replace every <PLACEHOLDER>, run every
command once, delete this block. Budget: 80 lines. -->
---
name: release-<project>
description: >-
  Cut a release of <PROJECT> by building and opening the artifact users install,
  publishing from the verified commit, and confirming the published version
  from outside. Use for a tag, a package publish, or a store or app build.
---

# Release <PROJECT>

A tag is not a release. The artifact users install is opened and executed before
the version is announced.

<!-- repo-governance skill: release v1 -->

## When this runs

A tag, a publish, a store build — anything a user installs. Not for a commit
that only lands on the default branch.

## If it did not help

If the artifact cannot be built or opened here (no signing identity, no store
access, a platform you are not on), stop and list exactly which step is
unverified. A release never opened is not released; say so before the version
is announced.

## 1. Preconditions

- Clean tree at the release commit; `<version source>` is the single source of
  truth.
- Full suite green at the head being released, recorded with its CI run id.
- Owner sign-off for a major version, a store submission, a yank, or money.

## 2. Build the artifact, not the dev command

```bash
<build or pack command>     # produces <artifact path>, the file users install
<checksum command>          # sha256sum / shasum -a 256 <artifact>
```

## 3. Open it against real old state

- Install or run the artifact in `<scratch dir>`, seeded from a copy of a real
  data directory at `<previous version>`.
- Exercise the top user path: `<command> → <expected output>`.
- Migration runs forward on the copy; no data loss observed.
- Edge worth checking here: `<offline / permissions / empty state / upgrade from
  the previous minor>`.

## 4. Publish

- Tag `<vX.Y.Z>` on the verified commit; push the tag, not the branch.
- Assets: `<artifact list>`. Only the highest stable version may carry the
  latest marker; prereleases never do.
- Every version string in a user-facing message matches what was published:
  `<npm view / download URL / store listing>`.

## 5. Confirm from outside

```bash
<install from the public source into a scratch dir>
<artifact> --version      # must print the released version
```

Record the transcript. A release never installed from its public source is
unverified, whatever the CI badge says.

## 6. Rollback

- Yank `<how>` and publish `<patch or next>`; never re-tag a published version.
- Announce on `<channel>`. A public retraction is the owner's call.

## 7. Record

Version, commit, CI run id, checksums, install transcript, platforms and stores
not run, and who approved.