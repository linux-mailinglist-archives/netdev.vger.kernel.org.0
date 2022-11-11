Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96B86257A6
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiKKKIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiKKKIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:08:54 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4159D2792B;
        Fri, 11 Nov 2022 02:08:52 -0800 (PST)
X-UUID: 5c44a1ef77594af6ac9ceb94def301c1-20221111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=2kPNOGOomYObpfy8Uhn469poBxSZitEQV8g7qGLyCTg=;
        b=EoWG/X1vNE9tlNJXU3eLOYQ/b0VQn/dcpmEFIIYlZHKNgyWZW6hPmfVVWuNti6i8/HWXF7eMOJVm5KNg6taenWJUoUGa0RhLUMqlvlJfajA8EhiBxOzkdCroEUsU02rdfShSsAHjn5pqxwkgM+YukWohHkduL1Gm5obGMWSw45g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:6ce37877-cdca-453d-9103-e8b498d82121,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.12,REQID:6ce37877-cdca-453d-9103-e8b498d82121,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:62cd327,CLOUDID:73b84b5d-100c-4555-952b-a62c895efded,B
        ulkID:221111180849L35M876A,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 5c44a1ef77594af6ac9ceb94def301c1-20221111
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 356781705; Fri, 11 Nov 2022 18:08:47 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Fri, 11 Nov 2022 18:08:45 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Fri, 11 Nov 2022 18:08:43 +0800
From:   <haozhe.chang@mediatek.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        haozhe chang <haozhe.chang@mediatek.com>,
        "open list:INTEL WWAN IOSM DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:REMOTE PROCESSOR MESSAGING (RPMSG) WWAN CONTROL..." 
        <linux-remoteproc@vger.kernel.org>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
CC:     <lambert.wang@mediatek.com>, <xiayu.zhang@mediatek.com>,
        <hua.yang@mediatek.com>
Subject: [PATCH v3] wwan: core: Support slicing in port TX flow of WWAN subsystem
Date:   Fri, 11 Nov 2022 18:08:36 +0800
Message-ID: <20221111100840.105305-1-haozhe.chang@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: haozhe chang <haozhe.chang@mediatek.com>

wwan_port_fops_write inputs the SKB parameter to the TX callback of
the WWAN device driver. However, the WWAN device (e.g., t7xx) may
have an MTU less than the size of SKB, causing the TX buffer to be
sliced and copied once more in the WWAN device driver.

This patch implements the slicing in the WWAN subsystem and gives
the WWAN devices driver the option to slice(by frag_len) or not. By
doing so, the additional memory copy is reduced.

Meanwhile, this patch gives WWAN devices driver the option to reserve
headroom in fragments for the device-specific metadata.

Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>

---
Changes in v2
  -send fragments to device driver by skb frag_list.

Changes in v3
  -move frag_len and headroom_len setting to wwan_create_port.
---
 drivers/net/wwan/iosm/iosm_ipc_port.c  |  3 +-
 drivers/net/wwan/mhi_wwan_ctrl.c       |  2 +-
 drivers/net/wwan/rpmsg_wwan_ctrl.c     |  2 +-
 drivers/net/wwan/t7xx/t7xx_port_wwan.c | 34 +++++++--------
 drivers/net/wwan/wwan_core.c           | 59 ++++++++++++++++++++------
 drivers/net/wwan/wwan_hwsim.c          |  2 +-
 drivers/usb/class/cdc-wdm.c            |  2 +-
 include/linux/wwan.h                   |  6 ++-
 8 files changed, 73 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c b/drivers/net/wwan/iosm/iosm_ipc_port.c
index b6d81c627277..dc43b8f0d1af 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_port.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
@@ -63,7 +63,8 @@ struct iosm_cdev *ipc_port_init(struct iosm_imem *ipc_imem,
 	ipc_port->ipc_imem = ipc_imem;
 
 	ipc_port->iosm_port = wwan_create_port(ipc_port->dev, port_type,
-					       &ipc_wwan_ctrl_ops, ipc_port);
+					       &ipc_wwan_ctrl_ops, 0, 0,
+					       ipc_port);
 
 	return ipc_port;
 }
diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index f7ca52353f40..29300838531c 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -237,7 +237,7 @@ static int mhi_wwan_ctrl_probe(struct mhi_device *mhi_dev,
 
 	/* Register as a wwan port, id->driver_data contains wwan port type */
 	port = wwan_create_port(&cntrl->mhi_dev->dev, id->driver_data,
-				&wwan_pops, mhiwwan);
+				&wwan_pops, 0, 0, mhiwwan);
 	if (IS_ERR(port)) {
 		kfree(mhiwwan);
 		return PTR_ERR(port);
diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
index 31c24420ab2e..060f06072dca 100644
--- a/drivers/net/wwan/rpmsg_wwan_ctrl.c
+++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
@@ -129,7 +129,7 @@ static int rpmsg_wwan_ctrl_probe(struct rpmsg_device *rpdev)
 
 	/* Register as a wwan port, id.driver_data contains wwan port type */
 	port = wwan_create_port(parent, rpdev->id.driver_data,
-				&rpmsg_wwan_pops, rpwwan);
+				&rpmsg_wwan_pops, 0, 0, rpwwan);
 	if (IS_ERR(port))
 		return PTR_ERR(port);
 
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
index 33931bfd78fd..b75bb272f861 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -54,13 +54,13 @@ static void t7xx_port_ctrl_stop(struct wwan_port *port)
 static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 {
 	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
-	size_t len, offset, chunk_len = 0, txq_mtu = CLDMA_MTU;
 	const struct t7xx_port_conf *port_conf;
+	struct sk_buff *cur = skb, *cloned;
 	struct t7xx_fsm_ctl *ctl;
 	enum md_state md_state;
+	int cnt = 0, ret;
 
-	len = skb->len;
-	if (!len || !port_private->chan_enable)
+	if (!port_private->chan_enable)
 		return -EINVAL;
 
 	port_conf = port_private->port_conf;
@@ -72,23 +72,21 @@ static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 		return -ENODEV;
 	}
 
