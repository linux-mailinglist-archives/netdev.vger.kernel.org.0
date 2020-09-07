Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F725260491
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgIGS3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbgIGS31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:29:27 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFFCC061756
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 11:29:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id ay8so13577779edb.8
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 11:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dWhxqZfcp5IwqdYuDqo2Ku5a3gYbdWodl/y599LW0+s=;
        b=AbSmBqlgGOmK475cRBeOwQfEQ0ZqmQ8YQc3/S4I8VqSLabG5KeFeGUODvuC9uFi9/b
         mZVdeIe0x1T97CKPlJaiq1ybVyKfDos/hONXh6doP1WqUXKsO8wUU44RjYBS3k8UbBQ0
         dAnE818kIseaHlBwaMmVFKBZEO9ImNB3HTyJUKcUzWuVj5w+N6S6ZtMtB5nrsSpCVKiR
         p1JXyR9gYpFMn8/S+SS7sF8VDv+HAw//r1oq13znAya/AapCe0LqLM0PbXS/XpL6unqZ
         CXI2BYjxBghNCF3TVXcxe7wFyJ2TXjeFYLsKPcvhWkoCYuvSP975Kw/+2AYg1w7ZivPI
         8lPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWhxqZfcp5IwqdYuDqo2Ku5a3gYbdWodl/y599LW0+s=;
        b=Ux1Mgx6CctEaDj6yokDGcfWGqBQs1JwIMgr7Tb1NhcBMzlsQ3U6MwmdptckoBEGcV+
         q63FxAfH1ig+8y++E5R7O8zC+ShycZs2sDQ9ZWZdkN/D5w6xbK9c/Xz9N12Z8dVZHz0C
         vV+zSemo1gPwGVpx5Rr1Mf71gdjPhb/R7traecoadxJTLX2DcEfahanM3jLpIemoH4W5
         NKrcNvo235YcGEv1PLgfHkz9Tzrmp7Ovr/7nr8JH4p+39VWjTpraXZcDDQNVy9nkGRJs
         3AsyRq8nzp/ucr+PhV7NhKwEcqh4j9mIwB03b8yQ2cJ4rpMCQhjxk2HKMKEbmUzjfaW+
         qcpw==
X-Gm-Message-State: AOAM5310OeE6l+cq6WpDt8BVtXG4NI3CBw4Uc7QPitn5Q3UFkh8xBcWf
        qkOi0x5UJJXOWEK17wPT0bQ=
X-Google-Smtp-Source: ABdhPJw2fbjrzoZ1GsGy6w+Wnbe42VkN0fTEZ3eZYYxC9aKOby2mE0wNMl9HCAreOttG3tlh/ts1wg==
X-Received: by 2002:aa7:dcc1:: with SMTP id w1mr22247345edu.360.1599503365931;
        Mon, 07 Sep 2020 11:29:25 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g24sm11746816edy.51.2020.09.07.11.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 11:29:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] Revert "net: dsa: Add more convenient functions for installing port VLANs"
Date:   Mon,  7 Sep 2020 21:29:09 +0300
Message-Id: <20200907182910.1285496-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907182910.1285496-1-olteanv@gmail.com>
References: <20200907182910.1285496-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 314f76d7a68bab0516aa52877944e6aacfa0fc3f.

Citing that commit message, the call graph was:

    dsa_slave_vlan_rx_add_vid   dsa_port_setup_8021q_tagging
                |                        |
                |                        |
                |          +-------------+
                |          |
                v          v
               dsa_port_vid_add      dsa_slave_port_obj_add
                      |                         |
                      +-------+         +-------+
                              |         |
                              v         v
                           dsa_port_vlan_add

Now that tag_8021q has its own ops structure, it no longer relies on
dsa_port_vid_add, and therefore on the dsa_switch_ops to install its
VLANs.

So dsa_port_vid_add now only has one single caller. So we can simplify
the call graph to what it was before, aka:

        dsa_slave_vlan_rx_add_vid     dsa_slave_port_obj_add
                      |                         |
                      +-------+         +-------+
                              |         |
                              v         v
                           dsa_port_vlan_add

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  2 --
 net/dsa/port.c     | 33 ---------------------------------
 net/dsa/slave.c    | 34 +++++++++++++++++++++++++++++++---
 3 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 1653e3377cb3..2da656d984ef 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -164,8 +164,6 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct switchdev_trans *trans);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
-int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e23ece229c7e..46c9bf709683 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -433,39 +433,6 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
-int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
-{
-	struct switchdev_obj_port_vlan vlan = {
-		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
-		.flags = flags,
-		.vid_begin = vid,
-		.vid_end = vid,
-	};
-	struct switchdev_trans trans;
-	int err;
-
-	trans.ph_prepare = true;
-	err = dsa_port_vlan_add(dp, &vlan, &trans);
-	if (err)
-		return err;
-
-	trans.ph_prepare = false;
-	return dsa_port_vlan_add(dp, &vlan, &trans);
-}
-EXPORT_SYMBOL(dsa_port_vid_add);
-
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid)
-{
-	struct switchdev_obj_port_vlan vlan = {
-		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
-		.vid_begin = vid,
-		.vid_end = vid,
-	};
-
-	return dsa_port_vlan_del(dp, &vlan);
-}
-EXPORT_SYMBOL(dsa_port_vid_del);
-
 static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 {
 	struct device_node *phy_dn;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9af1a2d0cec4..e429c71df854 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1233,7 +1233,15 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan vlan = {
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.vid_begin = vid,
+		.vid_end = vid,
+		/* This API only allows programming tagged, non-PVID VIDs */
+		.flags = 0,
+	};
 	struct bridge_vlan_info info;
+	struct switchdev_trans trans;
 	int ret;
 
 	/* Check for a possible bridge VLAN entry now since there is no
@@ -1252,11 +1260,25 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_add(dp, vid, 0);
+	/* User port... */
+	trans.ph_prepare = true;
+	ret = dsa_port_vlan_add(dp, &vlan, &trans);
+	if (ret)
+		return ret;
+
+	trans.ph_prepare = false;
+	ret = dsa_port_vlan_add(dp, &vlan, &trans);
 	if (ret)
 		return ret;
 
-	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
+	/* And CPU port... */
+	trans.ph_prepare = true;
+	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
+	if (ret)
+		return ret;
+
+	trans.ph_prepare = false;
+	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
 	if (ret)
 		return ret;
 
@@ -1267,6 +1289,12 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan vlan = {
+		.vid_begin = vid,
+		.vid_end = vid,
+		/* This API only allows programming tagged, non-PVID VIDs */
+		.flags = 0,
+	};
 	struct bridge_vlan_info info;
 	int ret;
 
@@ -1289,7 +1317,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vlan_del(dp, &vlan);
 }
 
 struct dsa_hw_port {
-- 
2.25.1

