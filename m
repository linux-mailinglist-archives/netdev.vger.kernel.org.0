Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56894D4241
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfJKOGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:06:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46770 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbfJKOGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:06:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so6142297pfg.13
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WeIHfo7ERuyeIDHUmtZRg3+/ZYCLq8h78OdWyljKhqg=;
        b=sp1veJA+mXD8JGD9wuDcfPdbNoc54EaJTHUdzNIa/j+swNL0Z0jc064GHyojLwkMJG
         BUAeCcLyPVhzjP/JHFRuOrctZSpIHt+/NIiO5tN5+vqyMBSJKEmZoc3w06yRYFuBnNXL
         p2YlvtvpRHWIB8f9H/WsQnw9Z0wnWYkb0nNa62V42MdBwvNtXI4Zqs81lNDhtoSOC/J4
         w44WappuWIykvLd8XuTlJWFNo1CG1ej2AZm0A4w5e/QrAsgbEBlMz4JIZeqiLvqty1cO
         QjAP373+PIj7ZPavK+RRjkNGD9HC3WOdlA3D/liTnLVCdwWL7wvdIXrTY8vun9Z2PPsn
         lDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WeIHfo7ERuyeIDHUmtZRg3+/ZYCLq8h78OdWyljKhqg=;
        b=nhYaKNyR4S41L8P5V3KSwm1tUo+3JEBk8bVvhRwHjBrViQia7JKS6mQuXCX2Z963P8
         I0zB7hQi2onz03wujXLQ7h9+gO08wne4h6phfmhFwXNgsdByJ6ckz/hl7S1OjBsOTZvx
         Slime1scfygtiUjp/LPWJo8p7/sFzSmcWiIEH4Bmkcyei3XzI9moIG2cbUPLsjaEL3Li
         8M0Ud3iM47/HjfylH0cAy967SRM5pMWayBZi73Vdtt5obrJanfb4Car6JmQEltb3UzgX
         WII4vkS9carxF6qk3xyNdfEBBlNffXwKJDo8LiW5jGz3VXcZ8qzkZbpe0kD2iCzdxpFy
         8TUw==
X-Gm-Message-State: APjAAAU+y28dTdwXXtqR2iwcM3wpCxQMjhIUEedA3j2HKhIoO3WWR9E4
        n1UCEoAiWTOI0VCaDRqtMs5vJthX
X-Google-Smtp-Source: APXvYqzb0RCBkbNmZFKkIs91ecTurctwtoqKptYLisEuGXhr3dxldX5GxwhuA2d0UbPm1f6oMSnDYQ==
X-Received: by 2002:a17:90a:80ca:: with SMTP id k10mr17651402pjw.88.1570802771794;
        Fri, 11 Oct 2019 07:06:11 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.06.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:06:11 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 10/10] net: openvswitch: simplify the ovs_dp_cmd_new
Date:   Fri, 11 Oct 2019 22:00:47 +0800
Message-Id: <1570802447-8019-11-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
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

