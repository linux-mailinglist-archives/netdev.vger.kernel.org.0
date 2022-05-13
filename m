Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EEB52650B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381349AbiEMOoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382806AbiEMOnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:43:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE059F3A4;
        Fri, 13 May 2022 07:40:40 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1npWT6-0001JO-Sj; Fri, 13 May 2022 16:40:36 +0200
Date:   Fri, 13 May 2022 16:40:36 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.8 release
Message-ID: <Yn5t5PQWNLRgmWuW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AS0v4bS3Zr6S/Iq+"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--AS0v4bS3Zr6S/Iq+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.8.8

This release contains new features:

* Add iptables-translate support for:
  * sctp match's --chunk-types option
  * connlimit match
  * multiport match's --ports option
  * tcpmss match
* Simplified translation of:
  * tcp match's --tcp-flags option
  * conntrack match
* Reject setuid executables in libxtables for safety reasons
* Support deleting builtin chains in iptables-nft
* Merged arptables-nft rule parser into iptables-nft one, thereby extending
  arptables-nft by:
  * '-C' and '-S' commands
  * Rule indexes with '-I' and '-R' commands
  * '-c N,M' counter syntax
* Drop support for multiple IPv4 ranges in *NAT targets which required a linux
  kernel before 2.6.11 anyway
* Use native log expression for NFLOG target with iptables-nft, this allows to
  use up to 127 character prefix strings
* Use native payload expressions when matching on TCP/UDP header fields in
  iptables-nft
* Debug output in iptables-nft and ebtables-nft when specifying '-v' multiple
  times
* Debug output in iptables-restore (all variants) by passing '-v' option
  multiple times
* Better legacy iptables lock timeout implementation, making '-W' option obsolete
* Improved performance of iptables-save and -restore
* Use native meta expression when matching on fwmark value.

... and fixes:

* Avoid ebtables program abort for unknown table names
* Zeroing rule counters not functional in iptables-nft
* Incorrect stripping of odd (non-prefix) netmasks with nft-variants
* Wrong iptables-translate output for odd (non-prefix) netmasks
* Wrong translation of inverted conntrack state/status matches
* Buffer exhaustion with huge rulesets in nft-variants
* Deleting rules with SECMARK target not possible due to binary data mismatch
  (requires kernel update)
* Broken ebtables-translate with '-o' and custom chains
* Wrong translation of sctp match on more than a single field
* Fix for static linking
* Check command was always verbose in iptables-nft
* Wrong translation of '--random-full' option in ip6tables MASQUERADE
* Missing space in listing of mac match
* Misc memory leaks
* Misc testsuite fixes
* ebtables-nft drops user-defined chain policies when flushing
* Clarify synopsis in iptables-translate help text
* Potential double free with unrecognized base chains in iptables-nft
* Wrong ip6tables-nft help text (identical with iptables by accident)
* Extra whitespace after --nflog-prefix option of NFLOG target
* Sanitize behaviour for unprivileged callers, allow printing (extension) help
* Trying to use non-existent extensions caused misleading error messages
* iptables-nft-restore accepted standard targets as chain names
* Extra newline when printing MARK extension help
* Improved arptables-nft help output

... and documentation updates:

* sctp match types
* Drop documentation of ebtables-nft unsupported atomic options
* Misc typo fixes
* Support for shifted port ranges with DNAT
* (Limited) support for service names with DNAT and REDIRECT
* Review NAT extensions' documentation in man page
* LOG target's --log-macdecode option

You can download the new release from:

https://netfilter.org/projects/iptables/downloads.html#iptables-1.8.8

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--AS0v4bS3Zr6S/Iq+
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-iptables-1.8.8.txt"
Content-Transfer-Encoding: 8bit

Alexander Mikhalitsyn (2):
      extensions: libxt_conntrack: use bitops for state negation
      extensions: libxt_conntrack: use bitops for status negation

Erik Wilson (1):
      xtables: Call init_extensions6() for static builds

Etienne Champetier (1):
      xtables: Call init_extensions{,a,b}() for static builds

Florian Westphal (12):
      iptables-nft: fix -Z option
      libxtables: exit if called by setuid executeable
      iptables-nft: allow removal of empty builtin chains
      extensions: tcpmss: add iptables-translate support
      nft-shared: set correct register value
      nft-shared: support native tcp port delinearize
      nft-shared: support native tcp port range delinearize
      nft-shared: support native udp port delinearize
      nft: prefer native expressions instead of udp match
      nft: prefer native expressions instead of tcp match
      nft-shared: add tcp flag dissection
      nft: add support for native tcp flag matching

