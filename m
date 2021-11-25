Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC4B45D32D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhKYCfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhKYCdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 21:33:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA85C061758
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:02:02 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so4405275pjb.1
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mgEM+X7i992VR8fO5OKNe6fpfybXyTGzQ6tKuGlZveo=;
        b=PM/xsKeJ6Kwstyne/Ht447lQ5Lxwi6+u69zvBqsTmVBIwqtfS6FrHcxfO6rVb+COPa
         AbHk5gQk8jJU51cRAThX7QQmAA28KkDqgoFYfrF2Q1orazLcW4PbC3ozmawEuzZ/bQEA
         t8I7fIcIkslhb1EZVhStCbU/ZZFg53v56MFafotgnp6oB2PvzNQZNuplMTd14EwCRLFH
         OaNyTTnFEqHp8Bn/UT7njldzpqk63LxlkOCv3WcYqQKnBHdMfVcUVI55p6/xywnj+1R8
         zXzr9ef6Beil/kSYq7iVBqdV3Knem1pr/HlF5WxJH4nSoQoPjnyPOVRD10NQ2Qhry+jZ
         hXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mgEM+X7i992VR8fO5OKNe6fpfybXyTGzQ6tKuGlZveo=;
        b=r74nowBULTkYyZGOCokDBCdjpDp8FgUh7457qQoJO499e8OBYHA4uw8qaNVeJUhKJh
         ioYMZK+u6sw9V0mod1Kd4WtQRYEf+AxZg0pZtzKP/OkDPoQVo5I5YM5PPGS/6Mxc+OJH
         JQOomQdSwynLtW2ILU+pevJkTJtXI2jZuN2rjtTW+W1Wzgpbn0iDSQYAXXMBYbmtWn0c
         +SE64CbRKyhsxGy+LuC84Mq1lMsr6sZbLdIskHPXw/bxQJb8fUYix7brSW3gFCH58MyR
         QUIli9Da/4xuAyCM5Xe8Gh9WkNFn30kbPQT0JH0Ob9BRoVqf3RyA4rbPqKLiw/8wiJlt
         DcSA==
X-Gm-Message-State: AOAM532U/Z96MHdSA7SOT/nDqifixnzy508P8SsuH5fHHWONCR/zcgeG
        ft/T1vQ/bJWBeHejubct7Dl+8fn4gS6KJQ==
X-Google-Smtp-Source: ABdhPJwgyAFYH5l2nrl3g/qifjmXDzVXpLBc+TX15ovywDQmSRIZzgGyWYmVPhxJQniRkz71uhXtzQ==
X-Received: by 2002:a17:90b:4a47:: with SMTP id lb7mr2417321pjb.243.1637805721955;
        Wed, 24 Nov 2021 18:02:01 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id 63sm1023494pfz.119.2021.11.24.18.02.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 18:02:01 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/2] ifb: support ethtools driver info
Date:   Thu, 25 Nov 2021 10:01:54 +0800
Message-Id: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

ifb netdev may be created by others prefix, not ifbX.
For getting netdev driver info, add ifb ethtools callback.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ifb.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 31f522b8e54e..d9078ce041c4 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -26,6 +26,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -35,7 +36,10 @@
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
 
-#define TX_Q_LIMIT    32
+#define DRV_NAME	"ifb"
+#define DRV_VERSION	"1.0"
+#define TX_Q_LIMIT	32
+
 struct ifb_q_private {
 	struct net_device	*dev;
 	struct tasklet_struct   ifb_tasklet;
@@ -181,6 +185,12 @@ static int ifb_dev_init(struct net_device *dev)
 	return 0;
 }
 
+static void ifb_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
+{
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+}
+
 static const struct net_device_ops ifb_netdev_ops = {
 	.ndo_open	= ifb_open,
 	.ndo_stop	= ifb_close,
@@ -190,6 +200,10 @@ static const struct net_device_ops ifb_netdev_ops = {
 	.ndo_init	= ifb_dev_init,
 };
 
+static const struct ethtool_ops ifb_ethtool_ops = {
+	.get_drvinfo = ifb_get_drvinfo,
+};
+
 #define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST	| \
 		      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL	| \
 		      NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX		| \
@@ -224,6 +238,8 @@ static void ifb_setup(struct net_device *dev)
 	dev->vlan_features |= IFB_FEATURES & ~(NETIF_F_HW_VLAN_CTAG_TX |
 					       NETIF_F_HW_VLAN_STAG_TX);
 
+	dev->ethtool_ops = &ifb_ethtool_ops;
+
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
@@ -289,7 +305,7 @@ static int ifb_validate(struct nlattr *tb[], struct nlattr *data[],
 }
 
 static struct rtnl_link_ops ifb_link_ops __read_mostly = {
-	.kind		= "ifb",
+	.kind		= DRV_NAME,
 	.priv_size	= sizeof(struct ifb_dev_private),
 	.setup		= ifb_setup,
 	.validate	= ifb_validate,
@@ -359,4 +375,4 @@ module_init(ifb_init_module);
 module_exit(ifb_cleanup_module);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jamal Hadi Salim");
-MODULE_ALIAS_RTNL_LINK("ifb");
+MODULE_ALIAS_RTNL_LINK(DRV_NAME);
-- 
2.27.0