-	for (offset = 0; offset < len; offset += chunk_len) {
-		struct sk_buff *skb_ccci;
-		int ret;
-
-		chunk_len = min(len - offset, txq_mtu - sizeof(struct ccci_header));
-		skb_ccci = t7xx_port_alloc_skb(chunk_len);
-		if (!skb_ccci)
-			return -ENOMEM;
-
-		skb_put_data(skb_ccci, skb->data + offset, chunk_len);
-		ret = t7xx_port_send_skb(port_private, skb_ccci, 0, 0);
+	while (cur) {
+		cloned = skb_clone(cur, GFP_KERNEL);
+		cloned->len = skb_headlen(cur);
+		ret = t7xx_port_send_skb(port_private, cloned, 0, 0);
 		if (ret) {
-			dev_kfree_skb_any(skb_ccci);
+			dev_kfree_skb(cloned);
 			dev_err(port_private->dev, "Write error on %s port, %d\n",
 				port_conf->name, ret);
-			return ret;
+			return cnt ? cnt + ret : ret;
 		}
+		cnt += cur->len;
+		if (cur == skb)
+			cur = skb_shinfo(skb)->frag_list;
+		else
+			cur = cur->next;
 	}
 
 	dev_kfree_skb(skb);
@@ -154,13 +152,15 @@ static int t7xx_port_wwan_disable_chl(struct t7xx_port *port)
 static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int state)
 {
 	const struct t7xx_port_conf *port_conf = port->port_conf;
+	unsigned int header_len = sizeof(struct ccci_header);
 
 	if (state != MD_STATE_READY)
 		return;
 
 	if (!port->wwan_port) {
 		port->wwan_port = wwan_create_port(port->dev, port_conf->port_type,
-						   &wwan_ops, port);
+						   &wwan_ops, CLDMA_MTU - header_len,
+						   header_len, port);
 		if (IS_ERR(port->wwan_port))
 			dev_err(port->dev, "Unable to create WWWAN port %s", port_conf->name);
 	}
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 62e9f7d6c9fe..0d466f4cc2df 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -67,6 +67,8 @@ struct wwan_device {
  * @rxq: Buffer inbound queue
  * @waitqueue: The waitqueue for port fops (read/write/poll)
  * @data_lock: Port specific data access serialization
+ * @headroom_len: SKB reserved headroom size
+ * @frag_len: Length to split packet
  * @at_data: AT port specific data
  */
 struct wwan_port {
@@ -79,6 +81,8 @@ struct wwan_port {
 	struct sk_buff_head rxq;
 	wait_queue_head_t waitqueue;
 	struct mutex data_lock;	/* Port specific data access serialization */
+	size_t headroom_len;
+	size_t frag_len;
 	union {
 		struct {
 			struct ktermios termios;
@@ -422,6 +426,8 @@ static int __wwan_port_dev_assign_name(struct wwan_port *port, const char *fmt)
 struct wwan_port *wwan_create_port(struct device *parent,
 				   enum wwan_port_type type,
 				   const struct wwan_port_ops *ops,
+				   size_t frag_len,
+				   unsigned int headroom_len,
 				   void *drvdata)
 {
 	struct wwan_device *wwandev;
@@ -455,6 +461,8 @@ struct wwan_port *wwan_create_port(struct device *parent,
 
 	port->type = type;
 	port->ops = ops;
+	port->frag_len = frag_len ? frag_len : SIZE_MAX;
+	port->headroom_len = headroom_len;
 	mutex_init(&port->ops_lock);
 	skb_queue_head_init(&port->rxq);
 	init_waitqueue_head(&port->waitqueue);
@@ -698,30 +706,53 @@ static ssize_t wwan_port_fops_read(struct file *filp, char __user *buf,
 static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
 				    size_t count, loff_t *offp)
 {
+	struct sk_buff *skb, *head = NULL, *tail = NULL;
 	struct wwan_port *port = filp->private_data;
-	struct sk_buff *skb;
+	size_t frag_len, remain = count;
 	int ret;
 
 	ret = wwan_wait_tx(port, !!(filp->f_flags & O_NONBLOCK));
 	if (ret)
 		return ret;
 
-	skb = alloc_skb(count, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
+	do {
+		frag_len = min(remain, port->frag_len);
+		skb = alloc_skb(frag_len + port->headroom_len, GFP_KERNEL);
+		if (!skb) {
+			ret = -ENOMEM;
+			goto freeskb;
+		}
+		skb_reserve(skb, port->headroom_len);
+
+		if (!head) {
+			head = skb;
+		} else if (!tail) {
+			skb_shinfo(head)->frag_list = skb;
+			tail = skb;
+		} else {
+			tail->next = skb;
+			tail = skb;
+		}
 
-	if (copy_from_user(skb_put(skb, count), buf, count)) {
-		kfree_skb(skb);
-		return -EFAULT;
-	}
+		if (copy_from_user(skb_put(skb, frag_len), buf + count - remain, frag_len)) {
+			ret = -EFAULT;
+			goto freeskb;
+		}
 
-	ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
-	if (ret) {
-		kfree_skb(skb);
-		return ret;
-	}
+		if (skb != head) {
+			head->data_len += skb->len;
+			head->len += skb->len;
+			head->truesize += skb->truesize;
+		}
+	} while (remain -= frag_len);
+
+	ret = wwan_port_op_tx(port, head, !!(filp->f_flags & O_NONBLOCK));
+	if (!ret)
+		return count;
 
-	return count;
+freeskb:
+	kfree_skb(head);
+	return ret;
 }
 
 static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index ff09a8cedf93..3a02a75d4485 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -205,7 +205,7 @@ static struct wwan_hwsim_port *wwan_hwsim_port_new(struct wwan_hwsim_dev *dev)
 
 	port->wwan = wwan_create_port(&dev->dev, WWAN_PORT_AT,
 				      &wwan_hwsim_port_ops,
-				      port);
+				      0, 0, port);
 	if (IS_ERR(port->wwan)) {
 		err = PTR_ERR(port->wwan);
 		goto err_free_port;
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 1f0951be15ab..ff7494635d0f 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -929,7 +929,7 @@ static void wdm_wwan_init(struct wdm_device *desc)
 		return;
 	}
 
-	port = wwan_create_port(&intf->dev, desc->wwanp_type, &wdm_wwan_port_ops, desc);
+	port = wwan_create_port(&intf->dev, desc->wwanp_type, &wdm_wwan_port_ops, 0, 0, desc);
 	if (IS_ERR(port)) {
 		dev_err(&intf->dev, "%s: Unable to create WWAN port\n",
 			dev_name(intf->usb_dev));
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 5ce2acf444fb..e1a6554792fc 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -67,6 +67,9 @@ struct wwan_port_ops {
  * @parent: Device to use as parent and shared by all WWAN ports
  * @type: WWAN port type
  * @ops: WWAN port operations
+ * @frag_len: TX fragments length, if 0 is set,
+ *            the WWAN core will not split the user package.
+ * @headroom_len: TX fragments reserved headroom length
  * @drvdata: Pointer to caller driver data
  *
  * Allocate and register a new WWAN port. The port will be automatically exposed
@@ -84,6 +87,8 @@ struct wwan_port_ops {
 struct wwan_port *wwan_create_port(struct device *parent,
 				   enum wwan_port_type type,
 				   const struct wwan_port_ops *ops,
+				   size_t frag_len,
+				   unsigned int headroom_len,
 				   void *drvdata);
 
 /**
@@ -112,7 +117,6 @@ void wwan_port_rx(struct wwan_port *port, struct sk_buff *skb);
  */
 void wwan_port_txoff(struct wwan_port *port);
 
-
 /**
  * wwan_port_txon - Restart TX on WWAN port
  * @port: WWAN port for which TX must be restarted
-- 
2.17.0

