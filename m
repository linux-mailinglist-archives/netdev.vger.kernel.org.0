Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C2934669B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhCWRoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhCWRoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:44:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BA8C061574;
        Tue, 23 Mar 2021 10:44:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s21so10430050pjq.1;
        Tue, 23 Mar 2021 10:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=uTTW2Bp8A8zw/GLQbpb96vNlplssbvzgvQZq5e4cEAY=;
        b=c5O6Oc4EH3/8pLm+5/KHLgeSeW6qcQliABWb8y1S6RHJFsEXmQOWFAcdfM9npIePNk
         4HaJmT4/o+WYPr0U9HgFXvfyqVjBwUQGW5gQoc2p7NfRK12wXpaycAa5xQ3mcQyUSCdC
         Pp40gw/8kNJ3EziFrqN8g/2Mgjw4DsodJrMCBdncyF0Yrs85dkiCZK4xats8P9mNtUKR
         CW6BK60kM/b4mEMncV43e29W9Oj8xiXLt5hSEsG+EK9pDd08NzqmZzwc0TlIUom5noqg
         29lxcDytnpJnxn2IFW8ZfF6aZERTgg5mldCPjNUQgpSkc6l2lAVbpccTRZWD+j8+DF4F
         LtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=uTTW2Bp8A8zw/GLQbpb96vNlplssbvzgvQZq5e4cEAY=;
        b=awkamsRhnSBKpdmJX2vFkd1eP3M/nmTgRMQ08y3EWMGXPWvt/68BmCxiVdgIf1pRPR
         4cNqGN9xE7Pu8RSbG6TNyHXZ15cPQ/URosdqHQWNMpuA0uV3f5NMqBcWaKJpjG+5SEgh
         dNW074FqvDlfR11Di8FnT0OsTbgMyJKySyHfv+qw1mQvKN58aLO5h3sHYswqNh6cGK0+
         +hkN+laglgV7/ouEDMHxsnYa1noapvpICLFrYGiobrgwtcp7PH58Anu4EZWoB2ZsHH5O
         MHkvm87nEV30JjsT6tCn/f2px9r99U/JOuNCBM4kXfpKoTQ/68QgVjvLl4WXCwsi9fnj
         T1yA==
X-Gm-Message-State: AOAM530D3Lc6te9m8d4WLEJutDLIxu5oWHnhTrzJcyCvZnnWhv4tTuho
        wBFkjLMmfBlCVaAONpzH2ok=
X-Google-Smtp-Source: ABdhPJwaSQJ4DZTqsHRbneBAAHdjShNRlLJ3igGyapleUAzvZkrihLUUvF5E3is1aoVScNNm/PuoeA==
X-Received: by 2002:a17:90a:4d81:: with SMTP id m1mr5553008pjh.143.1616521469036;
        Tue, 23 Mar 2021 10:44:29 -0700 (PDT)
Received: from localhost ([61.12.83.162])
        by smtp.gmail.com with ESMTPSA id d19sm3201209pjs.55.2021.03.23.10.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 10:44:28 -0700 (PDT)
Date:   Tue, 23 Mar 2021 23:14:19 +0530
From:   Sai Kalyaan Palla <saikalyaan63@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sai Kalyaan Palla <saikalyaan63@gmail.com>,
        Gaurav Singh <gaurav1086@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Subject: [PATCH] net: decnet: Fixed multiple Coding Style issues
Message-ID: <20210323174419.f53s5x26pvjqt57k@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Made changes to coding style as suggested by checkpatch.pl
    changes are of the type:
            space required before the open parenthesis '('
            space required after that ','

