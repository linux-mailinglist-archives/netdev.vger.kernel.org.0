Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CCE2B153B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 06:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgKMFH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 00:07:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33804 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKMFH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 00:07:28 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201113050724epoutp0496127ac7561d67ecfe47adb0566d1368~G_PQUPI0M2864828648epoutp04B
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 05:07:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201113050724epoutp0496127ac7561d67ecfe47adb0566d1368~G_PQUPI0M2864828648epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605244044;
        bh=vc4EfuxdU/AnabEI0I9GQOKinxufpNqRtwTWv+vZDCE=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=uGTZ/l3M2AF0AffBbN6Jy8HU6mhZu7+iktpnvMy5S52R+lYtWwxjaDprVIS5W4/lN
         xzOq0MXs7K3q9UG9e+6QEKL69ejTLALDiTWT+Q0lPHJfkBg3DMIz6Rw+JsrGCFQxdy
         jLCK1dr2gAVVeZq64oc0wRiznHR6J2yceCDfU37k=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201113050723epcas2p333b76d6c7136fa1d3c6b45d4c6deddf5~G_PPdzasd0850108501epcas2p37;
        Fri, 13 Nov 2020 05:07:23 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CXRKj06WdzMqYkk; Fri, 13 Nov
        2020 05:07:21 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-3a-5fae14889cdd
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.07.10621.8841EAF5; Fri, 13 Nov 2020 14:07:20 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 1/2] nfc: s3fwrn82: Add driver for Samsung S3FWRN82
 NFC Chip
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
Date:   Fri, 13 Nov 2020 14:07:19 +0900
X-CMS-MailID: 20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmmW6HyLp4gxczeSy2NE9it5hzvoXF
        Yv6Rc6wWF7b1sVocWyBm0br3CLsDm8eWlTeZPDat6mTz6NuyitHj8ya5AJaoHJuM1MSU1CKF
        1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
        fTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjCfT+1gLfhVX
        7Np5kr2B8UZ8FyMnh4SAicTT20vYQGwhgR2MEueeCHYxcnDwCghK/N0hDBIWFgiXuH/mCTNE
        iaLE/45zbBBxXYkXf4+C2WwC2hJrjzYygdgiAmESN1fcAKtnFpjPKDGzKxZiFa/EjPanLBC2
        tMT25VsZIWwNiR/LepkhbFGJm6vfssPY74/Nh6oRkWi9dxaqRlDiwc/dUHFJibf75gHVcwHZ
        7YwS53/+YINwZjBKnNr8F6pDX2LxuRVMEI/5Shy9qwYSZhFQlZjSdYMNosRFYsbsOWwQR8tL
        bH87hxmknFlAU2L9Ln0QU0JAWeLILRaICj6JjsN/2WHe2jHvCROErSrR2/yFCebFybNboM70
        kLix6CQLJAgDJbbsecM8gVFhFiKgZyHZOwth7wJG5lWMYqkFxbnpqcVGBYbIUbuJEZwKtVx3
        ME5++0HvECMTB+MhRgkOZiURXmWHNfFCvCmJlVWpRfnxRaU5qcWHGE2BPp7ILCWanA9Mxnkl
        8YamRmZmBpamFqZmRhZK4ryhK/vihQTSE0tSs1NTC1KLYPqYODilGpjqD/wq8Az/GjLLrqE0
        rCUlPOOu850fW95s7NKoujPr2ZoUN9u7ETL5TCtnqf5a9kd4o0FmqRrn8jpVke9r3a5rPOor
        mv/WXvlJ6vTgP8+1b89httyjnlj+Y3fK9xkqDmGvi9+cF5rvs77M3PrYwzWLukNKfmVPmBO1
        1GvF1CjF1VPK3h2zEbu6wKev/OT9sJ+hO0Wesb59wed1o+jK6W2eATpbn15s+T25fKHJhJL/
        ATsT60sifvd4GSrk9MuyL/xxftGqiRYV12TWCWtM3lbQ8eEL42/Gc3lB8b8Ep1fY/D28QLDy
        /5Zr9w6kTUwtX8MZd7dTZ93VZVOy2Z1u9WwScg0oP9H1sXX7n+YZbzWClFiKMxINtZiLihMB
        YOF59w4EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3
