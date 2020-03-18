Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60FA41892EC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCRAkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:10 -0400
Received: from correo.us.es ([193.147.175.20]:45560 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgCRAkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01A3727F8C2
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E63B4DA38D
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0CB7DA3A8; Wed, 18 Mar 2020 01:39:38 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05865DA72F;
        Wed, 18 Mar 2020 01:39:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D4056426CCB9;
        Wed, 18 Mar 2020 01:39:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/29] Netfilter updates for net-next
Date:   Wed, 18 Mar 2020 01:39:27 +0100
Message-Id: <20200318003956.73573-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Use nf_flow_offload_tuple() to fetch flow stats, from Paul Blakey.

2) Add new xt_IDLETIMER hard mode, from Manoj Basapathi.
   Follow up patch to clean up this new mode, from Dan Carpenter.

3) Add support for geneve tunnel options, from Xin Long.

4) Make sets built-in and remove modular infrastructure for sets,
   from Florian Westphal.

5) Remove unused TEMPLATE_NULLS_VAL, from Li RongQing.

6) Statify nft_pipapo_get, from Chen Wandun.

7) Use C99 flexible-array member, from Gustavo A. R. Silva.

8) More descriptive variable names for bitwise, from Jeremy Sowden.

9) Four patches to add tunnel device hardware offload to the flowtable
   infrastructure, from wenxu.

10) pipapo set supports for 8-bit grouping, from Stefano Brivio.

11) pipapo can switch between nibble and byte grouping, also from
    Stefano.

12) Add AVX2 vectorized version of pipapo, from Stefano Brivio.

13) Update pipapo to be use it for single ranges, from Stefano.

14) Add stateful expression support to elements via control plane,
    eg. counter per element.

15) Re-visit sysctls in unprivileged namespaces, from Florian Westphal.

