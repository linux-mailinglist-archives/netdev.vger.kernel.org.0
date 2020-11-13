Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422822B13FD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKMBrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:47:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43102 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMBrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 20:47:43 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201113014736epoutp0364ee6934a3776cbeb092303ed022ce61~G7gzp1yC22036220362epoutp03q
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 01:47:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201113014736epoutp0364ee6934a3776cbeb092303ed022ce61~G7gzp1yC22036220362epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605232056;
        bh=Oybib231jc1KYnlVbzUF0RmuotYWk203+B/RUVdL2Z4=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=vMN/mGWZd3aX40EDowJuyDbUWqLHkchuyf8vj+5YTLaIuKlT326MmiA5yANJZF37f
         0ON4xDq5NzSHgU8PLwrBP8/mOoi2JzLdOJCFmLtjVGQwSOhRCMuhFOw0Hs18rqcO27
         sPj33lUHNYdJwzPp/1Oc9Kbw3eqZin9AT3SSuep0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201113014736epcas2p140b063854f878126dbb1e596554b10d1~G7gzdjRtV1572115721epcas2p1B;
        Fri, 13 Nov 2020 01:47:36 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CXLv94v6pzMqYm0; Fri, 13 Nov
        2020 01:47:33 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-08-5fade5b346c0
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.69.10621.3B5EDAF5; Fri, 13 Nov 2020 10:47:31 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next] nfc: s3fwrn82: Add driver for Samsung S3FWRN82 NFC
 Chip
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6@epcms2p5>
Date:   Fri, 13 Nov 2020 10:47:30 +0900
X-CMS-MailID: 20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7bCmue7mp2vjDTonsVnMOd/CYnFhWx+r
        xbEFYg7MHltW3mTy2LSqk83j8ya5AOaoHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
        SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAJD
        wwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjJ19/9kL1tVVTP/4l7WB8Ul6FyMnh4SAicSD6xsZ
        uxi5OIQEdjBK7OhfztLFyMHBKyAo8XeHMEiNsECwxOOJD5lAbCEBRYn/HefYIOK6Ei/+HgWz
        2QS0JdYebQSrERFQl+g6eIIZZAyzQIrEpYdOEKt4JWa0P2WBsKUlti/fyghha0j8WNbLDGGL
        Stxc/ZYdxn5/bD5UjYhE672zUDWCEg9+7oaKS0q83TePHeR8CYF2RonzP3+wQTgzGCVObf4L
        1aEvsfjcCrDjeAV8Jdq/vAA7mkVAVeLi2RaoSS4SD+bfZAWxmQXkJba/nQP1gKbE+l36IKaE
        gLLEkVssEBV8Eh2H/7LD/LVj3hMmCFtVorf5CxPMj5Nnw0z3kHi0p4kVEoSBEvN7XrBPYFSY
        hQjoWUj2zkLYu4CReRWjWGpBcW56arFRgSFy3G5iBCc5LdcdjJPfftA7xMjEwXiIUYKDWUmE
        V9lhTbwQb0piZVVqUX58UWlOavEhRlOgjycyS4km5wPTbF5JvKGpkZmZgaWphamZkYWSOG/o
        yr54IYH0xJLU7NTUgtQimD4mDk6pBiavf5k/E5JfWZ9yzf5ntbWdJW9l0KU1XMcl7877L+Ks
        ldL+5Oq+CFmN5zd6W2R7tm/a5nk1JniN/ubbzIw7RWfuTGqItJvgVb1sRt63rccSKyefeqIl
        Z7kn1+/sJq20D+7zE+ML7S9JnMsWrJI4e/7ipePGU9N7Ntbeeu2muntN3bKbpUvYDtw0ZLim
        2TA7UM/qnXr8n5ff1u5ybNwvfmTzF07n1072J/R1+Z1fXn2n3p1iGXr2h6VPbFsPz4xModv5
        H30k9WLaVv5f7+92eOdJzw9tETU3bth6HmT6z88R6tmx6M36noIUt8Veu5L1mY4L+p9b0vn9
        6hPBByzFZw2P/53yca7RxTfu26a53j6uxFKckWioxVxUnAgAqzqPM/sDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6
References: <CGME20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Add driver for Samsung S3FWRN82 NFC controller.
S3FWRN82 is using NCI protocol and I2C communication interface.

