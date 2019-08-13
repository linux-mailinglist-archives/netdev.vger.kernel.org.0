Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8C48C0BD
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfHMShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:19 -0400
Received: from correo.us.es ([193.147.175.20]:58742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfHMShT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AFAA7B6322
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2638519F7
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 980E6512D2; Tue, 13 Aug 2019 20:37:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76A11DA72F;
        Tue, 13 Aug 2019 20:37:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2C46B4265A2F;
        Tue, 13 Aug 2019 20:37:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/17] Netfilter/IPVS updates for net-next
Date:   Tue, 13 Aug 2019 20:36:44 +0200
Message-Id: <20190813183701.4002-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Rename mss field to mss_option field in synproxy, from Fernando Mancera.

2) Use SYSCTL_{ZERO,ONE} definitions in conntrack, from Matteo Croce.

3) More strict validation of IPVS sysctl values, from Junwei Hu.

4) Remove unnecessary spaces after on the right hand side of assignments,
   from yangxingwu.

5) Add offload support for bitwise operation.

6) Extend the nft_offload_reg structure to store immediate date.

7) Collapse several ip_set header files into ip_set.h, from
   Jeremy Sowden.

8) Make netfilter headers compile with CONFIG_KERNEL_HEADER_TEST=y,
   from Jeremy Sowden.

9) Fix several sparse warnings due to missing prototypes, from
   Valdis Kletnieks.

