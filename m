Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAB133868C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhCLHas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhCLHaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:30:15 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD92C061574;
        Thu, 11 Mar 2021 23:30:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so10658132pjb.2;
        Thu, 11 Mar 2021 23:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=BkvWwioQy+TovUxuGJjJj/30Ns2zPuJ42mVidHoKW+4=;
        b=FhBGKOdrSIAd8JlwNDJx6tstPAmhfMWuV3Vvn8nP0J4Rpp/TNrZi6hBQrtiVHqP1sn
         m05RqzpH99ETgqmCiI6p/rTAs6fGccepDgNq4rq3z1iAIe8JV9ilfRrVUD4Jrkl5jRjf
         UT0Ohi3hF+mLq2jazvClOBe8mEokX8EWcW2u5z9veTvdR+X/erkrm//MNJ/mLmhTRWO2
         tKk560Zvc9Zeuem/ZbBuV/PoMH7K+1M3VaPDIh+F+tcQym5aXQI+z2VeGwOz+7qC+7mk
         GCoodOfj7fBzXnzlAiyfH3o7stPa1EPYbthU68/ol2sMeNN1F+CXxfO0ZScaOlhiHecC
         ciCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BkvWwioQy+TovUxuGJjJj/30Ns2zPuJ42mVidHoKW+4=;
        b=Pkhfdzy8eZZduMZWwYIEvw3nTHOKSSSC/57TJ9guU8vB/QXs4O5o6Vpk7ta4rcasgB
         7WmTZz/0HckrdrFlKVD3bVxqGMwEAbbF4RSkJ4/BE7+uOscUL0szTEcoI5ks3J4rj2u5
         tlkskM/1WHCzWuJrD1Eh9lyNp2FmivIAtE0fAZ3qcEZm4TMcK86eJ2OyG69nKd5hfjjx
         y4x1R4N+DbN6E75rcMABBb7Hy0Nr9iLVkf8RykpO80kfPFvLxqcPWiTe3gSa45ESyweo
         T6IceSNuXIgGBKXPTjugJebb7kT9txFRYibEXIyS4C3tfYF3+csGaf4ijw3xOx/tWrdJ
         5EcQ==
X-Gm-Message-State: AOAM532rpmgb1jKiVNDsi/6ORA5OCboTAxr8RorF6A/p5sgb18ajKq0E
        PKZAlMVI9mxoBGwIvq7Qv+4=
X-Google-Smtp-Source: ABdhPJwWcOWLLBfo3PlVs6ZAljqAGC+z8o42hnXpJKxIUSTF7URabYkK89jwbNG37Kvv3szuCp0OnQ==
X-Received: by 2002:a17:90b:17d1:: with SMTP id me17mr12758971pjb.106.1615534215197;
        Thu, 11 Mar 2021 23:30:15 -0800 (PST)
Received: from localhost ([106.206.64.11])
        by smtp.gmail.com with ESMTPSA id w84sm4436351pfc.142.2021.03.11.23.30.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 23:30:14 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:00:05 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sanjanasrinidhi1810@gmail.com