References: <CGME20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Add driver for Samsung S3FWRN82 NFC controller.
S3FWRN82 is using NCI protocol and I2C communication interface.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/Kconfig             |   1 +
 drivers/nfc/Makefile            |   1 +
 drivers/nfc/s3fwrn82/Kconfig    |  15 ++
 drivers/nfc/s3fwrn82/Makefile   |  10 ++
 drivers/nfc/s3fwrn82/core.c     | 133 +++++++++++++++
 drivers/nfc/s3fwrn82/i2c.c      | 288 ++++++++++++++++++++++++++++++++
 drivers/nfc/s3fwrn82/s3fwrn82.h |  86 ++++++++++
 7 files changed, 534 insertions(+)
 create mode 100644 drivers/nfc/s3fwrn82/Kconfig
 create mode 100644 drivers/nfc/s3fwrn82/Makefile
 create mode 100644 drivers/nfc/s3fwrn82/core.c
 create mode 100644 drivers/nfc/s3fwrn82/i2c.c
 create mode 100644 drivers/nfc/s3fwrn82/s3fwrn82.h

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 75c65d339018..102654909d3a 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -59,4 +59,5 @@ source "drivers/nfc/st-nci/Kconfig"
 source "drivers/nfc/nxp-nci/Kconfig"
 source "drivers/nfc/s3fwrn5/Kconfig"
 source "drivers/nfc/st95hf/Kconfig"
+source "drivers/nfc/s3fwrn82/Kconfig"
 endmenu
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index 5393ba59b17d..518d83301ad2 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_NFC_ST_NCI)	+= st-nci/
 obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
 obj-$(CONFIG_NFC_S3FWRN5)	+= s3fwrn5/
 obj-$(CONFIG_NFC_ST95HF)	+= st95hf/
