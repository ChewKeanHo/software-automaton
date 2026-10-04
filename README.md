# Automaton | (Holloway) Chew, Kean Ho's Software

```
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\_|
```

***Automate Reliably. Scale Confidently.***

`Automaton` is `(Holloway) Chew, Kean Ho`'s production-grade automation
toolchain that unifies your CI jobs across platforms using **ONLY** plain shell
and PowerShell scripts bootstrapped by a single polyglot script. This includes
manual human intervention capability where one can debug the processes at will
without affecting the CI pipelines.

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
| GitHub Actions    | `ubuntu-latest`, `windows-latest`, `macos-latest` | [GitHub Actions Pipelines](https://github.com/ChewKeanHo/software-automaton/actions/workflows/git-push.yml) |
| Codeberg.org Actions  | `codeberg-tiny`, `codeberg-tiny-lazy`, `codeberg-small`, `codeberg-small-lazy`, `codeberg-medium`, `codeberg-medium-lazy` | [Codeberg.org Actions Pipeline](https://codeberg.org/chewkeanho/software-automaton/actions) |
| Forgejo Actions  | `freebsd-amd64` | [References](https://forgejo.org/docs/next/user/actions/reference) |
| GitLab.com | `saas-linux-small-amd64`, `saas-windows-medium-amd64` | [GitLab CI Pipelines](https://gitlab.com/chewkeanho/software-automaton/-/pipelines) |
| Local (Manual)   | `freebsd-amd64` | Not Available |




## How It Works

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

The whole idea to unify both `Microsoft Windows` and `UNIX-based` operating
systems came from
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
6. Automaton source-imports (a.k.a. 'dot-imports') the CI job start script and
   hands full control over.

That is all. It is now this simple compared to its predecessor. You get the full
freedom to develop your own process freely in the job's start scripts.

Due to this nature, a human can intervene in the automation process at any step
for localized process debugging and testing. Hence, one can test any job within
the laptop and computer before it touches actual CI pipelines.




## Installation & Updates

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

To use `(Holloway) Chew, Kean Ho's Automaton` in your next project, the best
practices for installing, uninstalling, and updating are as follows:



### Download the Latest Version

To counter (nuisance) geopolitical threats, you can download the latest version
of `(Holloway) Chew, Kean Ho's Automaton` from the following mirror:

| Location            | URL                                                         |
|:--------------------|:------------------------------------------------------------|
| Global              | https://github.com/ChewKeanHo/software-automaton/releases   |
| Global              | https://codeberg.org/chewkeanho/software-automaton/releases |
| US (United States)  | https://github.com/ChewKeanHo/software-automaton/releases   |
| US (United States)  | https://gitlab.com/chewkeanho/software-automaton/-/releases |
| EU (European Union) | https://codeberg.org/chewkeanho/software-automaton/releases |
| EU (European Union) | https://doi.org/10.5281/zenodo.23129070                     |

1. You should download based on your extraction tool in your operating system
   such as but not limited to `tar`, `untar`, `gz`, `xz`, `zip`, or `unzip`.
   1. Note that although the packages are organized by operating systems, they
      are actually the same content. The packages are mainly for system
      compatibility purposes only.



### Verify Content Integrity

You should also download:

1. its GPG/PGP cryptographically signed certificate; AND
2. the public key

for cryptographically verify the package is healthy and
**IS GENUINELY FROM THE ORIGIN**. The command is to verify is as follows:

```
$ gpg --no-default-keyring --keyring /path/to/public-key.gpg --verify /path/to/file.asc
```

For GnuPG software, you can source it from
[GnuPG official website](https://gnupg.org).

Should GnuPG functioned healthy, it means everything is good. Otherwise, the
package is tainted and you **MUST** remove it at all cost. Try download from
another mirror and restart the content integrity verification again.



### Unpack The Payload

Once done, unpack the payload in your local computer.

for `.tar.gz` and `.tar.xz`:

```
$ tar -xvf chewkeanho_automaton_[VERSION]_[OS]_[ARCH].tar.[COMPRESSION] -C /path/to/directory

----

Example (for 1.0.0, freebsd, all, xz):

$ tar -xvf chewkeanho_automaton_1.0.0_freebsd_all.tar.xz -C /path/to/directory
```

for `.zip`:

```
$ unzip -d /path/to/directory chewkeanho_automaton_[VERSION]_[OS]_[ARCH].zip

----

Example (for 1.0.0, windows, all):

$ unzip -d /path/to/directory chewkeanho_automaton_1.0.0_windows_all.zip
```


### Copy/Overwrite into Your Repository

Place or overwrite existing `automaton/` directory inside your root repository
with such pathing:

```
your_project/
  |
  +-- .git/
  |
  +-- .internals/
          |
          +-- automaton/            <-- place or overwrite automaton/ here
```

That is how you add|update `(Holloway) Chew, Kean Ho's Automaton` into your
project.

> [!NOTE]
>
> The location can be any place inside the repository. The above is the default
> recommended location for keeping the repository clean.

Once done, provide execute permission to the script once:

```
cd your_project
$ chmod +x ./.internals/automaton/Start.sh.ps1
```

Then run `help` command from it:

```
$ ./.internals/automaton/Start.sh.ps1 help
```

If it works, your installation is now successful!



### Setup or Update CI Jobs Directory

If a CI job directory already exists, skip this step. Otherwise, setup or update
your CI Job directory as follows:

```
your_project/
  |
  +-- .git/
  |
  +-- .internals/
          |
          +-- automaton/
          |
          +-- ci/
               |
               +-- jobs/
                     |
                     +-- [JOB]/                <-- job name
                           +-- start.ps1       <-- PowerShell starter script
                           +-- start.sh        <-- POSIX Shell starter script
```

1. Basically, the directory name inside `.internals/ci/jobs/` is the job name.
   Have the freedom to create yours.
2. What you NEED to make sure are:
   1. The `[JOB]` name is as intended; AND
   2. There is a `start.ps1` for the `[JOB]`'s PowerShell starter script; AND
   3. There is a `start.sh` for the `[JOB]`'s POSIX Shell starter script.
3. You can create as many `[JOB]` as you like.

Once done, to check `(Holloway) Chew, Kean Ho's Automaton` search
functionalities, simply call `help` command again and observe the list of jobs
available to run. If your `[JOB]` directory name is listed, it is linked
correctly.

```
$ ./.internals/automaton/Start.sh.ps1 help
...
I: _________________________________________________________________________
I:
I: [JOBS]:
I:      * Archive                   <-- look for your [JOB] directory name here
I:      * Build
...
```

> [!NOTE]
>
> The CI directory can be explicitly defined to elsewhere using
> `$AUTOMATON_DIRECTORY_JOBS` (PowerShell: `${env:AUTOMATON_DIRECTORY_JOBS}`)
> environment variable. The above uses the default search path which is
> `.internals/ci/jobs/` directory.
>
> Example of such execution:
>
> ```
> AUTOMATON_DIRECTORY_JOBS=/path/to/elsewhere ./.internals/automaton/Start.sh.ps1 run [JOB]
> ```

> [!NOTE]
>
> For quick and lazy setup, the package actually distributes a default set of
> tested CI jobs as `ci/` directory. Refer below for instructions.



### Setup or Update CI Triggers

If there are CI triggers readily available, skip this step. Otherwise, setup or
update as follows:

```
your_project/
  |
  +-- .git/
  |
  +-- .github/
  |       |
  |       +-- workflows/
  |               |
  |               +-- [NAME].yml    <-- automated triggers in GitHub and Forgejo
  |
  |
  +-- .gitlab-ci.yml                <-- automated triggers in GitLab
```

Now that your CI jobs are linked, you can go ahead and run the job locally as:

```
$ ./.internals/automaton/Start.sh.ps1 run [JOB]
```

If your init script is internally working fine by default, you should see
`(Holloway) Chew, Kean Ho's Automaton` is able to run it seamlessly.

What you did is **manual triggering**. It allows you to check and debug any of
your CI steps locally.

Once you are satisfied, you can work on your automated CI triggers like
[GitHub Actions](https://github.com/features/actions),
[GitLab CI](https://docs.gitlab.com/ci/),
[Forgejo Actions](https://forgejo.org/docs/next/user/actions/reference/), etc.

> [!NOTE]
>
> For quick and lazy setup, the package actually distributes a default and
> tested set of CI configuration files namely `github-ci.yml` and
> `gitlab-ci.yml` matching the distributed default set as `ci/` directory. You
> can place them as follows:
>
> ```
> your_project/
>   |
>   +-- .git/
>   |
>   +-- .github/
>   |       |
>   |       +-- workflows/
>   |               |
>   |               +-- git-push.yml    <-- rename and place github-ci.yml here
>   |
>   |
>   +-- .gitlab-ci.yml                  <-- rename and place gitlab-ci.yml here
>   |
>   +-- .internals/
>           |
>           +-- automaton/              <-- place automaton here
>           |
>           +-- ci/                     <-- place ci directory here
> ```
>
> These default configuration files **REQUIRE** you to set the `$RUNNERS` CI
> variable for selecting the required runners.
>
> GitLab does not mandate its CI YAML file at the root repository. The location
> can be customized to elsewhere via the repository's settings:
>
> ```
> Settings > CI/CD > General Pipelines > CI/CD configuration file
> ```
>
> For GitHub (`Repository > Settings > Secrets and Variables > Variables`), you
> provide a JSON body provisioning the runners matrix. An example:
>
> ```
> { "os": [ "ubuntu-latest", "windows-latest", "macos-latest" ] }
> ```
>
> For GitLab (`Repository > Settings > Variables > Project Variables`), you
> provide a no-whitespace JSON body provisioning the wanted runners. An example:
>
> ```
> {"os":["saas-linux-small-amd64","saas-windows-medium-amd64"]}
> ```
>
> Unlike GitHub, for GitLab, you may need to add/remove runners by updating your
> `.gitlab-ci.yml` from time to time especially dealing with local runners.
>
> For Gitea and Forgejo, they use GitHub settings inherently so no additional
> configurations are required.



### You Are Done!

Once they are in place, commit and make a test run! If everything works out
fine, you should only be working on growing your `.internals/ci/jobs/`
directory.

If you wish to uninstall it, simply walk backwards through this guide.

Enjoy!




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
DOI: 10.5281/zenodo.23129070
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
