Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4778B8C0CB
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfHMSiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:38:24 -0400
Received: from correo.us.es ([193.147.175.20]:59032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbfHMSiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:38:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25A10DA738
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16F891150DA
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CB8A1150CC; Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0A944CA35;
        Tue, 13 Aug 2019 20:38:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:38:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6ABB54265A2F;
        Tue, 13 Aug 2019 20:38:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/17] kbuild: remove all netfilter headers from header-test blacklist.
Date:   Tue, 13 Aug 2019 20:38:06 +0200
Message-Id: <20190813183809.4081-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183809.4081-1-pablo@netfilter.org>
References: <20190813183809.4081-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

All the blacklisted NF headers can now be compiled stand-alone, so
removed them from the blacklist.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Kbuild | 74 ----------------------------------------------------------
 1 file changed, 74 deletions(-)

diff --git a/include/Kbuild b/include/Kbuild
index c38f0d46b267..af498acb7cd2 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -386,31 +386,6 @@ header-test-			+= linux/mvebu-pmsu.h
 header-test-			+= linux/mxm-wmi.h
 header-test-			+= linux/n_r3964.h
 header-test-			+= linux/ndctl.h
-header-test-			+= linux/netfilter/ipset/ip_set.h
-header-test-			+= linux/netfilter/ipset/ip_set_bitmap.h
-header-test-			+= linux/netfilter/ipset/ip_set_comment.h
-header-test-			+= linux/netfilter/ipset/ip_set_counter.h
-header-test-			+= linux/netfilter/ipset/ip_set_getport.h
-header-test-			+= linux/netfilter/ipset/ip_set_hash.h
-header-test-			+= linux/netfilter/ipset/ip_set_list.h
-header-test-			+= linux/netfilter/ipset/ip_set_skbinfo.h
-header-test-			+= linux/netfilter/ipset/ip_set_timeout.h
-header-test-			+= linux/netfilter/nf_conntrack_amanda.h
-header-test-			+= linux/netfilter/nf_conntrack_ftp.h
-header-test-			+= linux/netfilter/nf_conntrack_h323.h
-header-test-			+= linux/netfilter/nf_conntrack_h323_asn1.h
-header-test-			+= linux/netfilter/nf_conntrack_irc.h
-header-test-			+= linux/netfilter/nf_conntrack_pptp.h
-header-test-			+= linux/netfilter/nf_conntrack_proto_gre.h
-header-test-			+= linux/netfilter/nf_conntrack_sip.h
-header-test-			+= linux/netfilter/nf_conntrack_snmp.h
-header-test-			+= linux/netfilter/nf_conntrack_tftp.h
-header-test-			+= linux/netfilter/x_tables.h
-header-test-			+= linux/netfilter_arp/arp_tables.h
-header-test-			+= linux/netfilter_bridge/ebtables.h
-header-test-			+= linux/netfilter_ipv4/ip4_tables.h
-header-test-			+= linux/netfilter_ipv4/ip_tables.h
-header-test-			+= linux/netfilter_ipv6/ip6_tables.h
 header-test-			+= linux/nfs.h
 header-test-			+= linux/nfs_fs_i.h
 header-test-			+= linux/nfs_fs_sb.h
@@ -874,43 +849,6 @@ header-test-			+= net/mpls_iptunnel.h
 header-test-			+= net/mrp.h
 header-test-			+= net/ncsi.h
 header-test-			+= net/netevent.h
-header-test-			+= net/netfilter/br_netfilter.h
-header-test-			+= net/netfilter/ipv4/nf_dup_ipv4.h
-header-test-			+= net/netfilter/ipv6/nf_defrag_ipv6.h
-header-test-			+= net/netfilter/ipv6/nf_dup_ipv6.h
-header-test-			+= net/netfilter/nf_conntrack.h
-header-test-			+= net/netfilter/nf_conntrack_acct.h
-header-test-			+= net/netfilter/nf_conntrack_bridge.h
-header-test-			+= net/netfilter/nf_conntrack_core.h
-header-test-			+= net/netfilter/nf_conntrack_count.h
-header-test-			+= net/netfilter/nf_conntrack_ecache.h
-header-test-			+= net/netfilter/nf_conntrack_expect.h
-header-test-			+= net/netfilter/nf_conntrack_extend.h
-header-test-			+= net/netfilter/nf_conntrack_helper.h
-header-test-			+= net/netfilter/nf_conntrack_l4proto.h
-header-test-			+= net/netfilter/nf_conntrack_labels.h
-header-test-			+= net/netfilter/nf_conntrack_seqadj.h
-header-test-			+= net/netfilter/nf_conntrack_synproxy.h
-header-test-			+= net/netfilter/nf_conntrack_timeout.h
-header-test-			+= net/netfilter/nf_conntrack_timestamp.h
-header-test-			+= net/netfilter/nf_conntrack_tuple.h
-header-test-			+= net/netfilter/nf_dup_netdev.h
-header-test-			+= net/netfilter/nf_flow_table.h
-header-test-			+= net/netfilter/nf_nat.h
-header-test-			+= net/netfilter/nf_nat_helper.h
-header-test-			+= net/netfilter/nf_nat_masquerade.h
-header-test-			+= net/netfilter/nf_nat_redirect.h
-header-test-			+= net/netfilter/nf_queue.h
-header-test-			+= net/netfilter/nf_reject.h
-header-test-			+= net/netfilter/nf_synproxy.h
-header-test-$(CONFIG_NF_TABLES)	+= net/netfilter/nf_tables.h
-header-test-$(CONFIG_NF_TABLES)	+= net/netfilter/nf_tables_core.h
-header-test-$(CONFIG_NF_TABLES)	+= net/netfilter/nf_tables_ipv4.h
-header-test-			+= net/netfilter/nf_tables_ipv6.h
-header-test-$(CONFIG_NF_TABLES)	+= net/netfilter/nf_tables_offload.h
-header-test-			+= net/netfilter/nft_fib.h
-header-test-			+= net/netfilter/nft_meta.h
-header-test-			+= net/netfilter/nft_reject.h
 header-test-			+= net/netns/can.h
 header-test-			+= net/netns/generic.h
 header-test-			+= net/netns/ieee802154_6lowpan.h
@@ -1140,18 +1078,6 @@ header-test-			+= uapi/linux/kvm_para.h
 header-test-			+= uapi/linux/lightnvm.h
 header-test-			+= uapi/linux/mic_common.h
 header-test-			+= uapi/linux/mman.h
-header-test-			+= uapi/linux/netfilter/ipset/ip_set_bitmap.h
-header-test-			+= uapi/linux/netfilter/ipset/ip_set_hash.h
-header-test-			+= uapi/linux/netfilter/ipset/ip_set_list.h
-header-test-			+= uapi/linux/netfilter/nf_synproxy.h
-header-test-			+= uapi/linux/netfilter/xt_policy.h
-header-test-			+= uapi/linux/netfilter/xt_set.h
-header-test-			+= uapi/linux/netfilter_arp/arp_tables.h
-header-test-			+= uapi/linux/netfilter_arp/arpt_mangle.h
-header-test-			+= uapi/linux/netfilter_ipv4/ip_tables.h
-header-test-			+= uapi/linux/netfilter_ipv4/ipt_LOG.h
-header-test-			+= uapi/linux/netfilter_ipv6/ip6_tables.h
-header-test-			+= uapi/linux/netfilter_ipv6/ip6t_LOG.h
 header-test-			+= uapi/linux/nilfs2_ondisk.h
 header-test-			+= uapi/linux/patchkey.h
 header-test-			+= uapi/linux/ptrace.h
-- 
2.11.0


