Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5D1C767C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbgEFQb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:57 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42222 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgEFQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:41 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUZjG085528;
        Wed, 6 May 2020 11:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782635;
        bh=Cai31ZHxQi4/NU0CFxQdN7+fQQ232w1peH7dU6BgXjI=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=pPnCnFv8gH/arunhGMzsTty3UahGNwcbnd1MhojUXU0hgPQ9Q0Q+nRPCFtwop4zqt
         ujvF2sVuOgKC2hoYHnmETMDZrdW9ug6+OWHWU+sS3rpaknUKmsT7AHsECUuUgRqHXU
         V8jpTfCclkAaV2yQxRNsQaR3B1oVAiGbZEuiELYU=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUZpY081674
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:35 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:35 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:35 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDg119719;
        Wed, 6 May 2020 11:30:35 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 03/13] net: hsr: rename files to introduce PRP support
Date:   Wed, 6 May 2020 12:30:23 -0400
Message-ID: <20200506163033.3843-4-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As PRP implementation expect to re-use code from HSR driver, rename
the existing files that can be re-used with a hsr_prp prefix.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/Makefile                               | 11 ++++++-----
 net/hsr-prp/hsr_netlink.c                          |  6 +++---
 net/hsr-prp/{hsr_debugfs.c => hsr_prp_debugfs.c}   |  6 +++---
 net/hsr-prp/{hsr_device.c => hsr_prp_device.c}     | 10 +++++-----
 net/hsr-prp/{hsr_device.h => hsr_prp_device.h}     |  2 +-
 net/hsr-prp/{hsr_forward.c => hsr_prp_forward.c}   |  6 +++---
 net/hsr-prp/{hsr_forward.h => hsr_prp_forward.h}   |  2 +-
 net/hsr-prp/{hsr_framereg.c => hsr_prp_framereg.c} |  4 ++--
 net/hsr-prp/{hsr_framereg.h => hsr_prp_framereg.h} |  2 +-
 net/hsr-prp/{hsr_main.c => hsr_prp_main.c}         |  8 ++++----
 net/hsr-prp/{hsr_main.h => hsr_prp_main.h}         |  0
 net/hsr-prp/{hsr_slave.c => hsr_prp_slave.c}       | 10 +++++-----
 net/hsr-prp/{hsr_slave.h => hsr_prp_slave.h}       |  2 +-
 13 files changed, 35 insertions(+), 34 deletions(-)
 rename net/hsr-prp/{hsr_debugfs.c => hsr_prp_debugfs.c} (97%)
 rename net/hsr-prp/{hsr_device.c => hsr_prp_device.c} (98%)
 rename net/hsr-prp/{hsr_device.h => hsr_prp_device.h} (96%)
 rename net/hsr-prp/{hsr_forward.c => hsr_prp_forward.c} (99%)
 rename net/hsr-prp/{hsr_forward.h => hsr_prp_forward.h} (92%)
 rename net/hsr-prp/{hsr_framereg.c => hsr_prp_framereg.c} (99%)
 rename net/hsr-prp/{hsr_framereg.h => hsr_prp_framereg.h} (98%)
 rename net/hsr-prp/{hsr_main.c => hsr_prp_main.c} (96%)
 rename net/hsr-prp/{hsr_main.h => hsr_prp_main.h} (100%)
 rename net/hsr-prp/{hsr_slave.c => hsr_prp_slave.c} (96%)
 rename net/hsr-prp/{hsr_slave.h => hsr_prp_slave.h} (97%)

diff --git a/net/hsr-prp/Makefile b/net/hsr-prp/Makefile
index fd207c1a0854..608045f088a4 100644
--- a/net/hsr-prp/Makefile
+++ b/net/hsr-prp/Makefile
@@ -1,10 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Makefile for HSR
+# Makefile for HSR & PRP
 #
 
-obj-$(CONFIG_HSR_PRP)	+= hsr.o
+obj-$(CONFIG_HSR_PRP)	+= hsr-prp.o
 
