Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FFF6670EB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjALLaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjALL17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:27:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBC825E6;
        Thu, 12 Jan 2023 03:20:21 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pFvd5-0004qc-G6; Thu, 12 Jan 2023 12:20:19 +0100
Date:   Thu, 12 Jan 2023 12:20:19 +0100
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.9 release
Message-ID: <Y7/s83d8D0z1QYt1@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="s0pKw1af8TI9v0z2"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s0pKw1af8TI9v0z2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.8.9

This release contains new features:

* arptables-nft: Support --exact flag
* Add --enable-profiling configure option, preparing for gcov/gprof
* Support more chunk types in sctp extension
* Print '--' in ip6tables' 'opt' column for consistency with iptables
* More verbose error messages if iptables-nft-restore fails
* Support '-p Length' with ebtables-nft, needed for 802_3 extension
* Merge all NAT extensions into a single DSO
* Install ebtables-translate tool

... and fixes:

* Misc compiler warnings
* Duplicate ETH_ALEN definition when building against musl libc
* Failing out-of-tree build
* Avoid symbol pollution by limiting scope of some in xtables.h
* Increase testsuites' code-coverage
* Using --init-table would crash ebtables-restore, reject it properly
* Fix potential read from garbage in string extension
* Add missing nf_log.h kernel header to dist
* Fix listing format with overly long 'prot' column entries
* Print numeric protocol values with --numeric
* Broken ebtables' among match with MAC+IP address entries
* Occasional wrong line number reported by failing iptables-nft-restore
* Multiple rules using among match broke ebtables-restore
* Renaming a chain in legacy iptables could crash the program
* A second bitwise expression in a rule would mangle the first one
* More strictly reject rules with unexpected content
* Many xtables-translate fixes
* Misc memory leaks and garbage access, satisfy valgrind's leak checker

... and documentation updates:

* Iptables exits when setuid, mention this in man page
* Improve NFQUEUE queue-balance documentation

You can download the new release from:

https://netfilter.org/projects/iptables/downloads.html#iptables-1.8.9

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--s0pKw1af8TI9v0z2
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-iptables-1.8.9.txt"
Content-Transfer-Encoding: 8bit

Anton Luka Šijanec (1):
      xtables-monitor: add missing spaces in printed str

Ben Brown (1):
      build: Fix error during out of tree build

Erik Skultety (1):
      iptables: xshared: Ouptut '--' in the opt field in ipv6's fake mode

Florian Westphal (19):
      iptables.8: mention that iptables exits when setuid
      extensions: libxt_conntrack: remove always-false conditionals
      nft: fix ebtables among match when mac+ip addresses are used
      nft: support dissection of meta pkktype mode
      nft: prefer native 'meta pkttype' instead of xt match
      extensions: libxt_pkttype: support otherhost
      nft: support ttl/hoplimit dissection
      nft: prefer payload to ttl/hl module
      nft: un-break among match with concatenation
      Revert "nft: prefer payload to ttl/hl module"/'meta pkttype' match.
      nft: track each register individually
      tests: extend native delinearize script
      nft: check for unknown meta keys
      iptables-nft: exit nonzero when iptables-save cannot decode all expressions
      xlate: get rid of escape_quotes
      extensions: change expected output for new format
      xlate-test: avoid shell entanglements
      nft-bridge: work around recent "among" decode breakage
      extensions: add xt_statistics random mode translation

Markus Mayer (1):
      netfilter: add nf_log.h

Nick Hainke (1):
      treewide: use uint* instead of u_int*

Pablo Neira Ayuso (2):
      nft: replace nftnl_.*_nlmsg_build_hdr() by nftnl_nlmsg_build_hdr()
      nft-shared: replace nftnl_expr_get_data() by nftnl_expr_get()

