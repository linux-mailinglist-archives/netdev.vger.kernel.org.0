Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8FF3C10E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 03:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbfFKBrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 21:47:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45578 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389168AbfFKBrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 21:47:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi6so3972452plb.12;
        Mon, 10 Jun 2019 18:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qOCIU3pHa11BqOJDtitDLMSpV7CivUt4w35JumdU44Y=;
        b=R6RPO+gE+uX5TF5LhDxVY5ZDiVGdrcGD+Sxt9aP5PRDD0Cp7/NAMs+60HI7C6V7xSY
         1HktGeGQ1rFOGPx6it9C5yY/PqTtS0F04igI7VFUm5s9dV43TIDeG6JnrUfeWV3Yym00
         /G5T/3UJWvAGWQ5BWMx5rozumy1O5nSmXvHZHyZkUy5l8nfsD3QXl0dyTnJsBE+2OdLo
         pWblyJJoGnugsBRKdgFtaZ9f5Rl0+BbQUE4jxeHla2+t4qjkwibAIZcy5w5urKJAC9qH
         qQrLImIyQ2oJFaCicpBAqu+URr1ljwrKHV5zOOyi7bBFJrEpYuX6qVsqm1s2ohjrZ0Eb
         ESZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qOCIU3pHa11BqOJDtitDLMSpV7CivUt4w35JumdU44Y=;
        b=kbmZSBa6tZFtilzzdQYLt83e1WDgeJkq/CzWxVNePqwJWgbkMiptsYDVWh9NIhSwIt
         bqgwXzWSfKEAnNj/n8M/1wVEEUXuHYc6Vca4TD/Uzb1NYdRByndTF16ia15sZghMMSJF
         5SQyl9FlvYPLg1oGOv1yfP4eniWuoDrJjfkk/A+KHySHKNA5mAUTq1jXb5Vy2XHDmpV8
         K3iaB6iM/S/o8firX+bukBeCIwCsPB1eK8MIAxoHxAzxOkpR03fIldY3bkB35440dw4J
         IriZnrotsb5FaoRwIsDlySvjwfnBoSzfgwfi7vYd76oH6ajWILwkONEDSooztFgHwOXw
         OkRg==
X-Gm-Message-State: APjAAAX3pw9clxMfQUpl8viFXvER2d9x+WJTzq265uoFlYk/ztAzw2BJ
        8dZDG7v7gahYXmlMJBpmRRsJbobV
X-Google-Smtp-Source: APXvYqw5752JBG1RixqczI/Qo3INRzvN+TIpDT2dhGwRws0z49akmIOd/09FfK+0vcoTCAHZXLDnYA==
X-Received: by 2002:a17:902:8a87:: with SMTP id p7mr56606620plo.124.1560217661651;
        Mon, 10 Jun 2019 18:47:41 -0700 (PDT)
Received: from localhost (59-120-186-245.HINET-IP.hinet.net. [59.120.186.245])
        by smtp.gmail.com with ESMTPSA id s12sm666288pjp.10.2019.06.10.18.47.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 18:47:40 -0700 (PDT)
From:   "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
X-Google-Original-From: "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     davem@davemloft.net, f.suligoi@asem.it,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, peter_hong@fintek.com.tw,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
Subject: [RESEND PATCH V1] can: sja1000: f81601: add Fintek F81601 support
Date:   Tue, 11 Jun 2019 09:47:32 +0800
Message-Id: <1560217652-19834-1-git-send-email-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for Fintek PCIE to 2 CAN controller support

Signed-off-by: Ji-Ze Hong (Peter Hong) <hpeter+linux_kernel@gmail.com>
---
 drivers/net/can/sja1000/Kconfig  |   8 ++
 drivers/net/can/sja1000/Makefile |   1 +
 drivers/net/can/sja1000/f81601.c | 223 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+)
 create mode 100644 drivers/net/can/sja1000/f81601.c

diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index f6dc89927ece..8588323c5138 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -101,4 +101,12 @@ config CAN_TSCAN1
 	  IRQ numbers are read from jumpers JP4 and JP5,
 	  SJA1000 IO base addresses are chosen heuristically (first that works).
 