Signed-off-by: Sai Kalyaan Palla <saikalyaan63@gmail.com>
---
 net/decnet/dn_route.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 940755cdecc9..3e3242577440 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -92,7 +92,7 @@ struct dn_rt_hash_bucket {
 extern struct neigh_table dn_neigh_table;
 
 
-static unsigned char dn_hiord_addr[6] = {0xAA,0x00,0x04,0x00,0x00,0x00};
+static unsigned char dn_hiord_addr[6] = {0xAA, 0x00, 0x04, 0x00, 0x00, 0x00};
 
 static const int dn_rt_min_delay = 2 * HZ;
 static const int dn_rt_max_delay = 10 * HZ;
@@ -362,7 +362,7 @@ static void dn_run_flush(struct timer_list *unused)
 		if (!rt)
 			goto nothing_to_declare;
 
-		for(; rt; rt = next) {
+		for (; rt; rt = next) {
 			next = rcu_dereference_raw(rt->dn_next);
 			RCU_INIT_POINTER(rt->dn_next, NULL);
 			dst_dev_put(&rt->dst);
@@ -902,7 +902,7 @@ static inline int dn_match_addr(__le16 addr1, __le16 addr2)
 {
 	__u16 tmp = le16_to_cpu(addr1) ^ le16_to_cpu(addr2);
 	int match = 16;
-	while(tmp) {
+	while (tmp) {
 		tmp >>= 1;
 		match--;
 	}
@@ -1388,7 +1388,7 @@ static int dn_route_input_slow(struct sk_buff *skb)
 		fld.saddr = src_map;
 	}
 
-	switch(res.type) {
+	switch (res.type) {
 	case RTN_UNICAST:
 		/*
 		 * Forwarding check here, we only check for forwarding
@@ -1531,7 +1531,7 @@ static int dn_route_input(struct sk_buff *skb)
 		return 0;
 
 	rcu_read_lock();
-	for(rt = rcu_dereference(dn_rt_hash_table[hash].chain); rt != NULL;
+	for (rt = rcu_dereference(dn_rt_hash_table[hash].chain); rt != NULL;
 	    rt = rcu_dereference(rt->dn_next)) {
 		if ((rt->fld.saddr == cb->src) &&
 		    (rt->fld.daddr == cb->dst) &&
@@ -1744,13 +1744,13 @@ int dn_cache_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 	s_h = cb->args[0];
 	s_idx = idx = cb->args[1];
-	for(h = 0; h <= dn_rt_hash_mask; h++) {
+	for (h = 0; h <= dn_rt_hash_mask; h++) {
 		if (h < s_h)
 			continue;
 		if (h > s_h)
 			s_idx = 0;
 		rcu_read_lock_bh();
-		for(rt = rcu_dereference_bh(dn_rt_hash_table[h].chain), idx = 0;
+		for (rt = rcu_dereference_bh(dn_rt_hash_table[h].chain), idx = 0;
 			rt;
 			rt = rcu_dereference_bh(rt->dn_next), idx++) {
 			if (idx < s_idx)
@@ -1784,7 +1784,7 @@ static struct dn_route *dn_rt_cache_get_first(struct seq_file *seq)
 	struct dn_route *rt = NULL;
 	struct dn_rt_cache_iter_state *s = seq->private;
 
-	for(s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
+	for (s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
 		rcu_read_lock_bh();
 		rt = rcu_dereference_bh(dn_rt_hash_table[s->bucket].chain);
 		if (rt)
@@ -1814,7 +1814,7 @@ static void *dn_rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
 	struct dn_route *rt = dn_rt_cache_get_first(seq);
 
 	if (rt) {
-		while(*pos && (rt = dn_rt_cache_get_next(seq, rt)))
+		while (*pos && (rt = dn_rt_cache_get_next(seq, rt)))
 			--*pos;
 	}
 	return *pos ? NULL : rt;
@@ -1869,21 +1869,21 @@ void __init dn_route_init(void)
 
 	goal = totalram_pages() >> (26 - PAGE_SHIFT);
 
-	for(order = 0; (1UL << order) < goal; order++)
+	for (order = 0; (1UL << order) < goal; order++)
 		/* NOTHING */;
 
 	/*
 	 * Only want 1024 entries max, since the table is very, very unlikely
 	 * to be larger than that.
 	 */
-	while(order && ((((1UL << order) * PAGE_SIZE) /
+	while (order && ((((1UL << order) * PAGE_SIZE) /
 				sizeof(struct dn_rt_hash_bucket)) >= 2048))
 		order--;
 
 	do {
 		dn_rt_hash_mask = (1UL << order) * PAGE_SIZE /
 			sizeof(struct dn_rt_hash_bucket);
-		while(dn_rt_hash_mask & (dn_rt_hash_mask - 1))
+		while (dn_rt_hash_mask & (dn_rt_hash_mask - 1))
 			dn_rt_hash_mask--;
 		dn_rt_hash_table = (struct dn_rt_hash_bucket *)
 			__get_free_pages(GFP_ATOMIC, order);
@@ -1898,7 +1898,7 @@ void __init dn_route_init(void)
 		(long)(dn_rt_hash_mask*sizeof(struct dn_rt_hash_bucket))/1024);
 
 	dn_rt_hash_mask--;
-	for(i = 0; i <= dn_rt_hash_mask; i++) {
+	for (i = 0; i <= dn_rt_hash_mask; i++) {
 		spin_lock_init(&dn_rt_hash_table[i].lock);
 		dn_rt_hash_table[i].chain = NULL;
 	}
-- 
2.25.1

