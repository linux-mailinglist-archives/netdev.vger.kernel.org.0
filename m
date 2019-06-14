Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39EE7453AB
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfFNEmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:42:01 -0400
Received: from cat-porwal-prod-mail1.catalyst.net.nz ([202.78.240.226]:47766
        "EHLO cat-porwal-prod-mail1.catalyst.net.nz" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbfFNEmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 00:42:01 -0400
Received: from timbeale-pc.wgtn.cat-it.co.nz (unknown [IPv6:2404:130:0:1000:ed06:1c1d:e56c:b595])
        (Authenticated sender: timbeale@catalyst.net.nz)
        by cat-porwal-prod-mail1.catalyst.net.nz (Postfix) with ESMTPSA id 8D35C81546;
        Fri, 14 Jun 2019 16:41:59 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=catalyst.net.nz;
        s=default; t=1560487319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=SCh5QnKEX/n9xTL/ke/zsYY4Am+WLYmiCEIJreTOxzI=;
        b=JSmymAO9mNCGWH1fy2D9WI2URxMFXlTbQp9unuL56JRdgTmU1DBki3fyzS6Q9tTNSQqFSH
        yJ880SsPUJ/Jvz7J0bxFTC1rG/PYgLm9tkkfD8UsgMAdbRtTug+++L0GGF6deVeuUfjIAi
        Dek9iBOo6kXDVsKxBUFglaFLLCqbqtQRiIfVgqlkHRHI6FqSy1UEeGhluP46Wmo7EZBDuN
        30l84I5koamOb17dWsyQW/CYgjVP6ghRUSjPDuGFJSs1khX66fAaeDOtFCJddSpWCcgc2P
        +Y4Utb7Q1/UoBex4VhSi6XLtM81JyYyv2fYDZarPLRGEIPYS0n/hlF3Yon9r6w==
From:   Tim Beale <timbeale@catalyst.net.nz>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Tim Beale <timbeale@catalyst.net.nz>
Subject: [PATCH net next 2/2] udp: Remove unused variable/function (exact_dif)
Date:   Fri, 14 Jun 2019 16:41:27 +1200
Message-Id: <1560487287-198694-2-git-send-email-timbeale@catalyst.net.nz>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
References: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=catalyst.net.nz;
        s=default; t=1560487319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=SCh5QnKEX/n9xTL/ke/zsYY4Am+WLYmiCEIJreTOxzI=;
        b=q48k+Lq54jbK3h7xiZzmoFTZ8SeJQWvVI6tmMxUP8lleAx/55T3vD6dsdOCXfRa/J8EK70
        ZeTlV1zk89BFUWOtXDEtjFtZ5Y1T61nHnRQpdE6CYUwc8f7ErObtYXtaqzBizEOxRHURSN
        Dzpd5WyQluZZ5DgPOovoPGK3zc5bqYF9T6VNzRfr62egaVkwec3taR5buGLGyYDFPUBPfm
        10MAtuFf7gKfK0QYkPFS9BAY+pTPYw0k33hpq36990IXjTWoVMcdeShOkNP71doDxBuZGj
        /TmwPBCx7MHkSfH0dZr3uiBbepej7rqX9+dmkwztU3E2pr6wMBq+gOPK/WHLzQ==
ARC-Seal: i=1; s=default; d=catalyst.net.nz; t=1560487319; a=rsa-sha256;
        cv=none;
        b=jPVFIKSblpizb5KIQweZfz3exvjainUO58P/i018J9XRpCMV89ggU5bEQH6WGczsxlVmmP
        j5aWVqf7Ie8jNppf3zwSTNwhDUt8gZYFGAu8Dujg6TrpKkZEWeRFkErF5/nnKXLZyUSDZo
        9bX66RL2VH+CeVP0zp/SDU5lmGlMCE1tstBM3KKH5JrhHC/QCuDBvXv0yGMlOfbCJYyaim
        M96Mi0szECNwFG2BcvZC4V/+Us41Sbo4g5tneLHnnCIIivX2wHy71lqLkj+nJ44ZCGztvp
        AcS/4qrL+I+H1OWhSiN6XaA52R3wN//zFXNc4DRpH+6sIgtK6okuZQ507MSNkA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=timbeale@catalyst.net.nz smtp.mailfrom=timbeale@catalyst.net.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was originally passed through to the VRF logic in compute_score().
But that logic has now been replaced by udp_sk_bound_dev_eq() and so
this code is no longer used or needed.

Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
---
 net/ipv4/udp.c | 12 ------------
 net/ipv6/udp.c | 11 -----------
 2 files changed, 23 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 21febf1..211a8f3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -125,17 +125,6 @@ EXPORT_SYMBOL(udp_memory_allocated);
 #define MAX_UDP_PORTS 65536
 #define PORTS_PER_CHAIN (MAX_UDP_PORTS / UDP_HTABLE_SIZE_MIN)
 
-/* IPCB reference means this can not be used from early demux */
-static bool udp_lib_exact_dif_match(struct net *net, struct sk_buff *skb)
-{
-#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	if (!net->ipv4.sysctl_udp_l3mdev_accept &&
-	    skb && ipv4_l3mdev_skb(IPCB(skb)->flags))
-		return true;
-#endif
-	return false;
-}
-
 static int udp_lib_lport_inuse(struct net *net, __u16 num,
 			       const struct udp_hslot *hslot,
 			       unsigned long *bitmap,
@@ -460,7 +449,6 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
-	bool exact_dif = udp_lib_exact_dif_match(net, skb);
 
 	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
 	slot2 = hash2 & udptable->mask;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8acd24e..b50ecac 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -54,16 +54,6 @@
 #include <trace/events/skb.h>
 #include "udp_impl.h"
 
-static bool udp6_lib_exact_dif_match(struct net *net, struct sk_buff *skb)
-{
-#if defined(CONFIG_NET_L3_MASTER_DEV)
-	if (!net->ipv4.sysctl_udp_l3mdev_accept &&
-	    skb && ipv6_l3mdev_skb(IP6CB(skb)->flags))
-		return true;
-#endif
-	return false;
-}
-
 static u32 udp6_ehashfn(const struct net *net,
 			const struct in6_addr *laddr,
 			const u16 lport,
@@ -195,7 +185,6 @@ struct sock *__udp6_lib_lookup(struct net *net,
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
 	struct sock *result;
-	bool exact_dif = udp6_lib_exact_dif_match(net, skb);
 
 	hash2 = ipv6_portaddr_hash(net, daddr, hnum);
 	slot2 = hash2 & udptable->mask;
-- 
2.7.4

