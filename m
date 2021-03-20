Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8BE342C5C
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCTLkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhCTLje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:39:34 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA30C0613DF;
        Fri, 19 Mar 2021 23:26:03 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id t16so6140171qvr.12;
        Fri, 19 Mar 2021 23:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=oHahWSVlLUNFk2dULEm5PnUk4cpGh3Men11lJT8PaXg=;
        b=KyzxLak81HiQiatX3GX1rM4RJZGmN6niH0mC+dsow3kkbIuJkbKHaSHiTViUd+i1ld
         Y9R4xTigpf3VOOOs7VzB5o3NVyT8lLuhJ1FoQt7OjwVJF+luUk4JSpejmh4YNTDskmwg
         5KKDbdBH/nJKBcLrVGWZ+8Wv48Gcs0j/xx40AFhHh7fyTJHsV9HWqHHvsC02TNALQADy
         K4jlA//uZat3zgHqA1FWkVU9hBQQVDNgyfuMAwYSrk5ZgN/LZ1Ue+99FvNWzQo8M2e9s
         x2D+Qlu+R7ZcSH5n/bMsspwVa6Zxv+1G1ASo6CyLwjyOszAYrcxa/aWC4acXe66Dm9uG
         jnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=oHahWSVlLUNFk2dULEm5PnUk4cpGh3Men11lJT8PaXg=;
        b=hrjpkAM6p8jx1Yp9tzB0oRC52bPE5vW4ru+14LtkFT0NJjuIVVZgKjllnbnH0T0NSo
         hOi+B+9/gow+w1O3OkGMsbZgJ8iHPCAlovHlkgiRFcKr4+1wWQkCCt6/7O9zjJs0Tvlu
         kr3TgzrnLhJ1Gp2SGLbdX8+fM4r8ieh/tEDcO+T79XaPxSyi45jAufduxvJ3btV2HHpp
         /vgZwIH7R+D96ZHgwFwZ29n0BZntT9bSFqi7avyR4nMyoQ7lFH+VmWfYMIiNHhoDByU5
         LLAg+Ts7/sLfRkfy7M2rWAKAh21mIwVnyyo7ZdcxYvQ3RW00PFk0ZRIEuLvYxqoNnsZP
         d5Dw==
X-Gm-Message-State: AOAM531nWXP6RuD13cd4Dv5/a+cFgeOs59Rgr/HRObF8zsH0nFmq66iW
        iW1k6S+ND9AjoWa2yzTEbXDQrVzUW9V+Zeyk
X-Google-Smtp-Source: ABdhPJwj37GXsy65AMroGZ7FNWUh7O5tDzbVjzwXsBrHaJOoLZCPVBapA5vjLi2yfpMhJOSV1sKQ9g==
X-Received: by 2002:a17:902:441:b029:e6:364a:5f55 with SMTP id 59-20020a1709020441b02900e6364a5f55mr17635745ple.7.1616220920082;
        Fri, 19 Mar 2021 23:15:20 -0700 (PDT)
Received: from localhost ([61.12.83.162])
        by smtp.gmail.com with ESMTPSA id z1sm7174823pfn.127.2021.03.19.23.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 23:15:19 -0700 (PDT)
Date:   Sat, 20 Mar 2021 11:45:12 +0530
From:   Sai Kalyaan Palla <saikalyaan63@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sai Kalyaan Palla <saikalyaan63@gmail.com>,
        Gaurav Singh <gaurav1086@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bkkarthik@pesu.pes.edu
Subject: [PATCH] net: decnet: Fixed multiple coding style issues
Message-ID: <20210320061512.kztp7hijps4irjrl@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Made changes to coding style as suggested by checkpatch.pl
changes are of the type:
	open brace '{' following struct go on the same line
	do not use assignment in if condition

Signed-off-by: Sai Kalyaan Palla <saikalyaan63@gmail.com>
---
 net/decnet/dn_route.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 2193ae529e75..940755cdecc9 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -84,8 +84,7 @@
 #include <net/dn_neigh.h>
 #include <net/dn_fib.h>
 
-struct dn_rt_hash_bucket
-{
+struct dn_rt_hash_bucket {
 	struct dn_route __rcu *chain;
 	spinlock_t lock;
 };
@@ -359,7 +358,8 @@ static void dn_run_flush(struct timer_list *unused)
 	for (i = 0; i < dn_rt_hash_mask; i++) {
 		spin_lock_bh(&dn_rt_hash_table[i].lock);
 
-		if ((rt = xchg((struct dn_route **)&dn_rt_hash_table[i].chain, NULL)) == NULL)
+		rt = xchg((struct dn_route **)&dn_rt_hash_table[i].chain, NULL);
+		if (!rt)
 			goto nothing_to_declare;
 
 		for(; rt; rt = next) {
@@ -425,7 +425,8 @@ static int dn_return_short(struct sk_buff *skb)
 	/* Add back headers */
 	skb_push(skb, skb->data - skb_network_header(skb));
 
-	if ((skb = skb_unshare(skb, GFP_ATOMIC)) == NULL)
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
 		return NET_RX_DROP;
 
 	cb = DN_SKB_CB(skb);
@@ -461,7 +462,8 @@ static int dn_return_long(struct sk_buff *skb)
 	/* Add back all headers */
 	skb_push(skb, skb->data - skb_network_header(skb));
 
-	if ((skb = skb_unshare(skb, GFP_ATOMIC)) == NULL)
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
 		return NET_RX_DROP;
 
 	cb = DN_SKB_CB(skb);
@@ -505,7 +507,8 @@ static int dn_route_rx_packet(struct net *net, struct sock *sk, struct sk_buff *
 	struct dn_skb_cb *cb;
 	int err;
 
-	if ((err = dn_route_input(skb)) == 0)
+	err = dn_route_input(skb);
+	if (err == 0)
 		return dst_input(skb);
 
 	cb = DN_SKB_CB(skb);
@@ -629,7 +632,8 @@ int dn_route_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type
 	if (dn == NULL)
 		goto dump_it;
 
-	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
 		goto out;
 
 	if (!pskb_may_pull(skb, 3))
@@ -1324,7 +1328,8 @@ static int dn_route_input_slow(struct sk_buff *skb)
 
 	dev_hold(in_dev);
 
-	if ((dn_db = rcu_dereference(in_dev->dn_ptr)) == NULL)
+	dn_db = rcu_dereference(in_dev->dn_ptr);
+	if (!dn_db)
 		goto out;
 
 	/* Zero source addresses are not allowed */
-- 
2.25.1

