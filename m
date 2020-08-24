Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2C24F330
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHXHiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgHXHh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:37:59 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE8C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:37:58 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id i2so2329730qtb.8
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5eCGLgLNenZ566UZPUM5B88289BkX6rGslWGkr4wp0Q=;
        b=dF3PGoyRdkh+ejT/bJxGucIVmaKa6B6dYibGEaYQXOYHOX1Kjvblcg6NrxuLBtPP+B
         WWmNu1ZAiTJoSUHTonkabDrUYT09cNPvhN+yyhy+6YXkoBn5NiJdcOipR8ZSxlz/qOVO
         Ew2640Tv+ZLMS0ZmQZHRxN+MVRftfY8Oj9MKRPNEgD2shnArAR/sAyVEqeQcPoEdzgwb
         wA6XhdCXYfiYKdfd6Z4HBSVHeWo48dtk8jD+yS+LazqLluNWl/ytSIE7utACV+X/wk24
         B2U7/MjNRUTMteekWc42d108qo3ZeY1eKIlU2MvWMTabrxv4EB4FLheBSyuojFx5w8Nf
         ayLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5eCGLgLNenZ566UZPUM5B88289BkX6rGslWGkr4wp0Q=;
        b=EmJmz0cS2bI+UauCwfCDd28EY47VbFon5OcvaK5OBX8RDjSG4evonYjPwPXI+L1VGE
         17ifPbuXDhL8VFS+91+DUndI56BzIZSesXNpRbQT+BJPufRZ9Kmvg8LdGUSVqQ53Mnff
         GgFfdy0JHmaYzxwUCM3syNsqfXjj9sT8LZ7P1K22AKy5tmEtCfAwiOPAj2Vkk7/3oeFb
         qfW/DRUkGUIH/w9olLT3VZDxpod/Gz2nygQKwGYqiWJmxuiHTgquKn915TG4LBNh7dxe
         l/KalLZtKIxF5O4ZiIZJ+khCoPVmL+y/RbZzLZH+ORxNQtDc/ItMcnnsSHel1WPnKKTZ
         4RGQ==
X-Gm-Message-State: AOAM533bD6L3w12NkX0CXWTH7JdpDHG1e2Vh+hhhA0uhF0JtZFgvIVqR
        W7O8jcgJMumqQFvzhCTBDG398xiBtao=
X-Google-Smtp-Source: ABdhPJwK/Hj3CCDD9m+72hBs8laL15bod+DgIRMKMli+Y63P4Qv0ITzGZVv+RbJ48YYug5Dgm4je+Q==
X-Received: by 2002:ac8:1c6a:: with SMTP id j39mr1919228qtk.127.1598254677526;
        Mon, 24 Aug 2020 00:37:57 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id y9sm9092322qka.0.2020.08.24.00.37.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 00:37:56 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 3/3] net: openvswitch: remove unused keep_flows
Date:   Mon, 24 Aug 2020 15:36:02 +0800
Message-Id: <20200824073602.70812-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
References: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
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
v2:
change unnused -> unused
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