+obj-$(CONFIG_NFC_S3FWRN82)	+= s3fwrn82/
diff --git a/drivers/nfc/s3fwrn82/Kconfig b/drivers/nfc/s3fwrn82/Kconfig
new file mode 100644
index 000000000000..afbad659cf07
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NFC_S3FWRN82
+	tristate
+
+config NFC_S3FWRN82_I2C
+	tristate "Samsung S3FWRN82 I2C support"
+	depends on NFC_NCI && I2C
+	select NFC_S3FWRN82
+	help
+	  This module adds support for an I2C interface to the S3FWRN82 chip.
+	  Select this if your platform is using the I2C bus.
+
+	  To compile this driver as a module, choose m here. The module will
+	  be called s3fwrn82_i2c.ko.
+	  Say N if unsure.
diff --git a/drivers/nfc/s3fwrn82/Makefile b/drivers/nfc/s3fwrn82/Makefile
new file mode 100644
index 000000000000..198e2cd85e91
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for Samsung S3FWRN82 NFC driver
+#
+
+s3fwrn82-objs = core.o
+s3fwrn82_i2c-objs = i2c.o
+
+obj-$(CONFIG_NFC_S3FWRN82) += s3fwrn82.o
+obj-$(CONFIG_NFC_S3FWRN82_I2C) += s3fwrn82_i2c.o
diff --git a/drivers/nfc/s3fwrn82/core.c b/drivers/nfc/s3fwrn82/core.c
new file mode 100644
index 000000000000..e01e02c758ab
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/core.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * NCI based driver for Samsung S3FWRN82 NFC chip
+ *
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#include <linux/module.h>
+#include <net/nfc/nci_core.h>
+
+#include "s3fwrn82.h"
+
+#define S3FWRN82_NFC_PROTOCOLS  (NFC_PROTO_JEWEL_MASK | \
+				NFC_PROTO_MIFARE_MASK | \
+				NFC_PROTO_FELICA_MASK | \
+				NFC_PROTO_ISO14443_MASK | \
+				NFC_PROTO_ISO14443_B_MASK | \
+				NFC_PROTO_ISO15693_MASK)
+
+static int s3fwrn82_nci_open(struct nci_dev *ndev)
+{
+	struct s3fwrn82_info *info = nci_get_drvdata(ndev);
+
+	if (s3fwrn82_get_mode(info) != S3FWRN82_MODE_COLD)
+		return -EBUSY;
+
+	s3fwrn82_set_mode(info, S3FWRN82_MODE_NCI);
+	s3fwrn82_set_wake(info, true);
+
+	return 0;
+}
+
+static int s3fwrn82_nci_close(struct nci_dev *ndev)
+{
+	struct s3fwrn82_info *info = nci_get_drvdata(ndev);
+
+	s3fwrn82_set_wake(info, false);
+	s3fwrn82_set_mode(info, S3FWRN82_MODE_COLD);
+
+	return 0;
+}
+
+static int s3fwrn82_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	struct s3fwrn82_info *info = nci_get_drvdata(ndev);
+	int ret;
+
+	mutex_lock(&info->mutex);
+
+	if (s3fwrn82_get_mode(info) != S3FWRN82_MODE_NCI) {
+		mutex_unlock(&info->mutex);
+		return -EINVAL;
+	}
+
+	ret = s3fwrn82_write(info, skb);
+	if (ret < 0)
+		kfree_skb(skb);
+
+	mutex_unlock(&info->mutex);
+	return ret;
+}
+
+static struct nci_ops s3fwrn82_nci_ops = {
+	.open = s3fwrn82_nci_open,
+	.close = s3fwrn82_nci_close,
+	.send = s3fwrn82_nci_send,
+};
+
+int s3fwrn82_probe(struct nci_dev **ndev,
+		   void *phy_id,
+		   struct device *pdev,
+		   const struct s3fwrn82_phy_ops *phy_ops)
+{
+	struct s3fwrn82_info *info;
+	int ret;
+
+	info = devm_kzalloc(pdev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->phy_id = phy_id;
+	info->pdev = pdev;
+	info->phy_ops = phy_ops;
+	mutex_init(&info->mutex);
+
+	s3fwrn82_set_mode(info, S3FWRN82_MODE_COLD);
+
+	info->ndev = nci_allocate_device(&s3fwrn82_nci_ops, S3FWRN82_NFC_PROTOCOLS, 0, 0);
+	if (!info->ndev)
+		return -ENOMEM;
+
+	nci_set_parent_dev(info->ndev, pdev);
+	nci_set_drvdata(info->ndev, info);
+
+	ret = nci_register_device(info->ndev);
+	if (ret < 0) {
+		nci_free_device(info->ndev);
+		return ret;
+	}
+
+	*ndev = info->ndev;
+
+	return ret;
+}
+EXPORT_SYMBOL(s3fwrn82_probe);
+
+void s3fwrn82_remove(struct nci_dev *ndev)
+{
+	struct s3fwrn82_info *info = nci_get_drvdata(ndev);
+
+	s3fwrn82_set_mode(info, S3FWRN82_MODE_COLD);
+
+	nci_unregister_device(ndev);
+	nci_free_device(ndev);
+}
+EXPORT_SYMBOL(s3fwrn82_remove);
+
+int s3fwrn82_recv_frame(struct nci_dev *ndev, struct sk_buff *skb, enum s3fwrn82_mode mode)
+{
+	switch (mode) {
+	case S3FWRN82_MODE_NCI:
+		return nci_recv_frame(ndev, skb);
+	default:
+		kfree_skb(skb);
+		return -ENODEV;
+	}
+}
+EXPORT_SYMBOL(s3fwrn82_recv_frame);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Samsung S3FWRN82 NFC driver");
+MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");
diff --git a/drivers/nfc/s3fwrn82/i2c.c b/drivers/nfc/s3fwrn82/i2c.c
new file mode 100644
index 000000000000..ea50c0165865
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/i2c.c
@@ -0,0 +1,288 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * I2C Link Layer for Samsung S3FWRN82 NCI based Driver
+ *
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
+#include <linux/module.h>
+
+#include <net/nfc/nfc.h>
+
+#include "s3fwrn82.h"
+
+#define S3FWRN82_I2C_DRIVER_NAME "s3fwrn82_i2c"
+
+#define S3FWRN82_EN_WAIT_TIME 20
+
+struct s3fwrn82_i2c_phy {
+	struct i2c_client *i2c_dev;
+	struct nci_dev *ndev;
+
+	unsigned int gpio_en;
+	unsigned int gpio_fw_wake;
+
+	/* use this mutex for syncronization of phy */
+	struct mutex mutex;
+
+	enum s3fwrn82_mode mode;
+	unsigned int irq_skip:1;
+};
+
+static void s3fwrn82_i2c_set_wake(void *phy_id, bool wake)
+{
+	struct s3fwrn82_i2c_phy *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+	gpio_set_value(phy->gpio_fw_wake, wake);
+	if (wake)
+		msleep(S3FWRN82_EN_WAIT_TIME);
+	mutex_unlock(&phy->mutex);
+}
+
+static void s3fwrn82_i2c_set_mode(void *phy_id, enum s3fwrn82_mode mode)
+{
+	struct s3fwrn82_i2c_phy *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+
+	if (phy->mode == mode)
+		goto out;
+
+	phy->mode = mode;
+
+	gpio_set_value(phy->gpio_en, 1);
+	gpio_set_value(phy->gpio_fw_wake, 0);
+
+	if (mode != S3FWRN82_MODE_COLD) {
+		msleep(S3FWRN82_EN_WAIT_TIME);
+		gpio_set_value(phy->gpio_en, 0);
+		msleep(S3FWRN82_EN_WAIT_TIME / 2);
+	}
+
+	phy->irq_skip = true;
+
+out:
+	mutex_unlock(&phy->mutex);
+}
+
+static enum s3fwrn82_mode s3fwrn82_i2c_get_mode(void *phy_id)
+{
+	struct s3fwrn82_i2c_phy *phy = phy_id;
+	enum s3fwrn82_mode mode;
+
+	mutex_lock(&phy->mutex);
+
+	mode = phy->mode;
+
+	mutex_unlock(&phy->mutex);
+
+	return mode;
+}
+
+static int s3fwrn82_i2c_write(void *phy_id, struct sk_buff *skb)
+{
+	struct s3fwrn82_i2c_phy *phy = phy_id;
+	int ret;
+
+	mutex_lock(&phy->mutex);
+
+	phy->irq_skip = false;
+
+	ret = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
+	mutex_unlock(&phy->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	if (ret != skb->len)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static const struct s3fwrn82_phy_ops i2c_phy_ops = {
+	.set_wake = s3fwrn82_i2c_set_wake,
+	.set_mode = s3fwrn82_i2c_set_mode,
+	.get_mode = s3fwrn82_i2c_get_mode,
+	.write = s3fwrn82_i2c_write,
+};
+
+static int s3fwrn82_i2c_read(struct s3fwrn82_i2c_phy *phy)
+{
+	struct sk_buff *skb;
+	size_t hdr_size;
+	size_t data_len;
+	char hdr[4];
+	int ret;
+
+	hdr_size = NCI_CTRL_HDR_SIZE;
+	ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
+	if (ret < 0)
+		return ret;
+
+	if (ret < hdr_size)
+		return -EBADMSG;
+
+	data_len = ((struct nci_ctrl_hdr *)hdr)->plen;
+
+	skb = alloc_skb(hdr_size + data_len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put_data(skb, hdr, hdr_size);
+
+	if (data_len == 0)
+		goto out;
+
+	ret = i2c_master_recv(phy->i2c_dev, skb_put(skb, data_len), data_len);
+	if (ret != data_len) {
+		kfree_skb(skb);
+		return -EBADMSG;
+	}
+
+out:
+	return s3fwrn82_recv_frame(phy->ndev, skb, phy->mode);
+}
+
+static irqreturn_t s3fwrn82_i2c_irq_thread_fn(int irq, void *phy_id)
+{
+	struct s3fwrn82_i2c_phy *phy = phy_id;
+
+	if (!phy || !phy->ndev) {
+		WARN_ON_ONCE(1);
+		return IRQ_NONE;
+	}
+
+	mutex_lock(&phy->mutex);
+
+	if (phy->irq_skip)
+		goto out;
+
+	switch (phy->mode) {
+	case S3FWRN82_MODE_NCI:
+		s3fwrn82_i2c_read(phy);
+		break;
+	case S3FWRN82_MODE_COLD:
+		break;
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+
+	return IRQ_HANDLED;
+}
+
+static int s3fwrn82_i2c_parse_dt(struct i2c_client *client)
+{
+	struct s3fwrn82_i2c_phy *phy = i2c_get_clientdata(client);
+	struct device_node *np = client->dev.of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_en))
+		return -ENODEV;
+
+	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_fw_wake))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int s3fwrn82_i2c_probe(struct i2c_client *client,
+			      const struct i2c_device_id *id)
+{
+	struct s3fwrn82_i2c_phy *phy;
+	int ret;
+
+	phy = devm_kzalloc(&client->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	mutex_init(&phy->mutex);
+	phy->mode = S3FWRN82_MODE_COLD;
+	phy->irq_skip = true;
+
+	phy->i2c_dev = client;
+	i2c_set_clientdata(client, phy);
+
+	ret = s3fwrn82_i2c_parse_dt(client);
+	if (ret < 0)
+		return ret;
+
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev,
+				    phy->gpio_en,
+				    GPIOF_OUT_INIT_HIGH,
+				    "s3fwrn82_en");
+	if (ret < 0)
+		return ret;
+
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev,
+				    phy->gpio_fw_wake,
+				    GPIOF_OUT_INIT_LOW,
+				    "s3fwrn82_fw_wake");
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn82_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
+	if (ret < 0)
+		return ret;
+
+	ret = devm_request_threaded_irq(&client->dev,
+					phy->i2c_dev->irq,
+					NULL,
+					s3fwrn82_i2c_irq_thread_fn,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					S3FWRN82_I2C_DRIVER_NAME,
+					phy);
+	if (ret)
+		s3fwrn82_remove(phy->ndev);
+
+	return ret;
+}
+
+static int s3fwrn82_i2c_remove(struct i2c_client *client)
+{
+	struct s3fwrn82_i2c_phy *phy = i2c_get_clientdata(client);
+
+	s3fwrn82_remove(phy->ndev);
+
+	return 0;
+}
+
+static const struct i2c_device_id s3fwrn82_i2c_id_table[] = {
+	{S3FWRN82_I2C_DRIVER_NAME, 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, s3fwrn82_i2c_id_table);
+
+static const struct of_device_id of_s3fwrn82_i2c_match[] = {
+	{ .compatible = "samsung,s3fwrn82-i2c", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, of_s3fwrn82_i2c_match);
+
+static struct i2c_driver s3fwrn82_i2c_driver = {
+	.driver = {
+		.name = S3FWRN82_I2C_DRIVER_NAME,
+		.of_match_table = of_match_ptr(of_s3fwrn82_i2c_match),
+	},
+	.probe = s3fwrn82_i2c_probe,
+	.remove = s3fwrn82_i2c_remove,
+	.id_table = s3fwrn82_i2c_id_table,
+};
+
+module_i2c_driver(s3fwrn82_i2c_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("I2C driver for Samsung S3FWRN82");
+MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");
diff --git a/drivers/nfc/s3fwrn82/s3fwrn82.h b/drivers/nfc/s3fwrn82/s3fwrn82.h
new file mode 100644
index 000000000000..4c19d1fafde6
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/s3fwrn82.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * NCI based driver for Samsung S3FWRN82 NFC chip
+ *
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#ifndef __LOCAL_S3FWRN82_H_
+#define __LOCAL_S3FWRN82_H_
+
+#include <linux/nfc.h>
+
+#include <net/nfc/nci_core.h>
+
+enum s3fwrn82_mode {
+	S3FWRN82_MODE_COLD,
+	S3FWRN82_MODE_NCI,
+};
+
+struct s3fwrn82_phy_ops {
+	void (*set_wake)(void *id, bool sleep);
+	void (*set_mode)(void *id, enum s3fwrn82_mode);
+	enum s3fwrn82_mode (*get_mode)(void *id);
+	int (*write)(void *id, struct sk_buff *skb);
+};
+
+struct s3fwrn82_info {
+	struct nci_dev *ndev;
+	void *phy_id;
+	struct device *pdev;
+
+	const struct s3fwrn82_phy_ops *phy_ops;
+
+	/* use this mutex for syncronization of nci write */
+	struct mutex mutex;
+};
+
+static inline int s3fwrn82_set_mode(struct s3fwrn82_info *info,
+				    enum s3fwrn82_mode mode)
+{
+	if (!info->phy_ops->set_mode)
+		return -EOPNOTSUPP;
+
+	info->phy_ops->set_mode(info->phy_id, mode);
+
+	return 0;
+}
+
+static inline enum s3fwrn82_mode s3fwrn82_get_mode(struct s3fwrn82_info *info)
+{
+	if (!info->phy_ops->get_mode)
+		return -EOPNOTSUPP;
+
+	return info->phy_ops->get_mode(info->phy_id);
+}
+
+static inline int s3fwrn82_set_wake(struct s3fwrn82_info *info, bool wake)
+{
+	if (!info->phy_ops->set_wake)
+		return -EOPNOTSUPP;
+
+	info->phy_ops->set_wake(info->phy_id, wake);
+
+	return 0;
+}
+
+static inline int s3fwrn82_write(struct s3fwrn82_info *info, struct sk_buff *skb)
+{
+	if (!info->phy_ops->write)
+		return -EOPNOTSUPP;
+
+	return info->phy_ops->write(info->phy_id, skb);
+}
+
+int s3fwrn82_probe(struct nci_dev **ndev,
+		   void *phy_id,
+		   struct device *pdev,
+		   const struct s3fwrn82_phy_ops *phy_ops);
+void s3fwrn82_remove(struct nci_dev *ndev);
+
+int s3fwrn82_recv_frame(struct nci_dev *ndev,
+			struct sk_buff *skb,
+			enum s3fwrn82_mode mode);
+
+#endif /* __LOCAL_S3FWRN82_H_ */
-- 