Signed-off-by: bongsujeon <bongsu.jeon@samsung.com>
---
 .../devicetree/bindings/net/nfc/s3fwrn82.txt  |  30 ++
 drivers/nfc/Kconfig                           |   1 +
 drivers/nfc/Makefile                          |   1 +
 drivers/nfc/s3fwrn82/Kconfig                  |  20 ++
 drivers/nfc/s3fwrn82/Makefile                 |  10 +
 drivers/nfc/s3fwrn82/core.c                   | 133 +++++++++
 drivers/nfc/s3fwrn82/i2c.c                    | 281 ++++++++++++++++++
 drivers/nfc/s3fwrn82/s3fwrn82.h               |  82 +++++
 8 files changed, 558 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
 create mode 100644 drivers/nfc/s3fwrn82/Kconfig
 create mode 100644 drivers/nfc/s3fwrn82/Makefile
 create mode 100644 drivers/nfc/s3fwrn82/core.c
 create mode 100644 drivers/nfc/s3fwrn82/i2c.c
 create mode 100644 drivers/nfc/s3fwrn82/s3fwrn82.h

diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
new file mode 100644
index 000000000000..03ed880e1c7f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
@@ -0,0 +1,30 @@
+* Samsung S3FWRN82 NCI NFC Controller
+
+Required properties:
+- compatible: Should be "samsung,s3fwrn82-i2c".
+- reg: address on the bus
+- interrupts: GPIO interrupt to which the chip is connected
+- en-gpios: Output GPIO pin used for enabling/disabling the chip
+- wake-gpios: Output GPIO pin used to enter firmware mode and
+  sleep/wakeup control
+
+Example:
+
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    i2c4 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        s3fwrn82@27 {
+            compatible = "samsung,s3fwrn82-i2c";
+            reg = <0x27>;
+
+            interrupt-parent = <&gpa1>;
+            interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
+
+            en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
+            wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
+        };
+    };
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
index 000000000000..8765624c6fa4
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NFC_S3FWRN82
+	tristate
+	help
+	  Core driver for Samsung S3FWRN82 NFC chip. Contains core utilities
+	  of chip. It's intended to be used by PHYs to avoid duplicating lots
+	  of common code.
+
+config NFC_S3FWRN82_I2C
+	tristate "Samsung S3FWRN82 I2C support"
+	depends on NFC_NCI && I2C
+	select NFC_S3FWRN82
+	default n
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
index 000000000000..7ba60ec37fe3
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
+		return  -EBUSY;
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
+int s3fwrn82_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
+	const struct s3fwrn82_phy_ops *phy_ops)
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
+	info->ndev = nci_allocate_device(&s3fwrn82_nci_ops,
+		S3FWRN82_NFC_PROTOCOLS, 0, 0);
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
+int s3fwrn82_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
+	enum s3fwrn82_mode mode)
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
index 000000000000..26e60b76e6ca
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/i2c.c
@@ -0,0 +1,281 @@
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
+	if (wake == true)
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
+		msleep(S3FWRN82_EN_WAIT_TIME/2);
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
+	if (!gpio_is_valid(phy->gpio_en)) {
+		return -ENODEV;
+	}
+
+	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_fw_wake)) {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int s3fwrn82_i2c_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
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
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
+		GPIOF_OUT_INIT_HIGH, "s3fwrn82_en");
+	if (ret < 0)
+		return ret;
+
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw_wake,
+		GPIOF_OUT_INIT_LOW, "s3fwrn82_fw_wake");
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn82_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
+	if (ret < 0)
+		return ret;
+
+	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
+		s3fwrn82_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+		S3FWRN82_I2C_DRIVER_NAME, phy);
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
index 000000000000..5be6e08e04e2
--- /dev/null
+++ b/drivers/nfc/s3fwrn82/s3fwrn82.h
@@ -0,0 +1,82 @@
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
+	struct mutex mutex;
+};
+
+static inline int s3fwrn82_set_mode(struct s3fwrn82_info *info,
+	enum s3fwrn82_mode mode)
+{
+	if (!info->phy_ops->set_mode)
+		return -ENOTSUPP;
+
+	info->phy_ops->set_mode(info->phy_id, mode);
+
+	return 0;
+}
+
+static inline enum s3fwrn82_mode s3fwrn82_get_mode(struct s3fwrn82_info *info)
+{
+	if (!info->phy_ops->get_mode)
+		return -ENOTSUPP;
+
+	return info->phy_ops->get_mode(info->phy_id);
+}
+
+static inline int s3fwrn82_set_wake(struct s3fwrn82_info *info, bool wake)
+{
+	if (!info->phy_ops->set_wake)
+		return -ENOTSUPP;
+
+	info->phy_ops->set_wake(info->phy_id, wake);
+
+	return 0;
+}
+
+static inline int s3fwrn82_write(struct s3fwrn82_info *info, struct sk_buff *skb)
+{
+	if (!info->phy_ops->write)
+		return -ENOTSUPP;
+
+	return info->phy_ops->write(info->phy_id, skb);
+}
+
+int s3fwrn82_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
+	const struct s3fwrn82_phy_ops *phy_ops);
+void s3fwrn82_remove(struct nci_dev *ndev);
+
+int s3fwrn82_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
+	enum s3fwrn82_mode mode);
+
+#endif /* __LOCAL_S3FWRN82_H_ */
-- 