+config CAN_F81601
+	tristate "Fintek F81601 PCIE to 2 CAN Controller"
+	depends on PCI
+	help
+	  This driver adds support for Fintek F81601 PCIE to 2 CAN Controller.
+	  It had internal 24MHz clock source, but it can be changed by
+	  manufacturer. We can use modinfo to get usage for parameters.
+	  Visit http://www.fintek.com.tw to get more information.
 endif
diff --git a/drivers/net/can/sja1000/Makefile b/drivers/net/can/sja1000/Makefile
index 9253aaf9e739..6f6268543bd9 100644
--- a/drivers/net/can/sja1000/Makefile
+++ b/drivers/net/can/sja1000/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_CAN_PEAK_PCMCIA) += peak_pcmcia.o
 obj-$(CONFIG_CAN_PEAK_PCI) += peak_pci.o
 obj-$(CONFIG_CAN_PLX_PCI) += plx_pci.o
 obj-$(CONFIG_CAN_TSCAN1) += tscan1.o
+obj-$(CONFIG_CAN_F81601) += f81601.o
diff --git a/drivers/net/can/sja1000/f81601.c b/drivers/net/can/sja1000/f81601.c
new file mode 100644
index 000000000000..1578bb837aaf
--- /dev/null
+++ b/drivers/net/can/sja1000/f81601.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Fintek F81601 PCIE to 2 CAN controller driver
+ *
+ * Copyright (C) 2019 Peter Hong <peter_hong@fintek.com.tw>
+ * Copyright (C) 2019 Linux Foundation
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/netdevice.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/can/dev.h>
+#include <linux/io.h>
+#include <linux/version.h>
+
+#include "sja1000.h"
+
+#define F81601_PCI_MAX_CHAN		2
+
+#define F81601_DECODE_REG		0x209
+#define F81601_IO_MODE			BIT(7)
+#define F81601_MEM_MODE			BIT(6)
+#define F81601_CFG_MODE			BIT(5)
+#define F81601_CAN2_INTERNAL_CLK	BIT(3)
+#define F81601_CAN1_INTERNAL_CLK	BIT(2)
+#define F81601_CAN2_EN			BIT(1)
+#define F81601_CAN1_EN			BIT(0)
+
+#define F81601_TRAP_REG			0x20a
+#define F81601_CAN2_HAS_EN		BIT(4)
+
+struct f81601_pci_card {
+	int channels;			/* detected channels count */
+	void __iomem *addr;
+	spinlock_t lock;		/* for access mem io */
+	struct pci_dev *dev;
+	struct net_device *net_dev[F81601_PCI_MAX_CHAN];
+};
+
+static const struct pci_device_id f81601_pci_tbl[] = {
+	{ PCI_DEVICE(0x1c29, 0x1703) },
+	{},
+};
+
+MODULE_DEVICE_TABLE(pci, f81601_pci_tbl);
+
+static bool internal_clk = 1;
+module_param(internal_clk, bool, 0444);
+MODULE_PARM_DESC(internal_clk, "Use internal clock, default 1 (24MHz)");
+
+static unsigned int external_clk;
+module_param(external_clk, uint, 0444);
+MODULE_PARM_DESC(external_clk, "External Clock, must spec when internal_clk = 0");
+
+static u8 f81601_pci_read_reg(const struct sja1000_priv *priv, int port)
+{
+	return readb(priv->reg_base + port);
+}
+
+static void f81601_pci_write_reg(const struct sja1000_priv *priv, int port,
+				 u8 val)
+{
+	struct f81601_pci_card *card = priv->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+	writeb(val, priv->reg_base + port);
+	readb(priv->reg_base);
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
+static void f81601_pci_del_card(struct pci_dev *pdev)
+{
+	struct f81601_pci_card *card = pci_get_drvdata(pdev);
+	struct net_device *dev;
+	int i = 0;
+
+	for (i = 0; i < F81601_PCI_MAX_CHAN; i++) {
+		dev = card->net_dev[i];
+		if (!dev)
+			continue;
+
+		dev_info(&pdev->dev, "%s: Removing %s\n", __func__, dev->name);
+
+		unregister_sja1000dev(dev);
+		free_sja1000dev(dev);
+	}
+
+	pcim_iounmap(pdev, card->addr);
+}
+
+/* Probe F81601 based device for the SJA1000 chips and register each
+ * available CAN channel to SJA1000 Socket-CAN subsystem.
+ */
+static int f81601_pci_add_card(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	struct sja1000_priv *priv;
+	struct net_device *dev;
+	struct f81601_pci_card *card;
+	int err, i;
+	u8 tmp;
+
+	if (pcim_enable_device(pdev) < 0) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		return -ENODEV;
+	}
+
+	dev_info(&pdev->dev, "Detected card at slot #%i\n",
+		 PCI_SLOT(pdev->devfn));
+
+	card = devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
+	if (!card)
+		return -ENOMEM;
+
+	card->channels = 0;
+	card->dev = pdev;
+	spin_lock_init(&card->lock);
+
+	pci_set_drvdata(pdev, card);
+
+	tmp = F81601_IO_MODE | F81601_MEM_MODE | F81601_CFG_MODE |
+			F81601_CAN2_EN | F81601_CAN1_EN;
+
+	if (internal_clk) {
+		tmp |= F81601_CAN2_INTERNAL_CLK | F81601_CAN1_INTERNAL_CLK;
+
+		dev_info(&pdev->dev,
+			 "F81601 running with internal clock: 24Mhz\n");
+	} else {
+		dev_info(&pdev->dev,
+			 "F81601 running with external clock: %dMhz\n",
+			 external_clk / 1000000);
+	}
+
+	pci_write_config_byte(pdev, F81601_DECODE_REG, tmp);
+
+	card->addr = pcim_iomap(pdev, 0, pci_resource_len(pdev, 0));
+
+	if (!card->addr) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "%s: Failed to remap BAR\n", __func__);
+		goto failure_cleanup;
+	}
+
+	/* Detect available channels */
+	for (i = 0; i < F81601_PCI_MAX_CHAN; i++) {
+		/* read CAN2_HW_EN strap pin */
+		pci_read_config_byte(pdev, F81601_TRAP_REG, &tmp);
+		if (i == 1 && !(tmp & F81601_CAN2_HAS_EN))
+			break;
+
+		dev = alloc_sja1000dev(0);
+		if (!dev) {
+			err = -ENOMEM;
+			goto failure_cleanup;
+		}
+
+		card->net_dev[i] = dev;
+		dev->irq = pdev->irq;
+
+		priv = netdev_priv(dev);
+		priv->priv = card;
+		priv->irq_flags = IRQF_SHARED;
+		priv->reg_base = card->addr + 0x80 * i;
+		priv->read_reg = f81601_pci_read_reg;
+		priv->write_reg = f81601_pci_write_reg;
+
+		if (internal_clk)
+			priv->can.clock.freq = 24000000 / 2;
+		else
+			priv->can.clock.freq = external_clk / 2;
+
+		priv->ocr = OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL;
+		priv->cdr = CDR_CBP;
+
+		SET_NETDEV_DEV(dev, &pdev->dev);
+		dev->dev_id = i;
+
+		/* Register SJA1000 device */
+		err = register_sja1000dev(dev);
+		if (err) {
+			dev_err(&pdev->dev,
+				"%s: Registering device failed: %x\n", __func__,
+				err);
+			goto failure_cleanup;
+		}
+
+		card->channels++;
+
+		dev_info(&pdev->dev, "Channel #%d, %s at 0x%p, irq %d\n", i,
+			 dev->name, priv->reg_base, dev->irq);
+	}
+
+	if (!card->channels) {
+		err = -ENODEV;
+		goto failure_cleanup;
+	}
+
+	return 0;
+
+failure_cleanup:
+	dev_err(&pdev->dev, "%s: failed: %d. Cleaning Up.\n", __func__, err);
+	f81601_pci_del_card(pdev);
+
+	return err;
+}
+
+static struct pci_driver f81601_pci_driver = {
+	.name =		"f81601",
+	.id_table =	f81601_pci_tbl,
+	.probe =	f81601_pci_add_card,
+	.remove =	f81601_pci_del_card,
+};
+
+MODULE_DESCRIPTION("Fintek F81601 PCIE to 2 CANBUS adaptor driver");
+MODULE_AUTHOR("Peter Hong <peter_hong@fintek.com.tw>");
+MODULE_LICENSE("GPL v2");
+
+module_pci_driver(f81601_pci_driver);
-- 
2.7.4

