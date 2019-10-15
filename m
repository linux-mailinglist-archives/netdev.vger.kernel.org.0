Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D06D918B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404063AbfJPMuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37389 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393350AbfJPMuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:54 -0400
Received: by mail-pg1-f196.google.com with SMTP id p1so14246054pgi.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xFv3hcOcNKmj8ZwltKq36bAhvNe+rhJRgoAZb20SCBc=;
        b=B2uzbTYHH55OhH14H9cZJULC0XGZo517/NAa0HaAz/mgEH28ZBi1CF4NH5gtbMAQHI
         sEYCMBmn+r3ss78N8pgxU9JqWRwv3PCZFpVQSa5ZcYhRtQECZdlekw1DavKDfVGejO8C
         9hoE7ra6f6EKzGTqNJIU/JXzIpb3ZkxP0iV5qrAJj6zweCy7Mp8SOheTHQ6uT0uBwAhX
         Sgp+zlRaCs8rlrZFeVWL1DRuvnD6YemIbRaCdCK/up52/91Z50DOou6ikFHNeFD+JVgY
         pBv+0Jt8m1zvIlVEtQvut/0iV1DR+DVJftIqc9yaZpYIy0Rj90dITGj7ZM/rLLfpJad0
         54Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xFv3hcOcNKmj8ZwltKq36bAhvNe+rhJRgoAZb20SCBc=;
        b=CxvmnXJw8mn4+t4CBnrf2XnNSUt0JjlPLlhTEzCikIRg0isIbnMi4iEZBBqIPjxqyx
         dZPlhrPl77pLfxYmXkfFHP707P52hCkT6zI/+17m5I6k9LBoEKCSBb+Vl7bf+k5rlhDl
         YvAAn7OSR4xz/kl3gbB+Rz8kIikyI1CwLMAVQDAb1e2Ch1w+aNzrKeKTM8MzPiEvYUD8
         VrtwvT2ccQupjtb2saPT7VQPIbo6FupTpD+uWdjrfIgDCLp0Ak0kfJRsa/RsWirL37Xq
         wtCgeqdiARDSk03dfKDWL7D5URYL2IWyhmqc0UhxgK2ZCRR0+xwZMK/Oh9V1T/krrrXw
         +YrQ==
X-Gm-Message-State: APjAAAV/xLFyaZQ4J4ExKDeCjvOzQzFDovBIL5b7wks8aj7zxHRer5l3
        GwNxhwv6pxVxM0pqqd4z0LmXwN44
X-Google-Smtp-Source: APXvYqy/TgqziSwl8BdMxQwr0A2WVp3FOBk3INz/km5JoLd2WQA/lfIZp2gQl4Mz3/SHqNksmdJPdg==
X-Received: by 2002:a62:3203:: with SMTP id y3mr43205654pfy.221.1571230253158;
        Wed, 16 Oct 2019 05:50:53 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:52 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 10/10] net: openvswitch: simplify the ovs_dp_cmd_new
Date:   Tue, 15 Oct 2019 18:30:40 +0800
Message-Id: <1571135440-24313-11-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

use the specified functions to init resource.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
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

