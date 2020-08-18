Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD224829F
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHRKKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgHRKKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:10:36 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FB7C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:10:36 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 2so17654281qkf.10
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K44nLHLCzQuJMecWboH9C54UmBPakohQAbAnvZKlIJU=;
        b=UNG9L9cpgJ+Qx8+CmKvSghq8v0WdN6jNaAbGD8i4Vsr3jOGnzgJ1LVkmadmMC3cLnY
         h+rbvNKRB4zrp/BH7kujIwqYKyMrQ/yznJ7ssIn0PjgVB8ZSkxPzMzqV96sY2FJxn2I6
         xX7rLGuW8sDyVfscmhd3u8mtM57gBx8a2mw/TJnqsu+hXG94pqGKWfoyJ2YRMGhRQi4W
         3XePvzf40fTiNMR+vs/dEc3/vr9qyoZEkrkDxWcrtKcgRuYttqwUXtu+329cIhiar532
         mRQob5A6VeQCn0kpyHe/Nd0os9sUdQ5laarG5wwjrkubei6WaAYm3NGfsDKhPMp73t7X
         IhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K44nLHLCzQuJMecWboH9C54UmBPakohQAbAnvZKlIJU=;
        b=Q6r/zQHWHNZXpt5KGJQvKORH/HmAR1VRjutPo8/BfpCuAFSx4hnR1MSIG1AdfoljoE
         Q0ZcsvFhoLvzN9m/PEDbw80PoMURlEhO/V/sR7I9cHOd4Qaemr2/uDkJRiNJeVYDsIGO
         HqtKlIKcBT2KcJJS2zJTiOolRZFvcJ/0dWwNNHgJrKYtOaSMRdTT9HecNjYt7SrUHWqC
         GQboJSxoaL7V1cr1BcunZzKBejnuX6OXv/5BsvEczDbRrF3NlLosJyJN/e8/nX6VUomA
         mvZ1jBdery22/M2bDE10RJX7Bq5deIFL/SpyZtRjJNA/fadXpRDhMzLLz8QNQJhEsKQ3
         io5g==
X-Gm-Message-State: AOAM531H60RObhZisl/11EaYx3DWh5YwTUpXtas1fVLhZnwouI78sKwD
        LaB/AXE/A2T9PYs0AAdj/yg=
X-Google-Smtp-Source: ABdhPJzNvhVraJfNijcbgcNuMcjHOwTTaThP97iEc1N8rfE3IsM0gXbCGYs6HsYTe4++ioPCrGIqJQ==
X-Received: by 2002:a05:620a:13f7:: with SMTP id h23mr16809302qkl.396.1597745435515;
        Tue, 18 Aug 2020 03:10:35 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id 20sm20632139qkh.110.2020.08.18.03.10.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 03:10:34 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     pshelar@ovn.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v1 3/3] net: openvswitch: remove unnused keep_flows
Date:   Tue, 18 Aug 2020 18:09:23 +0800
Message-Id: <20200818100923.46840-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200818100923.46840-1-xiangxia.m.yue@gmail.com>
References: <20200818100923.46840-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

keep_flows was introduced by [1], which used as flag to delete flows or not.
When rehashing or expanding the table instance, we will not flush the flows.
Now don't use it anymore, remove it.

[1] - https://github.com/openvswitch/ovs/commit/acd051f1761569205827dc9b037e15568a8d59f8
Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 6 ------
 net/openvswitch/flow_table.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index f8a21dd80e72..0473758035b5 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -166,7 +166,6 @@ static struct table_instance *table_instance_alloc(int new_size)
 
 	ti->n_buckets = new_size;
 	ti->node_ver = 0;
-	ti->keep_flows = false;
 	get_random_bytes(&ti->hash_seed, sizeof(u32));
 
 	return ti;
@@ -479,9 +478,6 @@ void table_instance_flow_flush(struct flow_table *table,
 {
 	int i;
 
-	if (ti->keep_flows)
-		return;
-
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
@@ -598,8 +594,6 @@ static void flow_table_copy_flows(struct table_instance *old,
 						 lockdep_ovsl_is_held())
 				table_instance_insert(new, flow);
 	}
-
-	old->keep_flows = true;
 }
 
 static struct table_instance *table_instance_rehash(struct table_instance *ti,
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 6e7d4ac59353..d8fb7a3a3dfd 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -53,7 +53,6 @@ struct table_instance {
 	struct rcu_head rcu;
 	int node_ver;
 	u32 hash_seed;
-	bool keep_flows;
 };
 
 struct flow_table {
-- 
2.23.0

