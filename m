Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D062C00F2
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgKWH5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:57:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16252 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgKWH5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:57:07 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201123075702epoutp017ee8aaf1e8a8704238b1574c5f050761~KFAORJQeg1462714627epoutp015
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 07:57:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201123075702epoutp017ee8aaf1e8a8704238b1574c5f050761~KFAORJQeg1462714627epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606118222;
        bh=h7j3pGKTr+iZaSuLe5ARKR58MH3db2jp2Hf76uc6KoY=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=UV3HtczWGUixWaD4nGLUkC2wgxMh1BnxBe23uHW6g2/coEo2l/QvH3bL3dkaQvUQQ
         THVKVSn5KizD75SOG5P/ioxFATcwjH/0Qd+OvmX40MTzkedg5zJShDeEc6JzX2gdKb
         ZhO05IpUivfK7e3CE6rGoguRlgJVA+029cGbbNPc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201123075702epcas2p477d559fb81fcb32a54f6d496588d20eb~KFAN3giLa0709607096epcas2p4r;
        Mon, 23 Nov 2020 07:57:02 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Cffcr2GXlzMqYl8; Mon, 23 Nov
        2020 07:57:00 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-1f-5fbb6b4af633
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.36.10621.A4B6BBF5; Mon, 23 Nov 2020 16:56:58 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 2/2] net: nfc: s3fwrn5: Support a UART interface
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "krzk@kernel.org" <krzk@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
Date:   Mon, 23 Nov 2020 16:56:58 +0900
X-CMS-MailID: 20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsWy7bCmqa5X9u54g3WT+C3On9/AbnFhWx+r
        xeVdc9gs5mzYzG5xbIGYA6vHplWdbB7ds/+xeHzeJBfAHJVjk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJNxu2E+c8E8+4qvX74yNzBuNeli
        5OSQEDCRmDx/LnsXIxeHkMAORoml7z4zdjFycPAKCEr83SEMYgoLeEqcPyUNUi4koCjxv+Mc
        G4gtLKAr8eLvUTCbTUBbYu3RRiYQW0TAR2LhjgVMICOZBVYzSkycs4oVYhevxIz2pywQtrTE
        9uVbGSFsDYkfy3qZIWxRiZur37LD2O+PzYeqEZFovXcWqkZQ4sHP3VBxSYm3++aB3S8h0M4o
        cf7nDzYIZwajxKnNf6E69CUWn1sBdh6vgK/E2T1LwDawCKhKfF29iQmixkXi0/QTYNcxC8hL
        bH87hxnke2YBTYn1u/RBTAkBZYkjt6Aq+CQ6Dv9lh/lrx7wnUFNUJXqbvzDB/Dh5dgvUnR4S
        v1cuZ4EEYqDE1L4uxgmMCrMQIT0Lyd5ZCHsXMDKvYhRLLSjOTU8tNiowRI7cTYzg1KfluoNx
        8tsPeocYmTgYDzFKcDArifC2yu2MF+JNSaysSi3Kjy8qzUktPsRoCvTxRGYp0eR8YPLNK4k3
        NDUyMzOwNLUwNTOyUBLnDV3ZFy8kkJ5YkpqdmlqQWgTTx8TBKdXA1CKQ9p3n/fElLlk/Mv+Y
        iKc2XtnPEOWT9oCtZxpX11Mla/m9bX77ui4pLde5rVgzp18/74mtu8nWFxNaZ+y/pZ7Sv/DR
        r/RIka/qcctYrk3/L3b21exwkce/FqUcOBou38Ny3UM6+07Sh8+JOTzLyl9s3vj8wbrMtpeR
        d7TnHpGcptB65d3lCdZZe+9cF5tdr7lN54pSgs9BN7MrN46f/SZ+61D8naV7OIQWaD1uOWQX
        q7lg2+m1z5l2Tp67KvqR8UypuAs8K6RDri49rqnVZ7bTWNohznV6bfeLuws+rTz0pjoqcda0
        5HnxjKbsc8qLalkY0pYwB/F9WP/M86mRTvYONrFSoXsv+u9KHbznqazEUpyRaKjFXFScCABV
        Yf00BgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93
References: <CGME20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since S3FWRN82 NFC Chip, The UART interface can be used.
S3FWRN82 uses NCI protocol and supports I2C and UART interface.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/Kconfig  |  12 ++
 drivers/nfc/s3fwrn5/Makefile |   2 +
 drivers/nfc/s3fwrn5/uart.c   | 250 +++++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+)
 create mode 100644 drivers/nfc/s3fwrn5/uart.c

diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
index 3f8b6da58280..6f88737769e1 100644
--- a/drivers/nfc/s3fwrn5/Kconfig
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -20,3 +20,15 @@ config NFC_S3FWRN5_I2C
 	  To compile this driver as a module, choose m here. The module will
 	  be called s3fwrn5_i2c.ko.
 	  Say N if unsure.
+
+config NFC_S3FWRN82_UART
+	tristate "Samsung S3FWRN82 UART support"
+	depends on NFC_NCI && SERIAL_DEV_BUS
+	select NFC_S3FWRN5
+	help
+	  This module adds support for a UART interface to the S3FWRN82 chip.
+	  Select this if your platform is using the UART bus.
+
+	  To compile this driver as a module, choose m here. The module will
+	  be called s3fwrn82_uart.ko.
+	  Say N if unsure.
diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
index d0ffa35f50e8..d1902102060b 100644
--- a/drivers/nfc/s3fwrn5/Makefile
+++ b/drivers/nfc/s3fwrn5/Makefile
@@ -5,6 +5,8 @@
 
 s3fwrn5-objs = core.o firmware.o nci.o
 s3fwrn5_i2c-objs = i2c.o
+s3fwrn82_uart-objs = uart.o
 
 obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
 obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
+obj-$(CONFIG_NFC_S3FWRN82_UART) += s3fwrn82_uart.o
diff --git a/drivers/nfc/s3fwrn5/uart.c b/drivers/nfc/s3fwrn5/uart.c
new file mode 100644
index 000000000000..b3c36a5b28d3
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/uart.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * UART Link Layer for S3FWRN82 NCI based Driver
+ *
+ * Copyright (C) 2020 Samsung Electronics
+ * Author: Bongsu Jeon <bongsu.jeon@samsung.com>
+ * All rights reserved.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nfc.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/serdev.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+
+#include "s3fwrn5.h"
+
+#define S3FWRN82_UART_DRIVER_NAME "s3fwrn82_uart"
+#define S3FWRN82_NCI_HEADER 3
+#define S3FWRN82_NCI_IDX 2
+#define S3FWRN82_EN_WAIT_TIME 20
+#define NCI_SKB_BUFF_LEN 258
+
+struct s3fwrn82_uart_phy {
+	struct serdev_device *ser_dev;
+	struct nci_dev *ndev;
+	struct sk_buff *recv_skb;
+
+	unsigned int gpio_en;
+	unsigned int gpio_fw_wake;
+
+	/* mutex is used to synchronize */
+	struct mutex mutex;
+	enum s3fwrn5_mode mode;
+};
+
+static void s3fwrn82_uart_set_wake(void *phy_id, bool wake)
+{
+	struct s3fwrn82_uart_phy *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+	gpio_set_value(phy->gpio_fw_wake, wake);
+	msleep(S3FWRN82_EN_WAIT_TIME);
+	mutex_unlock(&phy->mutex);
+}
+
+static void s3fwrn82_uart_set_mode(void *phy_id, enum s3fwrn5_mode mode)
+{
+	struct s3fwrn82_uart_phy *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+	if (phy->mode == mode)
+		goto out;
+	phy->mode = mode;
+	gpio_set_value(phy->gpio_en, 1);
+	gpio_set_value(phy->gpio_fw_wake, 0);
+	if (mode == S3FWRN5_MODE_FW)
+		gpio_set_value(phy->gpio_fw_wake, 1);
+	if (mode != S3FWRN5_MODE_COLD) {
+		msleep(S3FWRN82_EN_WAIT_TIME);
+		gpio_set_value(phy->gpio_en, 0);
+		msleep(S3FWRN82_EN_WAIT_TIME);
+	}
+out:
+	mutex_unlock(&phy->mutex);
+}
+
+static enum s3fwrn5_mode s3fwrn82_uart_get_mode(void *phy_id)
+{
+	struct s3fwrn82_uart_phy *phy = phy_id;
+	enum s3fwrn5_mode mode;
+
+	mutex_lock(&phy->mutex);
+	mode = phy->mode;
+	mutex_unlock(&phy->mutex);
+	return mode;
+}
+
+static int s3fwrn82_uart_write(void *phy_id, struct sk_buff *out)
+{
+	struct s3fwrn82_uart_phy *phy = phy_id;
+	int err;
+
+	err = serdev_device_write(phy->ser_dev,
+				  out->data, out->len,
+				  MAX_SCHEDULE_TIMEOUT);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static const struct s3fwrn5_phy_ops uart_phy_ops = {
+	.set_wake = s3fwrn82_uart_set_wake,
+	.set_mode = s3fwrn82_uart_set_mode,
+	.get_mode = s3fwrn82_uart_get_mode,
+	.write = s3fwrn82_uart_write,
+};
+
+static int s3fwrn82_uart_read(struct serdev_device *serdev,
+			      const unsigned char *data,
+			      size_t count)
+{
+	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
+	size_t i;
+
+	for (i = 0; i < count; i++) {
+		skb_put_u8(phy->recv_skb, *data++);
+
+		if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
+			continue;
+
+		if ((phy->recv_skb->len - S3FWRN82_NCI_HEADER)
+				< phy->recv_skb->data[S3FWRN82_NCI_IDX])
+			continue;
+
+		s3fwrn5_recv_frame(phy->ndev, phy->recv_skb, phy->mode);
+		phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
+		if (!phy->recv_skb)
+			return 0;
+	}
+
+	return i;
+}
+
+static struct serdev_device_ops s3fwrn82_serdev_ops = {
+	.receive_buf = s3fwrn82_uart_read,
+	.write_wakeup = serdev_device_write_wakeup,
+};
+
+static const struct of_device_id s3fwrn82_uart_of_match[] = {
+	{ .compatible = "samsung,s3fwrn82-uart", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, s3fwrn82_uart_of_match);
+
+static int s3fwrn82_uart_parse_dt(struct serdev_device *serdev)
+{
+	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
+	struct device_node *np = serdev->dev.of_node;
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
+static int s3fwrn82_uart_probe(struct serdev_device *serdev)
+{
+	struct s3fwrn82_uart_phy *phy;
+	int ret = -ENOMEM;
+
+	phy = devm_kzalloc(&serdev->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		goto err_exit;
+
+	phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
+	if (!phy->recv_skb)
+		goto err_free;
+
+	mutex_init(&phy->mutex);
+	phy->mode = S3FWRN5_MODE_COLD;
+
+	phy->ser_dev = serdev;
+	serdev_device_set_drvdata(serdev, phy);
+	serdev_device_set_client_ops(serdev, &s3fwrn82_serdev_ops);
+	ret = serdev_device_open(serdev);
+	if (ret) {
+		dev_err(&serdev->dev, "Unable to open device\n");
+		goto err_skb;
+	}
+
+	ret = serdev_device_set_baudrate(serdev, 115200);
+	if (ret != 115200) {
+		ret = -EINVAL;
+		goto err_serdev;
+	}
+
+	serdev_device_set_flow_control(serdev, false);
+
+	ret = s3fwrn82_uart_parse_dt(serdev);
+	if (ret < 0)
+		goto err_serdev;
+
+	ret = devm_gpio_request_one(&phy->ser_dev->dev,
+				    phy->gpio_en,
+				    GPIOF_OUT_INIT_HIGH,
+				    "s3fwrn82_en");
+	if (ret < 0)
+		goto err_serdev;
+
+	ret = devm_gpio_request_one(&phy->ser_dev->dev,
+				    phy->gpio_fw_wake,
+				    GPIOF_OUT_INIT_LOW,
+				    "s3fwrn82_fw_wake");
+	if (ret < 0)
+		goto err_serdev;
+
+	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->ser_dev->dev, &uart_phy_ops);
+	if (ret < 0)
+		goto err_serdev;
+
+	return ret;
+
+err_serdev:
+	serdev_device_close(serdev);
+err_skb:
+	kfree_skb(phy->recv_skb);
+err_free:
+	kfree(phy);
+err_exit:
+	return ret;
+}
+
+static void s3fwrn82_uart_remove(struct serdev_device *serdev)
+{
+	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
+
+	s3fwrn5_remove(phy->ndev);
+	serdev_device_close(serdev);
+	kfree_skb(phy->recv_skb);
+	kfree(phy);
+}
+
+static struct serdev_device_driver s3fwrn82_uart_driver = {
+	.probe = s3fwrn82_uart_probe,
+	.remove = s3fwrn82_uart_remove,
+	.driver = {
+		.name = S3FWRN82_UART_DRIVER_NAME,
+		.of_match_table = of_match_ptr(s3fwrn82_uart_of_match),
+	},
+};
+
+module_serdev_device_driver(s3fwrn82_uart_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("UART driver for Samsung NFC");
+MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");
-- 
2.17.1

