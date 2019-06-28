Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B76959D51
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfF1N4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:12 -0400
Received: from packetmixer.de ([79.140.42.25]:52974 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfF1N4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:08 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 4BCA26206E;
        Fri, 28 Jun 2019 15:56:06 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 02/10] batman-adv: Fix includes for *_MAX constants
Date:   Fri, 28 Jun 2019 15:55:56 +0200
Message-Id: <20190628135604.11581-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit 54d50897d544 ("linux/kernel.h: split *_MAX and *_MIN macros into
<linux/limits.h>") moved the U32_MAX/INT_MAX/ULONG_MAX from linux/kernel.h
to linux/limits.h. Adjust the includes accordingly.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/gateway_common.c | 1 +
 net/batman-adv/hard-interface.c | 1 +
 net/batman-adv/netlink.c        | 1 +
 net/batman-adv/sysfs.c          | 1 +
 net/batman-adv/tp_meter.c       | 1 +
 5 files changed, 5 insertions(+)

diff --git a/net/batman-adv/gateway_common.c b/net/batman-adv/gateway_common.c
index dac097f9be03..fc55750542e4 100644
--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -11,6 +11,7 @@
 #include <linux/byteorder/generic.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/limits.h>
 #include <linux/math64.h>
 #include <linux/netdevice.h>
 #include <linux/stddef.h>
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 79d1731b8306..899487641bca 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -16,6 +16,7 @@
 #include <linux/if_ether.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index a67720fad46c..7253699c3151 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -21,6 +21,7 @@
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
index 80fc3253c336..1efcb97039cd 100644
--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/kref.h>
+#include <linux/limits.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 820392146249..dd6a9a40dbb9 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/kthread.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/param.h>
-- 
2.11.0

