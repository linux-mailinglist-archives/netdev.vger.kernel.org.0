Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42932282D5E
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgJDTuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:08 -0400
Received: from correo.us.es ([193.147.175.20]:34920 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgJDTuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91360EF42D
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8426BDA78E
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7968EDA78D; Sun,  4 Oct 2020 21:50:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E0E3DA72F;
        Sun,  4 Oct 2020 21:50:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 25FF442EF9E2;
        Sun,  4 Oct 2020 21:50:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 00/11] Netfilter updates for net-next
Date:   Sun,  4 Oct 2020 21:49:29 +0200
Message-Id: <20201004194940.7368-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Rename 'searched' column to 'clashres' in conntrack /proc/ stats
   to amend a recent patch, from Florian Westphal.

2) Remove unused nft_data_debug(), from YueHaibing.

3) Remove unused definitions in IPVS, also from YueHaibing.

4) Fix user data memleak in tables and objects, this is also amending
   a recent patch, from Jose M. Guisado.

5) Use nla_memdup() to allocate user data in table and objects, also
   from Jose M. Guisado

6) User data support for chains, from Jose M. Guisado

7) Remove unused definition in nf_tables_offload, from YueHaibing.

8) Use kvzalloc() in ip_set_alloc(), from Vasily Averin.

9) Fix false positive reported by lockdep in nfnetlink mutexes,
   from Florian Westphal.

10) Extend fast variant of cmp for neq operation, from Phil Sutter.

11) Implement fast bitwise variant, also from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit c5a2a132a38619d24d6d115c66cc277594b4fe01:

  Merge tag 'linux-can-next-for-5.10-20200921' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next (2020-09-21 14:57:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 10fdd6d80e4c21ad48f3860d723f5b3b5965477b:

  netfilter: nf_tables: Implement fast bitwise expression (2020-10-04 21:08:33 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: conntrack: proc: rename stat column
      netfilter: nfnetlink: place subsys mutexes in distinct lockdep classes

Jose M. Guisado Gomez (3):
      netfilter: nf_tables: fix userdata memleak
      netfilter: nf_tables: use nla_memdup to copy udata
      netfilter: nf_tables: add userdata attributes to nft_chain

Phil Sutter (2):
      netfilter: nf_tables: Enable fast nft_cmp for inverted matches
      netfilter: nf_tables: Implement fast bitwise expression

Vasily Averin (1):
      netfilter: ipset: enable memory accounting for ipset allocations

YueHaibing (3):
      netfilter: nf_tables: Remove ununsed function nft_data_debug
      ipvs: Remove unused macros
      netfilter: nf_tables_offload: Remove unused macro FLOW_SETUP_BLOCK

 include/net/netfilter/nf_tables.h        |   9 +-
 include/net/netfilter/nf_tables_core.h   |  11 +++
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/ipset/ip_set_core.c        |  17 +---
 net/netfilter/ipvs/ip_vs_sync.c          |   3 -
 net/netfilter/nf_conntrack_standalone.c  |   4 +-
 net/netfilter/nf_tables_api.c            |  49 +++++++----
 net/netfilter/nf_tables_core.c           |  15 +++-
 net/netfilter/nf_tables_offload.c        |   2 -
 net/netfilter/nfnetlink.c                |  19 ++++-
 net/netfilter/nft_bitwise.c              | 141 +++++++++++++++++++++++++++++--
 net/netfilter/nft_cmp.c                  |  13 +--
 12 files changed, 222 insertions(+), 63 deletions(-)