Jeremy Sowden (11):
      tests: shell: fix bashism
      nft: fix indentation error.
      tests: iptables-test: correct misspelt variable
      extensions: libxt_NFLOG: fix `--nflog-prefix` Python test-cases
      extensions: libxt_NFLOG: remove extra space when saving targets with prefixes
      build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with `LT_INIT`
      extensions: libxt_NFLOG: fix typo
      tests: iptables-test: rename variable
      tests: add `NOMATCH` test result
      tests: support explicit variant test result
      tests: NFLOG: enable `--nflog-range` tests

Jethro Beekman (1):
      xshared: Implement xtables lock timeout using signals

Kyle Bowman (3):
      extensions: libxt_NFLOG: use nft built-in logging instead of xt_NFLOG
      extensions: libxt_NFLOG: don't truncate log prefix on print/save
      extensions: libxt_NFLOG: disable `--nflog-range` Python test-cases

Maciej Żenczykowski (1):
      fix build for missing ETH_ALEN definition

Pablo Neira Ayuso (13):
      libxtables: extend xlate infrastructure
      tests: xlate-test: support multiline expectation
      extensions: libxt_connlimit: add translation
      extensions: libxt_tcp: rework translation to use flags match representation
      extensions: libxt_conntrack: simplify translation using negation
      extensions: libxt_multiport: add translation for -m multiport --ports
      nft-shared: update context register for bitwise expression
      nft: pass struct nft_xt_ctx to parse_meta()
      nft: native mark matching support
      nft: pass handle to helper functions to build netlink payload
      nft: prepare for dynamic register allocation
      nft: split gen_payload() to allocate register and initialize expression
      configure: bump version for 1.8.8 release

Pavel Tikhomirov (1):
      ip6tables: masquerade: use fully-random so that nft can understand the rule