15) Add new egress hook, from Lukas Wunner.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 5d0ab06b63fc9c727a7bb72c81321c0114be540b:

  cdc_ncm: Fix the build warning (2020-03-15 00:41:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 8537f78647c072bdb1a5dbe32e1c7e5b13ff1258:

  netfilter: Introduce egress hook (2020-03-18 01:20:15 +0100)

----------------------------------------------------------------
Chen Wandun (1):
      netfilter: nft_set_pipapo: make the symbol 'nft_pipapo_get' static

Dan Carpenter (1):
      netfilter: xt_IDLETIMER: clean up some indenting

Florian Westphal (3):
      netfilter: nf_tables: make sets built-in
      netfilter: nf_tables: make all set structs const
      netfilter: conntrack: re-visit sysctls in unprivileged namespaces

Gustavo A. R. Silva (1):
      netfilter: Replace zero-length array with flexible-array member

Jeremy Sowden (1):
      netfilter: bitwise: use more descriptive variable-names.

Li RongQing (1):
      netfilter: cleanup unused macro

Lukas Wunner (3):
      netfilter: Rename ingress hook include file
      netfilter: Generalize ingress hook
      netfilter: Introduce egress hook

Manoj Basapathi (1):
      netfilter: xtables: Add snapshot of hardidletimer target

Pablo Neira Ayuso (5):
      netfilter: nf_tables: add nft_set_elem_expr_alloc()
      netfilter: nf_tables: statify nft_expr_init()
      netfilter: nf_tables: add elements with stateful expressions
      netfilter: nf_tables: add nft_set_elem_update_expr() helper function
      netfilter: nft_lookup: update element stateful expression

Paul Blakey (1):
      netfilter: flowtable: Use nf_flow_offload_tuple for stats as well

Stefano Brivio (6):
      nft_set_pipapo: Generalise group size for buckets
      nft_set_pipapo: Add support for 8-bit lookup groups and dynamic switch
      nft_set_pipapo: Prepare for vectorised implementation: alignment
      nft_set_pipapo: Prepare for vectorised implementation: helpers
      nft_set_pipapo: Introduce AVX2-based lookup implementation
      nft_set_pipapo: Prepare for single ranged field usage

Xin Long (1):
      netfilter: nft_tunnel: add support for geneve opts

wenxu (4):
      netfilter: flowtable: add nf_flow_table_block_offload_init()
      netfilter: flowtable: add indr block setup support
      netfilter: flowtable: add tunnel match offload support
      netfilter: flowtable: add tunnel encap/decap action offload support

 include/linux/netdevice.h                       |    4 +
 include/linux/netfilter/ipset/ip_set.h          |    2 +-
 include/linux/netfilter/x_tables.h              |    8 +-
 include/linux/netfilter_arp/arp_tables.h        |    2 +-
 include/linux/netfilter_bridge/ebtables.h       |    2 +-
 include/linux/netfilter_ingress.h               |   58 --
 include/linux/netfilter_ipv4/ip_tables.h        |    2 +-
 include/linux/netfilter_ipv6/ip6_tables.h       |    2 +-
 include/linux/netfilter_netdev.h                |  102 ++
 include/net/netfilter/nf_conntrack_extend.h     |    2 +-
 include/net/netfilter/nf_conntrack_timeout.h    |    2 +-
 include/net/netfilter/nf_flow_table.h           |    6 +
 include/net/netfilter/nf_tables.h               |   34 +-
 include/net/netfilter/nf_tables_core.h          |   13 +-
 include/uapi/linux/netfilter.h                  |    1 +
 include/uapi/linux/netfilter/nf_tables.h        |   10 +
 include/uapi/linux/netfilter/xt_IDLETIMER.h     |   12 +-
 include/uapi/linux/netfilter_bridge/ebt_among.h |    2 +-
 net/bridge/netfilter/ebtables.c                 |    2 +-
 net/core/dev.c                                  |   27 +-
 net/ipv4/netfilter/arp_tables.c                 |    4 +-
 net/ipv4/netfilter/ip_tables.c                  |    4 +-
 net/ipv6/netfilter/ip6_tables.c                 |    4 +-
 net/netfilter/Kconfig                           |   16 +-
 net/netfilter/Makefile                          |   13 +-
 net/netfilter/core.c                            |   24 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c          |    2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c       |    2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c        |    2 +-
 net/netfilter/ipset/ip_set_hash_gen.h           |    4 +-
 net/netfilter/nf_conntrack_core.c               |    1 -
 net/netfilter/nf_conntrack_standalone.c         |   19 +-
 net/netfilter/nf_flow_table_offload.c           |  251 ++++-
 net/netfilter/nf_tables_api.c                   |  113 ++-
 net/netfilter/nf_tables_set_core.c              |   31 -
 net/netfilter/nfnetlink_acct.c                  |    2 +-
 net/netfilter/nft_bitwise.c                     |   14 +-
 net/netfilter/nft_chain_filter.c                |    4 +-
 net/netfilter/nft_dynset.c                      |   23 +-
 net/netfilter/nft_lookup.c                      |    1 +
 net/netfilter/nft_set_bitmap.c                  |    3 +-
 net/netfilter/nft_set_hash.c                    |    9 +-
 net/netfilter/nft_set_pipapo.c                  |  637 +++++++-----
 net/netfilter/nft_set_pipapo.h                  |  280 ++++++
 net/netfilter/nft_set_pipapo_avx2.c             | 1223 +++++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.h             |   14 +
 net/netfilter/nft_set_rbtree.c                  |    3 +-
 net/netfilter/nft_tunnel.c                      |  110 +-
 net/netfilter/xt_IDLETIMER.c                    |  248 ++++-
 net/netfilter/xt_SECMARK.c                      |    2 -
 net/netfilter/xt_hashlimit.c                    |    2 +-
 net/netfilter/xt_recent.c                       |    4 +-
 52 files changed, 2781 insertions(+), 581 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h
 delete mode 100644 net/netfilter/nf_tables_set_core.c
 create mode 100644 net/netfilter/nft_set_pipapo.h
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h
