Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D349264A7C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIJQ71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgIJQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:57:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81E1C061385
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:07 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so9722507ejf.6
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xvEQyyg3oPETZShok18kOiiLEep3Vy9+jr8PlMr+V/E=;
        b=U4gOGkQeMaJxdLmB4q9EGEzrEV2JSf1CksCM6llgbFhniLH8iJRj4EdwAT6NAW9lgi
         h3+QGUfljrNYdtqcxs7F3c17ubZkVEiV6KQRXzxWDsu1MDjVqNzNANQvFbEjRNZWmnEy
         V3uj8hojTfACH+DF9NYdViBfcv2s7EhCbWolS0e+pYr91bFlOIpJ6xHbCgT3CFgbxFkN
         pd5TDivkmwpoVgdtbSmns0/4xhRlfH4OizfzGEwiez562jNWoxzlSXZ3BdoZDWxzA7pp
         EPlsIpxFgSaNBjNFhnIb0evlusH8tq7lzC90JXc1DQfQgTOz24crWQslrRQnCuh8WFHo
         Q0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xvEQyyg3oPETZShok18kOiiLEep3Vy9+jr8PlMr+V/E=;
        b=UN22Ct/w7NnuuvJ6kYH6HsYTiJgGGPedB0sOgSYStZ/6gN8sQuKQcjUfQWF4P2nkQA
         Z9SPoeCm+/7N/1G1peVzKZqfhUK7JHddCjEeWl7ibhkND8dmX5z5SD9rzYJ8Te+cjLzt
         05TCVW0E4vvEIBw08kwUoOP2KmEOFRM2SSEhp9r1+ZfTZtRBrv3TSHqqRzhsipQXo3hT
         B65Vc53g2q4lskMtdAEjUKB8FTV6iI4cNP2fhUoit0IKONrGvWbiHAs204p0eJ1imCEp
         5ioJmh5n8rgpDrfInKdBaoknzfRgDBjQ4RPNSE1vUXwUfziwEXx3Ahr6SBhmE/f9d2TX
         gqaQ==
X-Gm-Message-State: AOAM532e8xM8Y6id6QcOsc/qAqm5fKQhyzfmv4KwH5Ew6o07JkXEiZRI
        borD3kP6qkAkYpYh6WtoOtM=
X-Google-Smtp-Source: ABdhPJyAsQEh63Lu+3PAd/l5sKF7T1Q+MSbvnNKNW4wnkgz05ZTQ95XeqzTMJr9LsUMupH8ZYyPKKQ==
X-Received: by 2002:a17:906:a1c2:: with SMTP id bx2mr10173620ejb.426.1599756546509;
        Thu, 10 Sep 2020 09:49:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id o93sm8108024edd.75.2020.09.10.09.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:49:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 4/4] Revert "net: dsa: Add more convenient functions for installing port VLANs"
Date:   Thu, 10 Sep 2020 19:48:57 +0300
Message-Id: <20200910164857.1221202-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910164857.1221202-1-olteanv@gmail.com>
References: <20200910164857.1221202-1-olteanv@gmail.com>
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
index 4987f94a8f52..66a5268398a5 100644
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