Phil Sutter (134):
      ebtables: Exit gracefully on invalid table names
      include: Drop libipulog.h
      nft: Fix bitwise expression avoidance detection
      xtables-translate: Fix translation of odd netmasks
      libxtables: Simplify xtables_ipmask_to_cidr() a bit
      nft: cache: Sort chains on demand only
      nft: Increase BATCH_PAGE_SIZE to support huge rulesets
      extensions: sctp: Explain match types in man page
      Eliminate inet_aton() and inet_ntoa()
      nft-arp: Make use of ipv4_addr_to_string()
      extensions: SECMARK: Implement revision 1
      xtables: Make invflags 16bit wide
      xshared: Eliminate iptables_command_state->invert
      xshared: Merge invflags handling code
      ebtables-translate: Use shared ebt_get_current_chain() function
      Use proto_to_name() from xshared in more places
      extensions: sctp: Fix nftables translation
      extensions: sctp: Translate --chunk-types option
      libxtables: Drop leftover variable in xtables_numeric_to_ip6addr()
      extensions: libebt_ip6: Drop unused variables
      libxtables: Fix memleak in xtopt_parse_hostmask()
      nft: Avoid memleak in error path of nft_cmd_new()
      nft: Avoid buffer size warnings copying iface names
      iptables-apply: Drop unused variable
      extensions: libebt_ip6: Use xtables_ip6parse_any()
      libxtables: Introduce xtables_strdup() and use it everywhere
      extensions: libxt_string: Avoid buffer size warning for strncpy()
      doc: ebtables-nft.8: Adjust for missing atomic-options
      ebtables: Dump atomic waste
      nft: Fix for non-verbose check command
      tests/shell: Assert non-verbose mode is silent
      extensions: hashlimit: Fix tests with HZ=100
      iptables-test: Make netns spawning more robust
      extensions: libxt_mac: Fix for missing space in listing
      nft: Use xtables_malloc() in mnl_err_list_node_add()
      nft: Use xtables_{m,c}alloc() everywhere
      tests: iptables-test: Fix missing chain case
      tests: xlate-test: Don't skip any input after the first empty line
      tests: xlate-test: Print errors to stderr
      tests: iptables-test: Print errors to stderr
      tests: xlate-test: Exit non-zero on error
      tests: iptables-test: Exit non-zero on error
      tests: shell: Return non-zero on error
      ebtables: Avoid dropping policy when flushing
      tests: iptables-test: Fix conditional colors on stderr
      nft: cache: Avoid double free of unrecognized base-chains
      nft: Check base-chain compatibility when adding to cache
      nft-chain: Introduce base_slot field
      nft: Delete builtin chains compatibly
      nft: Introduce builtin_tables_lookup()
      xshared: Store optstring in xtables_globals
      nft-shared: Introduce init_cs family ops callback
      xtables: Simplify addr_mask freeing
      nft: Add family ops callbacks wrapping different nft_cmd_* functions
      xtables-standalone: Drop version number from init errors
      libxtables: Introduce xtables_globals print_help callback
      arptables: Use standard data structures when parsing
      nft-arp: Introduce post_parse callback
      nft-shared: Make nft_check_xt_legacy() family agnostic
      xtables: Derive xtables_globals from family
      xtables: arptables accepts empty interface names
      nft: Merge xtables-arp-standalone.c into xtables-standalone.c
      Unbreak xtables-translate
      xlate-test: Print full path if testing all files
      extensions: hashlimit: Fix tests with HZ=1000
      xshared: Merge and share parse_chain()
      nft: Change whitespace printing in save_rule callback
      xshared: Share print_iface() function
      xshared: Share save_rule_details() with legacy
      xshared: Share save_ipv{4,6}_addr() with legacy
      xshared: Share print_rule_details() with legacy
      xshared: Share print_fragment() with legacy
      xshared: Share print_header() with legacy iptables
      nft-shared: Drop unused function print_proto()
      xshared: Make load_proto() static
      xshared: Share print_match_save() between legacy ip*tables
      xshared: Share a common printhelp function
      xshared: Share exit_tryhelp()
      xtables_globals: Embed variant name in .program_version
      libxtables: Extend basic_exit_err()
      iptables-*-restore: Drop pointless line reference
      xtables: Drop xtables' family on demand feature
      xtables: Pull table validity check out of do_parse()
      xtables: Move struct nft_xt_cmd_parse to xshared.h
      xtables: Pass xtables_args to check_empty_interface()
      xtables: Pass xtables_args to check_inverse()
      xtables: Do not pass nft_handle to do_parse()
      xshared: Move do_parse to shared space
      xshared: Store parsed wait and wait_interval in xtables_args
      nft: Move proto_parse and post_parse callbacks to xshared
      iptables: Use xtables' do_parse() function
      ip6tables: Use the shared do_parse, too
      extensions: *NAT: Kill multiple IPv4 range support
      xshared: Fix response to unprivileged users
      nft: Use verbose flag to toggle debug output
      iptables-restore: Support for extra debug output
      nft: Set NFTNL_CHAIN_FAMILY in new chains
      ebtables: Support verbose mode
      nft: Add debug output to table creation
      nft: cache: Dump rules if debugging
      tests: iptables-test: Support variant deviation
      iptables.8: Describe the effect of multiple -v flags
      libxtables: Register only the highest revision extension
      Improve error messages for unsupported extensions
      nft: Simplify immediate parsing
      nft: Speed up immediate parsing
      xshared: Prefer xtables_chain_protos lookup over getprotoent
      nft: Don't pass command state opaque to family ops callbacks
      libxtables: Fix for warning in xtables_ipmask_to_numeric
      Simplify static build extension loading
      nft: Review static extension loading
      tests: shell: Fix 0004-return-codes_0 for static builds
      nft: Reject standard targets as chain names when restoring
      libxtables: Implement notargets hash table
      libxtables: Boost rule target checks by announcing chain names
      xlate-test: Fix for empty source line on failure
      man: DNAT: Describe shifted port range feature
      Revert "libipt_[SD]NAT: avoid false error about multiple destinations specified"
      extensions: ipt_DNAT: Merge v1 and v2 parsers
      extensions: ipt_DNAT: Merge v1/v2 print/save code
      extensions: ipt_DNAT: Combine xlate functions also
      extensions: DNAT: Rename from libipt to libxt
      extensions: Merge IPv4 and IPv6 DNAT targets
      extensions: Merge REDIRECT into DNAT
      extensions: man: Document service name support in DNAT and REDIRECT
      extensions: MARK: Drop extra newline at end of help
      xshared: Move arp_opcodes into shared space
      xshared: Extend xtables_printhelp() for arptables
      libxtables: Drop xtables_globals 'optstring' field
      libxtables: Revert change to struct xtables_pprot
      extensions: DNAT: Merge core printing functions
      man: *NAT: Review --random* option descriptions
      extensions: LOG: Document --log-macdecode in man page
      nft: Fix EPERM handling for extensions without rev 0

mizuta.takeshi@fujitsu.com (1):
      xtables-translate: add missing argument and option to usage

Štěpán Němec (2):
      Fix a few doc typos
      iptables-test.py: print with color escapes only when stdout isatty


--AS0v4bS3Zr6S/Iq+--
