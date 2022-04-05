Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C6C4F4035
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379963AbiDEUEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450184AbiDEPvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:51:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609141275B9;
        Tue,  5 Apr 2022 07:39:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nbkLO-0004be-Lh; Tue, 05 Apr 2022 16:39:42 +0200
Date:   Tue, 5 Apr 2022 16:39:42 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnfnetlink 1.0.2 release
Message-ID: <YkxUru2QG/o1BlTV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PfK1Du911qYl3QzP"
Content-Disposition: inline
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PfK1Du911qYl3QzP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnfnetlink 1.0.2

This release contains only fixes:

* Warnings with automake-1.12
* Update header comments to reflect GPLv2+ license
* Allow building on uclinux
* Valgrind warnings due to uninitialized padding in netlink messages
* Hide private library symbols
* Support builds with newer doxygen versions
* Failing calls to getsockname() were left unnoticed

You can download the new release from:

https://netfilter.org/projects/libnfnetlink/downloads.html#libnfnetlink-1.0.2

Note that despite the new release, this library remains deprecated and
users should migrate to libmnl if possible.

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--PfK1Du911qYl3QzP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnfnetlink-1.0.2.txt"

Duncan Roe (2):
      Minimally resurrect doxygen documentation
      Make it clear that this library is deprecated

Felix Janda (2):
      include: Sync with kernel headers
      src: Use stdint types everywhere

Gustavo Zacarias (1):
      configure: uclinux is also linux

Jan Engelhardt (1):
      build: resolve automake-1.12 warnings

Pablo Neira Ayuso (5):
      src: get source code license header in sync with current licensing terms
      libnfnetlink: initialize attribute padding to resolve valgrind warnings
      autogen: don't convert __u16 to u_int16_t
      bump version to 1.0.2
      build: add nfnl.version to sources

Phil Sutter (2):
      include: Silence gcc warning in linux_list.h
      libnfnetlink: Check getsockname() return code

Yury Gribov (1):
      libnfnetlink: hide private symbols


--PfK1Du911qYl3QzP--
