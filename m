Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146583DA375
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhG2My6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:54:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:22062 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbhG2Myn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 08:54:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627563279; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=w7LjC7HqdOoOn/G3xC2Jafj8ce9vj4IqWkq+cBr0cto=; b=CC2e2Oh3WvGoYQ0X2xxBPoC85v4UUZnhCsMYVMk1xLD2Sne4pbjtlNizwiXjra+wDDg0+gwx
 4tP8z7XDqixcXC5HzydjcYaC+vyeKUfWMNmf6ePYylpDOQDEODoK04NOU4aGfZB7bbYR/4EV
 FecNzky2D+TSA+69QxP64BR6CPI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6102a50717c2b4047d44a6d2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 29 Jul 2021 12:54:31
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C678AC433D3; Thu, 29 Jul 2021 12:54:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F94FC433F1;
        Thu, 29 Jul 2021 12:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F94FC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH 2/3] net: mdio-ipq4019: rename mdio_ipq4019 to mdio_ipq
Date:   Thu, 29 Jul 2021 20:53:57 +0800
Message-Id: <20210729125358.5227-2-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210729125358.5227-1-luoj@codeaurora.org>
References: <20210729125358.5227-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio_ipq driver supports more SOCs such as ipq40xx, ipq807x,
ipq60xx and ipq50xx.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/mdio/Kconfig                      |  6 +-
 drivers/net/mdio/Makefile                     |  2 +-
 .../net/mdio/{mdio-ipq4019.c => mdio-ipq.c}   | 66 +++++++++----------
 3 files changed, 37 insertions(+), 37 deletions(-)
 rename drivers/net/mdio/{mdio-ipq4019.c => mdio-ipq.c} (81%)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 06a605ffb950..133c3d9cb083 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -166,13 +166,13 @@ config MDIO_OCTEON
 	  buses. It is required by the Octeon and ThunderX ethernet device
 	  drivers on some systems.
 
-config MDIO_IPQ4019
-	tristate "Qualcomm IPQ4019 MDIO interface support"
+config MDIO_IPQ
+	tristate "Qualcomm IPQ MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
 	depends on GPIOLIB && COMMON_CLK && RESET_CONTROLLER
 	help
 	  This driver supports the MDIO interface found in Qualcomm
-	  IPQ40xx series Soc-s.
+	  IPQ40xx, IPQ60XX, IPQ807X and IPQ50XX series Soc-s.
 
 config MDIO_IPQ8064
 	tristate "Qualcomm IPQ8064 MDIO interface support"
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 15f8dc4042ce..df7afc8462de 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_MDIO_CAVIUM)		+= mdio-cavium.o
 obj-$(CONFIG_MDIO_GPIO)			+= mdio-gpio.o
 obj-$(CONFIG_MDIO_HISI_FEMAC)		+= mdio-hisi-femac.o
 obj-$(CONFIG_MDIO_I2C)			+= mdio-i2c.o
-obj-$(CONFIG_MDIO_IPQ4019)		+= mdio-ipq4019.o
+obj-$(CONFIG_MDIO_IPQ)			+= mdio-ipq.o
 obj-$(CONFIG_MDIO_IPQ8064)		+= mdio-ipq8064.o
 obj-$(CONFIG_MDIO_MOXART)		+= mdio-moxart.o
 obj-$(CONFIG_MDIO_MSCC_MIIM)		+= mdio-mscc-miim.o
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq.c
similarity index 81%
rename from drivers/net/mdio/mdio-ipq4019.c
rename to drivers/net/mdio/mdio-ipq.c
index 01f5b9393537..70e1ae05a64f 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq.c
@@ -31,38 +31,38 @@
 /* 0 = Clause 22, 1 = Clause 45 */
 #define MDIO_MODE_C45				BIT(8)
 
-#define IPQ4019_MDIO_TIMEOUT	10000
-#define IPQ4019_MDIO_SLEEP		10
+#define IPQ_MDIO_TIMEOUT	10000
+#define IPQ_MDIO_SLEEP		10
 
 /* MDIO clock source frequency is fixed to 100M */
 #define QCA_MDIO_CLK_RATE	100000000
 
 #define QCA_PHY_SET_DELAY_US	100000
 
-struct ipq4019_mdio_data {
+struct ipq_mdio_data {
 	void __iomem	*membase;
 	void __iomem *eth_ldo_rdy;
 	struct reset_control *reset_ctrl;
 	struct clk *mdio_clk;
 };
 
-static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
+static int ipq_mdio_wait_busy(struct mii_bus *bus)
 {
-	struct ipq4019_mdio_data *priv = bus->priv;
+	struct ipq_mdio_data *priv = bus->priv;
 	unsigned int busy;
 
 	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
 				  (busy & MDIO_CMD_ACCESS_BUSY) == 0,
-				  IPQ4019_MDIO_SLEEP, IPQ4019_MDIO_TIMEOUT);
+				  IPQ_MDIO_SLEEP, IPQ_MDIO_TIMEOUT);
 }
 