10) Use static lock initialiser to ensure connlabel spinlock is
    initialized on boot time to fix sched/act_ct.c, patch
    from Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 4de97b0c86fcf9a225dff465f1614c834c2eeea6:

  Merge branch 'enetc-PCIe-MDIO' (2019-08-02 18:22:18 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 105333435b4f3b21ffc325f32fae17719310db64:

  netfilter: connlabels: prefer static lock initialiser (2019-08-13 12:15:45 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: synproxy: rename mss synproxy_options field

Florian Westphal (1):
      netfilter: connlabels: prefer static lock initialiser

Jeremy Sowden (8):
      netfilter: inline four headers files into another one.
      netfilter: add missing includes to a number of header-files.
      netfilter: add missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to header-file.
      netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
      netfilter: add missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to some header-files.
      netfilter: add missing IS_ENABLED(CONFIG_NETFILTER) checks to some header-files.
      netfilter: remove "#ifdef __KERNEL__" guards from some headers.
      kbuild: remove all netfilter headers from header-test blacklist.

Junwei Hu (1):
      ipvs: Improve robustness to the ipvs sysctl

Matteo Croce (1):
      netfilter: conntrack: use shared sysctl constants

Pablo Neira Ayuso (2):
      netfilter: nft_bitwise: add offload support
      netfilter: nf_tables: store data in offload context registers

Valdis Kletnieks (2):
      netfilter: nf_tables: add missing prototypes.
      netfilter: nf_nat_proto: make tables static

yangxingwu (1):
      netfilter: remove unnecessary spaces

 include/Kbuild                                   |  74 -------
 include/linux/netfilter/ipset/ip_set.h           | 238 ++++++++++++++++++++++-
 include/linux/netfilter/ipset/ip_set_comment.h   |  73 -------
 include/linux/netfilter/ipset/ip_set_counter.h   |  84 --------
 include/linux/netfilter/ipset/ip_set_getport.h   |   4 +
 include/linux/netfilter/ipset/ip_set_skbinfo.h   |  42 ----
 include/linux/netfilter/ipset/ip_set_timeout.h   |  77 --------
 include/linux/netfilter/nf_conntrack_amanda.h    |   4 +
 include/linux/netfilter/nf_conntrack_dccp.h      |   3 -
 include/linux/netfilter/nf_conntrack_ftp.h       |   8 +-
 include/linux/netfilter/nf_conntrack_h323.h      |  11 +-
 include/linux/netfilter/nf_conntrack_h323_asn1.h |   2 +
 include/linux/netfilter/nf_conntrack_irc.h       |   5 +-
 include/linux/netfilter/nf_conntrack_pptp.h      |  12 +-
 include/linux/netfilter/nf_conntrack_proto_gre.h |   2 -
 include/linux/netfilter/nf_conntrack_sane.h      |   4 -
 include/linux/netfilter/nf_conntrack_sip.h       |   6 +-
 include/linux/netfilter/nf_conntrack_snmp.h      |   3 +
 include/linux/netfilter/nf_conntrack_tftp.h      |   5 +
 include/linux/netfilter/x_tables.h               |   6 +
 include/linux/netfilter_arp/arp_tables.h         |   2 +
 include/linux/netfilter_bridge/ebtables.h        |   2 +
 include/linux/netfilter_ipv4/ip_tables.h         |   4 +
 include/linux/netfilter_ipv6/ip6_tables.h        |   2 +
 include/net/netfilter/br_netfilter.h             |  12 ++
 include/net/netfilter/ipv4/nf_dup_ipv4.h         |   3 +
 include/net/netfilter/ipv6/nf_defrag_ipv6.h      |   4 +-
 include/net/netfilter/ipv6/nf_dup_ipv6.h         |   2 +
 include/net/netfilter/nf_conntrack.h             |  10 +
 include/net/netfilter/nf_conntrack_acct.h        |  13 ++
 include/net/netfilter/nf_conntrack_bridge.h      |   6 +
 include/net/netfilter/nf_conntrack_core.h        |   3 +
 include/net/netfilter/nf_conntrack_count.h       |   3 +
 include/net/netfilter/nf_conntrack_l4proto.h     |   4 +
 include/net/netfilter/nf_conntrack_synproxy.h    |   2 +-
 include/net/netfilter/nf_conntrack_timestamp.h   |   6 +
 include/net/netfilter/nf_conntrack_tuple.h       |   2 +
 include/net/netfilter/nf_dup_netdev.h            |   2 +
 include/net/netfilter/nf_flow_table.h            |   5 +
 include/net/netfilter/nf_nat.h                   |   4 +
 include/net/netfilter/nf_nat_helper.h            |   4 +-
 include/net/netfilter/nf_nat_redirect.h          |   3 +
 include/net/netfilter/nf_queue.h                 |   7 +
 include/net/netfilter/nf_reject.h                |   3 +
 include/net/netfilter/nf_synproxy.h              |   4 +
 include/net/netfilter/nf_tables.h                |  12 ++
 include/net/netfilter/nf_tables_ipv6.h           |   1 +
 include/net/netfilter/nf_tables_offload.h        |   1 +
 include/net/netfilter/nft_fib.h                  |   2 +
 include/net/netfilter/nft_meta.h                 |   2 +
 include/net/netfilter/nft_reject.h               |   5 +
 include/uapi/linux/netfilter/xt_policy.h         |   1 +
 net/ipv4/netfilter/ipt_SYNPROXY.c                |   4 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c               |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_list_set.c            |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                  |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                   |  69 +++----
 net/netfilter/ipvs/ip_vs_mh.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c             |   2 +-
 net/netfilter/nf_conntrack_ftp.c                 |   2 +-
 net/netfilter/nf_conntrack_labels.c              |   3 +-
 net/netfilter/nf_conntrack_proto_tcp.c           |   2 +-
 net/netfilter/nf_conntrack_standalone.c          |  34 ++--
 net/netfilter/nf_nat_proto.c                     |   4 +-
 net/netfilter/nf_synproxy_core.c                 |   8 +-
 net/netfilter/nfnetlink_log.c                    |   4 +-
 net/netfilter/nfnetlink_queue.c                  |   4 +-
 net/netfilter/nft_bitwise.c                      |  19 ++
 net/netfilter/nft_immediate.c                    |  24 ++-
 net/netfilter/nft_set_bitmap.c                   |   2 +-
 net/netfilter/nft_set_hash.c                     |   2 +-
 net/netfilter/nft_set_rbtree.c                   |   2 +-
 net/netfilter/nft_synproxy.c                     |   4 +-
 net/netfilter/xt_IDLETIMER.c                     |   2 +-
 net/netfilter/xt_set.c                           |   1 -
 76 files changed, 527 insertions(+), 480 deletions(-)
 delete mode 100644 include/linux/netfilter/ipset/ip_set_comment.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_counter.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_skbinfo.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_timeout.h

