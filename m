Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3285A258E57
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgIAMlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgIAM3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:29:20 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D69C061249
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 05:29:19 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id cy2so392511qvb.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 05:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QVdwJ+FE/ogrH2MCBk57HD52dDvLWyfsL/EvW07drLg=;
        b=pn4Kv3SzFmYS3R8PJ3Hugg4a5VSY9AWGCLWB4joFhIKmi0m9TOki4lLXEg23kh67xu
         OA1Twl8inc8ELF35YJCYfzTcnh58mSrKDpAxXEya9TAseYy/Ai7YPoDNsWmoB7Ehd0Hj
         c3sNVbgeEDOPZQjRZ8oxDnqj9TMRTUjhFnQpmaBAMjBui/SQi2itaO6XpyPNWiT3IJjn
         OZrhePct5WvXkZxPeDcN/4PnHavE9+xyvT5F9BDUs38Q+5P2Y9dhJ7frpSi16cUTLKBP
         4zTXI4ZORN4SI9h+fd2nDwjKp7UIocqnOxVR2zalAllkzCGdQdgcmN2pLzwRhz6Gn4Ib
         VENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QVdwJ+FE/ogrH2MCBk57HD52dDvLWyfsL/EvW07drLg=;
        b=GMfiNBi+crGVBZLuepLsiDFqsEapOeT+cl1ajXlbbRjH+PL3t3XxEPIRhBNN/Kffzy
         qWv4szuujvviMfmAERhmn5OeQy/EjvjKoUIAQkcH2mOzy7636Y/wqggGsOrtZ55MtdS4
         ko1fFSr8O/ZmwXJcbNib4ciQwtDxgzMdexj0CTLLC48cyI6ZRUqYgaIPpvFmf7b82BrY
         dCO6TUcIjWGiPgNwVygM6fQ+85ApduAQyMRPcCN4nuyHnrwzcjB58dZZ7uOkuFq35oZu
         E/+JEOGcUZboy6duOMWno1gp36SJKkGdlG2z2FuLIf/syaqvFd0HBIGTi4c3JRv+KbRr
         B00g==
X-Gm-Message-State: AOAM5316mtxNclYVxjC94kn1qGE0h1iw451HqbViIbgd6uVGvVgoGy7n
        6poxQygadWT0Sx8EYhonfiA=
X-Google-Smtp-Source: ABdhPJwYiJqaMQ+GcUyKLRHiXGSSqeqEv1HgBy/ts/9jMBwHczV9GTkHAq4i+LjIfcHnpSzgWTQo5g==
X-Received: by 2002:a0c:f584:: with SMTP id k4mr1706056qvm.6.1598963358391;
        Tue, 01 Sep 2020 05:29:18 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id q35sm1174220qtd.75.2020.09.01.05.29.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 05:29:17 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     sbrivio@redhat.com, davem@davemloft.net, pshelar@ovn.org,
        xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 3/3] net: openvswitch: remove unused keep_flows
Date:   Tue,  1 Sep 2020 20:26:14 +0800
Message-Id: <20200901122614.73464-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
References: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
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
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
 net/openvswitch/flow_table.c | 6 ------
 net/openvswitch/flow_table.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 80849bdf45d2..87c286ad660e 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -168,7 +168,6 @@ static struct table_instance *table_instance_alloc(int new_size)
 
 	ti->n_buckets = new_size;
 	ti->node_ver = 0;
-	ti->keep_flows = false;
 	get_random_bytes(&ti->hash_seed, sizeof(u32));
 
 	return ti;
@@ -481,9 +480,6 @@ void table_instance_flow_flush(struct flow_table *table,
 {
 	int i;
 
-	if (ti->keep_flows)
-		return;
-
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
@@ -603,8 +599,6 @@ static void flow_table_copy_flows(struct table_instance *old,
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