-static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+static int ipq_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
-	struct ipq4019_mdio_data *priv = bus->priv;
+	struct ipq_mdio_data *priv = bus->priv;
 	unsigned int data;
 	unsigned int cmd;
 
-	if (ipq4019_mdio_wait_busy(bus))
+	if (ipq_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
 	/* Clause 45 support */
@@ -102,7 +102,7 @@ static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	writel(cmd, priv->membase + MDIO_CMD_REG);
 
 	/* Wait read complete */
-	if (ipq4019_mdio_wait_busy(bus))
+	if (ipq_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
 	if (regnum & MII_ADDR_C45) {
@@ -110,7 +110,7 @@ static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 
 		writel(cmd, priv->membase + MDIO_CMD_REG);
 
-		if (ipq4019_mdio_wait_busy(bus))
+		if (ipq_mdio_wait_busy(bus))
 			return -ETIMEDOUT;
 	}
 
@@ -118,14 +118,13 @@ static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	return readl(priv->membase + MDIO_DATA_READ_REG);
 }
 
-static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
-							 u16 value)
+static int ipq_mdio_write(struct mii_bus *bus, int mii_id, int regnum, u16 value)
 {
-	struct ipq4019_mdio_data *priv = bus->priv;
+	struct ipq_mdio_data *priv = bus->priv;
 	unsigned int data;
 	unsigned int cmd;
 
-	if (ipq4019_mdio_wait_busy(bus))
+	if (ipq_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
 	/* Clause 45 support */
@@ -150,7 +149,7 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 
 		writel(cmd, priv->membase + MDIO_CMD_REG);
 
-		if (ipq4019_mdio_wait_busy(bus))
+		if (ipq_mdio_wait_busy(bus))
 			return -ETIMEDOUT;
 	} else {
 		/* Enter Clause 22 mode */
@@ -176,7 +175,7 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	writel(cmd, priv->membase + MDIO_CMD_REG);
 
 	/* Wait write complete */
-	if (ipq4019_mdio_wait_busy(bus))
+	if (ipq_mdio_wait_busy(bus))
 		return -ETIMEDOUT;
 
 	return 0;
@@ -184,7 +183,7 @@ static int ipq4019_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 
 static int ipq_mdio_reset(struct mii_bus *bus)
 {
-	struct ipq4019_mdio_data *priv = bus->priv;
+	struct ipq_mdio_data *priv = bus->priv;
 	struct device *dev = bus->parent;
 	struct gpio_desc *reset_gpio;
 	u32 val;
@@ -232,9 +231,9 @@ static int ipq_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
-static int ipq4019_mdio_probe(struct platform_device *pdev)
+static int ipq_mdio_probe(struct platform_device *pdev)
 {
-	struct ipq4019_mdio_data *priv;
+	struct ipq_mdio_data *priv;
 	struct mii_bus *bus;
 	struct resource *res;
 	int ret;
@@ -257,9 +256,9 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 	priv->reset_ctrl = devm_reset_control_get_exclusive(&pdev->dev, "gephy_mdc_rst");
 	priv->mdio_clk = devm_clk_get(&pdev->dev, "gcc_mdio_ahb_clk");
 
-	bus->name = "ipq4019_mdio";
-	bus->read = ipq4019_mdio_read;
-	bus->write = ipq4019_mdio_write;
+	bus->name = "ipq_mdio";
+	bus->read = ipq_mdio_read;
+	bus->write = ipq_mdio_write;
 	bus->reset = ipq_mdio_reset;
 	bus->parent = &pdev->dev;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
@@ -275,7 +274,7 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ipq4019_mdio_remove(struct platform_device *pdev)
+static int ipq_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
 
@@ -284,23 +283,24 @@ static int ipq4019_mdio_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id ipq4019_mdio_dt_ids[] = {
+static const struct of_device_id ipq_mdio_dt_ids[] = {
 	{ .compatible = "qcom,ipq4019-mdio" },
+	{ .compatible = "qcom,ipq-mdio" },
 	{ }
 };
-MODULE_DEVICE_TABLE(of, ipq4019_mdio_dt_ids);
+MODULE_DEVICE_TABLE(of, ipq_mdio_dt_ids);
 
-static struct platform_driver ipq4019_mdio_driver = {
-	.probe = ipq4019_mdio_probe,
-	.remove = ipq4019_mdio_remove,
+static struct platform_driver ipq_mdio_driver = {
+	.probe = ipq_mdio_probe,
+	.remove = ipq_mdio_remove,
 	.driver = {
-		.name = "ipq4019-mdio",
-		.of_match_table = ipq4019_mdio_dt_ids,
+		.name = "ipq-mdio",
+		.of_match_table = ipq_mdio_dt_ids,
 	},
 };
 
-module_platform_driver(ipq4019_mdio_driver);
+module_platform_driver(ipq_mdio_driver);
 
-MODULE_DESCRIPTION("ipq4019 MDIO interface driver");
+MODULE_DESCRIPTION("ipq MDIO interface driver");
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