Subject: [PATCH] net: ipv4: route.c: Fix indentation of multi line comment.
Message-ID: <20210312073005.l7s25qeui5lh5zsd@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All comment lines inside the comment block have been aligned.
Every line of comment starts with a * (uniformity in code).

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/ipv4/route.c | 97 ++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 48 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 02d81d79deeb..b930f5976961 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -722,6 +722,7 @@ static void update_or_create_fnhe(struct fib_nh_common *nhc, __be32 daddr,
 
 		for_each_possible_cpu(i) {
 			struct rtable __rcu **prt;
+
 			prt = per_cpu_ptr(nhc->nhc_pcpu_rth_output, i);
 			rt = rcu_dereference(*prt);
 			if (rt)
@@ -1258,12 +1259,12 @@ static int ip_rt_bug(struct net *net, struct sock *sk, struct sk_buff *skb)
 }
 
 /*
-   We do not cache source address of outgoing interface,
-   because it is used only by IP RR, TS and SRR options,
-   so that it out of fast path.
-
-   BTW remember: "addr" is allowed to be not aligned
-   in IP options!
+ * We do not cache source address of outgoing interface,
+ * because it is used only by IP RR, TS and SRR options,
+ * so that it out of fast path.
+ *
+ * BTW remember: "addr" is allowed to be not aligned
+ * in IP options!
  */
 
 void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
@@ -2108,7 +2109,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		goto out;
 
 	/* Check for the most weird martians, which can be not detected
-	   by fib_lookup.
+	 * by fib_lookup.
 	 */
 
 	tun_info = skb_tunnel_info(skb);
@@ -2317,15 +2318,15 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		       u8 tos, struct net_device *dev, struct fib_result *res)
 {
 	/* Multicast recognition logic is moved from route cache to here.
-	   The problem was that too many Ethernet cards have broken/missing
-	   hardware multicast filters :-( As result the host on multicasting
-	   network acquires a lot of useless route cache entries, sort of
-	   SDR messages from all the world. Now we try to get rid of them.
-	   Really, provided software IP multicast filter is organized
-	   reasonably (at least, hashed), it does not result in a slowdown
-	   comparing with route cache reject entries.
-	   Note, that multicast routers are not affected, because
-	   route cache entry is created eventually.
+	 * The problem was that too many Ethernet cards have broken/missing
+	 * hardware multicast filters :-( As result the host on multicasting
+	 * network acquires a lot of useless route cache entries, sort of
+	 * SDR messages from all the world. Now we try to get rid of them.
+	 * Really, provided software IP multicast filter is organized
+	 * reasonably (at least, hashed), it does not result in a slowdown
+	 * comparing with route cache reject entries.
+	 * Note, that multicast routers are not affected, because
+	 * route cache entry is created eventually.
 	 */
 	if (ipv4_is_multicast(daddr)) {
 		struct in_device *in_dev = __in_dev_get_rcu(dev);
@@ -2537,11 +2538,11 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 		rth = ERR_PTR(-ENETUNREACH);
 
 		/* I removed check for oif == dev_out->oif here.
-		   It was wrong for two reasons:
-		   1. ip_dev_find(net, saddr) can return wrong iface, if saddr
-		      is assigned to multiple interfaces.
-		   2. Moreover, we are allowed to send packets with saddr
-		      of another iface. --ANK
+		 * It was wrong for two reasons:
+		 * 1. ip_dev_find(net, saddr) can return wrong iface, if saddr
+		 *    is assigned to multiple interfaces.
+		 * 2. Moreover, we are allowed to send packets with saddr
+		 *    of another iface. --ANK
 		 */
 
 		if (fl4->flowi4_oif == 0 &&
@@ -2553,18 +2554,18 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 				goto out;
 
 			/* Special hack: user can direct multicasts
-			   and limited broadcast via necessary interface
-			   without fiddling with IP_MULTICAST_IF or IP_PKTINFO.
-			   This hack is not just for fun, it allows
-			   vic,vat and friends to work.
-			   They bind socket to loopback, set ttl to zero
-			   and expect that it will work.
-			   From the viewpoint of routing cache they are broken,
-			   because we are not allowed to build multicast path
-			   with loopback source addr (look, routing cache
-			   cannot know, that ttl is zero, so that packet
-			   will not leave this host and route is valid).
-			   Luckily, this hack is good workaround.
+			 * and limited broadcast via necessary interface
+			 * without fiddling with IP_MULTICAST_IF or IP_PKTINFO.
+			 * This hack is not just for fun, it allows
+			 * vic,vat and friends to work.
+			 * They bind socket to loopback, set ttl to zero
+			 * and expect that it will work.
+			 * From the viewpoint of routing cache they are broken,
+			 * because we are not allowed to build multicast path
+			 * with loopback source addr (look, routing cache
+			 * cannot know, that ttl is zero, so that packet
+			 * will not leave this host and route is valid).
+			 * Luckily, this hack is good workaround.
 			 */
 
 			fl4->flowi4_oif = dev_out->ifindex;
@@ -2627,21 +2628,21 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 		    (ipv4_is_multicast(fl4->daddr) ||
 		    !netif_index_is_l3_master(net, fl4->flowi4_oif))) {
 			/* Apparently, routing tables are wrong. Assume,
-			   that the destination is on link.
-
-			   WHY? DW.
-			   Because we are allowed to send to iface
-			   even if it has NO routes and NO assigned
-			   addresses. When oif is specified, routing
-			   tables are looked up with only one purpose:
-			   to catch if destination is gatewayed, rather than
-			   direct. Moreover, if MSG_DONTROUTE is set,
-			   we send packet, ignoring both routing tables
-			   and ifaddr state. --ANK
-
-
-			   We could make it even if oif is unknown,
-			   likely IPv6, but we do not.
+			 * that the destination is on link.
+			 *
+			 * WHY? DW.
+			 * Because we are allowed to send to iface
+			 * even if it has NO routes and NO assigned
+			 * addresses. When oif is specified, routing
+			 * tables are looked up with only one purpose:
+			 * to catch if destination is gatewayed, rather than
+			 * direct. Moreover, if MSG_DONTROUTE is set,
+			 * we send packet, ignoring both routing tables
+			 * and ifaddr state. --ANK
+			 *
+			 *
+			 * We could make it even if oif is unknown,
+			 * likely IPv6, but we do not.
 			 */
 
 			if (fl4->saddr == 0)
-- 
2.17.1

