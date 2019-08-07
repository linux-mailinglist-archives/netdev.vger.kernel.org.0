Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBEF84E75
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbfHGORW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:22 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46016 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fp+voSZmWvbMQBhIaifN4kxvyAeoXHdh8ECDxWSpZpA=; b=c8RvZ1AGayn4k7OONIoQK5g41J
        i+m3CaqVeGdizn7qiItWC2o11iT3ewXyueVJmuk1BmqhclzL1IMyufAbobhOgLbzoX7pqPHbkcyNg
        +mMlF8G+sVJQ1t2p4kqfPx+XYIAGz8h2S9S2D1TxwymmweyASRbtSbj2JrDkTO8Rw05/IWmMBDwP/
        VJtvu8m78+0pPYArtAxeyBxks7loYydWGRjCauQAsb4wua9f+bxZmwQdiPIlTZv4x0B5W1QfCg54o
        FxtlmUeYCYTgf1+Yr8ca5BobBGYZi3Y3SbJ4X+BygGU1rPZT39+9SR40gfRUNLldjmaqMkc3qoBhj
        mMMYLUAw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkV-0001Wc-Dg; Wed, 07 Aug 2019 15:17:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 8/8] kbuild: removed all netfilter headers from header-test blacklist.
Date:   Wed,  7 Aug 2019 15:17:05 +0100
Message-Id: <20190807141705.4864-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the blacklisted NF headers can now be compiled stand-alone, so
removed them from the blacklist.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/Kbuild | 74 --------------------------------------------------
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
2.20.1

