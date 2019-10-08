Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F660CF902
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbfJHL5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33648 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:57:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so10678089pfl.0
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WeIHfo7ERuyeIDHUmtZRg3+/ZYCLq8h78OdWyljKhqg=;
        b=u857IKg52gmpI2ROyRw0kCe3A4j61rjXTprHdCewHHnHqXH6/uQpqXDS3MfdLIZyjk
         kq6MhncJVYdKRutzAxHRGD79bTPWMxwMQIujkZNTBdQ2WZP8Gg6/vlaPxSi9IKQUxPCc
         nWfanMmClwE5sCWNASfpo+wjcg/t0APv0XXiLUgXyijab5Sv0a9ANqUywnMtrkNAKRTi
         NilT7uGXHRloXkNGi1QGLqedcqD4PyL6Xif86CRZWh6pFaDMBYephCeF3D7c5Kbn5MH3
         Ad4nkdgT+FX43FY9+eBKw0eCuv2IjL8NeZA0SQ8Ws0+CxvSIbPtQAYQwoJkXFAMfj3hr
         OSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WeIHfo7ERuyeIDHUmtZRg3+/ZYCLq8h78OdWyljKhqg=;
        b=FPKdkCb/enhU9ELZ2H8Wdh7icI/VnSzdo596b+JB24u32yqHK+VrvgTwcCn7/hFlm7
         beOVk58dOi4FD3QtcfqxMl2n3e5PjkQI6sFK8IJ7zk6PLuO6yFr+OIMJ0EfdRXRUlaqr
         2DL9KoUllsQK6G9fzA2/1gAoDlA4jJ+obKIMQNwk3AD4mdPyis4oLWSYgrPH/8NvgyU0
         ioGeRUv1a0dSBVPQi/9gpUxre0raKrAVn1+SLJOp7hS1hx00j5smjJi9FoldUeAf4zXv
         w8j5B3FML6umVWxmxCeTNr7Mt1CS/YOiG24WeWY71kYtwqRuKP7TvoxcwaACxQJKK9Vs
         BFng==
X-Gm-Message-State: APjAAAVTBGZOW8N8d2PgChqINpmw9a0uzmmXkKmFRycMPEtfbnW/RKe1
        AppEmGNrVzTij4o7EXCLiVHI/vt8
X-Google-Smtp-Source: APXvYqwvlhs3BFYamWDyobkMjwus1K4M65YbULz1F0bhWsHECTvw6HbSF8vqohY3UQ8cK7PvwKQRLw==
X-Received: by 2002:a17:90a:2301:: with SMTP id f1mr5387893pje.121.1570535834429;
        Tue, 08 Oct 2019 04:57:14 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:57:13 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 10/10] net: openvswitch: simplify the ovs_dp_cmd_new
Date:   Tue,  8 Oct 2019 09:00:38 +0800
Message-Id: <1570496438-15460-11-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

use the specified functions to init resource.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c | 60 +++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index aeb76e4..4d48e48 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1576,6 +1576,31 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 	return 0;
 }
 
+static int ovs_dp_stats_init(struct datapath *dp)
+{
+	dp->stats_percpu = netdev_alloc_pcpu_stats(struct dp_stats_percpu);
+	if (!dp->stats_percpu)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int ovs_dp_vport_init(struct datapath *dp)
+{
+	int i;
+
+	dp->ports = kmalloc_array(DP_VPORT_HASH_BUCKETS,
+				  sizeof(struct hlist_head),
+				  GFP_KERNEL);
+	if (!dp->ports)
+		return -ENOMEM;
+
+	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
+		INIT_HLIST_HEAD(&dp->ports[i]);
+
+	return 0;
+}
+
 static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr **a = info->attrs;
@@ -1584,7 +1609,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	struct vport *vport;
 	struct ovs_net *ovs_net;
-	int err, i;
+	int err;
 
 	err = -EINVAL;
 	if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
@@ -1597,35 +1622,26 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	err = -ENOMEM;
 	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 	if (dp == NULL)
-		goto err_free_reply;
+		goto err_destroy_reply;
 
 	ovs_dp_set_net(dp, sock_net(skb->sk));
 
 	/* Allocate table. */
 	err = ovs_flow_tbl_init(&dp->table);
 	if (err)
-		goto err_free_dp;
+		goto err_destroy_dp;
 
-	dp->stats_percpu = netdev_alloc_pcpu_stats(struct dp_stats_percpu);
-	if (!dp->stats_percpu) {
-		err = -ENOMEM;
+	err = ovs_dp_stats_init(dp);
+	if (err)
 		goto err_destroy_table;
-	}
 
-	dp->ports = kmalloc_array(DP_VPORT_HASH_BUCKETS,
-				  sizeof(struct hlist_head),
-				  GFP_KERNEL);
-	if (!dp->ports) {
-		err = -ENOMEM;
-		goto err_destroy_percpu;
-	}
-
-	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
-		INIT_HLIST_HEAD(&dp->ports[i]);
+	err = ovs_dp_vport_init(dp);
+	if (err)
+		goto err_destroy_stats;
 
 	err = ovs_meters_init(dp);
 	if (err)
-		goto err_destroy_ports_array;
+		goto err_destroy_ports;
 
 	/* Set up our datapath device. */
 	parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
@@ -1675,15 +1691,15 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 err_destroy_meters:
 	ovs_meters_exit(dp);
-err_destroy_ports_array:
+err_destroy_ports:
 	kfree(dp->ports);
-err_destroy_percpu:
+err_destroy_stats:
 	free_percpu(dp->stats_percpu);
 err_destroy_table:
 	ovs_flow_tbl_destroy(&dp->table);
-err_free_dp:
+err_destroy_dp:
 	kfree(dp);
-err_free_reply:
+err_destroy_reply:
 	kfree_skb(reply);
 err:
 	return err;
-- 
1.8.3.1

