Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87C3348F0
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCJUdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCJUdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:33:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CABC061574;
        Wed, 10 Mar 2021 12:33:23 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d8so9056766plg.10;
        Wed, 10 Mar 2021 12:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pUa3+6lMCh9OsEEA0VH4ygBAOSBRoM3nA1zgeCu6wVI=;
        b=rg8UwETO4XJrE9SHJd9evgunYIpfaPDNEAniCBv52ARsPQ0Pzg1lKcjrLGwv+SxEH8
         60M8Ve4BU9oOkAnp8kCuggBZkJKVhOaV78OsEXGgyB7D8uI9xCq3s+Y7S+gR/dHzFYMu
         JEBEZGlRY04LFg6qKN7x2Xt8U5mFQOmAho5a2vfxqeuOfoCk2FqPFp2RkscZri/ut/hl
         o7MBcwMVDmzA5wubrdX99sP1TM4t0hBc1FYRFA4n14drvoHKApCGrWMbOFtxjEfobja9
         QYoCjeyVutdcLMfhce5zMma0MlzJb6nbZRyJ8aZvnJlLGosUUsl4+hca66KXCSTNBk4C
         0h4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pUa3+6lMCh9OsEEA0VH4ygBAOSBRoM3nA1zgeCu6wVI=;
        b=NIZmy9CPWAt+1HLDHLjKcWFkqSV6r3Qf0nGUkmuPrMBU7aiy+RCadX/dZyvvYRuxMI
         iq6pj4TdnKlfg25q+uvWn+cXVUaagCj8YViscJ6DW9LGuydcKiYmPya1L0XDAcExRoUL
         lOXZCRYE7jNVlzF3L9GQBle4KpZw5cOg6hIVDA+CYeFikkCaflCoabobQK9rhI8ykN3R
         rzI3AURSOt5vg/a7IoVvKqMAOEGmfslHxyCbSgSOnHJ3wCNaUBGJ7qqol16AyZEREAz7
         3j2nn1B03HMUEgcSZbiiJhVg08Aw3JumG3xd6xUSVujenLqgz2wmXDcsOVlqEvXAyNpf
         b0pA==
X-Gm-Message-State: AOAM5314TmkulFG8EtR5FyvuVcIm2CBqOQB04LEReXMOX5rdbudH30Eg
        xq0FiJ2YmOqlYipXhLNYAjg=
X-Google-Smtp-Source: ABdhPJwg3mB5jAeRZERraMNPZDOvziwbLUWHkqXWMCPqlZ8Oy67Th3RiPoxnSvjqcY3v/DxVh5X/CA==
X-Received: by 2002:a17:90a:ec15:: with SMTP id l21mr5184321pjy.164.1615408403205;
        Wed, 10 Mar 2021 12:33:23 -0800 (PST)
Received: from localhost ([122.179.55.249])
        by smtp.gmail.com with ESMTPSA id o123sm376601pfb.16.2021.03.10.12.33.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 12:33:22 -0800 (PST)
Date:   Thu, 11 Mar 2021 02:03:14 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, bpf@vger.kernel.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        bkkarthik@pesu.pes.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ipv6: route.c:fix indentation
Message-ID: <20210310203314.wk6zjxyo6ax5chbd@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series of space has been replaced by tab space
wherever required.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/ipv6/route.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1536f4948e86..60058f3dcc48 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2378,7 +2378,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 
 			memset(&hash_keys, 0, sizeof(hash_keys));
 
-                        if (!flkeys) {
+			if (!flkeys) {
 				skb_flow_dissect_flow_keys(skb, &keys, flag);
 				flkeys = &keys;
 			}
@@ -2518,20 +2518,20 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
 					 struct flowi6 *fl6,
 					 int flags)
 {
-        struct dst_entry *dst;
-        struct rt6_info *rt6;
+	struct dst_entry *dst;
+	struct rt6_info *rt6;
 
-        rcu_read_lock();
-        dst = ip6_route_output_flags_noref(net, sk, fl6, flags);
-        rt6 = (struct rt6_info *)dst;
-        /* For dst cached in uncached_list, refcnt is already taken. */
-        if (list_empty(&rt6->rt6i_uncached) && !dst_hold_safe(dst)) {
-                dst = &net->ipv6.ip6_null_entry->dst;
-                dst_hold(dst);
-        }
-        rcu_read_unlock();
+	rcu_read_lock();
+	dst = ip6_route_output_flags_noref(net, sk, fl6, flags);
+	rt6 = (struct rt6_info *)dst;
+	/* For dst cached in uncached_list, refcnt is already taken. */
+	if (list_empty(&rt6->rt6i_uncached) && !dst_hold_safe(dst)) {
+		dst = &net->ipv6.ip6_null_entry->dst;
+		dst_hold(dst);
+	}
+	rcu_read_unlock();
 
-        return dst;
+	return dst;
 }
 EXPORT_SYMBOL_GPL(ip6_route_output_flags);
 
-- 
2.17.1