-hsr-y			:= hsr_main.o hsr_framereg.o hsr_device.o \
-			   hsr_netlink.o hsr_slave.o hsr_forward.o
-hsr-$(CONFIG_DEBUG_FS) += hsr_debugfs.o
+hsr-prp-y		:= hsr_prp_main.o hsr_prp_framereg.o \
+			   hsr_prp_device.o hsr_netlink.o hsr_prp_slave.o \
+			   hsr_prp_forward.o
+hsr-prp-$(CONFIG_DEBUG_FS) += hsr_prp_debugfs.o
diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index 1decb25f6764..9791d4d89aef 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -11,9 +11,9 @@
 #include <linux/kernel.h>
 #include <net/rtnetlink.h>
 #include <net/genetlink.h>
-#include "hsr_main.h"
-#include "hsr_device.h"
-#include "hsr_framereg.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_device.h"
+#include "hsr_prp_framereg.h"
 
 static const struct nla_policy hsr_policy[IFLA_HSR_MAX + 1] = {
 	[IFLA_HSR_SLAVE1]		= { .type = NLA_U32 },
diff --git a/net/hsr-prp/hsr_debugfs.c b/net/hsr-prp/hsr_prp_debugfs.c
similarity index 97%
rename from net/hsr-prp/hsr_debugfs.c
rename to net/hsr-prp/hsr_prp_debugfs.c
index 9787ef11ca71..d37b44082e92 100644
--- a/net/hsr-prp/hsr_debugfs.c
+++ b/net/hsr-prp/hsr_prp_debugfs.c
@@ -1,5 +1,5 @@
 /*
- * hsr_debugfs code
+ * hsr_prp_debugfs code
  * Copyright (C) 2019 Texas Instruments Incorporated
  *
  * Author(s):
@@ -17,8 +17,8 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/debugfs.h>
-#include "hsr_main.h"
-#include "hsr_framereg.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_framereg.h"
 
 static struct dentry *hsr_debugfs_root_dir;
 
diff --git a/net/hsr-prp/hsr_device.c b/net/hsr-prp/hsr_prp_device.c
similarity index 98%
rename from net/hsr-prp/hsr_device.c
rename to net/hsr-prp/hsr_prp_device.c
index cd99f548e440..ed50022849cb 100644
--- a/net/hsr-prp/hsr_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -13,11 +13,11 @@
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/pkt_sched.h>
-#include "hsr_device.h"
-#include "hsr_slave.h"
-#include "hsr_framereg.h"
-#include "hsr_main.h"
-#include "hsr_forward.h"
+#include "hsr_prp_device.h"
+#include "hsr_prp_slave.h"
+#include "hsr_prp_framereg.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_forward.h"
 
 static bool is_admin_up(struct net_device *dev)
 {
diff --git a/net/hsr-prp/hsr_device.h b/net/hsr-prp/hsr_prp_device.h
similarity index 96%
rename from net/hsr-prp/hsr_device.h
rename to net/hsr-prp/hsr_prp_device.h
index a099d7de7e79..4cf3db603174 100644
--- a/net/hsr-prp/hsr_device.h
+++ b/net/hsr-prp/hsr_prp_device.h
@@ -9,7 +9,7 @@
 #define __HSR_DEVICE_H
 
 #include <linux/netdevice.h>
-#include "hsr_main.h"
+#include "hsr_prp_main.h"
 
 void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
diff --git a/net/hsr-prp/hsr_forward.c b/net/hsr-prp/hsr_prp_forward.c
similarity index 99%
rename from net/hsr-prp/hsr_forward.c
rename to net/hsr-prp/hsr_prp_forward.c
index ddd9605bad04..5ff0efba5db5 100644
--- a/net/hsr-prp/hsr_forward.c
+++ b/net/hsr-prp/hsr_prp_forward.c
@@ -5,13 +5,13 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#include "hsr_forward.h"
+#include "hsr_prp_forward.h"
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
-#include "hsr_main.h"
-#include "hsr_framereg.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_framereg.h"
 
 struct hsr_node;
 
diff --git a/net/hsr-prp/hsr_forward.h b/net/hsr-prp/hsr_prp_forward.h
similarity index 92%
rename from net/hsr-prp/hsr_forward.h
rename to net/hsr-prp/hsr_prp_forward.h
index 51a69295566c..cbc0704cc14a 100644
--- a/net/hsr-prp/hsr_forward.h
+++ b/net/hsr-prp/hsr_prp_forward.h
@@ -9,7 +9,7 @@
 #define __HSR_FORWARD_H
 
 #include <linux/netdevice.h>
-#include "hsr_main.h"
+#include "hsr_prp_main.h"
 
 void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port);
 
diff --git a/net/hsr-prp/hsr_framereg.c b/net/hsr-prp/hsr_prp_framereg.c
similarity index 99%
rename from net/hsr-prp/hsr_framereg.c
rename to net/hsr-prp/hsr_prp_framereg.c
index 03b891904314..b02a2a0ca0ff 100644
--- a/net/hsr-prp/hsr_framereg.c
+++ b/net/hsr-prp/hsr_prp_framereg.c
@@ -14,8 +14,8 @@
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
-#include "hsr_main.h"
-#include "hsr_framereg.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_framereg.h"
 #include "hsr_netlink.h"
 
 /*	TODO: use hash lists for mac addresses (linux/jhash.h)?    */
diff --git a/net/hsr-prp/hsr_framereg.h b/net/hsr-prp/hsr_prp_framereg.h
similarity index 98%
rename from net/hsr-prp/hsr_framereg.h
rename to net/hsr-prp/hsr_prp_framereg.h
index 0f0fa12b4329..c7a2a975aca0 100644
--- a/net/hsr-prp/hsr_framereg.h
+++ b/net/hsr-prp/hsr_prp_framereg.h
@@ -8,7 +8,7 @@
 #ifndef __HSR_FRAMEREG_H
 #define __HSR_FRAMEREG_H
 
-#include "hsr_main.h"
+#include "hsr_prp_main.h"
 
 struct hsr_node;
 
diff --git a/net/hsr-prp/hsr_main.c b/net/hsr-prp/hsr_prp_main.c
similarity index 96%
rename from net/hsr-prp/hsr_main.c
rename to net/hsr-prp/hsr_prp_main.c
index e2564de67603..d0b7117bf5f9 100644
--- a/net/hsr-prp/hsr_main.c
+++ b/net/hsr-prp/hsr_prp_main.c
@@ -9,11 +9,11 @@
 #include <linux/rculist.h>
 #include <linux/timer.h>
 #include <linux/etherdevice.h>
-#include "hsr_main.h"
-#include "hsr_device.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_device.h"
 #include "hsr_netlink.h"
-#include "hsr_framereg.h"
-#include "hsr_slave.h"
+#include "hsr_prp_framereg.h"
+#include "hsr_prp_slave.h"
 
 static bool hsr_slave_empty(struct hsr_priv *hsr)
 {
diff --git a/net/hsr-prp/hsr_main.h b/net/hsr-prp/hsr_prp_main.h
similarity index 100%
rename from net/hsr-prp/hsr_main.h
rename to net/hsr-prp/hsr_prp_main.h
diff --git a/net/hsr-prp/hsr_slave.c b/net/hsr-prp/hsr_prp_slave.c
similarity index 96%
rename from net/hsr-prp/hsr_slave.c
rename to net/hsr-prp/hsr_prp_slave.c
index 25b6ffba26cd..fad8fef783cc 100644
--- a/net/hsr-prp/hsr_slave.c
+++ b/net/hsr-prp/hsr_prp_slave.c
@@ -5,14 +5,14 @@
  *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
  */
 
-#include "hsr_slave.h"
+#include "hsr_prp_slave.h"
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/if_vlan.h>
-#include "hsr_main.h"
-#include "hsr_device.h"
-#include "hsr_forward.h"
-#include "hsr_framereg.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_device.h"
+#include "hsr_prp_forward.h"
+#include "hsr_prp_framereg.h"
 
 static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 {
diff --git a/net/hsr-prp/hsr_slave.h b/net/hsr-prp/hsr_prp_slave.h
similarity index 97%
rename from net/hsr-prp/hsr_slave.h
rename to net/hsr-prp/hsr_prp_slave.h
index 8953ea279ce9..c0360b111151 100644
--- a/net/hsr-prp/hsr_slave.h
+++ b/net/hsr-prp/hsr_prp_slave.h
@@ -10,7 +10,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
-#include "hsr_main.h"
+#include "hsr_prp_main.h"
 
 int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 		 enum hsr_port_type pt, struct netlink_ext_ack *extack);
-- 
2.17.1

