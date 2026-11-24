# Changelog

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

Below are the changelog for `(Holloway) Chew, Kean Ho's Automaton` application.
It details all the version changes per release from the latest to the oldest.




# Version `v2.0.1`

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

* Date: `TBD`
* Type: `stable`



### Non-Backward Compatible

These are breaking changes requiring manual upgrades attention.

1. **None**.



### Backward Compatible

These are non-breaking changes requiring no manual upgrade attention.

1. **Commit ID TBD** - Remove all XuanQi's artifact residues




## Version `v2.0.0`

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

* Date: `2026-11-23`
* Type: `stable`



### Non-Backward Compatible

These are breaking changes requiring manual upgrades attention.

1. **d839cc** - switched PowerShell to use `$global:LASTEXITCODE` instead of the
   non-programmable `$LASTEXITCODE` return code variable and `return` command.
   The latter pollutes any output data by accident.

   This affects existing `run` API and requires mild return codes correction to
   all existing PowerShell script from:

   ```
   # error return
   return 1

   # report status
   return 0
   ```

   to:

   ```
   # error return
   $global:LASTEXITCODE = 1
   return

   # report status
   $global:LASTEXITCODE = 0
   return
   ```
2. **1d4388** - removed PowerShell version restriction allowing Automaton to
   serve wider range of Microsoft Windows' already deployed ecosystems.

   This affects all PowerShell scripts especially those inside `ci/jobs`
   directory. Manual efforts are required to patch by removing the first line
   of requirement as shown in `diff` format below:

   ```
   -#requires -Version 5.1
   ```



### Backward Compatible

These are non-breaking changes requiring no manual upgrade attention.

1. **2870e7** - re-structured code foundation into full VIPER application
   format.
2. **116c4c** - added `Help - Run` API
3. **742d67** - added `Help - List` and `List` APIs
4. **d839cc** - added `Help - Create` and `Create` APIs
5. **3f42c7** - added `Help - Delete` and `Delete` APIs
6. **5c2e2f** - added `CI - Prepare` scripts for self-testing
7. **1310fc** - added `CI - Test` scripts for self-testing
8. **389bc6** - added `CI - Package` scripts for self-packaging
9. **4da49c** - added `CI - Environment` scripts for self-testing




## Version `v1.1.0`

* Date: `2026-10-09`
* Type: `stable`

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)



### Non-Backward Compatible

These are breaking changes requiring manual upgrades attention.

1. None.



### Backward Compatible

These are non-breaking changes requiring no manual upgrade attention.


1. Fixed `____init_directory` starter bug just in case Automaton becomes a
   full-battery local application.
2. Removed help printout from all error prompt for making the error message
   simple and clear.




## Version `v1.0.1`

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

* Date: `2026-10-05`
* Type: `stable`



### Non-Backward Compatible

These are breaking changes requiring manual upgrades attention.

1. None.



### Backward Compatible

These are non-breaking changes requiring no manual upgrade attention.

1. Amended `README.md` for better readability.
2. Corrected `src/` and `share/` registered pathing for avoiding future
   namespace conflict.




## Version `v1.0.0`

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

* Date: `2026-10-04`
* Type: `stable`



### Non-Backward Compatible

These are breaking changes requiring manual upgrades attention.

1. Added DOI ID.
2. Enhanced GPG Content Integrity Verification for Downstream Distribution
   Safety.
3. `help` now print `AUTOMATON_DIRECTORY_JOBS` environment variable for
   verification.
4. Official release.




### Backward Compatible

These are non-breaking changes requiring no manual upgrade attention.

1. None.




## Version `v0.0.1`

[![banner](/.internals/trademarks/banner_1200x100.svg)](#)

* Date: `2026-10-04`
* Type: `stable`



### Non-Backward Compatible

These are breaking changes requiring manual upgrades attention.

1. None.



### Backward Compatible

These are non-breaking changes requiring no manual upgrade attention.

1. First developed.
