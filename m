Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C8B38D8A1
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 06:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhEWEGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 00:06:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4588 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhEWEGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 00:06:36 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FnmrW1DVJzkY2T;
        Sun, 23 May 2021 12:02:19 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 12:05:02 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 23
 May 2021 12:05:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] libertas: use DEVICE_ATTR_RW macro
Date:   Sun, 23 May 2021 12:03:39 +0800
Message-ID: <20210523040339.2724-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_RW helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 149 ++++++++++---------
 1 file changed, 78 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index c68814841583..6cbba84989b8 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -151,13 +151,13 @@ static uint16_t lbs_mesh_get_channel(struct lbs_private *priv)
  */
 
 /**
- * lbs_anycast_get - Get function for sysfs attribute anycast_mask
+ * anycast_mask_show - Get function for sysfs attribute anycast_mask
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t lbs_anycast_get(struct device *dev,
-		struct device_attribute *attr, char * buf)
+static ssize_t anycast_mask_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_access mesh_access;
@@ -173,14 +173,15 @@ static ssize_t lbs_anycast_get(struct device *dev,
 }
 
 /**
- * lbs_anycast_set - Set function for sysfs attribute anycast_mask
+ * anycast_mask_store - Set function for sysfs attribute anycast_mask
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t lbs_anycast_set(struct device *dev,
-		struct device_attribute *attr, const char * buf, size_t count)
+static ssize_t anycast_mask_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_access mesh_access;
@@ -199,13 +200,13 @@ static ssize_t lbs_anycast_set(struct device *dev,
 }
 
 /**
- * lbs_prb_rsp_limit_get - Get function for sysfs attribute prb_rsp_limit
+ * prb_rsp_limit_show - Get function for sysfs attribute prb_rsp_limit
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t lbs_prb_rsp_limit_get(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t prb_rsp_limit_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_access mesh_access;
@@ -225,14 +226,15 @@ static ssize_t lbs_prb_rsp_limit_get(struct device *dev,
 }
 
 /**
- * lbs_prb_rsp_limit_set - Set function for sysfs attribute prb_rsp_limit
+ * prb_rsp_limit_store - Set function for sysfs attribute prb_rsp_limit
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t prb_rsp_limit_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_access mesh_access;
@@ -259,27 +261,28 @@ static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
 }
 
 /**
- * lbs_mesh_get - Get function for sysfs attribute mesh
+ * lbs_mesh_show - Get function for sysfs attribute mesh
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t lbs_mesh_get(struct device *dev,
-		struct device_attribute *attr, char * buf)
+static ssize_t lbs_mesh_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	return snprintf(buf, 5, "0x%X\n", !!priv->mesh_dev);
 }
 
 /**
- * lbs_mesh_set - Set function for sysfs attribute mesh
+ * lbs_mesh_store - Set function for sysfs attribute mesh
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t lbs_mesh_set(struct device *dev,
-		struct device_attribute *attr, const char * buf, size_t count)
+static ssize_t lbs_mesh_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	int enable;
@@ -301,20 +304,19 @@ static ssize_t lbs_mesh_set(struct device *dev,
  * lbs_mesh attribute to be exported per ethX interface
  * through sysfs (/sys/class/net/ethX/lbs_mesh)
  */
-static DEVICE_ATTR(lbs_mesh, 0644, lbs_mesh_get, lbs_mesh_set);
+static DEVICE_ATTR_RW(lbs_mesh);
 
 /*
  * anycast_mask attribute to be exported per mshX interface
  * through sysfs (/sys/class/net/mshX/anycast_mask)
  */
-static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
+static DEVICE_ATTR_RW(anycast_mask);
 
 /*
  * prb_rsp_limit attribute to be exported per mshX interface
  * through sysfs (/sys/class/net/mshX/prb_rsp_limit)
  */
