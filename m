Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB904F3E18
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353216AbiDEOXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiDENyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:54:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE7BBD2CD;
        Tue,  5 Apr 2022 05:55:50 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nbiiq-0003dp-DO; Tue, 05 Apr 2022 14:55:48 +0200
Date:   Tue, 5 Apr 2022 14:55:48 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libmnl 1.0.5 release
Message-ID: <Ykw8VBenlUgEVPvl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FgAyCt4XeABDY93x"
Content-Disposition: inline
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FgAyCt4XeABDY93x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libmnl 1.0.5

This release contains new features:

* Two new examples:
  * rtnl-neigh-dump, dumping ARP cache
  * rtnl-addr-add, adding an IP address to an interface
* MNL_SOCKET_DUMP_SIZE define, holding a recommended buffer size for
  netlink dumps

... and fixes:

* nfct-daemon example compile error with musl libc
* Compiler warning when passing a const 'cb_ctl_array' to mnl_cb_run2()
* Typo in rtnl-addr-dump example
* Valgrind warnings due to uninitialized padding in netlink messages
* Misc fixes in doxygen documentation
* Misc build system fixes

You can download this new release from:

https://netfilter.org/projects/libmnl/downloads.html#libmnl-1.0.5

Check out the doxygen documentation at:

https://netfilter.org/projects/libmnl/doxygen/html/

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--FgAyCt4XeABDY93x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libmnl-1.0.5.txt"

Duncan Roe (5):
      nlmsg: Fix a missing doxygen section trailer
      build: doc: "make" builds & installs a full set of man pages
      build: doc: get rid of the need for manual updating of Makefile
      build: If doxygen is not available, be sure to report "doxygen: no" to ./configure
      src: doc: Fix messed-up Netlink message batch diagram

Fernando Fernandez Mancera (1):
      src: fix doxygen function documentation

Florian Westphal (1):
      libmnl: zero attribute padding

Guillaume Nault (1):
      callback: mark cb_ctl_array 'const' in mnl_cb_run2()

Kylie McClain (1):
      examples: nfct-daemon: Fix test building on musl libc

Laura Garcia Liebana (4):
      examples: add arp cache dump example
      examples: fix neigh max attributes
      examples: fix print line format
      examples: reduce LOCs during neigh attributes validation

Pablo Neira Ayuso (3):
      doxygen: remove EXPORT_SYMBOL from the output
      include: add MNL_SOCKET_DUMP_SIZE definition
      build: libmnl 1.0.5 release

Petr Vorel (1):
      examples: Add rtnl-addr-add.c

Stephen Hemminger (1):
      examples: rtnl-addr-dump: fix typo

igo95862 (1):
      doxygen: Fixed link to the git source tree on the website.


--FgAyCt4XeABDY93x--
