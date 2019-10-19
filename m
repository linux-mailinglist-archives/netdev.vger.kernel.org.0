Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA49E9567
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfJ3Ds5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45983 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJ3Ds4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1so490452pgj.12
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xFv3hcOcNKmj8ZwltKq36bAhvNe+rhJRgoAZb20SCBc=;
        b=Ir6et4RVZ8IYG5MRACQiiPbIP2EDLzccL8dXtOVtJh1TS4N9xpkifa3vrOF1w7fzDA
         Tt0VPzxdJvSAq8m6KloDXYN9r7cQCQiu5Crom2OFnqqHb8lSROJBv8X36Grs24lqsHiu
         y2wGCr1wyDeyHMfpOO7VMv82S43ydC466YLCis/IkJcUJL+Nod/3ec+iN3o7R/mrdDbG
         hGimVDgAk3i2vHDYF99uuIDIg5YUgHCMfbdBHKaU0/BwkXq/Ws1N//3mWhxL9tAOk/QD
         2GFZ/wh97jmJVIArajtDoMhJggs+eUG7RetJJsmIyyGnazm5ObLorYCKhKsGB4Zaka0U
         YiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xFv3hcOcNKmj8ZwltKq36bAhvNe+rhJRgoAZb20SCBc=;
        b=qvJbEEpm1EgjXlK8zt2xdgyjXebNuz7TfS2om2S1Y2N9upzSgsSnFDPnIYTLETNt4x
         FGdUtf9OKqQFLRRsGvgJmjzT1KTO66S9u6yWqEDkDSCFmna6fPRSpRQ7u/5g1wFK56Ps
         UlbZRLbeA1TwelkgkX/ubYkJNBHiIWv3i5GRNWYrkAobr0+L965dgiN3xqaKw5TOj7iF
         VOGWJ/2ZfNaGxkfVkZnbgCndqg490ngrQcKz8bMpAFD+gTSuPduRbwzZ4g6LCuZbI0h9
         BcwNKxz9MDFcKH3jmLYUni60q5MNawuoPvc2WtDg+4aSSPrsRT2RfbmiWCjkyvoSOY6m
         sJPg==
X-Gm-Message-State: APjAAAX0bqAo+uEl/AZu1mV/BmuiExsmXFPJmN2qowqPb5vHg80WcenH
        a0YGTEG7C+MrskmGF27dLLo=
X-Google-Smtp-Source: APXvYqxLVvRFKbuO0UXcvrO2GlohazHzPpuwp0EB9PtOu4sf1IfB4FC4iABA3E1ZjpuUAi6VGBkHEw==
X-Received: by 2002:a63:6e82:: with SMTP id j124mr7758302pgc.115.1572407335374;
        Tue, 29 Oct 2019 20:48:55 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:54 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v5 10/10] net: openvswitch: simplify the ovs_dp_cmd_new
Date:   Sat, 19 Oct 2019 16:08:44 +0800
Message-Id: <1571472524-73832-11-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
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