-static DEVICE_ATTR(prb_rsp_limit, 0644, lbs_prb_rsp_limit_get,
-		lbs_prb_rsp_limit_set);
+static DEVICE_ATTR_RW(prb_rsp_limit);
 
 static struct attribute *lbs_mesh_sysfs_entries[] = {
 	&dev_attr_anycast_mask.attr,
@@ -351,13 +353,13 @@ static int mesh_get_default_parameters(struct device *dev,
 }
 
 /**
- * bootflag_get - Get function for sysfs attribute bootflag
+ * bootflag_show - Get function for sysfs attribute bootflag
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t bootflag_get(struct device *dev,
-			    struct device_attribute *attr, char *buf)
+static ssize_t bootflag_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -371,14 +373,14 @@ static ssize_t bootflag_get(struct device *dev,
 }
 
 /**
- * bootflag_set - Set function for sysfs attribute bootflag
+ * bootflag_store - Set function for sysfs attribute bootflag
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
+static ssize_t bootflag_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_config cmd;
@@ -401,13 +403,13 @@ static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * boottime_get - Get function for sysfs attribute boottime
+ * boottime_show - Get function for sysfs attribute boottime
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t boottime_get(struct device *dev,
-			    struct device_attribute *attr, char *buf)
+static ssize_t boottime_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -421,14 +423,15 @@ static ssize_t boottime_get(struct device *dev,
 }
 
 /**
- * boottime_set - Set function for sysfs attribute boottime
+ * boottime_store - Set function for sysfs attribute boottime
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t boottime_set(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t boottime_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_config cmd;
@@ -460,13 +463,13 @@ static ssize_t boottime_set(struct device *dev,
 }
 
 /**
- * channel_get - Get function for sysfs attribute channel
+ * channel_show - Get function for sysfs attribute channel
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t channel_get(struct device *dev,
-			   struct device_attribute *attr, char *buf)
+static ssize_t channel_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -480,14 +483,14 @@ static ssize_t channel_get(struct device *dev,
 }
 
 /**
- * channel_set - Set function for sysfs attribute channel
+ * channel_store - Set function for sysfs attribute channel
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
+static ssize_t channel_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_config cmd;
@@ -510,13 +513,13 @@ static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * mesh_id_get - Get function for sysfs attribute mesh_id
+ * mesh_id_show - Get function for sysfs attribute mesh_id
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t mesh_id_get(struct device *dev, struct device_attribute *attr,
-			   char *buf)
+static ssize_t mesh_id_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -539,14 +542,14 @@ static ssize_t mesh_id_get(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * mesh_id_set - Set function for sysfs attribute mesh_id
+ * mesh_id_store - Set function for sysfs attribute mesh_id
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t mesh_id_set(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
+static ssize_t mesh_id_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_mesh_defaults defs;
@@ -585,13 +588,14 @@ static ssize_t mesh_id_set(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * protocol_id_get - Get function for sysfs attribute protocol_id
+ * protocol_id_show - Get function for sysfs attribute protocol_id
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t protocol_id_get(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t protocol_id_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -605,14 +609,15 @@ static ssize_t protocol_id_get(struct device *dev,
 }
 
 /**
- * protocol_id_set - Set function for sysfs attribute protocol_id
+ * protocol_id_store - Set function for sysfs attribute protocol_id
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t protocol_id_set(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t protocol_id_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_mesh_defaults defs;
@@ -646,13 +651,13 @@ static ssize_t protocol_id_set(struct device *dev,
 }
 
 /**
- * metric_id_get - Get function for sysfs attribute metric_id
+ * metric_id_show - Get function for sysfs attribute metric_id
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t metric_id_get(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t metric_id_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -666,14 +671,15 @@ static ssize_t metric_id_get(struct device *dev,
 }
 
 /**
- * metric_id_set - Set function for sysfs attribute metric_id
+ * metric_id_store - Set function for sysfs attribute metric_id
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
+static ssize_t metric_id_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_mesh_defaults defs;
@@ -707,13 +713,13 @@ static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * capability_get - Get function for sysfs attribute capability
+ * capability_show - Get function for sysfs attribute capability
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer where data will be returned
  */
-static ssize_t capability_get(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t capability_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct mrvl_mesh_defaults defs;
 	int ret;
@@ -727,14 +733,15 @@ static ssize_t capability_get(struct device *dev,
 }
 
 /**
- * capability_set - Set function for sysfs attribute capability
+ * capability_store - Set function for sysfs attribute capability
  * @dev: the &struct device
  * @attr: device attributes
  * @buf: buffer that contains new attribute value
  * @count: size of buffer
  */
-static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
-			      const char *buf, size_t count)
+static ssize_t capability_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_mesh_defaults defs;
@@ -768,13 +775,13 @@ static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
 }
 
 
-static DEVICE_ATTR(bootflag, 0644, bootflag_get, bootflag_set);
-static DEVICE_ATTR(boottime, 0644, boottime_get, boottime_set);
-static DEVICE_ATTR(channel, 0644, channel_get, channel_set);
-static DEVICE_ATTR(mesh_id, 0644, mesh_id_get, mesh_id_set);
-static DEVICE_ATTR(protocol_id, 0644, protocol_id_get, protocol_id_set);
-static DEVICE_ATTR(metric_id, 0644, metric_id_get, metric_id_set);
-static DEVICE_ATTR(capability, 0644, capability_get, capability_set);
+static DEVICE_ATTR_RW(bootflag);
+static DEVICE_ATTR_RW(boottime);
+static DEVICE_ATTR_RW(channel);
+static DEVICE_ATTR_RW(mesh_id);
+static DEVICE_ATTR_RW(protocol_id);
+static DEVICE_ATTR_RW(metric_id);
+static DEVICE_ATTR_RW(capability);
 
 static struct attribute *boot_opts_attrs[] = {
 	&dev_attr_bootflag.attr,
-- 
2.17.1

