```
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\_|
```

# Automaton | (Holloway) Chew, Kean Ho's Software

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

***Automate Reliably. Scale Confidently.***

`Automaton` is `(Holloway) Chew, Kean Ho`'s production-grade automation
toolchain that unifies your CI jobs across platforms using plain shell and
PowerShell scripts, bootstrapped by a single polyglot script. This includes
manual human intervention where one can debug the processes at will without
affecting the CI pipelines.

It solves the following business problems:

* **No Vendor Lock-In** - Take full control over your production process
  entirely. Your pipelines live in your repository, not in any provider's
  console. Hence, they outlive any single vendor's pricing or roadmap changes.
* **Zero Runtime Dependencies** - It just works! Automaton boots with what each
  OS already ships: a POSIX shell on Linux/macOS, PowerShell on Windows. Nothing
  to install before first use. In fact, use Automaton to install the tools and
  set up the environment instead!
* **Manual Intervention Capable** - Test any CI job on your own laptop before
  it touches CI: no more silly, noisy "fix CI" commits.
* **Full Downstream Freedom** - It merely streamlines all triggers into your
  CI shell scripts. You develop your own processes therein with absolute
  freedom!
* **Lightweight to Install** - Just unpack a few shell and PowerShell scripts.
  No complicated installer. No unused bloat.
* **Tested Across Platforms** - GitHub.com, GitLab.com, Codeberg.org,
  self-hosted Forgejo, etc. This project tests on them whenever runners are
  available.