Phil Sutter (136):
      xshared: Fix build for -Werror=format-security
      Revert "fix build for missing ETH_ALEN definition"
      tests: shell: Check overhead in iptables-save and -restore
      libxtables: Unexport init_extensions*() declarations
      arptables: Support -x/--exact flag
      iptables-legacy: Drop redundant include of xtables-multi.h
      xshared: Make some functions static
      Makefile: Add --enable-profiling configure option
      tests: shell: Add some more rules to 0002-verbose-output_0
      tests: shell: Extend iptables-xml test a bit
      tests: shell: Extend zero counters test a bit further
      extensions: libebt_standard.t: Test logical-{in,out} as well
      ebtables-restore: Deny --init-table
      extensions: string: Do not print default --to value
      extensions: string: Review parse_string() function
      extensions: string: Fix and enable tests
      nft: Exit if nftnl_alloc_expr fails
      libxtables: Move struct xtables_afinfo into xtables.h
      libxtables: Define XT_OPTION_OFFSET_SCALE in xtables.h
      libxtables: Fix unsupported extension warning corner case
      tests: shell: Fix testcases for changed ip6tables opts output
      xshared: Fix for missing space after 'prot' column
      xshared: Print protocol numbers if --numeric was given
      xtables-restore: Extend failure error message
      nft: Expand extended error reporting to nft_cmd, too
      tests: shell: Test delinearization of native nftables expressions
      ebtables: Drop unused OPT_* defines
      ebtables: Eliminate OPT_TABLE
      ebtables: Merge OPT_* flags with xshared ones
      nft-shared: Introduce __get_cmp_data()
      ebtables: Support '-p Length'
      ebtables: Fix among match
      nft: Fix meta statement parsing
      nft-bridge: Drop 'sreg_count' variable
      tests: iptables-test: Simplify '-N' option a bit
      tests: iptables-test: Simplify execute_cmd() calling
      tests: iptables-test: Pass netns to execute_cmd()
      tests: iptables-test: Test both variants by default
      extensions: among: Remove pointless fall through
      extensions: among: Fix for use with ebtables-restore
      extensions: libebt_stp: Eliminate duplicate space in output
      extensions: libip6t_dst: Fix output for empty options
      extensions: TCPOPTSTRIP: Do not print empty options
      extensions: libebt_log: Avoid empty log-prefix in output
      tests: IDLETIMER.t: Fix syntax, support for restore input
      tests: libebt_stp.t: Drop duplicate whitespace
      tests: shell: Fix expected output for ip6tables dst match
      tests: shell: Fix expected ebtables log target output
      libiptc: Fix for segfault when renaming a chain
      nft: Fix compile with -DDEBUG
      extensions: NFQUEUE: Document queue-balance limitation
      tests: iptables-test: Implement fast test mode
      tests: iptables-test: Cover for obligatory -j CONTINUE in ebtables
      tests: *.t: Fix expected output for simple calls
      tests: *.t: Fix for hexadecimal output
      tests: libebt_redirect.t: Plain redirect prints with trailing whitespace
      tests: libxt_length.t: Fix odd use-case output
      tests: libxt_recent.t: Add missing default values
      tests: libxt_tos.t, libxt_TOS.t: Add missing masks in output
      tests: libebt_vlan.t: Drop trailing whitespace from rules
      tests: libxt_connlimit.t: Add missing default values
      tests: *.t: Add missing all-one's netmasks to expected output
      extensions: DNAT: Fix bad IP address error reporting
      extensions: *NAT: Drop NF_NAT_RANGE_PROTO_RANDOM* flag checks
      extensions: DNAT: Use __DNAT_xlate for REDIRECT, too
      extensions: DNAT: Generate print, save and xlate callbacks
      extensions: DNAT: Rename some symbols
      extensions: Merge SNAT, DNAT, REDIRECT and MASQUERADE
      tests: xlate-test: Cleanup file reading loop
      tests: xlate-test.py: Introduce run_proc()
      tests: xlate-test: Replay results for reverse direction testing
      xshared: Share make_delete_mask() between ip{,6}tables
      nft-shared: Introduce port_match_single_to_range()
      extensions: libip*t_LOG: Merge extensions
      extensions: libebt_ip: Include kernel header
      extensions: libebt_arp, libebt_ip: Use xtables_ipparse_any()
      extensions: Collate ICMP types/codes in libxt_icmp.h
      extensions: Unify ICMP parser into libxt_icmp.h
      Drop extra newline from xtables_error() calls
      extensions: mark: Test double bitwise in a rule
      extensions: libebt_mark: Fix mark target xlate
      extensions: libebt_mark: Fix xlate test case
      extensions: libebt_redirect: Fix xlate return code
      extensions: libipt_ttl: Sanitize xlate callback
      extensions: CONNMARK: Fix xlate callback
      extensions: MARK: Sanitize MARK_xlate()
      extensions: TCPMSS: Use xlate callback for IPv6, too
      extensions: TOS: Fix v1 xlate callback
      extensions: ecn: Sanitize xlate callback
      extensions: tcp: Translate TCP option match
      extensions: libebt_log: Add comment to clarify xlate callback
      extensions: frag: Add comment to clarify xlate callback
      extensions: ipcomp: Add comment to clarify xlate callback
      libxtables: xt_xlate_add() to take care of spacing
      extensions: Leverage xlate auto-spacing
      extensions: libxt_conntrack: Drop extra whitespace in xlate
      extensions: xlate: Format sets consistently
      tests: shell: Test selective ebtables flushing
      tests: shell: Fix valgrind mode for 0008-unprivileged_0
      iptables-restore: Free handle with --test also
      iptables-xml: Free allocated chain strings
      nft: Plug memleak in nft_rule_zero_counters()
      iptables: Plug memleaks in print_firewall()
      xtables: Introduce xtables_clear_iptables_command_state()
      iptables: Properly clear iptables_command_state object
      xshared: Free data after printing help
      libiptc: Eliminate garbage access
      ebtables: Implement --check command
      tests: xlate: Use --check to verify replay
      nft: Fix for comparing ifname matches against nft-generated ones
      nft: Fix match generator for '! -i +'
      nft: Recognize INVAL/D interface name
      xtables-translate: Fix for interfaces with asterisk mid-string
      ebtables: Fix MAC address match translation
      Makefile: Create LZMA-compressed dist-files
      Drop INCOMPATIBILITIES file
      Drop libiptc/linux_stddef.h
      Makefile: Generate ip6tables man pages on the fly
      extensions: Makefile: Merge initext targets
      iptables/Makefile: Reorg variable assignments
      iptables/Makefile: Split nft-variant man page list
      Makefile: Fix for 'make distcheck'
      Makefile: Generate .tar.xz archive with 'make dist'
      include/Makefile: xtables-version.h is generated
      tests: Adjust testsuite return codes to automake guidelines
      Makefile.am: Integrate testsuites
      nft: Parse icmp header matches
      arptables: Check the mandatory ar_pln match
      nft: Increase rule parser strictness
      nft: Make rule parsing errors fatal
      nft: Reject tcp/udp extension without proper protocol match
      gitignore: Ignore utils/nfsynproxy
      gitignore: Ignore generated ip6tables man pages
      ebtables-translate: Install symlink
      Makefile: Replace brace expansion
      configure: Bump version for 1.8.9 release

Yi Chen (1):
      tests: add ebtables among testcase

Yuxuan Luo (1):
      xt_sctp: support a couple of new chunk types


--s0pKw1af8TI9v0z2--