* **Learnt From The Past** - 2nd generation development based on learning from
  its predecessor: the [`(Holloway) Chew, Kean Ho's AutomataCI`](https://github.com/ChewKeanHo/software-automataci).




## Tested Platforms

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

These are the currently linked and tested platforms where
`(Holloway) Chew, Kean Ho's Automaton` is expected to work seamlessly:

| Platforms         | Runners          | Dashboard |
|:------------------|:-----------------|:----------|
| GitHub Actions    | `linux-latest`, `windows-latest`, `macos-latest` | [GitHub Actions Pipelines](https://github.com/ChewKeanHo/software-automaton/actions/workflows/git-push.yml) |
| Codeberg.org Actions  | `codeberg-tiny`, `codeberg-tiny-lazy`, `codeberg-small`, `codeberg-small-lazy`, `codeberg-medium`, `codeberg-medium-lazy` | [Codeberg.org Actions Pipeline](https://codeberg.org/chewkeanho/software-automaton/actions) |
| Forgejo Actions  | private tags | [References](https://forgejo.org/docs/next/user/actions/reference) |
| GitLab.com | `runner-saas-linux-small-amd64`, `saas-windows-medium-amd64` | [GitLab CI Pipelines](https://gitlab.com/chewkeanho/software-automaton/-/pipelines) |




## How It Works

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

The whole idea to unify both `Microsoft Windows` and `UNIX-based` operating
systems comes down to
[`(Holloway) Chew, Kean Ho's The Polyglot Scripts Research Project`](https://doi.org/10.5281/zenodo.19805433).
Without the polyglot shell scripts, it is **VERY DIFFICULT** to unite all the
operating systems without compromise.

The sequence of actions are as follows:

```
trigger
  |
  ▼
.internals/automaton/Start.sh.ps1
  |
  ▼
.internals/automaton/presenters/init.{sh,ps1}
  |
  ▼
.internals/ci/jobs/[JOB]/start.{sh,ps1}
```

1. A human, robot, or schedule triggers the repository's CI pipeline.
2. Every trigger calls the `.internals/automaton/Start.sh.ps1` polyglot script.
3. The polyglot script natively identifies the shell type and locates the
   project's init shell or PowerShell script (defaulting to
   `.internals/automaton/presenters/init.{sh,ps1}`).
4. The polyglot script sources the init script to initialize the CI and locate
   the CI job directory via the `$AUTOMATON_DIRECTORY_JOBS` environment
   variable.
5. Automaton searches for the job's start script (default:
   `.internals/ci/jobs/[JOB]/start.{sh,ps1}`).
6. Automaton source-imports (a.k.a. 'dot-imports') the job start script and
   hands control over.

That is all. It is now this simple compared to its predecessor. You get the full
freedom to develop your own process freely in the job's start scripts.

Due to this nature, human can intervene the automation process at any step for
localized process debugging and testing. Hence, one can test any job within the
laptop and computer before it touches actual CI pipelines.




## Installation

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

**COMING SOON**




## Verifying Content Integrity

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

To secure the content from unauthorized modification by anyone down to bit-level
(`0|1`), they are cryptographically signed using one or more cryptography tools
such as but not limited to:

* [GnuPG](https://gnupg.org); AND/OR
* [OpenSSL](https://www.openssl.org/).

The public key and the associated certificate are attached. Only the main owner
keeps and maintains the private keys. To verify the content's integrity:



### GnuPG

1. Install [GnuPG](https://gnupg.org) software if not present.
2. Download the target file and its detached signature file (the `.asc` file
   with the same filename).
3. Download the public key file (`.gpg`).
4. Place them next to each other in the directory.
5. Open a terminal and execute the following command:

```
$ gpg --no-default-keyring --keyring /path/to/public.gpg --verify /path/to/file.asc
```



### OpenSSL

1. Install [OpenSSL](https://www.openssl.org) software if not present.
2. Download the target file and its detached signature file (the `.sig`/`.sign`
   file with the same filename).
3. Download the public certificate file (`.pem`) containing the public key
   within.
4. Place them next to each other in the directory.
5. Open a terminal and execute the following command:

```
$ openssl dgst -verify /path/to/pubkey.pem -signature /path/to/file.sig /path/to/file
```




## Artificial Intelligence (A.I.) Decrees

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

Please refer to [AI_DECREES.md](AI_DECREES.md) for the project's policy on the
use of Artificial Intelligence.




## Maintainers' Notes

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md) for contributing &
maintenances guidelines.




## License

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

* [Agreed GIMP License](.internals/terms-of-services/GimpORG-License.pdf)
* [Agreed GIMP Privacy Policy](.internals/privacy-policy/GimpORG-Privacy-Policy.pdf)
* [Agreed Inkscape License](.internals/terms-of-services/Inkscape-License.pdf)
* [Agreed Inkscape Privacy Policy](.internals/privacy-policy/Inkscape-Privacy-Policy.pdf)

This entire repository is licensed under [BSD Zero Clause License](LICENSE.txt).
To ensure better understanding of this license, the following sub-sections will
briefly describe how to deploy the content.

For registered non-profit organizations (NGO), you are considered a
`Commercial Entity` the same as any for-profit organization by default. However,
you will be eligible for the NGO disbursement grant and receive exception
privileges from the creator(s).



### Attribution

This license **DOES NOT** mandate attribution requirement. Unless absolutely
needed, you may attribute back to the creator(s) as follows:

```
Title: (Holloway) Chew, Kean Ho's Automaton
Creators: (Holloway) Chew, Kean Ho
Contact: hello@chewkeanho.com
SKU: chewkeanho-software-automaton
UUID: 77EFA9DB-18A0-4279-A885-BBB5769A116B
License: BSD Zero Clause License (https://opensource.org/licenses/0BSD)
Repository Made On: 2026-09-09
Repository Made From: Malaysia, South East Asia
Procure: https://github.com/ChewKeanHo/software-automaton
```



### Ownership - Personal

> [!NOTE]
>
> This targets any customer wanting to own a copy of the content and then only
> he/she is using it without sharing with any 3rd-party entity; AND **WITHOUT**
> any monetary intention such as but not limited to:
>
> * Saving a local copy and then viewing via his/her own mobile device(s); OR
> * Saving a local copy and then viewing via his/her own personal computer; OR
> * Saving a local copy for artificial intelligence data training purposes.

You are **ALLOWED** without any restriction.



### Ownership - Commercial

> [!NOTE]
>
> This targets any customer wanting to own a copy of the content and then only
> he/she is using it without sharing with any 3rd-party entity; AND **WITH** any
> monetary intention such as but not limited to:
>
> * Saving a local copy for enhancing his/her company's procurement list; OR
> * Saving a local copy for commercial artificial intelligence data training
>   purposes.

You are **ALLOWED** without any restriction.



### Reference - Personal & Commercial

> [!NOTE]
>
> This targets any customer wanting to refer or to provide a guide for sourcing
> the original content for any 3rd-party entity **without directly displaying
> any portion of the original content**; **WITHOUT** any monetary intention such
> as but not limited to:
>
> * Academic research and paper writing; OR
> * New content creation linking to the original content **WITHOUT displaying
>   any of the original content** for his/her own streaming platform; OR
> * Content production and collection linking to original content **WITHOUT
>   displaying any of the original content**; OR
> * Web portfolio project linking to the original content **WITHOUT displaying
>   any of the original content**; OR
> * Event materials linking the original content **WITHOUT displaying any of the
>   original content**; OR
> * Meeting materials linking the original content **WITHOUT displaying any of
>   the original content**; OR
> * Advertisement contents linking the original content **WITHOUT displaying any
>   of the original content**.

You are **ALLOWED** without any restriction.



### Integration - Personal

> [!NOTE]
>
> This targets any customer wanting to directly **display portions and NOT ALL**
> of the original content **as it is OR without any composing remixes or
> modifications retaining the original intent, art direction and messages** into
> his/her content creation; **WITHOUT** any monetary intention such as but not
> limited to:
>
> * New content creation with displaying portion(s) of the original content for
>   his/her own streaming platform **without any monetary gain**; OR
> * Content production and collection with displaying portion(s) of the original
>   content **without any monetary gain**; OR
> * Web portfolio project with displaying portion(s) of the original content
>   **without any monetary gain**; OR
> * Event materials with displaying portion(s) of the original content
>   **without any monetary gain**; OR
> * Meeting materials with displaying portion(s) of the original content
>   **without any monetary gain**.

You are **ALLOWED** without any restriction.



### Integration - Commercial

> [!NOTE]
>
> This targets any customer wanting to directly **display portions and NOT ALL**
> of the original content **as it is OR without any composing remixes or
> modifications retaining the original intent, art direction and messages** into
> his/her content creation; **WITH** any monetary intention such as but not
> limited to:
>
> * New content creation with displaying portion(s) of the original content for
>   his/her own streaming platform; OR
> * Content production and collection with displaying portion(s) of the original
>   content; OR
> * Web portfolio project with displaying portion(s) of the original content; OR
> * Event materials with displaying portion(s) of the original content; OR
> * Meeting materials with displaying portion(s) of the original content; OR
> * Advertisement materials with displaying portion(s) of the original content.

You are **ALLOWED** without any restriction.



### Composition Remix - Personal

> [!NOTE]
>
> This targets any customer wanting to own and then **modify the original
> content extensively preserving or altering the original intent, art direction,
> or message** for composing his/her new content creation; **WITHOUT** any
> monetary intention such as but not limited to:
>
> * New content creation with digitally modified and processed original content
>   integration for his/her own streaming platform **WITHOUT** any profits
>   including advertisement commission; OR
> * Personal content production and collection with digitally modified and
>   processed original content integration for his/her own streaming platform
>   **WITHOUT** any profits including advertisement commission; OR
> * Personal web portfolio project with digitally modified and processed
>   original content integration for his/her own streaming platform **WITHOUT**
>   any profits including advertisement commission; OR
> * Social media meme content creation with digitally modified and processed
>   original content integration for his/her own streaming platform **WITHOUT**
>   any profits including advertisement commission.

You are **ALLOWED** without any restriction.



### Composition Remix - Commercial

> [!NOTE]
>
> This targets any customer wanting to own and then **modify the original
> content extensively preserving or altering the original intent, art direction,
> or message** for composing his/her new content creation; **WITH** any monetary
> intention such as but not limited to:
>
> * New content creation with digitally modified and processed original content
>   integration for his/her own streaming platform; OR
> * Personal content production and collection with digitally modified and
>   processed original content integration for his/her own streaming platform;
>   OR
> * Personal web portfolio project with digitally modified and processed
>   original content integration for his/her own streaming platform; OR
> * Social media meme content creation with digitally modified and processed
>   original content integration for his/her own streaming platform.

You are **ALLOWED** without any restriction.



### Broadcast or Resell Redistribution - Personal

> [!NOTE]
>
> This targets any customer wanting to share, to broadcast, to re-distribute,
> to sell, or to re-sell the original, **modified, OR derived** content
> **WITHOUT** any monetary intention such as but not limited to:
>
> * Sharing with family members; OR
> * Streaming the content via any streaming platform with private viewer
>   access; OR
> * Displaying the content in his/her gallery with privately invited guests; OR
> * Displaying the content in private, free entry open spaces like living room;
>   OR
> * Owning a copy of the original content and serving it as downloadable content
>   on a website in a private network (e.g. self-hosted home network); OR
> * Sharing the original content across social media or messaging applications
>   like email or instant messenger.

You are **ALLOWED** without any restriction.



### Broadcast or Resell Redistribution - Commercial

> [!NOTE]
>
> This targets any customer wanting to share, to broadcast, to re-distribute,
> to sell, or to re-sell the original, **modified, OR derived** content
> **WITH** any monetary intention such as but not limited to:
>
> * Streaming the content via any streaming platform with public or private
>   viewer access; OR
> * Displaying the content in any company's public events with free or payable
>   guest invites; OR
> * Displaying the content in any company's internal/private events with free or
>   payable guest invites; OR
> * Owning a copy of the original content and serving it as free OR payable
>   downloadable content on his/her website in any network (Internet, Intranet,
>   or private networks); OR
> * Sharing the original content across social media or messaging applications
>   like email or instant messenger; OR
> * Distributing the original content via multiple profit-earning streaming
>   platforms.

You are **ALLOWED** without any restriction.
