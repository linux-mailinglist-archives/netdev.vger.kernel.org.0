Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB1484CC4
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiAEDPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiAEDPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:15:52 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF7DC061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:15:52 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id hu2so826235qvb.8
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w59HMd28fzQXaKtZtjsBxZJS/NZhuI4Mn4bloFd5V/0=;
        b=CC/0Uf8V8SxErOGKvo4YNlPjNoyHAWeJBYasUJ+iEK2JZywUxCCxcLKkFxvZjFdF+9
         Hjgyd+zl/Zub2aUNtMjMxBL/go9Ur60frLUkb6qBEqiyWVkHo1AKSyOMYC5wN7D5jMy8
         xNZlArU3GFKXBhfu9EXxn6M7g2VSL7osQHS81mVwCxSRTMKLvD58SkfCFwmRsIHbe11k
         QxjtoQ4JAzZRxfgK2rDHr1UnG8RiPqhdcVDvm7go33ExVzflP3E7LiTkoVBg+Eg5OrFw
         ic8nqIWYR3UgsEqdjG/udBPBWhV0T3BNGDckLeop5k+YK0yxp4LHqNQBbVq7qyURDaZC
         SUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w59HMd28fzQXaKtZtjsBxZJS/NZhuI4Mn4bloFd5V/0=;
        b=A4WvmER8cE3Y8Wix9qDplMA5QfxHMCg4ncnlEU5hzPSGsMhzAKYCu/c077kXoqf0yW
         aTqFYI9cXdolNeSeRuoq836KwOHVSXCFfW2SHTjitesz3Z0AqUupbFLS3tdDKRFKcLZV
         2Z3T4uCC+fWhNI6MH7ugIYR3yUxwtTCBosr2BEUjz10JMRXpy5Y8ixyDeCpUiITd0a1P
         SA6/H90i00uYrju2ga5L5yCaKbP+3vnZNsNpK4KKwPxweQb6WJ4/A8Nkpj96BLPQOhRr
         oM43AwyDvQdUgk5X+kFPaoJlz76kHz//g8AmSGQTazaMxaC6lNS12bfmDHD824qBiWEm
         veVg==
X-Gm-Message-State: AOAM5336i6extOgeEjO9JHkzHFMZh9PupYaKrLDgfSrLejHIvkOApb+9
        omnLeb6Wook3Z6SMGSegJX2mXewJIOqGOkE4
X-Google-Smtp-Source: ABdhPJyAU21BsuJyhGc0XpNdn6OA2f2CaFzbog5to+yCxU5wX0e/9g5MoHWm++jQFCFNSqpjdbThAg==
X-Received: by 2002:a05:6214:21e8:: with SMTP id p8mr48682013qvj.99.1641352549516;
        Tue, 04 Jan 2022 19:15:49 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:15:48 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 02/11] net: dsa: realtek: rename realtek_smi to realtek_priv
Date:   Wed,  5 Jan 2022 00:15:06 -0300
Message-Id: <20220105031515.29276-3-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to adding other interfaces, the private data structure
was renamed to priv. Also, realtek_smi_variant and realtek_smi_ops
were renamed to realtek_variant and realtek_ops as those structs are
not SMI specific.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi-core.c    | 316 +++++++-------
 .../realtek/{realtek-smi-core.h => realtek.h} |  68 +--
 drivers/net/dsa/realtek/rtl8365mb.c           | 394 ++++++++---------
 drivers/net/dsa/realtek/rtl8366.c             | 164 +++----
 drivers/net/dsa/realtek/rtl8366rb.c           | 402 +++++++++---------
 5 files changed, 672 insertions(+), 672 deletions(-)
 rename drivers/net/dsa/realtek/{realtek-smi-core.h => realtek.h} (57%)

diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
index aae46ada8d83..7dfd86a99c24 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi-core.c
@@ -40,105 +40,105 @@
 #include <linux/bitops.h>
 #include <linux/if_bridge.h>
 
-#include "realtek-smi-core.h"
+#include "realtek.h"
 
 #define REALTEK_SMI_ACK_RETRY_COUNT		5
 #define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
 #define REALTEK_SMI_HW_START_DELAY		100	/* msecs */
 
-static inline void realtek_smi_clk_delay(struct realtek_smi *smi)
+static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
 {
-	ndelay(smi->clk_delay);
+	ndelay(priv->clk_delay);
 }
 
-static void realtek_smi_start(struct realtek_smi *smi)
+static void realtek_smi_start(struct realtek_priv *priv)
 {
 	/* Set GPIO pins to output mode, with initial state:
 	 * SCK = 0, SDA = 1
 	 */
-	gpiod_direction_output(smi->mdc, 0);
-	gpiod_direction_output(smi->mdio, 1);
-	realtek_smi_clk_delay(smi);
+	gpiod_direction_output(priv->mdc, 0);
+	gpiod_direction_output(priv->mdio, 1);
+	realtek_smi_clk_delay(priv);
 
 	/* CLK 1: 0 -> 1, 1 -> 0 */
-	gpiod_set_value(smi->mdc, 1);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 0);
-	realtek_smi_clk_delay(smi);
+	gpiod_set_value(priv->mdc, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 0);
+	realtek_smi_clk_delay(priv);
 
 	/* CLK 2: */
-	gpiod_set_value(smi->mdc, 1);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdio, 0);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 0);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdio, 1);
+	gpiod_set_value(priv->mdc, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdio, 0);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 0);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdio, 1);
 }
 
-static void realtek_smi_stop(struct realtek_smi *smi)
+static void realtek_smi_stop(struct realtek_priv *priv)
 {
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdio, 0);
-	gpiod_set_value(smi->mdc, 1);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdio, 1);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 1);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 0);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdio, 0);
+	gpiod_set_value(priv->mdc, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdio, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 0);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 1);
 
 	/* Add a click */
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 0);
-	realtek_smi_clk_delay(smi);
-	gpiod_set_value(smi->mdc, 1);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 0);
+	realtek_smi_clk_delay(priv);
+	gpiod_set_value(priv->mdc, 1);
 
 	/* Set GPIO pins to input mode */
-	gpiod_direction_input(smi->mdio);
-	gpiod_direction_input(smi->mdc);
+	gpiod_direction_input(priv->mdio);
+	gpiod_direction_input(priv->mdc);
 }
 
-static void realtek_smi_write_bits(struct realtek_smi *smi, u32 data, u32 len)
+static void realtek_smi_write_bits(struct realtek_priv *priv, u32 data, u32 len)
 {
 	for (; len > 0; len--) {
-		realtek_smi_clk_delay(smi);
+		realtek_smi_clk_delay(priv);
 
 		/* Prepare data */
-		gpiod_set_value(smi->mdio, !!(data & (1 << (len - 1))));
-		realtek_smi_clk_delay(smi);
+		gpiod_set_value(priv->mdio, !!(data & (1 << (len - 1))));
+		realtek_smi_clk_delay(priv);
 
 		/* Clocking */
-		gpiod_set_value(smi->mdc, 1);
-		realtek_smi_clk_delay(smi);
-		gpiod_set_value(smi->mdc, 0);
+		gpiod_set_value(priv->mdc, 1);
+		realtek_smi_clk_delay(priv);
+		gpiod_set_value(priv->mdc, 0);
 	}
 }
 
-static void realtek_smi_read_bits(struct realtek_smi *smi, u32 len, u32 *data)
+static void realtek_smi_read_bits(struct realtek_priv *priv, u32 len, u32 *data)
 {
-	gpiod_direction_input(smi->mdio);
+	gpiod_direction_input(priv->mdio);
 
 	for (*data = 0; len > 0; len--) {
 		u32 u;
 
-		realtek_smi_clk_delay(smi);
+		realtek_smi_clk_delay(priv);
 
 		/* Clocking */
-		gpiod_set_value(smi->mdc, 1);
-		realtek_smi_clk_delay(smi);
-		u = !!gpiod_get_value(smi->mdio);
-		gpiod_set_value(smi->mdc, 0);
+		gpiod_set_value(priv->mdc, 1);
+		realtek_smi_clk_delay(priv);
+		u = !!gpiod_get_value(priv->mdio);
+		gpiod_set_value(priv->mdc, 0);
 
 		*data |= (u << (len - 1));
 	}
 
-	gpiod_direction_output(smi->mdio, 0);
+	gpiod_direction_output(priv->mdio, 0);
 }
 
-static int realtek_smi_wait_for_ack(struct realtek_smi *smi)
+static int realtek_smi_wait_for_ack(struct realtek_priv *priv)
 {
 	int retry_cnt;
 
@@ -146,12 +146,12 @@ static int realtek_smi_wait_for_ack(struct realtek_smi *smi)
 	do {
 		u32 ack;
 
-		realtek_smi_read_bits(smi, 1, &ack);
+		realtek_smi_read_bits(priv, 1, &ack);
 		if (ack == 0)
 			break;
 
 		if (++retry_cnt > REALTEK_SMI_ACK_RETRY_COUNT) {
-			dev_err(smi->dev, "ACK timeout\n");
+			dev_err(priv->dev, "ACK timeout\n");
 			return -ETIMEDOUT;
 		}
 	} while (1);
@@ -159,131 +159,131 @@ static int realtek_smi_wait_for_ack(struct realtek_smi *smi)
 	return 0;
 }
 
-static int realtek_smi_write_byte(struct realtek_smi *smi, u8 data)
+static int realtek_smi_write_byte(struct realtek_priv *priv, u8 data)
 {
-	realtek_smi_write_bits(smi, data, 8);
-	return realtek_smi_wait_for_ack(smi);
+	realtek_smi_write_bits(priv, data, 8);
+	return realtek_smi_wait_for_ack(priv);
 }
 
-static int realtek_smi_write_byte_noack(struct realtek_smi *smi, u8 data)
+static int realtek_smi_write_byte_noack(struct realtek_priv *priv, u8 data)
 {
-	realtek_smi_write_bits(smi, data, 8);
+	realtek_smi_write_bits(priv, data, 8);
 	return 0;
 }
 
-static int realtek_smi_read_byte0(struct realtek_smi *smi, u8 *data)
+static int realtek_smi_read_byte0(struct realtek_priv *priv, u8 *data)
 {
 	u32 t;
 
 	/* Read data */
-	realtek_smi_read_bits(smi, 8, &t);
+	realtek_smi_read_bits(priv, 8, &t);
 	*data = (t & 0xff);
 
 	/* Send an ACK */
-	realtek_smi_write_bits(smi, 0x00, 1);
+	realtek_smi_write_bits(priv, 0x00, 1);
 
 	return 0;
 }
 
-static int realtek_smi_read_byte1(struct realtek_smi *smi, u8 *data)
+static int realtek_smi_read_byte1(struct realtek_priv *priv, u8 *data)
 {
 	u32 t;
 
 	/* Read data */
-	realtek_smi_read_bits(smi, 8, &t);
+	realtek_smi_read_bits(priv, 8, &t);
 	*data = (t & 0xff);
 
 	/* Send an ACK */
-	realtek_smi_write_bits(smi, 0x01, 1);
+	realtek_smi_write_bits(priv, 0x01, 1);
 
 	return 0;
 }
 
-static int realtek_smi_read_reg(struct realtek_smi *smi, u32 addr, u32 *data)
+static int realtek_smi_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
 {
 	unsigned long flags;
 	u8 lo = 0;
 	u8 hi = 0;
 	int ret;
 
-	spin_lock_irqsave(&smi->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	realtek_smi_start(smi);
+	realtek_smi_start(priv);
 
 	/* Send READ command */
-	ret = realtek_smi_write_byte(smi, smi->cmd_read);
+	ret = realtek_smi_write_byte(priv, priv->cmd_read);
 	if (ret)
 		goto out;
 
 	/* Set ADDR[7:0] */
-	ret = realtek_smi_write_byte(smi, addr & 0xff);
+	ret = realtek_smi_write_byte(priv, addr & 0xff);
 	if (ret)
 		goto out;
 
 	/* Set ADDR[15:8] */
-	ret = realtek_smi_write_byte(smi, addr >> 8);
+	ret = realtek_smi_write_byte(priv, addr >> 8);
 	if (ret)
 		goto out;
 
 	/* Read DATA[7:0] */
-	realtek_smi_read_byte0(smi, &lo);
+	realtek_smi_read_byte0(priv, &lo);
 	/* Read DATA[15:8] */
-	realtek_smi_read_byte1(smi, &hi);
+	realtek_smi_read_byte1(priv, &hi);
 
 	*data = ((u32)lo) | (((u32)hi) << 8);
 
 	ret = 0;
 
  out:
-	realtek_smi_stop(smi);
-	spin_unlock_irqrestore(&smi->lock, flags);
+	realtek_smi_stop(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
 }
 
-static int realtek_smi_write_reg(struct realtek_smi *smi,
+static int realtek_smi_write_reg(struct realtek_priv *priv,
 				 u32 addr, u32 data, bool ack)
 {
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&smi->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	realtek_smi_start(smi);
+	realtek_smi_start(priv);
 
 	/* Send WRITE command */
-	ret = realtek_smi_write_byte(smi, smi->cmd_write);
+	ret = realtek_smi_write_byte(priv, priv->cmd_write);
 	if (ret)
 		goto out;
 
 	/* Set ADDR[7:0] */
-	ret = realtek_smi_write_byte(smi, addr & 0xff);
+	ret = realtek_smi_write_byte(priv, addr & 0xff);
 	if (ret)
 		goto out;
 
 	/* Set ADDR[15:8] */
-	ret = realtek_smi_write_byte(smi, addr >> 8);
+	ret = realtek_smi_write_byte(priv, addr >> 8);
 	if (ret)
 		goto out;
 
 	/* Write DATA[7:0] */
-	ret = realtek_smi_write_byte(smi, data & 0xff);
+	ret = realtek_smi_write_byte(priv, data & 0xff);
 	if (ret)
 		goto out;
 
 	/* Write DATA[15:8] */
 	if (ack)
-		ret = realtek_smi_write_byte(smi, data >> 8);
+		ret = realtek_smi_write_byte(priv, data >> 8);
 	else
-		ret = realtek_smi_write_byte_noack(smi, data >> 8);
+		ret = realtek_smi_write_byte_noack(priv, data >> 8);
 	if (ret)
 		goto out;
 
 	ret = 0;
 
  out:
-	realtek_smi_stop(smi);
-	spin_unlock_irqrestore(&smi->lock, flags);
+	realtek_smi_stop(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
 }
@@ -292,10 +292,10 @@ static int realtek_smi_write_reg(struct realtek_smi *smi,
  * is when issueing soft reset. Since the device reset as soon as we write
  * that bit, no ACK will come back for natural reasons.
  */
-int realtek_smi_write_reg_noack(struct realtek_smi *smi, u32 addr,
+int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
 				u32 data)
 {
-	return realtek_smi_write_reg(smi, addr, data, false);
+	return realtek_smi_write_reg(priv, addr, data, false);
 }
 EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
 
@@ -303,16 +303,16 @@ EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
 
 static int realtek_smi_write(void *ctx, u32 reg, u32 val)
 {
-	struct realtek_smi *smi = ctx;
+	struct realtek_priv *priv = ctx;
 
-	return realtek_smi_write_reg(smi, reg, val, true);
+	return realtek_smi_write_reg(priv, reg, val, true);
 }
 
 static int realtek_smi_read(void *ctx, u32 reg, u32 *val)
 {
-	struct realtek_smi *smi = ctx;
+	struct realtek_priv *priv = ctx;
 
-	return realtek_smi_read_reg(smi, reg, val);
+	return realtek_smi_read_reg(priv, reg, val);
 }
 
 static const struct regmap_config realtek_smi_mdio_regmap_config = {
@@ -329,49 +329,49 @@ static const struct regmap_config realtek_smi_mdio_regmap_config = {
 
 static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
 {
-	struct realtek_smi *smi = bus->priv;
+	struct realtek_priv *priv = bus->priv;
 
-	return smi->ops->phy_read(smi, addr, regnum);
+	return priv->ops->phy_read(priv, addr, regnum);
 }
 
 static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 				  u16 val)
 {
-	struct realtek_smi *smi = bus->priv;
+	struct realtek_priv *priv = bus->priv;
 
-	return smi->ops->phy_write(smi, addr, regnum, val);
+	return priv->ops->phy_write(priv, addr, regnum, val);
 }
 
-int realtek_smi_setup_mdio(struct realtek_smi *smi)
+int realtek_smi_setup_mdio(struct realtek_priv *priv)
 {
 	struct device_node *mdio_np;
 	int ret;
 
-	mdio_np = of_get_compatible_child(smi->dev->of_node, "realtek,smi-mdio");
+	mdio_np = of_get_compatible_child(priv->dev->of_node, "realtek,smi-mdio");
 	if (!mdio_np) {
-		dev_err(smi->dev, "no MDIO bus node\n");
+		dev_err(priv->dev, "no MDIO bus node\n");
 		return -ENODEV;
 	}
 
-	smi->slave_mii_bus = devm_mdiobus_alloc(smi->dev);
-	if (!smi->slave_mii_bus) {
+	priv->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
+	if (!priv->slave_mii_bus) {
 		ret = -ENOMEM;
 		goto err_put_node;
 	}
-	smi->slave_mii_bus->priv = smi;
-	smi->slave_mii_bus->name = "SMI slave MII";
-	smi->slave_mii_bus->read = realtek_smi_mdio_read;
-	smi->slave_mii_bus->write = realtek_smi_mdio_write;
-	snprintf(smi->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
-		 smi->ds->index);
-	smi->slave_mii_bus->dev.of_node = mdio_np;
-	smi->slave_mii_bus->parent = smi->dev;
-	smi->ds->slave_mii_bus = smi->slave_mii_bus;
-
-	ret = devm_of_mdiobus_register(smi->dev, smi->slave_mii_bus, mdio_np);
+	priv->slave_mii_bus->priv = priv;
+	priv->slave_mii_bus->name = "SMI slave MII";
+	priv->slave_mii_bus->read = realtek_smi_mdio_read;
+	priv->slave_mii_bus->write = realtek_smi_mdio_write;
+	snprintf(priv->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
+		 priv->ds->index);
+	priv->slave_mii_bus->dev.of_node = mdio_np;
+	priv->slave_mii_bus->parent = priv->dev;
+	priv->ds->slave_mii_bus = priv->slave_mii_bus;
+
+	ret = devm_of_mdiobus_register(priv->dev, priv->slave_mii_bus, mdio_np);
 	if (ret) {
-		dev_err(smi->dev, "unable to register MDIO bus %s\n",
-			smi->slave_mii_bus->id);
+		dev_err(priv->dev, "unable to register MDIO bus %s\n",
+			priv->slave_mii_bus->id);
 		goto err_put_node;
 	}
 
@@ -385,76 +385,76 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi)
 
 static int realtek_smi_probe(struct platform_device *pdev)
 {
-	const struct realtek_smi_variant *var;
+	const struct realtek_variant *var;
 	struct device *dev = &pdev->dev;
-	struct realtek_smi *smi;
+	struct realtek_priv *priv;
 	struct device_node *np;
 	int ret;
 
 	var = of_device_get_match_data(dev);
 	np = dev->of_node;
 
-	smi = devm_kzalloc(dev, sizeof(*smi) + var->chip_data_sz, GFP_KERNEL);
-	if (!smi)
+	priv = devm_kzalloc(dev, sizeof(*priv) + var->chip_data_sz, GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
-	smi->chip_data = (void *)smi + sizeof(*smi);
-	smi->map = devm_regmap_init(dev, NULL, smi,
-				    &realtek_smi_mdio_regmap_config);
-	if (IS_ERR(smi->map)) {
-		ret = PTR_ERR(smi->map);
+	priv->chip_data = (void *)priv + sizeof(*priv);
+	priv->map = devm_regmap_init(dev, NULL, priv,
+				     &realtek_smi_mdio_regmap_config);
+	if (IS_ERR(priv->map)) {
+		ret = PTR_ERR(priv->map);
 		dev_err(dev, "regmap init failed: %d\n", ret);
 		return ret;
 	}
 
 	/* Link forward and backward */
-	smi->dev = dev;
-	smi->clk_delay = var->clk_delay;
-	smi->cmd_read = var->cmd_read;
-	smi->cmd_write = var->cmd_write;
-	smi->ops = var->ops;
+	priv->dev = dev;
+	priv->clk_delay = var->clk_delay;
+	priv->cmd_read = var->cmd_read;
+	priv->cmd_write = var->cmd_write;
+	priv->ops = var->ops;
 
-	dev_set_drvdata(dev, smi);
-	spin_lock_init(&smi->lock);
+	dev_set_drvdata(dev, priv);
+	spin_lock_init(&priv->lock);
 
 	/* TODO: if power is software controlled, set up any regulators here */
 
 	/* Assert then deassert RESET */
-	smi->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(smi->reset)) {
+	priv->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->reset)) {
 		dev_err(dev, "failed to get RESET GPIO\n");
-		return PTR_ERR(smi->reset);
+		return PTR_ERR(priv->reset);
 	}
 	msleep(REALTEK_SMI_HW_STOP_DELAY);
-	gpiod_set_value(smi->reset, 0);
+	gpiod_set_value(priv->reset, 0);
 	msleep(REALTEK_SMI_HW_START_DELAY);
 	dev_info(dev, "deasserted RESET\n");
 
 	/* Fetch MDIO pins */
-	smi->mdc = devm_gpiod_get_optional(dev, "mdc", GPIOD_OUT_LOW);
-	if (IS_ERR(smi->mdc))
-		return PTR_ERR(smi->mdc);
-	smi->mdio = devm_gpiod_get_optional(dev, "mdio", GPIOD_OUT_LOW);
-	if (IS_ERR(smi->mdio))
-		return PTR_ERR(smi->mdio);
+	priv->mdc = devm_gpiod_get_optional(dev, "mdc", GPIOD_OUT_LOW);
+	if (IS_ERR(priv->mdc))
+		return PTR_ERR(priv->mdc);
+	priv->mdio = devm_gpiod_get_optional(dev, "mdio", GPIOD_OUT_LOW);
+	if (IS_ERR(priv->mdio))
+		return PTR_ERR(priv->mdio);
 
-	smi->leds_disabled = of_property_read_bool(np, "realtek,disable-leds");
+	priv->leds_disabled = of_property_read_bool(np, "realtek,disable-leds");
 
-	ret = smi->ops->detect(smi);
+	ret = priv->ops->detect(priv);
 	if (ret) {
 		dev_err(dev, "unable to detect switch\n");
 		return ret;
 	}
 
-	smi->ds = devm_kzalloc(dev, sizeof(*smi->ds), GFP_KERNEL);
-	if (!smi->ds)
+	priv->ds = devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
+	if (!priv->ds)
 		return -ENOMEM;
 
-	smi->ds->dev = dev;
-	smi->ds->num_ports = smi->num_ports;
-	smi->ds->priv = smi;
+	priv->ds->dev = dev;
+	priv->ds->num_ports = priv->num_ports;
+	priv->ds->priv = priv;
 
-	smi->ds->ops = var->ds_ops;
-	ret = dsa_register_switch(smi->ds);
+	priv->ds->ops = var->ds_ops;
+	ret = dsa_register_switch(priv->ds);
 	if (ret) {
 		dev_err_probe(dev, ret, "unable to register switch\n");
 		return ret;
@@ -464,15 +464,15 @@ static int realtek_smi_probe(struct platform_device *pdev)
 
 static int realtek_smi_remove(struct platform_device *pdev)
 {
-	struct realtek_smi *smi = platform_get_drvdata(pdev);
+	struct realtek_priv *priv = platform_get_drvdata(pdev);
 
-	if (!smi)
+	if (!priv)
 		return 0;
 
-	dsa_unregister_switch(smi->ds);
-	if (smi->slave_mii_bus)
-		of_node_put(smi->slave_mii_bus->dev.of_node);
-	gpiod_set_value(smi->reset, 1);
+	dsa_unregister_switch(priv->ds);
+	if (priv->slave_mii_bus)
+		of_node_put(priv->slave_mii_bus->dev.of_node);
+	gpiod_set_value(priv->reset, 1);
 
 	platform_set_drvdata(pdev, NULL);
 
@@ -481,12 +481,12 @@ static int realtek_smi_remove(struct platform_device *pdev)
 
 static void realtek_smi_shutdown(struct platform_device *pdev)
 {
-	struct realtek_smi *smi = platform_get_drvdata(pdev);
+	struct realtek_priv *priv = platform_get_drvdata(pdev);
 
-	if (!smi)
+	if (!priv)
 		return;
 
-	dsa_switch_shutdown(smi->ds);
+	dsa_switch_shutdown(priv->ds);
 
 	platform_set_drvdata(pdev, NULL);
 }
diff --git a/drivers/net/dsa/realtek/realtek-smi-core.h b/drivers/net/dsa/realtek/realtek.h
similarity index 57%
rename from drivers/net/dsa/realtek/realtek-smi-core.h
rename to drivers/net/dsa/realtek/realtek.h
index 5bfa53e2480a..177fff90b8a6 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -13,7 +13,7 @@
 #include <linux/gpio/consumer.h>
 #include <net/dsa.h>
 
-struct realtek_smi_ops;
+struct realtek_ops;
 struct dentry;
 struct inode;
 struct file;
@@ -43,7 +43,7 @@ struct rtl8366_vlan_4k {
 	u8	fid;
 };
 
-struct realtek_smi {
+struct realtek_priv {
 	struct device		*dev;
 	struct gpio_desc	*reset;
 	struct gpio_desc	*mdc;
@@ -65,7 +65,7 @@ struct realtek_smi {
 	unsigned int		num_mib_counters;
 	struct rtl8366_mib_counter *mib_counters;
 
-	const struct realtek_smi_ops *ops;
+	const struct realtek_ops *ops;
 
 	int			vlan_enabled;
 	int			vlan4k_enabled;
@@ -75,40 +75,40 @@ struct realtek_smi {
 };
 
 /**
- * struct realtek_smi_ops - vtable for the per-SMI-chiptype operations
+ * struct realtek_ops - vtable for the per-SMI-chiptype operations
  * @detect: detects the chiptype
  */
-struct realtek_smi_ops {
-	int	(*detect)(struct realtek_smi *smi);
-	int	(*reset_chip)(struct realtek_smi *smi);
-	int	(*setup)(struct realtek_smi *smi);
-	void	(*cleanup)(struct realtek_smi *smi);
-	int	(*get_mib_counter)(struct realtek_smi *smi,
+struct realtek_ops {
+	int	(*detect)(struct realtek_priv *priv);
+	int	(*reset_chip)(struct realtek_priv *priv);
+	int	(*setup)(struct realtek_priv *priv);
+	void	(*cleanup)(struct realtek_priv *priv);
+	int	(*get_mib_counter)(struct realtek_priv *priv,
 				   int port,
 				   struct rtl8366_mib_counter *mib,
 				   u64 *mibvalue);
-	int	(*get_vlan_mc)(struct realtek_smi *smi, u32 index,
+	int	(*get_vlan_mc)(struct realtek_priv *priv, u32 index,
 			       struct rtl8366_vlan_mc *vlanmc);
-	int	(*set_vlan_mc)(struct realtek_smi *smi, u32 index,
+	int	(*set_vlan_mc)(struct realtek_priv *priv, u32 index,
 			       const struct rtl8366_vlan_mc *vlanmc);
-	int	(*get_vlan_4k)(struct realtek_smi *smi, u32 vid,
+	int	(*get_vlan_4k)(struct realtek_priv *priv, u32 vid,
 			       struct rtl8366_vlan_4k *vlan4k);
-	int	(*set_vlan_4k)(struct realtek_smi *smi,
+	int	(*set_vlan_4k)(struct realtek_priv *priv,
 			       const struct rtl8366_vlan_4k *vlan4k);
-	int	(*get_mc_index)(struct realtek_smi *smi, int port, int *val);
-	int	(*set_mc_index)(struct realtek_smi *smi, int port, int index);
-	bool	(*is_vlan_valid)(struct realtek_smi *smi, unsigned int vlan);
-	int	(*enable_vlan)(struct realtek_smi *smi, bool enable);
-	int	(*enable_vlan4k)(struct realtek_smi *smi, bool enable);
-	int	(*enable_port)(struct realtek_smi *smi, int port, bool enable);
-	int	(*phy_read)(struct realtek_smi *smi, int phy, int regnum);
-	int	(*phy_write)(struct realtek_smi *smi, int phy, int regnum,
+	int	(*get_mc_index)(struct realtek_priv *priv, int port, int *val);
+	int	(*set_mc_index)(struct realtek_priv *priv, int port, int index);
+	bool	(*is_vlan_valid)(struct realtek_priv *priv, unsigned int vlan);
+	int	(*enable_vlan)(struct realtek_priv *priv, bool enable);
+	int	(*enable_vlan4k)(struct realtek_priv *priv, bool enable);
+	int	(*enable_port)(struct realtek_priv *priv, int port, bool enable);
+	int	(*phy_read)(struct realtek_priv *priv, int phy, int regnum);
+	int	(*phy_write)(struct realtek_priv *priv, int phy, int regnum,
 			     u16 val);
 };
 
-struct realtek_smi_variant {
+struct realtek_variant {
 	const struct dsa_switch_ops *ds_ops;
-	const struct realtek_smi_ops *ops;
+	const struct realtek_ops *ops;
 	unsigned int clk_delay;
 	u8 cmd_read;
 	u8 cmd_write;
@@ -116,19 +116,19 @@ struct realtek_smi_variant {
 };
 
 /* SMI core calls */
-int realtek_smi_write_reg_noack(struct realtek_smi *smi, u32 addr,
+int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
 				u32 data);
-int realtek_smi_setup_mdio(struct realtek_smi *smi);
+int realtek_smi_setup_mdio(struct realtek_priv *priv);
 
 /* RTL8366 library helpers */
-int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used);
-int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
+int rtl8366_mc_is_used(struct realtek_priv *priv, int mc_index, int *used);
+int rtl8366_set_vlan(struct realtek_priv *priv, int vid, u32 member,
 		     u32 untag, u32 fid);
-int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
+int rtl8366_set_pvid(struct realtek_priv *priv, unsigned int port,
 		     unsigned int vid);
-int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
-int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
-int rtl8366_reset_vlan(struct realtek_smi *smi);
+int rtl8366_enable_vlan4k(struct realtek_priv *priv, bool enable);
+int rtl8366_enable_vlan(struct realtek_priv *priv, bool enable);
+int rtl8366_reset_vlan(struct realtek_priv *priv);
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan,
 		     struct netlink_ext_ack *extack);
@@ -139,7 +139,7 @@ void rtl8366_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 int rtl8366_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void rtl8366_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 
-extern const struct realtek_smi_variant rtl8366rb_variant;
-extern const struct realtek_smi_variant rtl8365mb_variant;
+extern const struct realtek_variant rtl8366rb_variant;
+extern const struct realtek_variant rtl8365mb_variant;
 
 #endif /*  _REALTEK_SMI_H */
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 3b729544798b..6b8797ba80c6 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -99,7 +99,7 @@
 #include <linux/regmap.h>
 #include <linux/if_bridge.h>
 
-#include "realtek-smi-core.h"
+#include "realtek.h"
 
 /* Chip-specific data and limits */
 #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
@@ -516,7 +516,7 @@ struct rtl8365mb_cpu {
 
 /**
  * struct rtl8365mb_port - private per-port data
- * @smi: pointer to parent realtek_smi data
+ * @priv: pointer to parent realtek_priv data
  * @index: DSA port index, same as dsa_port::index
  * @stats: link statistics populated by rtl8365mb_stats_poll, ready for atomic
  *         access via rtl8365mb_get_stats64
@@ -524,7 +524,7 @@ struct rtl8365mb_cpu {
  * @mib_work: delayed work for polling MIB counters
  */
 struct rtl8365mb_port {
-	struct realtek_smi *smi;
+	struct realtek_priv *priv;
 	unsigned int index;
 	struct rtnl_link_stats64 stats;
 	spinlock_t stats_lock;
@@ -533,7 +533,7 @@ struct rtl8365mb_port {
 
 /**
  * struct rtl8365mb - private chip-specific driver data
- * @smi: pointer to parent realtek_smi data
+ * @priv: pointer to parent realtek_priv data
  * @irq: registered IRQ or zero
  * @chip_id: chip identifier
  * @chip_ver: chip silicon revision
@@ -548,7 +548,7 @@ struct rtl8365mb_port {
  * Private data for this driver.
  */
 struct rtl8365mb {
-	struct realtek_smi *smi;
+	struct realtek_priv *priv;
 	int irq;
 	u32 chip_id;
 	u32 chip_ver;
@@ -561,16 +561,16 @@ struct rtl8365mb {
 	size_t jam_size;
 };
 
-static int rtl8365mb_phy_poll_busy(struct realtek_smi *smi)
+static int rtl8365mb_phy_poll_busy(struct realtek_priv *priv)
 {
 	u32 val;
 
-	return regmap_read_poll_timeout(smi->map,
+	return regmap_read_poll_timeout(priv->map,
 					RTL8365MB_INDIRECT_ACCESS_STATUS_REG,
 					val, !val, 10, 100);
 }
 
-static int rtl8365mb_phy_ocp_prepare(struct realtek_smi *smi, int phy,
+static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
 				     u32 ocp_addr)
 {
 	u32 val;
@@ -579,7 +579,7 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_smi *smi, int phy,
 	/* Set OCP prefix */
 	val = FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK, ocp_addr);
 	ret = regmap_update_bits(
-		smi->map, RTL8365MB_GPHY_OCP_MSB_0_REG,
+		priv->map, RTL8365MB_GPHY_OCP_MSB_0_REG,
 		RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
 		FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK, val));
 	if (ret)
@@ -592,7 +592,7 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_smi *smi, int phy,
 			  ocp_addr >> 1);
 	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
 			  ocp_addr >> 6);
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
+	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
 			   val);
 	if (ret)
 		return ret;
@@ -600,17 +600,17 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_smi *smi, int phy,
 	return 0;
 }
 
-static int rtl8365mb_phy_ocp_read(struct realtek_smi *smi, int phy,
+static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
 				  u32 ocp_addr, u16 *data)
 {
 	u32 val;
 	int ret;
 
-	ret = rtl8365mb_phy_poll_busy(smi);
+	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
 		return ret;
 
-	ret = rtl8365mb_phy_ocp_prepare(smi, phy, ocp_addr);
+	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
 	if (ret)
 		return ret;
 
@@ -619,16 +619,16 @@ static int rtl8365mb_phy_ocp_read(struct realtek_smi *smi, int phy,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_READ);
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
 	if (ret)
 		return ret;
 
-	ret = rtl8365mb_phy_poll_busy(smi);
+	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
 		return ret;
 
 	/* Get PHY register data */
-	ret = regmap_read(smi->map, RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG,
+	ret = regmap_read(priv->map, RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG,
 			  &val);
 	if (ret)
 		return ret;
@@ -638,22 +638,22 @@ static int rtl8365mb_phy_ocp_read(struct realtek_smi *smi, int phy,
 	return 0;
 }
 
-static int rtl8365mb_phy_ocp_write(struct realtek_smi *smi, int phy,
+static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 				   u32 ocp_addr, u16 data)
 {
 	u32 val;
 	int ret;
 
-	ret = rtl8365mb_phy_poll_busy(smi);
+	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
 		return ret;
 
-	ret = rtl8365mb_phy_ocp_prepare(smi, phy, ocp_addr);
+	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
 	if (ret)
 		return ret;
 
 	/* Set PHY register data */
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG,
+	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG,
 			   data);
 	if (ret)
 		return ret;
@@ -663,18 +663,18 @@ static int rtl8365mb_phy_ocp_write(struct realtek_smi *smi, int phy,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_WRITE);
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
 	if (ret)
 		return ret;
 
-	ret = rtl8365mb_phy_poll_busy(smi);
+	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
 		return ret;
 
 	return 0;
 }
 
-static int rtl8365mb_phy_read(struct realtek_smi *smi, int phy, int regnum)
+static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 {
 	u32 ocp_addr;
 	u16 val;
@@ -688,21 +688,21 @@ static int rtl8365mb_phy_read(struct realtek_smi *smi, int phy, int regnum)
 
 	ocp_addr = RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;
 
-	ret = rtl8365mb_phy_ocp_read(smi, phy, ocp_addr, &val);
+	ret = rtl8365mb_phy_ocp_read(priv, phy, ocp_addr, &val);
 	if (ret) {
-		dev_err(smi->dev,
+		dev_err(priv->dev,
 			"failed to read PHY%d reg %02x @ %04x, ret %d\n", phy,
 			regnum, ocp_addr, ret);
 		return ret;
 	}
 
-	dev_dbg(smi->dev, "read PHY%d register 0x%02x @ %04x, val <- %04x\n",
+	dev_dbg(priv->dev, "read PHY%d register 0x%02x @ %04x, val <- %04x\n",
 		phy, regnum, ocp_addr, val);
 
 	return val;
 }
 
-static int rtl8365mb_phy_write(struct realtek_smi *smi, int phy, int regnum,
+static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 			       u16 val)
 {
 	u32 ocp_addr;
@@ -716,15 +716,15 @@ static int rtl8365mb_phy_write(struct realtek_smi *smi, int phy, int regnum,
 
 	ocp_addr = RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;
 
-	ret = rtl8365mb_phy_ocp_write(smi, phy, ocp_addr, val);
+	ret = rtl8365mb_phy_ocp_write(priv, phy, ocp_addr, val);
 	if (ret) {
-		dev_err(smi->dev,
+		dev_err(priv->dev,
 			"failed to write PHY%d reg %02x @ %04x, ret %d\n", phy,
 			regnum, ocp_addr, ret);
 		return ret;
 	}
 
-	dev_dbg(smi->dev, "write PHY%d register 0x%02x @ %04x, val -> %04x\n",
+	dev_dbg(priv->dev, "write PHY%d register 0x%02x @ %04x, val -> %04x\n",
 		phy, regnum, ocp_addr, val);
 
 	return 0;
@@ -737,7 +737,7 @@ rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_RTL8_4;
 }
 
-static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
+static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 				      phy_interface_t interface)
 {
 	struct device_node *dn;
@@ -748,14 +748,14 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	u32 val;
 	int ret;
 
-	if (port == smi->cpu_port) {
+	if (port == priv->cpu_port) {
 		ext_port = 1;
 	} else {
-		dev_err(smi->dev, "only one EXT port is currently supported\n");
+		dev_err(priv->dev, "only one EXT port is currently supported\n");
 		return -EINVAL;
 	}
 
-	dp = dsa_to_port(smi->ds, port);
+	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
 	/* Set the RGMII TX/RX delay
@@ -786,7 +786,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 		if (val == 0 || val == 2)
 			tx_delay = val / 2;
 		else
-			dev_warn(smi->dev,
+			dev_warn(priv->dev,
 				 "EXT port TX delay must be 0 or 2 ns\n");
 	}
 
@@ -796,12 +796,12 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 		if (val <= 7)
 			rx_delay = val;
 		else
-			dev_warn(smi->dev,
+			dev_warn(priv->dev,
 				 "EXT port RX delay must be 0 to 2.1 ns\n");
 	}
 
 	ret = regmap_update_bits(
-		smi->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
+		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
 		RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
 			RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
 		FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
@@ -810,7 +810,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 		return ret;
 
 	ret = regmap_update_bits(
-		smi->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_port),
+		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_port),
 		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_port),
 		RTL8365MB_EXT_PORT_MODE_RGMII
 			<< RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
@@ -821,7 +821,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	return 0;
 }
 
-static int rtl8365mb_ext_config_forcemode(struct realtek_smi *smi, int port,
+static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 					  bool link, int speed, int duplex,
 					  bool tx_pause, bool rx_pause)
 {
@@ -834,10 +834,10 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_smi *smi, int port,
 	int val;
 	int ret;
 
-	if (port == smi->cpu_port) {
+	if (port == priv->cpu_port) {
 		ext_port = 1;
 	} else {
-		dev_err(smi->dev, "only one EXT port is currently supported\n");
+		dev_err(priv->dev, "only one EXT port is currently supported\n");
 		return -EINVAL;
 	}
 
@@ -854,7 +854,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_smi *smi, int port,
 		} else if (speed == SPEED_10) {
 			r_speed = RTL8365MB_PORT_SPEED_10M;
 		} else {
-			dev_err(smi->dev, "unsupported port speed %s\n",
+			dev_err(priv->dev, "unsupported port speed %s\n",
 				phy_speed_to_str(speed));
 			return -EINVAL;
 		}
@@ -864,7 +864,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_smi *smi, int port,
 		} else if (duplex == DUPLEX_HALF) {
 			r_duplex = 0;
 		} else {
-			dev_err(smi->dev, "unsupported duplex %s\n",
+			dev_err(priv->dev, "unsupported duplex %s\n",
 				phy_duplex_to_str(duplex));
 			return -EINVAL;
 		}
@@ -886,7 +886,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_smi *smi, int port,
 	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_DUPLEX_MASK,
 			 r_duplex) |
 	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_speed);
-	ret = regmap_write(smi->map,
+	ret = regmap_write(priv->map,
 			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_port),
 			   val);
 	if (ret)
@@ -916,7 +916,7 @@ static void rtl8365mb_phylink_validate(struct dsa_switch *ds, int port,
 				       unsigned long *supported,
 				       struct phylink_link_state *state)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0 };
 
 	/* include/linux/phylink.h says:
@@ -925,7 +925,7 @@ static void rtl8365mb_phylink_validate(struct dsa_switch *ds, int port,
 	 */
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    !rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
-		dev_err(smi->dev, "phy mode %s is unsupported on port %d\n",
+		dev_err(priv->dev, "phy mode %s is unsupported on port %d\n",
 			phy_modes(state->interface), port);
 		linkmode_zero(supported);
 		return;
@@ -951,26 +951,26 @@ static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
 					 unsigned int mode,
 					 const struct phylink_link_state *state)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret;
 
 	if (!rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
-		dev_err(smi->dev, "phy mode %s is unsupported on port %d\n",
+		dev_err(priv->dev, "phy mode %s is unsupported on port %d\n",
 			phy_modes(state->interface), port);
 		return;
 	}
 
 	if (mode != MLO_AN_PHY && mode != MLO_AN_FIXED) {
-		dev_err(smi->dev,
+		dev_err(priv->dev,
 			"port %d supports only conventional PHY or fixed-link\n",
 			port);
 		return;
 	}
 
 	if (phy_interface_mode_is_rgmii(state->interface)) {
-		ret = rtl8365mb_ext_config_rgmii(smi, port, state->interface);
+		ret = rtl8365mb_ext_config_rgmii(priv, port, state->interface);
 		if (ret)
-			dev_err(smi->dev,
+			dev_err(priv->dev,
 				"failed to configure RGMII mode on port %d: %d\n",
 				port, ret);
 		return;
@@ -985,20 +985,20 @@ static void rtl8365mb_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					    unsigned int mode,
 					    phy_interface_t interface)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb_port *p;
 	struct rtl8365mb *mb;
 	int ret;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 	p = &mb->ports[port];
 	cancel_delayed_work_sync(&p->mib_work);
 
 	if (phy_interface_mode_is_rgmii(interface)) {
-		ret = rtl8365mb_ext_config_forcemode(smi, port, false, 0, 0,
+		ret = rtl8365mb_ext_config_forcemode(priv, port, false, 0, 0,
 						     false, false);
 		if (ret)
-			dev_err(smi->dev,
+			dev_err(priv->dev,
 				"failed to reset forced mode on port %d: %d\n",
 				port, ret);
 
@@ -1013,21 +1013,21 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
 					  int duplex, bool tx_pause,
 					  bool rx_pause)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb_port *p;
 	struct rtl8365mb *mb;
 	int ret;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 	p = &mb->ports[port];
 	schedule_delayed_work(&p->mib_work, 0);
 
 	if (phy_interface_mode_is_rgmii(interface)) {
-		ret = rtl8365mb_ext_config_forcemode(smi, port, true, speed,
+		ret = rtl8365mb_ext_config_forcemode(priv, port, true, speed,
 						     duplex, tx_pause,
 						     rx_pause);
 		if (ret)
-			dev_err(smi->dev,
+			dev_err(priv->dev,
 				"failed to force mode on port %d: %d\n", port,
 				ret);
 
@@ -1038,7 +1038,7 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
 static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
 					 u8 state)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	enum rtl8365mb_stp_state val;
 	int msti = 0;
 
@@ -1057,36 +1057,36 @@ static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
 		val = RTL8365MB_STP_STATE_FORWARDING;
 		break;
 	default:
-		dev_err(smi->dev, "invalid STP state: %u\n", state);
+		dev_err(priv->dev, "invalid STP state: %u\n", state);
 		return;
 	}
 
-	regmap_update_bits(smi->map, RTL8365MB_MSTI_CTRL_REG(msti, port),
+	regmap_update_bits(priv->map, RTL8365MB_MSTI_CTRL_REG(msti, port),
 			   RTL8365MB_MSTI_CTRL_PORT_STATE_MASK(port),
 			   val << RTL8365MB_MSTI_CTRL_PORT_STATE_OFFSET(port));
 }
 
-static int rtl8365mb_port_set_learning(struct realtek_smi *smi, int port,
+static int rtl8365mb_port_set_learning(struct realtek_priv *priv, int port,
 				       bool enable)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 
 	/* Enable/disable learning by limiting the number of L2 addresses the
 	 * port can learn. Realtek documentation states that a limit of zero
 	 * disables learning. When enabling learning, set it to the chip's
 	 * maximum.
 	 */
-	return regmap_write(smi->map, RTL8365MB_LUT_PORT_LEARN_LIMIT_REG(port),
+	return regmap_write(priv->map, RTL8365MB_LUT_PORT_LEARN_LIMIT_REG(port),
 			    enable ? mb->learn_limit_max : 0);
 }
 
-static int rtl8365mb_port_set_isolation(struct realtek_smi *smi, int port,
+static int rtl8365mb_port_set_isolation(struct realtek_priv *priv, int port,
 					u32 mask)
 {
-	return regmap_write(smi->map, RTL8365MB_PORT_ISOLATION_REG(port), mask);
+	return regmap_write(priv->map, RTL8365MB_PORT_ISOLATION_REG(port), mask);
 }
 
-static int rtl8365mb_mib_counter_read(struct realtek_smi *smi, int port,
+static int rtl8365mb_mib_counter_read(struct realtek_priv *priv, int port,
 				      u32 offset, u32 length, u64 *mibvalue)
 {
 	u64 tmpvalue = 0;
@@ -1098,13 +1098,13 @@ static int rtl8365mb_mib_counter_read(struct realtek_smi *smi, int port,
 	 * and then poll the control register before reading the value from some
 	 * counter registers.
 	 */
-	ret = regmap_write(smi->map, RTL8365MB_MIB_ADDRESS_REG,
+	ret = regmap_write(priv->map, RTL8365MB_MIB_ADDRESS_REG,
 			   RTL8365MB_MIB_ADDRESS(port, offset));
 	if (ret)
 		return ret;
 
 	/* Poll for completion */
-	ret = regmap_read_poll_timeout(smi->map, RTL8365MB_MIB_CTRL0_REG, val,
+	ret = regmap_read_poll_timeout(priv->map, RTL8365MB_MIB_CTRL0_REG, val,
 				       !(val & RTL8365MB_MIB_CTRL0_BUSY_MASK),
 				       10, 100);
 	if (ret)
@@ -1126,7 +1126,7 @@ static int rtl8365mb_mib_counter_read(struct realtek_smi *smi, int port,
 
 	/* Read the MIB counter 16 bits at a time */
 	for (i = 0; i < length; i++) {
-		ret = regmap_read(smi->map,
+		ret = regmap_read(priv->map,
 				  RTL8365MB_MIB_COUNTER_REG(offset - i), &val);
 		if (ret)
 			return ret;
@@ -1142,21 +1142,21 @@ static int rtl8365mb_mib_counter_read(struct realtek_smi *smi, int port,
 
 static void rtl8365mb_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 
 	mutex_lock(&mb->mib_lock);
 	for (i = 0; i < RTL8365MB_MIB_END; i++) {
 		struct rtl8365mb_mib_counter *mib = &rtl8365mb_mib_counters[i];
 
-		ret = rtl8365mb_mib_counter_read(smi, port, mib->offset,
+		ret = rtl8365mb_mib_counter_read(priv, port, mib->offset,
 						 mib->length, &data[i]);
 		if (ret) {
-			dev_err(smi->dev,
+			dev_err(priv->dev,
 				"failed to read port %d counters: %d\n", port,
 				ret);
 			break;
@@ -1190,15 +1190,15 @@ static int rtl8365mb_get_sset_count(struct dsa_switch *ds, int port, int sset)
 static void rtl8365mb_get_phy_stats(struct dsa_switch *ds, int port,
 				    struct ethtool_eth_phy_stats *phy_stats)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb_mib_counter *mib;
 	struct rtl8365mb *mb;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 	mib = &rtl8365mb_mib_counters[RTL8365MB_MIB_dot3StatsSymbolErrors];
 
 	mutex_lock(&mb->mib_lock);
-	rtl8365mb_mib_counter_read(smi, port, mib->offset, mib->length,
+	rtl8365mb_mib_counter_read(priv, port, mib->offset, mib->length,
 				   &phy_stats->SymbolErrorDuringCarrier);
 	mutex_unlock(&mb->mib_lock);
 }
@@ -1226,12 +1226,12 @@ static void rtl8365mb_get_mac_stats(struct dsa_switch *ds, int port,
 		[RTL8365MB_MIB_dot3StatsExcessiveCollisions] = 1,
 
 	};
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 
 	mutex_lock(&mb->mib_lock);
 	for (i = 0; i < RTL8365MB_MIB_END; i++) {
@@ -1241,7 +1241,7 @@ static void rtl8365mb_get_mac_stats(struct dsa_switch *ds, int port,
 		if (!cnt[i])
 			continue;
 
-		ret = rtl8365mb_mib_counter_read(smi, port, mib->offset,
+		ret = rtl8365mb_mib_counter_read(priv, port, mib->offset,
 						 mib->length, &cnt[i]);
 		if (ret)
 			break;
@@ -1291,20 +1291,20 @@ static void rtl8365mb_get_mac_stats(struct dsa_switch *ds, int port,
 static void rtl8365mb_get_ctrl_stats(struct dsa_switch *ds, int port,
 				     struct ethtool_eth_ctrl_stats *ctrl_stats)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb_mib_counter *mib;
 	struct rtl8365mb *mb;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 	mib = &rtl8365mb_mib_counters[RTL8365MB_MIB_dot3ControlInUnknownOpcodes];
 
 	mutex_lock(&mb->mib_lock);
-	rtl8365mb_mib_counter_read(smi, port, mib->offset, mib->length,
+	rtl8365mb_mib_counter_read(priv, port, mib->offset, mib->length,
 				   &ctrl_stats->UnsupportedOpcodesReceived);
 	mutex_unlock(&mb->mib_lock);
 }
 
-static void rtl8365mb_stats_update(struct realtek_smi *smi, int port)
+static void rtl8365mb_stats_update(struct realtek_priv *priv, int port)
 {
 	u64 cnt[RTL8365MB_MIB_END] = {
 		[RTL8365MB_MIB_ifOutOctets] = 1,
@@ -1323,7 +1323,7 @@ static void rtl8365mb_stats_update(struct realtek_smi *smi, int port)
 		[RTL8365MB_MIB_dot3StatsFCSErrors] = 1,
 		[RTL8365MB_MIB_dot3StatsLateCollisions] = 1,
 	};
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	struct rtnl_link_stats64 *stats;
 	int ret;
 	int i;
@@ -1338,7 +1338,7 @@ static void rtl8365mb_stats_update(struct realtek_smi *smi, int port)
 		if (!cnt[i])
 			continue;
 
-		ret = rtl8365mb_mib_counter_read(smi, port, c->offset,
+		ret = rtl8365mb_mib_counter_read(priv, port, c->offset,
 						 c->length, &cnt[i]);
 		if (ret)
 			break;
@@ -1388,9 +1388,9 @@ static void rtl8365mb_stats_poll(struct work_struct *work)
 	struct rtl8365mb_port *p = container_of(to_delayed_work(work),
 						struct rtl8365mb_port,
 						mib_work);
-	struct realtek_smi *smi = p->smi;
+	struct realtek_priv *priv = p->priv;
 
-	rtl8365mb_stats_update(smi, p->index);
+	rtl8365mb_stats_update(priv, p->index);
 
 	schedule_delayed_work(&p->mib_work, RTL8365MB_STATS_INTERVAL_JIFFIES);
 }
@@ -1398,11 +1398,11 @@ static void rtl8365mb_stats_poll(struct work_struct *work)
 static void rtl8365mb_get_stats64(struct dsa_switch *ds, int port,
 				  struct rtnl_link_stats64 *s)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb_port *p;
 	struct rtl8365mb *mb;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 	p = &mb->ports[port];
 
 	spin_lock(&p->stats_lock);
@@ -1410,9 +1410,9 @@ static void rtl8365mb_get_stats64(struct dsa_switch *ds, int port,
 	spin_unlock(&p->stats_lock);
 }
 
-static void rtl8365mb_stats_setup(struct realtek_smi *smi)
+static void rtl8365mb_stats_setup(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	int i;
 
 	/* Per-chip global mutex to protect MIB counter access, since doing
@@ -1420,10 +1420,10 @@ static void rtl8365mb_stats_setup(struct realtek_smi *smi)
 	 */
 	mutex_init(&mb->mib_lock);
 
-	for (i = 0; i < smi->num_ports; i++) {
+	for (i = 0; i < priv->num_ports; i++) {
 		struct rtl8365mb_port *p = &mb->ports[i];
 
-		if (dsa_is_unused_port(smi->ds, i))
+		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
 		/* Per-port spinlock to protect the stats64 data */
@@ -1436,45 +1436,45 @@ static void rtl8365mb_stats_setup(struct realtek_smi *smi)
 	}
 }
 
-static void rtl8365mb_stats_teardown(struct realtek_smi *smi)
+static void rtl8365mb_stats_teardown(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	int i;
 
-	for (i = 0; i < smi->num_ports; i++) {
+	for (i = 0; i < priv->num_ports; i++) {
 		struct rtl8365mb_port *p = &mb->ports[i];
 
-		if (dsa_is_unused_port(smi->ds, i))
+		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
 		cancel_delayed_work_sync(&p->mib_work);
 	}
 }
 
-static int rtl8365mb_get_and_clear_status_reg(struct realtek_smi *smi, u32 reg,
+static int rtl8365mb_get_and_clear_status_reg(struct realtek_priv *priv, u32 reg,
 					      u32 *val)
 {
 	int ret;
 
-	ret = regmap_read(smi->map, reg, val);
+	ret = regmap_read(priv->map, reg, val);
 	if (ret)
 		return ret;
 
-	return regmap_write(smi->map, reg, *val);
+	return regmap_write(priv->map, reg, *val);
 }
 
 static irqreturn_t rtl8365mb_irq(int irq, void *data)
 {
-	struct realtek_smi *smi = data;
+	struct realtek_priv *priv = data;
 	unsigned long line_changes = 0;
 	struct rtl8365mb *mb;
 	u32 stat;
 	int line;
 	int ret;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 
-	ret = rtl8365mb_get_and_clear_status_reg(smi, RTL8365MB_INTR_STATUS_REG,
+	ret = rtl8365mb_get_and_clear_status_reg(priv, RTL8365MB_INTR_STATUS_REG,
 						 &stat);
 	if (ret)
 		goto out_error;
@@ -1485,14 +1485,14 @@ static irqreturn_t rtl8365mb_irq(int irq, void *data)
 		u32 val;
 
 		ret = rtl8365mb_get_and_clear_status_reg(
-			smi, RTL8365MB_PORT_LINKUP_IND_REG, &val);
+			priv, RTL8365MB_PORT_LINKUP_IND_REG, &val);
 		if (ret)
 			goto out_error;
 
 		linkup_ind = FIELD_GET(RTL8365MB_PORT_LINKUP_IND_MASK, val);
 
 		ret = rtl8365mb_get_and_clear_status_reg(
-			smi, RTL8365MB_PORT_LINKDOWN_IND_REG, &val);
+			priv, RTL8365MB_PORT_LINKDOWN_IND_REG, &val);
 		if (ret)
 			goto out_error;
 
@@ -1504,8 +1504,8 @@ static irqreturn_t rtl8365mb_irq(int irq, void *data)
 	if (!line_changes)
 		goto out_none;
 
-	for_each_set_bit(line, &line_changes, smi->num_ports) {
-		int child_irq = irq_find_mapping(smi->irqdomain, line);
+	for_each_set_bit(line, &line_changes, priv->num_ports) {
+		int child_irq = irq_find_mapping(priv->irqdomain, line);
 
 		handle_nested_irq(child_irq);
 	}
@@ -1513,7 +1513,7 @@ static irqreturn_t rtl8365mb_irq(int irq, void *data)
 	return IRQ_HANDLED;
 
 out_error:
-	dev_err(smi->dev, "failed to read interrupt status: %d\n", ret);
+	dev_err(priv->dev, "failed to read interrupt status: %d\n", ret);
 
 out_none:
 	return IRQ_NONE;
@@ -1548,27 +1548,27 @@ static const struct irq_domain_ops rtl8365mb_irqdomain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static int rtl8365mb_set_irq_enable(struct realtek_smi *smi, bool enable)
+static int rtl8365mb_set_irq_enable(struct realtek_priv *priv, bool enable)
 {
-	return regmap_update_bits(smi->map, RTL8365MB_INTR_CTRL_REG,
+	return regmap_update_bits(priv->map, RTL8365MB_INTR_CTRL_REG,
 				  RTL8365MB_INTR_LINK_CHANGE_MASK,
 				  FIELD_PREP(RTL8365MB_INTR_LINK_CHANGE_MASK,
 					     enable ? 1 : 0));
 }
 
-static int rtl8365mb_irq_enable(struct realtek_smi *smi)
+static int rtl8365mb_irq_enable(struct realtek_priv *priv)
 {
-	return rtl8365mb_set_irq_enable(smi, true);
+	return rtl8365mb_set_irq_enable(priv, true);
 }
 
-static int rtl8365mb_irq_disable(struct realtek_smi *smi)
+static int rtl8365mb_irq_disable(struct realtek_priv *priv)
 {
-	return rtl8365mb_set_irq_enable(smi, false);
+	return rtl8365mb_set_irq_enable(priv, false);
 }
 
-static int rtl8365mb_irq_setup(struct realtek_smi *smi)
+static int rtl8365mb_irq_setup(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	struct device_node *intc;
 	u32 irq_trig;
 	int virq;
@@ -1577,9 +1577,9 @@ static int rtl8365mb_irq_setup(struct realtek_smi *smi)
 	int ret;
 	int i;
 
-	intc = of_get_child_by_name(smi->dev->of_node, "interrupt-controller");
+	intc = of_get_child_by_name(priv->dev->of_node, "interrupt-controller");
 	if (!intc) {
-		dev_err(smi->dev, "missing child interrupt-controller node\n");
+		dev_err(priv->dev, "missing child interrupt-controller node\n");
 		return -EINVAL;
 	}
 
@@ -1587,24 +1587,24 @@ static int rtl8365mb_irq_setup(struct realtek_smi *smi)
 	irq = of_irq_get(intc, 0);
 	if (irq <= 0) {
 		if (irq != -EPROBE_DEFER)
-			dev_err(smi->dev, "failed to get parent irq: %d\n",
+			dev_err(priv->dev, "failed to get parent irq: %d\n",
 				irq);
 		ret = irq ? irq : -EINVAL;
 		goto out_put_node;
 	}
 
-	smi->irqdomain = irq_domain_add_linear(intc, smi->num_ports,
-					       &rtl8365mb_irqdomain_ops, smi);
-	if (!smi->irqdomain) {
-		dev_err(smi->dev, "failed to add irq domain\n");
+	priv->irqdomain = irq_domain_add_linear(intc, priv->num_ports,
+						&rtl8365mb_irqdomain_ops, priv);
+	if (!priv->irqdomain) {
+		dev_err(priv->dev, "failed to add irq domain\n");
 		ret = -ENOMEM;
 		goto out_put_node;
 	}
 
-	for (i = 0; i < smi->num_ports; i++) {
-		virq = irq_create_mapping(smi->irqdomain, i);
+	for (i = 0; i < priv->num_ports; i++) {
+		virq = irq_create_mapping(priv->irqdomain, i);
 		if (!virq) {
-			dev_err(smi->dev,
+			dev_err(priv->dev,
 				"failed to create irq domain mapping\n");
 			ret = -EINVAL;
 			goto out_remove_irqdomain;
@@ -1625,40 +1625,40 @@ static int rtl8365mb_irq_setup(struct realtek_smi *smi)
 		val = RTL8365MB_INTR_POLARITY_LOW;
 		break;
 	default:
-		dev_err(smi->dev, "unsupported irq trigger type %u\n",
+		dev_err(priv->dev, "unsupported irq trigger type %u\n",
 			irq_trig);
 		ret = -EINVAL;
 		goto out_remove_irqdomain;
 	}
 
-	ret = regmap_update_bits(smi->map, RTL8365MB_INTR_POLARITY_REG,
+	ret = regmap_update_bits(priv->map, RTL8365MB_INTR_POLARITY_REG,
 				 RTL8365MB_INTR_POLARITY_MASK,
 				 FIELD_PREP(RTL8365MB_INTR_POLARITY_MASK, val));
 	if (ret)
 		goto out_remove_irqdomain;
 
 	/* Disable the interrupt in case the chip has it enabled on reset */
-	ret = rtl8365mb_irq_disable(smi);
+	ret = rtl8365mb_irq_disable(priv);
 	if (ret)
 		goto out_remove_irqdomain;
 
 	/* Clear the interrupt status register */
-	ret = regmap_write(smi->map, RTL8365MB_INTR_STATUS_REG,
+	ret = regmap_write(priv->map, RTL8365MB_INTR_STATUS_REG,
 			   RTL8365MB_INTR_ALL_MASK);
 	if (ret)
 		goto out_remove_irqdomain;
 
 	ret = request_threaded_irq(irq, NULL, rtl8365mb_irq, IRQF_ONESHOT,
-				   "rtl8365mb", smi);
+				   "rtl8365mb", priv);
 	if (ret) {
-		dev_err(smi->dev, "failed to request irq: %d\n", ret);
+		dev_err(priv->dev, "failed to request irq: %d\n", ret);
 		goto out_remove_irqdomain;
 	}
 
 	/* Store the irq so that we know to free it during teardown */
 	mb->irq = irq;
 
-	ret = rtl8365mb_irq_enable(smi);
+	ret = rtl8365mb_irq_enable(priv);
 	if (ret)
 		goto out_free_irq;
 
@@ -1667,17 +1667,17 @@ static int rtl8365mb_irq_setup(struct realtek_smi *smi)
 	return 0;
 
 out_free_irq:
-	free_irq(mb->irq, smi);
+	free_irq(mb->irq, priv);
 	mb->irq = 0;
 
 out_remove_irqdomain:
-	for (i = 0; i < smi->num_ports; i++) {
-		virq = irq_find_mapping(smi->irqdomain, i);
+	for (i = 0; i < priv->num_ports; i++) {
+		virq = irq_find_mapping(priv->irqdomain, i);
 		irq_dispose_mapping(virq);
 	}
 
-	irq_domain_remove(smi->irqdomain);
-	smi->irqdomain = NULL;
+	irq_domain_remove(priv->irqdomain);
+	priv->irqdomain = NULL;
 
 out_put_node:
 	of_node_put(intc);
@@ -1685,36 +1685,36 @@ static int rtl8365mb_irq_setup(struct realtek_smi *smi)
 	return ret;
 }
 
-static void rtl8365mb_irq_teardown(struct realtek_smi *smi)
+static void rtl8365mb_irq_teardown(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	int virq;
 	int i;
 
 	if (mb->irq) {
-		free_irq(mb->irq, smi);
+		free_irq(mb->irq, priv);
 		mb->irq = 0;
 	}
 
-	if (smi->irqdomain) {
-		for (i = 0; i < smi->num_ports; i++) {
-			virq = irq_find_mapping(smi->irqdomain, i);
+	if (priv->irqdomain) {
+		for (i = 0; i < priv->num_ports; i++) {
+			virq = irq_find_mapping(priv->irqdomain, i);
 			irq_dispose_mapping(virq);
 		}
 
-		irq_domain_remove(smi->irqdomain);
-		smi->irqdomain = NULL;
+		irq_domain_remove(priv->irqdomain);
+		priv->irqdomain = NULL;
 	}
 }
 
-static int rtl8365mb_cpu_config(struct realtek_smi *smi)
+static int rtl8365mb_cpu_config(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	struct rtl8365mb_cpu *cpu = &mb->cpu;
 	u32 val;
 	int ret;
 
-	ret = regmap_update_bits(smi->map, RTL8365MB_CPU_PORT_MASK_REG,
+	ret = regmap_update_bits(priv->map, RTL8365MB_CPU_PORT_MASK_REG,
 				 RTL8365MB_CPU_PORT_MASK_MASK,
 				 FIELD_PREP(RTL8365MB_CPU_PORT_MASK_MASK,
 					    cpu->mask));
@@ -1729,23 +1729,23 @@ static int rtl8365mb_cpu_config(struct realtek_smi *smi)
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_port) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
 			 cpu->trap_port >> 3);
-	ret = regmap_write(smi->map, RTL8365MB_CPU_CTRL_REG, val);
+	ret = regmap_write(priv->map, RTL8365MB_CPU_CTRL_REG, val);
 	if (ret)
 		return ret;
 
 	return 0;
 }
 
-static int rtl8365mb_switch_init(struct realtek_smi *smi)
+static int rtl8365mb_switch_init(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	int ret;
 	int i;
 
 	/* Do any chip-specific init jam before getting to the common stuff */
 	if (mb->jam_table) {
 		for (i = 0; i < mb->jam_size; i++) {
-			ret = regmap_write(smi->map, mb->jam_table[i].reg,
+			ret = regmap_write(priv->map, mb->jam_table[i].reg,
 					   mb->jam_table[i].val);
 			if (ret)
 				return ret;
@@ -1754,7 +1754,7 @@ static int rtl8365mb_switch_init(struct realtek_smi *smi)
 
 	/* Common init jam */
 	for (i = 0; i < ARRAY_SIZE(rtl8365mb_init_jam_common); i++) {
-		ret = regmap_write(smi->map, rtl8365mb_init_jam_common[i].reg,
+		ret = regmap_write(priv->map, rtl8365mb_init_jam_common[i].reg,
 				   rtl8365mb_init_jam_common[i].val);
 		if (ret)
 			return ret;
@@ -1763,11 +1763,11 @@ static int rtl8365mb_switch_init(struct realtek_smi *smi)
 	return 0;
 }
 
-static int rtl8365mb_reset_chip(struct realtek_smi *smi)
+static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 {
 	u32 val;
 
-	realtek_smi_write_reg_noack(smi, RTL8365MB_CHIP_RESET_REG,
+	realtek_smi_write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
 				    FIELD_PREP(RTL8365MB_CHIP_RESET_HW_MASK,
 					       1));
 
@@ -1775,63 +1775,63 @@ static int rtl8365mb_reset_chip(struct realtek_smi *smi)
 	 * for 100 ms before accessing any registers to prevent ACK timeouts.
 	 */
 	msleep(100);
-	return regmap_read_poll_timeout(smi->map, RTL8365MB_CHIP_RESET_REG, val,
+	return regmap_read_poll_timeout(priv->map, RTL8365MB_CHIP_RESET_REG, val,
 					!(val & RTL8365MB_CHIP_RESET_HW_MASK),
 					20000, 1e6);
 }
 
 static int rtl8365mb_setup(struct dsa_switch *ds)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
 
-	mb = smi->chip_data;
+	mb = priv->chip_data;
 
-	ret = rtl8365mb_reset_chip(smi);
+	ret = rtl8365mb_reset_chip(priv);
 	if (ret) {
-		dev_err(smi->dev, "failed to reset chip: %d\n", ret);
+		dev_err(priv->dev, "failed to reset chip: %d\n", ret);
 		goto out_error;
 	}
 
 	/* Configure switch to vendor-defined initial state */
-	ret = rtl8365mb_switch_init(smi);
+	ret = rtl8365mb_switch_init(priv);
 	if (ret) {
-		dev_err(smi->dev, "failed to initialize switch: %d\n", ret);
+		dev_err(priv->dev, "failed to initialize switch: %d\n", ret);
 		goto out_error;
 	}
 
 	/* Set up cascading IRQs */
-	ret = rtl8365mb_irq_setup(smi);
+	ret = rtl8365mb_irq_setup(priv);
 	if (ret == -EPROBE_DEFER)
 		return ret;
 	else if (ret)
-		dev_info(smi->dev, "no interrupt support\n");
+		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	ret = rtl8365mb_cpu_config(smi);
+	ret = rtl8365mb_cpu_config(priv);
 	if (ret)
 		goto out_teardown_irq;
 
 	/* Configure ports */
-	for (i = 0; i < smi->num_ports; i++) {
+	for (i = 0; i < priv->num_ports; i++) {
 		struct rtl8365mb_port *p = &mb->ports[i];
 
-		if (dsa_is_unused_port(smi->ds, i))
+		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
 		/* Set up per-port private data */
-		p->smi = smi;
+		p->priv = priv;
 		p->index = i;
 
 		/* Forward only to the CPU */
-		ret = rtl8365mb_port_set_isolation(smi, i, BIT(smi->cpu_port));
+		ret = rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
 		if (ret)
 			goto out_teardown_irq;
 
 		/* Disable learning */
-		ret = rtl8365mb_port_set_learning(smi, i, false);
+		ret = rtl8365mb_port_set_learning(priv, i, false);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -1839,29 +1839,29 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		 * ports will still forward frames to the CPU despite being
 		 * administratively down by default.
 		 */
-		rtl8365mb_port_stp_state_set(smi->ds, i, BR_STATE_DISABLED);
+		rtl8365mb_port_stp_state_set(priv->ds, i, BR_STATE_DISABLED);
 	}
 
 	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(smi->map, RTL8365MB_CFG0_MAX_LEN_REG,
+	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
 				 RTL8365MB_CFG0_MAX_LEN_MASK,
 				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
 	if (ret)
 		goto out_teardown_irq;
 
-	ret = realtek_smi_setup_mdio(smi);
+	ret = realtek_smi_setup_mdio(priv);
 	if (ret) {
-		dev_err(smi->dev, "could not set up MDIO bus\n");
+		dev_err(priv->dev, "could not set up MDIO bus\n");
 		goto out_teardown_irq;
 	}
 
 	/* Start statistics counter polling */
-	rtl8365mb_stats_setup(smi);
+	rtl8365mb_stats_setup(priv);
 
 	return 0;
 
 out_teardown_irq:
-	rtl8365mb_irq_teardown(smi);
+	rtl8365mb_irq_teardown(priv);
 
 out_error:
 	return ret;
@@ -1869,10 +1869,10 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 
 static void rtl8365mb_teardown(struct dsa_switch *ds)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 
-	rtl8365mb_stats_teardown(smi);
-	rtl8365mb_irq_teardown(smi);
+	rtl8365mb_stats_teardown(priv);
+	rtl8365mb_irq_teardown(priv);
 }
 
 static int rtl8365mb_get_chip_id_and_ver(struct regmap *map, u32 *id, u32 *ver)
@@ -1902,40 +1902,40 @@ static int rtl8365mb_get_chip_id_and_ver(struct regmap *map, u32 *id, u32 *ver)
 	return 0;
 }
 
-static int rtl8365mb_detect(struct realtek_smi *smi)
+static int rtl8365mb_detect(struct realtek_priv *priv)
 {
-	struct rtl8365mb *mb = smi->chip_data;
+	struct rtl8365mb *mb = priv->chip_data;
 	u32 chip_id;
 	u32 chip_ver;
 	int ret;
 
-	ret = rtl8365mb_get_chip_id_and_ver(smi->map, &chip_id, &chip_ver);
+	ret = rtl8365mb_get_chip_id_and_ver(priv->map, &chip_id, &chip_ver);
 	if (ret) {
-		dev_err(smi->dev, "failed to read chip id and version: %d\n",
+		dev_err(priv->dev, "failed to read chip id and version: %d\n",
 			ret);
 		return ret;
 	}
 
 	switch (chip_id) {
 	case RTL8365MB_CHIP_ID_8365MB_VC:
-		dev_info(smi->dev,
+		dev_info(priv->dev,
 			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
 			 chip_ver);
 
-		smi->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
-		smi->num_ports = smi->cpu_port + 1;
+		priv->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
+		priv->num_ports = priv->cpu_port + 1;
 
-		mb->smi = smi;
+		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = BIT(smi->num_ports) - 1;
+		mb->port_mask = BIT(priv->num_ports) - 1;
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
 		mb->cpu.enable = 1;
-		mb->cpu.mask = BIT(smi->cpu_port);
-		mb->cpu.trap_port = smi->cpu_port;
+		mb->cpu.mask = BIT(priv->cpu_port);
+		mb->cpu.trap_port = priv->cpu_port;
 		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
 		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
 		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
@@ -1943,7 +1943,7 @@ static int rtl8365mb_detect(struct realtek_smi *smi)
 
 		break;
 	default:
-		dev_err(smi->dev,
+		dev_err(priv->dev,
 			"found an unknown Realtek switch (id=0x%04x, ver=0x%04x)\n",
 			chip_id, chip_ver);
 		return -ENODEV;
@@ -1970,15 +1970,15 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 	.get_stats64 = rtl8365mb_get_stats64,
 };
 
-static const struct realtek_smi_ops rtl8365mb_smi_ops = {
+static const struct realtek_ops rtl8365mb_ops = {
 	.detect = rtl8365mb_detect,
 	.phy_read = rtl8365mb_phy_read,
 	.phy_write = rtl8365mb_phy_write,
 };
 
-const struct realtek_smi_variant rtl8365mb_variant = {
+const struct realtek_variant rtl8365mb_variant = {
 	.ds_ops = &rtl8365mb_switch_ops,
-	.ops = &rtl8365mb_smi_ops,
+	.ops = &rtl8365mb_ops,
 	.clk_delay = 10,
 	.cmd_read = 0xb9,
 	.cmd_write = 0xb8,
diff --git a/drivers/net/dsa/realtek/rtl8366.c b/drivers/net/dsa/realtek/rtl8366.c
index bdb8d8d34880..dc5f75be3017 100644
--- a/drivers/net/dsa/realtek/rtl8366.c
+++ b/drivers/net/dsa/realtek/rtl8366.c
@@ -11,18 +11,18 @@
 #include <linux/if_bridge.h>
 #include <net/dsa.h>
 
-#include "realtek-smi-core.h"
+#include "realtek.h"
 
-int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used)
+int rtl8366_mc_is_used(struct realtek_priv *priv, int mc_index, int *used)
 {
 	int ret;
 	int i;
 
 	*used = 0;
-	for (i = 0; i < smi->num_ports; i++) {
+	for (i = 0; i < priv->num_ports; i++) {
 		int index = 0;
 
-		ret = smi->ops->get_mc_index(smi, i, &index);
+		ret = priv->ops->get_mc_index(priv, i, &index);
 		if (ret)
 			return ret;
 
@@ -38,13 +38,13 @@ EXPORT_SYMBOL_GPL(rtl8366_mc_is_used);
 
 /**
  * rtl8366_obtain_mc() - retrieve or allocate a VLAN member configuration
- * @smi: the Realtek SMI device instance
+ * @priv: the Realtek SMI device instance
  * @vid: the VLAN ID to look up or allocate
  * @vlanmc: the pointer will be assigned to a pointer to a valid member config
  * if successful
  * @return: index of a new member config or negative error number
  */
-static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
+static int rtl8366_obtain_mc(struct realtek_priv *priv, int vid,
 			     struct rtl8366_vlan_mc *vlanmc)
 {
 	struct rtl8366_vlan_4k vlan4k;
@@ -52,10 +52,10 @@ static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
 	int i;
 
 	/* Try to find an existing member config entry for this VID */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->get_vlan_mc(smi, i, vlanmc);
+	for (i = 0; i < priv->num_vlan_mc; i++) {
+		ret = priv->ops->get_vlan_mc(priv, i, vlanmc);
 		if (ret) {
-			dev_err(smi->dev, "error searching for VLAN MC %d for VID %d\n",
+			dev_err(priv->dev, "error searching for VLAN MC %d for VID %d\n",
 				i, vid);
 			return ret;
 		}
@@ -65,19 +65,19 @@ static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
 	}
 
 	/* We have no MC entry for this VID, try to find an empty one */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->get_vlan_mc(smi, i, vlanmc);
+	for (i = 0; i < priv->num_vlan_mc; i++) {
+		ret = priv->ops->get_vlan_mc(priv, i, vlanmc);
 		if (ret) {
-			dev_err(smi->dev, "error searching for VLAN MC %d for VID %d\n",
+			dev_err(priv->dev, "error searching for VLAN MC %d for VID %d\n",
 				i, vid);
 			return ret;
 		}
 
 		if (vlanmc->vid == 0 && vlanmc->member == 0) {
 			/* Update the entry from the 4K table */
-			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+			ret = priv->ops->get_vlan_4k(priv, vid, &vlan4k);
 			if (ret) {
-				dev_err(smi->dev, "error looking for 4K VLAN MC %d for VID %d\n",
+				dev_err(priv->dev, "error looking for 4K VLAN MC %d for VID %d\n",
 					i, vid);
 				return ret;
 			}
@@ -86,30 +86,30 @@ static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
 			vlanmc->member = vlan4k.member;
 			vlanmc->untag = vlan4k.untag;
 			vlanmc->fid = vlan4k.fid;
-			ret = smi->ops->set_vlan_mc(smi, i, vlanmc);
+			ret = priv->ops->set_vlan_mc(priv, i, vlanmc);
 			if (ret) {
-				dev_err(smi->dev, "unable to set/update VLAN MC %d for VID %d\n",
+				dev_err(priv->dev, "unable to set/update VLAN MC %d for VID %d\n",
 					i, vid);
 				return ret;
 			}
 
-			dev_dbg(smi->dev, "created new MC at index %d for VID %d\n",
+			dev_dbg(priv->dev, "created new MC at index %d for VID %d\n",
 				i, vid);
 			return i;
 		}
 	}
 
 	/* MC table is full, try to find an unused entry and replace it */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
+	for (i = 0; i < priv->num_vlan_mc; i++) {
 		int used;
 
-		ret = rtl8366_mc_is_used(smi, i, &used);
+		ret = rtl8366_mc_is_used(priv, i, &used);
 		if (ret)
 			return ret;
 
 		if (!used) {
 			/* Update the entry from the 4K table */
-			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+			ret = priv->ops->get_vlan_4k(priv, vid, &vlan4k);
 			if (ret)
 				return ret;
 
@@ -117,23 +117,23 @@ static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
 			vlanmc->member = vlan4k.member;
 			vlanmc->untag = vlan4k.untag;
 			vlanmc->fid = vlan4k.fid;
-			ret = smi->ops->set_vlan_mc(smi, i, vlanmc);
+			ret = priv->ops->set_vlan_mc(priv, i, vlanmc);
 			if (ret) {
-				dev_err(smi->dev, "unable to set/update VLAN MC %d for VID %d\n",
+				dev_err(priv->dev, "unable to set/update VLAN MC %d for VID %d\n",
 					i, vid);
 				return ret;
 			}
-			dev_dbg(smi->dev, "recycled MC at index %i for VID %d\n",
+			dev_dbg(priv->dev, "recycled MC at index %i for VID %d\n",
 				i, vid);
 			return i;
 		}
 	}
 
-	dev_err(smi->dev, "all VLAN member configurations are in use\n");
+	dev_err(priv->dev, "all VLAN member configurations are in use\n");
 	return -ENOSPC;
 }
 
-int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
+int rtl8366_set_vlan(struct realtek_priv *priv, int vid, u32 member,
 		     u32 untag, u32 fid)
 {
 	struct rtl8366_vlan_mc vlanmc;
@@ -141,31 +141,31 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int mc;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, vid))
+	if (!priv->ops->is_vlan_valid(priv, vid))
 		return -EINVAL;
 
-	dev_dbg(smi->dev,
+	dev_dbg(priv->dev,
 		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, member, untag);
 
 	/* Update the 4K table */
-	ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+	ret = priv->ops->get_vlan_4k(priv, vid, &vlan4k);
 	if (ret)
 		return ret;
 
 	vlan4k.member |= member;
 	vlan4k.untag |= untag;
 	vlan4k.fid = fid;
-	ret = smi->ops->set_vlan_4k(smi, &vlan4k);
+	ret = priv->ops->set_vlan_4k(priv, &vlan4k);
 	if (ret)
 		return ret;
 
-	dev_dbg(smi->dev,
+	dev_dbg(priv->dev,
 		"resulting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, vlan4k.member, vlan4k.untag);
 
 	/* Find or allocate a member config for this VID */
-	ret = rtl8366_obtain_mc(smi, vid, &vlanmc);
+	ret = rtl8366_obtain_mc(priv, vid, &vlanmc);
 	if (ret < 0)
 		return ret;
 	mc = ret;
@@ -176,12 +176,12 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	vlanmc.fid = fid;
 
 	/* Commit updates to the MC entry */
-	ret = smi->ops->set_vlan_mc(smi, mc, &vlanmc);
+	ret = priv->ops->set_vlan_mc(priv, mc, &vlanmc);
 	if (ret)
-		dev_err(smi->dev, "failed to commit changes to VLAN MC index %d for VID %d\n",
+		dev_err(priv->dev, "failed to commit changes to VLAN MC index %d for VID %d\n",
 			mc, vid);
 	else
-		dev_dbg(smi->dev,
+		dev_dbg(priv->dev,
 			"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
 			vid, vlanmc.member, vlanmc.untag);
 
@@ -189,37 +189,37 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 }
 EXPORT_SYMBOL_GPL(rtl8366_set_vlan);
 
-int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
+int rtl8366_set_pvid(struct realtek_priv *priv, unsigned int port,
 		     unsigned int vid)
 {
 	struct rtl8366_vlan_mc vlanmc;
 	int mc;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, vid))
+	if (!priv->ops->is_vlan_valid(priv, vid))
 		return -EINVAL;
 
 	/* Find or allocate a member config for this VID */
-	ret = rtl8366_obtain_mc(smi, vid, &vlanmc);
+	ret = rtl8366_obtain_mc(priv, vid, &vlanmc);
 	if (ret < 0)
 		return ret;
 	mc = ret;
 
-	ret = smi->ops->set_mc_index(smi, port, mc);
+	ret = priv->ops->set_mc_index(priv, port, mc);
 	if (ret) {
-		dev_err(smi->dev, "set PVID: failed to set MC index %d for port %d\n",
+		dev_err(priv->dev, "set PVID: failed to set MC index %d for port %d\n",
 			mc, port);
 		return ret;
 	}
 
-	dev_dbg(smi->dev, "set PVID: the PVID for port %d set to %d using existing MC index %d\n",
+	dev_dbg(priv->dev, "set PVID: the PVID for port %d set to %d using existing MC index %d\n",
 		port, vid, mc);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8366_set_pvid);
 
-int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable)
+int rtl8366_enable_vlan4k(struct realtek_priv *priv, bool enable)
 {
 	int ret;
 
@@ -229,52 +229,52 @@ int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable)
 	 */
 	if (enable) {
 		/* Make sure VLAN is ON */
-		ret = smi->ops->enable_vlan(smi, true);
+		ret = priv->ops->enable_vlan(priv, true);
 		if (ret)
 			return ret;
 
-		smi->vlan_enabled = true;
+		priv->vlan_enabled = true;
 	}
 
-	ret = smi->ops->enable_vlan4k(smi, enable);
+	ret = priv->ops->enable_vlan4k(priv, enable);
 	if (ret)
 		return ret;
 
-	smi->vlan4k_enabled = enable;
+	priv->vlan4k_enabled = enable;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8366_enable_vlan4k);
 
-int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable)
+int rtl8366_enable_vlan(struct realtek_priv *priv, bool enable)
 {
 	int ret;
 
-	ret = smi->ops->enable_vlan(smi, enable);
+	ret = priv->ops->enable_vlan(priv, enable);
 	if (ret)
 		return ret;
 
-	smi->vlan_enabled = enable;
+	priv->vlan_enabled = enable;
 
 	/* If we turn VLAN off, make sure that we turn off
 	 * 4k VLAN as well, if that happened to be on.
 	 */
 	if (!enable) {
-		smi->vlan4k_enabled = false;
-		ret = smi->ops->enable_vlan4k(smi, false);
+		priv->vlan4k_enabled = false;
+		ret = priv->ops->enable_vlan4k(priv, false);
 	}
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rtl8366_enable_vlan);
 
-int rtl8366_reset_vlan(struct realtek_smi *smi)
+int rtl8366_reset_vlan(struct realtek_priv *priv)
 {
 	struct rtl8366_vlan_mc vlanmc;
 	int ret;
 	int i;
 
-	rtl8366_enable_vlan(smi, false);
-	rtl8366_enable_vlan4k(smi, false);
+	rtl8366_enable_vlan(priv, false);
+	rtl8366_enable_vlan4k(priv, false);
 
 	/* Clear the 16 VLAN member configurations */
 	vlanmc.vid = 0;
@@ -282,8 +282,8 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
 	vlanmc.member = 0;
 	vlanmc.untag = 0;
 	vlanmc.fid = 0;
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
+	for (i = 0; i < priv->num_vlan_mc; i++) {
+		ret = priv->ops->set_vlan_mc(priv, i, &vlanmc);
 		if (ret)
 			return ret;
 	}
@@ -298,12 +298,12 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 {
 	bool untagged = !!(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
 	bool pvid = !!(vlan->flags & BRIDGE_VLAN_INFO_PVID);
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	u32 member = 0;
 	u32 untag = 0;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, vlan->vid)) {
+	if (!priv->ops->is_vlan_valid(priv, vlan->vid)) {
 		NL_SET_ERR_MSG_MOD(extack, "VLAN ID not valid");
 		return -EINVAL;
 	}
@@ -312,13 +312,13 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	 * FIXME: what's with this 4k business?
 	 * Just rtl8366_enable_vlan() seems inconclusive.
 	 */
-	ret = rtl8366_enable_vlan4k(smi, true);
+	ret = rtl8366_enable_vlan4k(priv, true);
 	if (ret) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to enable VLAN 4K");
 		return ret;
 	}
 
-	dev_dbg(smi->dev, "add VLAN %d on port %d, %s, %s\n",
+	dev_dbg(priv->dev, "add VLAN %d on port %d, %s, %s\n",
 		vlan->vid, port, untagged ? "untagged" : "tagged",
 		pvid ? "PVID" : "no PVID");
 
@@ -327,18 +327,18 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	if (untagged)
 		untag |= BIT(port);
 
-	ret = rtl8366_set_vlan(smi, vlan->vid, member, untag, 0);
+	ret = rtl8366_set_vlan(priv, vlan->vid, member, untag, 0);
 	if (ret) {
-		dev_err(smi->dev, "failed to set up VLAN %04x", vlan->vid);
+		dev_err(priv->dev, "failed to set up VLAN %04x", vlan->vid);
 		return ret;
 	}
 
 	if (!pvid)
 		return 0;
 
-	ret = rtl8366_set_pvid(smi, port, vlan->vid);
+	ret = rtl8366_set_pvid(priv, port, vlan->vid);
 	if (ret) {
-		dev_err(smi->dev, "failed to set PVID on port %d to VLAN %04x",
+		dev_err(priv->dev, "failed to set PVID on port %d to VLAN %04x",
 			port, vlan->vid);
 		return ret;
 	}
@@ -350,15 +350,15 @@ EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret, i;
 
-	dev_dbg(smi->dev, "del VLAN %d on port %d\n", vlan->vid, port);
+	dev_dbg(priv->dev, "del VLAN %d on port %d\n", vlan->vid, port);
 
-	for (i = 0; i < smi->num_vlan_mc; i++) {
+	for (i = 0; i < priv->num_vlan_mc; i++) {
 		struct rtl8366_vlan_mc vlanmc;
 
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
+		ret = priv->ops->get_vlan_mc(priv, i, &vlanmc);
 		if (ret)
 			return ret;
 
@@ -376,9 +376,9 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 				vlanmc.priority = 0;
 				vlanmc.fid = 0;
 			}
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
+			ret = priv->ops->set_vlan_mc(priv, i, &vlanmc);
 			if (ret) {
-				dev_err(smi->dev,
+				dev_err(priv->dev,
 					"failed to remove VLAN %04x\n",
 					vlan->vid);
 				return ret;
@@ -394,15 +394,15 @@ EXPORT_SYMBOL_GPL(rtl8366_vlan_del);
 void rtl8366_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 			 uint8_t *data)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8366_mib_counter *mib;
 	int i;
 
-	if (port >= smi->num_ports)
+	if (port >= priv->num_ports)
 		return;
 
-	for (i = 0; i < smi->num_mib_counters; i++) {
-		mib = &smi->mib_counters[i];
+	for (i = 0; i < priv->num_mib_counters; i++) {
+		mib = &priv->mib_counters[i];
 		strncpy(data + i * ETH_GSTRING_LEN,
 			mib->name, ETH_GSTRING_LEN);
 	}
@@ -411,35 +411,35 @@ EXPORT_SYMBOL_GPL(rtl8366_get_strings);
 
 int rtl8366_get_sset_count(struct dsa_switch *ds, int port, int sset)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 
 	/* We only support SS_STATS */
 	if (sset != ETH_SS_STATS)
 		return 0;
-	if (port >= smi->num_ports)
+	if (port >= priv->num_ports)
 		return -EINVAL;
 
-	return smi->num_mib_counters;
+	return priv->num_mib_counters;
 }
 EXPORT_SYMBOL_GPL(rtl8366_get_sset_count);
 
 void rtl8366_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int i;
 	int ret;
 
-	if (port >= smi->num_ports)
+	if (port >= priv->num_ports)
 		return;
 
-	for (i = 0; i < smi->num_mib_counters; i++) {
+	for (i = 0; i < priv->num_mib_counters; i++) {
 		struct rtl8366_mib_counter *mib;
 		u64 mibvalue = 0;
 
-		mib = &smi->mib_counters[i];
-		ret = smi->ops->get_mib_counter(smi, port, mib, &mibvalue);
+		mib = &priv->mib_counters[i];
+		ret = priv->ops->get_mib_counter(priv, port, mib, &mibvalue);
 		if (ret) {
-			dev_err(smi->dev, "error reading MIB counter %s\n",
+			dev_err(priv->dev, "error reading MIB counter %s\n",
 				mib->name);
 		}
 		data[i] = mibvalue;
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index ecc19bd5115f..241e6b6ebea5 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -21,7 +21,7 @@
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 
-#include "realtek-smi-core.h"
+#include "realtek.h"
 
 #define RTL8366RB_PORT_NUM_CPU		5
 #define RTL8366RB_NUM_PORTS		6
@@ -396,7 +396,7 @@ static struct rtl8366_mib_counter rtl8366rb_mib_counters[] = {
 	{ 0, 70, 2, "IfOutBroadcastPkts"			},
 };
 
-static int rtl8366rb_get_mib_counter(struct realtek_smi *smi,
+static int rtl8366rb_get_mib_counter(struct realtek_priv *priv,
 				     int port,
 				     struct rtl8366_mib_counter *mib,
 				     u64 *mibvalue)
@@ -412,12 +412,12 @@ static int rtl8366rb_get_mib_counter(struct realtek_smi *smi,
 	/* Writing access counter address first
 	 * then ASIC will prepare 64bits counter wait for being retrived
 	 */
-	ret = regmap_write(smi->map, addr, 0); /* Write whatever */
+	ret = regmap_write(priv->map, addr, 0); /* Write whatever */
 	if (ret)
 		return ret;
 
 	/* Read MIB control register */
-	ret = regmap_read(smi->map, RTL8366RB_MIB_CTRL_REG, &val);
+	ret = regmap_read(priv->map, RTL8366RB_MIB_CTRL_REG, &val);
 	if (ret)
 		return -EIO;
 
@@ -430,7 +430,7 @@ static int rtl8366rb_get_mib_counter(struct realtek_smi *smi,
 	/* Read each individual MIB 16 bits at the time */
 	*mibvalue = 0;
 	for (i = mib->length; i > 0; i--) {
-		ret = regmap_read(smi->map, addr + (i - 1), &val);
+		ret = regmap_read(priv->map, addr + (i - 1), &val);
 		if (ret)
 			return ret;
 		*mibvalue = (*mibvalue << 16) | (val & 0xFFFF);
@@ -455,38 +455,38 @@ static u32 rtl8366rb_get_irqmask(struct irq_data *d)
 
 static void rtl8366rb_mask_irq(struct irq_data *d)
 {
-	struct realtek_smi *smi = irq_data_get_irq_chip_data(d);
+	struct realtek_priv *priv = irq_data_get_irq_chip_data(d);
 	int ret;
 
-	ret = regmap_update_bits(smi->map, RTL8366RB_INTERRUPT_MASK_REG,
+	ret = regmap_update_bits(priv->map, RTL8366RB_INTERRUPT_MASK_REG,
 				 rtl8366rb_get_irqmask(d), 0);
 	if (ret)
-		dev_err(smi->dev, "could not mask IRQ\n");
+		dev_err(priv->dev, "could not mask IRQ\n");
 }
 
 static void rtl8366rb_unmask_irq(struct irq_data *d)
 {
-	struct realtek_smi *smi = irq_data_get_irq_chip_data(d);
+	struct realtek_priv *priv = irq_data_get_irq_chip_data(d);
 	int ret;
 
-	ret = regmap_update_bits(smi->map, RTL8366RB_INTERRUPT_MASK_REG,
+	ret = regmap_update_bits(priv->map, RTL8366RB_INTERRUPT_MASK_REG,
 				 rtl8366rb_get_irqmask(d),
 				 rtl8366rb_get_irqmask(d));
 	if (ret)
-		dev_err(smi->dev, "could not unmask IRQ\n");
+		dev_err(priv->dev, "could not unmask IRQ\n");
 }
 
 static irqreturn_t rtl8366rb_irq(int irq, void *data)
 {
-	struct realtek_smi *smi = data;
+	struct realtek_priv *priv = data;
 	u32 stat;
 	int ret;
 
 	/* This clears the IRQ status register */
-	ret = regmap_read(smi->map, RTL8366RB_INTERRUPT_STATUS_REG,
+	ret = regmap_read(priv->map, RTL8366RB_INTERRUPT_STATUS_REG,
 			  &stat);
 	if (ret) {
-		dev_err(smi->dev, "can't read interrupt status\n");
+		dev_err(priv->dev, "can't read interrupt status\n");
 		return IRQ_NONE;
 	}
 	stat &= RTL8366RB_INTERRUPT_VALID;
@@ -502,7 +502,7 @@ static irqreturn_t rtl8366rb_irq(int irq, void *data)
 		 */
 		if (line < 12 && line > 5)
 			line -= 5;
-		child_irq = irq_find_mapping(smi->irqdomain, line);
+		child_irq = irq_find_mapping(priv->irqdomain, line);
 		handle_nested_irq(child_irq);
 	}
 	return IRQ_HANDLED;
@@ -538,7 +538,7 @@ static const struct irq_domain_ops rtl8366rb_irqdomain_ops = {
 	.xlate  = irq_domain_xlate_onecell,
 };
 
-static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
+static int rtl8366rb_setup_cascaded_irq(struct realtek_priv *priv)
 {
 	struct device_node *intc;
 	unsigned long irq_trig;
@@ -547,24 +547,24 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 	u32 val;
 	int i;
 
-	intc = of_get_child_by_name(smi->dev->of_node, "interrupt-controller");
+	intc = of_get_child_by_name(priv->dev->of_node, "interrupt-controller");
 	if (!intc) {
-		dev_err(smi->dev, "missing child interrupt-controller node\n");
+		dev_err(priv->dev, "missing child interrupt-controller node\n");
 		return -EINVAL;
 	}
 	/* RB8366RB IRQs cascade off this one */
 	irq = of_irq_get(intc, 0);
 	if (irq <= 0) {
-		dev_err(smi->dev, "failed to get parent IRQ\n");
+		dev_err(priv->dev, "failed to get parent IRQ\n");
 		ret = irq ? irq : -EINVAL;
 		goto out_put_node;
 	}
 
 	/* This clears the IRQ status register */
-	ret = regmap_read(smi->map, RTL8366RB_INTERRUPT_STATUS_REG,
+	ret = regmap_read(priv->map, RTL8366RB_INTERRUPT_STATUS_REG,
 			  &val);
 	if (ret) {
-		dev_err(smi->dev, "can't read interrupt status\n");
+		dev_err(priv->dev, "can't read interrupt status\n");
 		goto out_put_node;
 	}
 
@@ -573,48 +573,48 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 	switch (irq_trig) {
 	case IRQF_TRIGGER_RISING:
 	case IRQF_TRIGGER_HIGH:
-		dev_info(smi->dev, "active high/rising IRQ\n");
+		dev_info(priv->dev, "active high/rising IRQ\n");
 		val = 0;
 		break;
 	case IRQF_TRIGGER_FALLING:
 	case IRQF_TRIGGER_LOW:
-		dev_info(smi->dev, "active low/falling IRQ\n");
+		dev_info(priv->dev, "active low/falling IRQ\n");
 		val = RTL8366RB_INTERRUPT_POLARITY;
 		break;
 	}
-	ret = regmap_update_bits(smi->map, RTL8366RB_INTERRUPT_CONTROL_REG,
+	ret = regmap_update_bits(priv->map, RTL8366RB_INTERRUPT_CONTROL_REG,
 				 RTL8366RB_INTERRUPT_POLARITY,
 				 val);
 	if (ret) {
-		dev_err(smi->dev, "could not configure IRQ polarity\n");
+		dev_err(priv->dev, "could not configure IRQ polarity\n");
 		goto out_put_node;
 	}
 
-	ret = devm_request_threaded_irq(smi->dev, irq, NULL,
+	ret = devm_request_threaded_irq(priv->dev, irq, NULL,
 					rtl8366rb_irq, IRQF_ONESHOT,
-					"RTL8366RB", smi);
+					"RTL8366RB", priv);
 	if (ret) {
-		dev_err(smi->dev, "unable to request irq: %d\n", ret);
+		dev_err(priv->dev, "unable to request irq: %d\n", ret);
 		goto out_put_node;
 	}
-	smi->irqdomain = irq_domain_add_linear(intc,
-					       RTL8366RB_NUM_INTERRUPT,
-					       &rtl8366rb_irqdomain_ops,
-					       smi);
-	if (!smi->irqdomain) {
-		dev_err(smi->dev, "failed to create IRQ domain\n");
+	priv->irqdomain = irq_domain_add_linear(intc,
+						RTL8366RB_NUM_INTERRUPT,
+						&rtl8366rb_irqdomain_ops,
+						priv);
+	if (!priv->irqdomain) {
+		dev_err(priv->dev, "failed to create IRQ domain\n");
 		ret = -EINVAL;
 		goto out_put_node;
 	}
-	for (i = 0; i < smi->num_ports; i++)
-		irq_set_parent(irq_create_mapping(smi->irqdomain, i), irq);
+	for (i = 0; i < priv->num_ports; i++)
+		irq_set_parent(irq_create_mapping(priv->irqdomain, i), irq);
 
 out_put_node:
 	of_node_put(intc);
 	return ret;
 }
 
-static int rtl8366rb_set_addr(struct realtek_smi *smi)
+static int rtl8366rb_set_addr(struct realtek_priv *priv)
 {
 	u8 addr[ETH_ALEN];
 	u16 val;
@@ -622,18 +622,18 @@ static int rtl8366rb_set_addr(struct realtek_smi *smi)
 
 	eth_random_addr(addr);
 
-	dev_info(smi->dev, "set MAC: %02X:%02X:%02X:%02X:%02X:%02X\n",
+	dev_info(priv->dev, "set MAC: %02X:%02X:%02X:%02X:%02X:%02X\n",
 		 addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
 	val = addr[0] << 8 | addr[1];
-	ret = regmap_write(smi->map, RTL8366RB_SMAR0, val);
+	ret = regmap_write(priv->map, RTL8366RB_SMAR0, val);
 	if (ret)
 		return ret;
 	val = addr[2] << 8 | addr[3];
-	ret = regmap_write(smi->map, RTL8366RB_SMAR1, val);
+	ret = regmap_write(priv->map, RTL8366RB_SMAR1, val);
 	if (ret)
 		return ret;
 	val = addr[4] << 8 | addr[5];
-	ret = regmap_write(smi->map, RTL8366RB_SMAR2, val);
+	ret = regmap_write(priv->map, RTL8366RB_SMAR2, val);
 	if (ret)
 		return ret;
 
@@ -765,7 +765,7 @@ static const struct rtl8366rb_jam_tbl_entry rtl8366rb_green_jam[] = {
 
 /* Function that jams the tables in the proper registers */
 static int rtl8366rb_jam_table(const struct rtl8366rb_jam_tbl_entry *jam_table,
-			       int jam_size, struct realtek_smi *smi,
+			       int jam_size, struct realtek_priv *priv,
 			       bool write_dbg)
 {
 	u32 val;
@@ -774,24 +774,24 @@ static int rtl8366rb_jam_table(const struct rtl8366rb_jam_tbl_entry *jam_table,
 
 	for (i = 0; i < jam_size; i++) {
 		if ((jam_table[i].reg & 0xBE00) == 0xBE00) {
-			ret = regmap_read(smi->map,
+			ret = regmap_read(priv->map,
 					  RTL8366RB_PHY_ACCESS_BUSY_REG,
 					  &val);
 			if (ret)
 				return ret;
 			if (!(val & RTL8366RB_PHY_INT_BUSY)) {
-				ret = regmap_write(smi->map,
-						RTL8366RB_PHY_ACCESS_CTRL_REG,
-						RTL8366RB_PHY_CTRL_WRITE);
+				ret = regmap_write(priv->map,
+						   RTL8366RB_PHY_ACCESS_CTRL_REG,
+						   RTL8366RB_PHY_CTRL_WRITE);
 				if (ret)
 					return ret;
 			}
 		}
 		if (write_dbg)
-			dev_dbg(smi->dev, "jam %04x into register %04x\n",
+			dev_dbg(priv->dev, "jam %04x into register %04x\n",
 				jam_table[i].val,
 				jam_table[i].reg);
-		ret = regmap_write(smi->map,
+		ret = regmap_write(priv->map,
 				   jam_table[i].reg,
 				   jam_table[i].val);
 		if (ret)
@@ -802,7 +802,7 @@ static int rtl8366rb_jam_table(const struct rtl8366rb_jam_tbl_entry *jam_table,
 
 static int rtl8366rb_setup(struct dsa_switch *ds)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	const struct rtl8366rb_jam_tbl_entry *jam_table;
 	struct rtl8366rb *rb;
 	u32 chip_ver = 0;
@@ -812,11 +812,11 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	int ret;
 	int i;
 
-	rb = smi->chip_data;
+	rb = priv->chip_data;
 
-	ret = regmap_read(smi->map, RTL8366RB_CHIP_ID_REG, &chip_id);
+	ret = regmap_read(priv->map, RTL8366RB_CHIP_ID_REG, &chip_id);
 	if (ret) {
-		dev_err(smi->dev, "unable to read chip id\n");
+		dev_err(priv->dev, "unable to read chip id\n");
 		return ret;
 	}
 
@@ -824,18 +824,18 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	case RTL8366RB_CHIP_ID_8366:
 		break;
 	default:
-		dev_err(smi->dev, "unknown chip id (%04x)\n", chip_id);
+		dev_err(priv->dev, "unknown chip id (%04x)\n", chip_id);
 		return -ENODEV;
 	}
 
-	ret = regmap_read(smi->map, RTL8366RB_CHIP_VERSION_CTRL_REG,
+	ret = regmap_read(priv->map, RTL8366RB_CHIP_VERSION_CTRL_REG,
 			  &chip_ver);
 	if (ret) {
-		dev_err(smi->dev, "unable to read chip version\n");
+		dev_err(priv->dev, "unable to read chip version\n");
 		return ret;
 	}
 
-	dev_info(smi->dev, "RTL%04x ver %u chip found\n",
+	dev_info(priv->dev, "RTL%04x ver %u chip found\n",
 		 chip_id, chip_ver & RTL8366RB_CHIP_VERSION_MASK);
 
 	/* Do the init dance using the right jam table */
@@ -872,20 +872,20 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		jam_size = ARRAY_SIZE(rtl8366rb_init_jam_dgn3500);
 	}
 
-	ret = rtl8366rb_jam_table(jam_table, jam_size, smi, true);
+	ret = rtl8366rb_jam_table(jam_table, jam_size, priv, true);
 	if (ret)
 		return ret;
 
 	/* Isolate all user ports so they can only send packets to itself and the CPU port */
 	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
-		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
+		ret = regmap_write(priv->map, RTL8366RB_PORT_ISO(i),
 				   RTL8366RB_PORT_ISO_PORTS(BIT(RTL8366RB_PORT_NUM_CPU)) |
 				   RTL8366RB_PORT_ISO_EN);
 		if (ret)
 			return ret;
 	}
 	/* CPU port can send packets to all ports */
-	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
+	ret = regmap_write(priv->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
 			   RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds)) |
 			   RTL8366RB_PORT_ISO_EN);
 	if (ret)
@@ -893,26 +893,26 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 
 	/* Set up the "green ethernet" feature */
 	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
-				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
+				  ARRAY_SIZE(rtl8366rb_green_jam), priv, false);
 	if (ret)
 		return ret;
 
-	ret = regmap_write(smi->map,
+	ret = regmap_write(priv->map,
 			   RTL8366RB_GREEN_FEATURE_REG,
 			   (chip_ver == 1) ? 0x0007 : 0x0003);
 	if (ret)
 		return ret;
 
 	/* Vendor driver sets 0x240 in registers 0xc and 0xd (undocumented) */
-	ret = regmap_write(smi->map, 0x0c, 0x240);
+	ret = regmap_write(priv->map, 0x0c, 0x240);
 	if (ret)
 		return ret;
-	ret = regmap_write(smi->map, 0x0d, 0x240);
+	ret = regmap_write(priv->map, 0x0d, 0x240);
 	if (ret)
 		return ret;
 
 	/* Set some random MAC address */
-	ret = rtl8366rb_set_addr(smi);
+	ret = rtl8366rb_set_addr(priv);
 	if (ret)
 		return ret;
 
@@ -921,21 +921,21 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	 * If you set RTL8368RB_CPU_NO_TAG (bit 15) in this registers
 	 * the custom tag is turned off.
 	 */
-	ret = regmap_update_bits(smi->map, RTL8368RB_CPU_CTRL_REG,
+	ret = regmap_update_bits(priv->map, RTL8368RB_CPU_CTRL_REG,
 				 0xFFFF,
-				 BIT(smi->cpu_port));
+				 BIT(priv->cpu_port));
 	if (ret)
 		return ret;
 
 	/* Make sure we default-enable the fixed CPU port */
-	ret = regmap_update_bits(smi->map, RTL8366RB_PECR,
-				 BIT(smi->cpu_port),
+	ret = regmap_update_bits(priv->map, RTL8366RB_PECR,
+				 BIT(priv->cpu_port),
 				 0);
 	if (ret)
 		return ret;
 
 	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(smi->map, RTL8366RB_SGCR,
+	ret = regmap_update_bits(priv->map, RTL8366RB_SGCR,
 				 RTL8366RB_SGCR_MAX_LENGTH_MASK,
 				 RTL8366RB_SGCR_MAX_LENGTH_1536);
 	if (ret)
@@ -945,13 +945,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		rb->max_mtu[i] = 1532;
 
 	/* Disable learning for all ports */
-	ret = regmap_write(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL,
+	ret = regmap_write(priv->map, RTL8366RB_PORT_LEARNDIS_CTRL,
 			   RTL8366RB_PORT_ALL);
 	if (ret)
 		return ret;
 
 	/* Enable auto ageing for all ports */
-	ret = regmap_write(smi->map, RTL8366RB_SECURITY_CTRL, 0);
+	ret = regmap_write(priv->map, RTL8366RB_SECURITY_CTRL, 0);
 	if (ret)
 		return ret;
 
@@ -962,30 +962,30 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	 * connected to something exotic such as fiber, then this might
 	 * be worth experimenting with.
 	 */
-	ret = regmap_update_bits(smi->map, RTL8366RB_PMC0,
+	ret = regmap_update_bits(priv->map, RTL8366RB_PMC0,
 				 RTL8366RB_PMC0_P4_IOMODE_MASK,
 				 0 << RTL8366RB_PMC0_P4_IOMODE_SHIFT);
 	if (ret)
 		return ret;
 
 	/* Accept all packets by default, we enable filtering on-demand */
-	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
+	ret = regmap_write(priv->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
 			   0);
 	if (ret)
 		return ret;
-	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
+	ret = regmap_write(priv->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
 			   0);
 	if (ret)
 		return ret;
 
 	/* Don't drop packets whose DA has not been learned */
-	ret = regmap_update_bits(smi->map, RTL8366RB_SSCR2,
+	ret = regmap_update_bits(priv->map, RTL8366RB_SSCR2,
 				 RTL8366RB_SSCR2_DROP_UNKNOWN_DA, 0);
 	if (ret)
 		return ret;
 
 	/* Set blinking, TODO: make this configurable */
-	ret = regmap_update_bits(smi->map, RTL8366RB_LED_BLINKRATE_REG,
+	ret = regmap_update_bits(priv->map, RTL8366RB_LED_BLINKRATE_REG,
 				 RTL8366RB_LED_BLINKRATE_MASK,
 				 RTL8366RB_LED_BLINKRATE_56MS);
 	if (ret)
@@ -996,15 +996,15 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	 * behaviour (no individual config) but we can set up each
 	 * LED separately.
 	 */
-	if (smi->leds_disabled) {
+	if (priv->leds_disabled) {
 		/* Turn everything off */
-		regmap_update_bits(smi->map,
+		regmap_update_bits(priv->map,
 				   RTL8366RB_LED_0_1_CTRL_REG,
 				   0x0FFF, 0);
-		regmap_update_bits(smi->map,
+		regmap_update_bits(priv->map,
 				   RTL8366RB_LED_2_3_CTRL_REG,
 				   0x0FFF, 0);
-		regmap_update_bits(smi->map,
+		regmap_update_bits(priv->map,
 				   RTL8366RB_INTERRUPT_CONTROL_REG,
 				   RTL8366RB_P4_RGMII_LED,
 				   0);
@@ -1014,7 +1014,7 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		val = RTL8366RB_LED_FORCE;
 	}
 	for (i = 0; i < 4; i++) {
-		ret = regmap_update_bits(smi->map,
+		ret = regmap_update_bits(priv->map,
 					 RTL8366RB_LED_CTRL_REG,
 					 0xf << (i * 4),
 					 val << (i * 4));
@@ -1022,17 +1022,17 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
-	ret = rtl8366_reset_vlan(smi);
+	ret = rtl8366_reset_vlan(priv);
 	if (ret)
 		return ret;
 
-	ret = rtl8366rb_setup_cascaded_irq(smi);
+	ret = rtl8366rb_setup_cascaded_irq(priv);
 	if (ret)
-		dev_info(smi->dev, "no interrupt support\n");
+		dev_info(priv->dev, "no interrupt support\n");
 
-	ret = realtek_smi_setup_mdio(smi);
+	ret = realtek_smi_setup_mdio(priv);
 	if (ret) {
-		dev_info(smi->dev, "could not set up MDIO bus\n");
+		dev_info(priv->dev, "could not set up MDIO bus\n");
 		return -ENODEV;
 	}
 
@@ -1052,35 +1052,35 @@ rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 		      phy_interface_t interface, struct phy_device *phydev,
 		      int speed, int duplex, bool tx_pause, bool rx_pause)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	if (port != smi->cpu_port)
+	if (port != priv->cpu_port)
 		return;
 
-	dev_dbg(smi->dev, "MAC link up on CPU port (%d)\n", port);
+	dev_dbg(priv->dev, "MAC link up on CPU port (%d)\n", port);
 
 	/* Force the fixed CPU port into 1Gbit mode, no autonegotiation */
-	ret = regmap_update_bits(smi->map, RTL8366RB_MAC_FORCE_CTRL_REG,
+	ret = regmap_update_bits(priv->map, RTL8366RB_MAC_FORCE_CTRL_REG,
 				 BIT(port), BIT(port));
 	if (ret) {
-		dev_err(smi->dev, "failed to force 1Gbit on CPU port\n");
+		dev_err(priv->dev, "failed to force 1Gbit on CPU port\n");
 		return;
 	}
 
-	ret = regmap_update_bits(smi->map, RTL8366RB_PAACR2,
+	ret = regmap_update_bits(priv->map, RTL8366RB_PAACR2,
 				 0xFF00U,
 				 RTL8366RB_PAACR_CPU_PORT << 8);
 	if (ret) {
-		dev_err(smi->dev, "failed to set PAACR on CPU port\n");
+		dev_err(priv->dev, "failed to set PAACR on CPU port\n");
 		return;
 	}
 
 	/* Enable the CPU port */
-	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
+	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
 				 0);
 	if (ret) {
-		dev_err(smi->dev, "failed to enable the CPU port\n");
+		dev_err(priv->dev, "failed to enable the CPU port\n");
 		return;
 	}
 }
@@ -1089,99 +1089,99 @@ static void
 rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 			phy_interface_t interface)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	if (port != smi->cpu_port)
+	if (port != priv->cpu_port)
 		return;
 
-	dev_dbg(smi->dev, "MAC link down on CPU port (%d)\n", port);
+	dev_dbg(priv->dev, "MAC link down on CPU port (%d)\n", port);
 
 	/* Disable the CPU port */
-	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
+	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
 				 BIT(port));
 	if (ret) {
-		dev_err(smi->dev, "failed to disable the CPU port\n");
+		dev_err(priv->dev, "failed to disable the CPU port\n");
 		return;
 	}
 }
 
-static void rb8366rb_set_port_led(struct realtek_smi *smi,
+static void rb8366rb_set_port_led(struct realtek_priv *priv,
 				  int port, bool enable)
 {
 	u16 val = enable ? 0x3f : 0;
 	int ret;
 
-	if (smi->leds_disabled)
+	if (priv->leds_disabled)
 		return;
 
 	switch (port) {
 	case 0:
-		ret = regmap_update_bits(smi->map,
+		ret = regmap_update_bits(priv->map,
 					 RTL8366RB_LED_0_1_CTRL_REG,
 					 0x3F, val);
 		break;
 	case 1:
-		ret = regmap_update_bits(smi->map,
+		ret = regmap_update_bits(priv->map,
 					 RTL8366RB_LED_0_1_CTRL_REG,
 					 0x3F << RTL8366RB_LED_1_OFFSET,
 					 val << RTL8366RB_LED_1_OFFSET);
 		break;
 	case 2:
-		ret = regmap_update_bits(smi->map,
+		ret = regmap_update_bits(priv->map,
 					 RTL8366RB_LED_2_3_CTRL_REG,
 					 0x3F, val);
 		break;
 	case 3:
-		ret = regmap_update_bits(smi->map,
+		ret = regmap_update_bits(priv->map,
 					 RTL8366RB_LED_2_3_CTRL_REG,
 					 0x3F << RTL8366RB_LED_3_OFFSET,
 					 val << RTL8366RB_LED_3_OFFSET);
 		break;
 	case 4:
-		ret = regmap_update_bits(smi->map,
+		ret = regmap_update_bits(priv->map,
 					 RTL8366RB_INTERRUPT_CONTROL_REG,
 					 RTL8366RB_P4_RGMII_LED,
 					 enable ? RTL8366RB_P4_RGMII_LED : 0);
 		break;
 	default:
-		dev_err(smi->dev, "no LED for port %d\n", port);
+		dev_err(priv->dev, "no LED for port %d\n", port);
 		return;
 	}
 	if (ret)
-		dev_err(smi->dev, "error updating LED on port %d\n", port);
+		dev_err(priv->dev, "error updating LED on port %d\n", port);
 }
 
 static int
 rtl8366rb_port_enable(struct dsa_switch *ds, int port,
 		      struct phy_device *phy)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	dev_dbg(smi->dev, "enable port %d\n", port);
-	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
+	dev_dbg(priv->dev, "enable port %d\n", port);
+	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
 				 0);
 	if (ret)
 		return ret;
 
-	rb8366rb_set_port_led(smi, port, true);
+	rb8366rb_set_port_led(priv, port, true);
 	return 0;
 }
 
 static void
 rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	dev_dbg(smi->dev, "disable port %d\n", port);
-	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
+	dev_dbg(priv->dev, "disable port %d\n", port);
+	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
 				 BIT(port));
 	if (ret)
 		return;
 
-	rb8366rb_set_port_led(smi, port, false);
+	rb8366rb_set_port_led(priv, port, false);
 }
 
 static int
@@ -1189,7 +1189,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge,
 			   bool *tx_fwd_offload)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	unsigned int port_bitmap = 0;
 	int ret, i;
 
@@ -1202,17 +1202,17 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Join this port to each other port on the bridge */
-		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+		ret = regmap_update_bits(priv->map, RTL8366RB_PORT_ISO(i),
 					 RTL8366RB_PORT_ISO_PORTS(BIT(port)),
 					 RTL8366RB_PORT_ISO_PORTS(BIT(port)));
 		if (ret)
-			dev_err(smi->dev, "failed to join port %d\n", port);
+			dev_err(priv->dev, "failed to join port %d\n", port);
 
 		port_bitmap |= BIT(i);
 	}
 
 	/* Set the bits for the ports we can access */
-	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+	return regmap_update_bits(priv->map, RTL8366RB_PORT_ISO(port),
 				  RTL8366RB_PORT_ISO_PORTS(port_bitmap),
 				  RTL8366RB_PORT_ISO_PORTS(port_bitmap));
 }
@@ -1221,7 +1221,7 @@ static void
 rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 			    struct dsa_bridge bridge)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	unsigned int port_bitmap = 0;
 	int ret, i;
 
@@ -1234,28 +1234,28 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Remove this port from any other port on the bridge */
-		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+		ret = regmap_update_bits(priv->map, RTL8366RB_PORT_ISO(i),
 					 RTL8366RB_PORT_ISO_PORTS(BIT(port)), 0);
 		if (ret)
-			dev_err(smi->dev, "failed to leave port %d\n", port);
+			dev_err(priv->dev, "failed to leave port %d\n", port);
 
 		port_bitmap |= BIT(i);
 	}
 
 	/* Clear the bits for the ports we can not access, leave ourselves */
-	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+	regmap_update_bits(priv->map, RTL8366RB_PORT_ISO(port),
 			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
 }
 
 /**
  * rtl8366rb_drop_untagged() - make the switch drop untagged and C-tagged frames
- * @smi: SMI state container
+ * @priv: SMI state container
  * @port: the port to drop untagged and C-tagged frames on
  * @drop: whether to drop or pass untagged and C-tagged frames
  */
-static int rtl8366rb_drop_untagged(struct realtek_smi *smi, int port, bool drop)
+static int rtl8366rb_drop_untagged(struct realtek_priv *priv, int port, bool drop)
 {
-	return regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
+	return regmap_update_bits(priv->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
 				  RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port),
 				  drop ? RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port) : 0);
 }
@@ -1264,17 +1264,17 @@ static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
 				    bool vlan_filtering,
 				    struct netlink_ext_ack *extack)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8366rb *rb;
 	int ret;
 
-	rb = smi->chip_data;
+	rb = priv->chip_data;
 
-	dev_dbg(smi->dev, "port %d: %s VLAN filtering\n", port,
+	dev_dbg(priv->dev, "port %d: %s VLAN filtering\n", port,
 		vlan_filtering ? "enable" : "disable");
 
 	/* If the port is not in the member set, the frame will be dropped */
-	ret = regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
+	ret = regmap_update_bits(priv->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
 				 BIT(port), vlan_filtering ? BIT(port) : 0);
 	if (ret)
 		return ret;
@@ -1284,9 +1284,9 @@ static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
 	 * filtering on a port, we need to accept any frames.
 	 */
 	if (vlan_filtering)
-		ret = rtl8366rb_drop_untagged(smi, port, !rb->pvid_enabled[port]);
+		ret = rtl8366rb_drop_untagged(priv, port, !rb->pvid_enabled[port]);
 	else
-		ret = rtl8366rb_drop_untagged(smi, port, false);
+		ret = rtl8366rb_drop_untagged(priv, port, false);
 
 	return ret;
 }
@@ -1308,11 +1308,11 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 			    struct switchdev_brport_flags flags,
 			    struct netlink_ext_ack *extack)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	int ret;
 
 	if (flags.mask & BR_LEARNING) {
-		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL,
+		ret = regmap_update_bits(priv->map, RTL8366RB_PORT_LEARNDIS_CTRL,
 					 BIT(port),
 					 (flags.val & BR_LEARNING) ? 0 : BIT(port));
 		if (ret)
@@ -1325,7 +1325,7 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 static void
 rtl8366rb_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	u32 val;
 	int i;
 
@@ -1344,13 +1344,13 @@ rtl8366rb_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		val = RTL8366RB_STP_STATE_FORWARDING;
 		break;
 	default:
-		dev_err(smi->dev, "unknown bridge state requested\n");
+		dev_err(priv->dev, "unknown bridge state requested\n");
 		return;
 	}
 
 	/* Set the same status for the port on all the FIDs */
 	for (i = 0; i < RTL8366RB_NUM_FIDS; i++) {
-		regmap_update_bits(smi->map, RTL8366RB_STP_STATE_BASE + i,
+		regmap_update_bits(priv->map, RTL8366RB_STP_STATE_BASE + i,
 				   RTL8366RB_STP_STATE_MASK(port),
 				   RTL8366RB_STP_STATE(port, val));
 	}
@@ -1359,26 +1359,26 @@ rtl8366rb_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 static void
 rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 
 	/* This will age out any learned L2 entries */
-	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
+	regmap_update_bits(priv->map, RTL8366RB_SECURITY_CTRL,
 			   BIT(port), BIT(port));
 	/* Restore the normal state of things */
-	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
+	regmap_update_bits(priv->map, RTL8366RB_SECURITY_CTRL,
 			   BIT(port), 0);
 }
 
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
-	struct realtek_smi *smi = ds->priv;
+	struct realtek_priv *priv = ds->priv;
 	struct rtl8366rb *rb;
 	unsigned int max_mtu;
 	u32 len;
 	int i;
 
 	/* Cache the per-port MTU setting */
-	rb = smi->chip_data;
+	rb = priv->chip_data;
 	rb->max_mtu[port] = new_mtu;
 
 	/* Roof out the MTU for the entire switch to the greatest
@@ -1406,7 +1406,7 @@ static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	else
 		len = RTL8366RB_SGCR_MAX_LENGTH_16000;
 
-	return regmap_update_bits(smi->map, RTL8366RB_SGCR,
+	return regmap_update_bits(priv->map, RTL8366RB_SGCR,
 				  RTL8366RB_SGCR_MAX_LENGTH_MASK,
 				  len);
 }
@@ -1419,7 +1419,7 @@ static int rtl8366rb_max_mtu(struct dsa_switch *ds, int port)
 	return 15996;
 }
 
-static int rtl8366rb_get_vlan_4k(struct realtek_smi *smi, u32 vid,
+static int rtl8366rb_get_vlan_4k(struct realtek_priv *priv, u32 vid,
 				 struct rtl8366_vlan_4k *vlan4k)
 {
 	u32 data[3];
@@ -1432,19 +1432,19 @@ static int rtl8366rb_get_vlan_4k(struct realtek_smi *smi, u32 vid,
 		return -EINVAL;
 
 	/* write VID */
-	ret = regmap_write(smi->map, RTL8366RB_VLAN_TABLE_WRITE_BASE,
+	ret = regmap_write(priv->map, RTL8366RB_VLAN_TABLE_WRITE_BASE,
 			   vid & RTL8366RB_VLAN_VID_MASK);
 	if (ret)
 		return ret;
 
 	/* write table access control word */
-	ret = regmap_write(smi->map, RTL8366RB_TABLE_ACCESS_CTRL_REG,
+	ret = regmap_write(priv->map, RTL8366RB_TABLE_ACCESS_CTRL_REG,
 			   RTL8366RB_TABLE_VLAN_READ_CTRL);
 	if (ret)
 		return ret;
 
 	for (i = 0; i < 3; i++) {
-		ret = regmap_read(smi->map,
+		ret = regmap_read(priv->map,
 				  RTL8366RB_VLAN_TABLE_READ_BASE + i,
 				  &data[i]);
 		if (ret)
@@ -1460,7 +1460,7 @@ static int rtl8366rb_get_vlan_4k(struct realtek_smi *smi, u32 vid,
 	return 0;
 }
 
-static int rtl8366rb_set_vlan_4k(struct realtek_smi *smi,
+static int rtl8366rb_set_vlan_4k(struct realtek_priv *priv,
 				 const struct rtl8366_vlan_4k *vlan4k)
 {
 	u32 data[3];
@@ -1480,7 +1480,7 @@ static int rtl8366rb_set_vlan_4k(struct realtek_smi *smi,
 	data[2] = vlan4k->fid & RTL8366RB_VLAN_FID_MASK;
 
 	for (i = 0; i < 3; i++) {
-		ret = regmap_write(smi->map,
+		ret = regmap_write(priv->map,
 				   RTL8366RB_VLAN_TABLE_WRITE_BASE + i,
 				   data[i]);
 		if (ret)
@@ -1488,13 +1488,13 @@ static int rtl8366rb_set_vlan_4k(struct realtek_smi *smi,
 	}
 
 	/* write table access control word */
-	ret = regmap_write(smi->map, RTL8366RB_TABLE_ACCESS_CTRL_REG,
+	ret = regmap_write(priv->map, RTL8366RB_TABLE_ACCESS_CTRL_REG,
 			   RTL8366RB_TABLE_VLAN_WRITE_CTRL);
 
 	return ret;
 }
 
-static int rtl8366rb_get_vlan_mc(struct realtek_smi *smi, u32 index,
+static int rtl8366rb_get_vlan_mc(struct realtek_priv *priv, u32 index,
 				 struct rtl8366_vlan_mc *vlanmc)
 {
 	u32 data[3];
@@ -1507,7 +1507,7 @@ static int rtl8366rb_get_vlan_mc(struct realtek_smi *smi, u32 index,
 		return -EINVAL;
 
 	for (i = 0; i < 3; i++) {
-		ret = regmap_read(smi->map,
+		ret = regmap_read(priv->map,
 				  RTL8366RB_VLAN_MC_BASE(index) + i,
 				  &data[i]);
 		if (ret)
@@ -1525,7 +1525,7 @@ static int rtl8366rb_get_vlan_mc(struct realtek_smi *smi, u32 index,
 	return 0;
 }
 
-static int rtl8366rb_set_vlan_mc(struct realtek_smi *smi, u32 index,
+static int rtl8366rb_set_vlan_mc(struct realtek_priv *priv, u32 index,
 				 const struct rtl8366_vlan_mc *vlanmc)
 {
 	u32 data[3];
@@ -1549,7 +1549,7 @@ static int rtl8366rb_set_vlan_mc(struct realtek_smi *smi, u32 index,
 	data[2] = vlanmc->fid & RTL8366RB_VLAN_FID_MASK;
 
 	for (i = 0; i < 3; i++) {
-		ret = regmap_write(smi->map,
+		ret = regmap_write(priv->map,
 				   RTL8366RB_VLAN_MC_BASE(index) + i,
 				   data[i]);
 		if (ret)
@@ -1559,15 +1559,15 @@ static int rtl8366rb_set_vlan_mc(struct realtek_smi *smi, u32 index,
 	return 0;
 }
 
-static int rtl8366rb_get_mc_index(struct realtek_smi *smi, int port, int *val)
+static int rtl8366rb_get_mc_index(struct realtek_priv *priv, int port, int *val)
 {
 	u32 data;
 	int ret;
 
-	if (port >= smi->num_ports)
+	if (port >= priv->num_ports)
 		return -EINVAL;
 
-	ret = regmap_read(smi->map, RTL8366RB_PORT_VLAN_CTRL_REG(port),
+	ret = regmap_read(priv->map, RTL8366RB_PORT_VLAN_CTRL_REG(port),
 			  &data);
 	if (ret)
 		return ret;
@@ -1578,22 +1578,22 @@ static int rtl8366rb_get_mc_index(struct realtek_smi *smi, int port, int *val)
 	return 0;
 }
 
-static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
+static int rtl8366rb_set_mc_index(struct realtek_priv *priv, int port, int index)
 {
 	struct rtl8366rb *rb;
 	bool pvid_enabled;
 	int ret;
 
-	rb = smi->chip_data;
+	rb = priv->chip_data;
 	pvid_enabled = !!index;
 
-	if (port >= smi->num_ports || index >= RTL8366RB_NUM_VLANS)
+	if (port >= priv->num_ports || index >= RTL8366RB_NUM_VLANS)
 		return -EINVAL;
 
-	ret = regmap_update_bits(smi->map, RTL8366RB_PORT_VLAN_CTRL_REG(port),
-				RTL8366RB_PORT_VLAN_CTRL_MASK <<
+	ret = regmap_update_bits(priv->map, RTL8366RB_PORT_VLAN_CTRL_REG(port),
+				 RTL8366RB_PORT_VLAN_CTRL_MASK <<
 					RTL8366RB_PORT_VLAN_CTRL_SHIFT(port),
-				(index & RTL8366RB_PORT_VLAN_CTRL_MASK) <<
+				 (index & RTL8366RB_PORT_VLAN_CTRL_MASK) <<
 					RTL8366RB_PORT_VLAN_CTRL_SHIFT(port));
 	if (ret)
 		return ret;
@@ -1604,17 +1604,17 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 	 * not drop any untagged or C-tagged frames. Make sure to update the
 	 * filtering setting.
 	 */
-	if (dsa_port_is_vlan_filtering(dsa_to_port(smi->ds, port)))
-		ret = rtl8366rb_drop_untagged(smi, port, !pvid_enabled);
+	if (dsa_port_is_vlan_filtering(dsa_to_port(priv->ds, port)))
+		ret = rtl8366rb_drop_untagged(priv, port, !pvid_enabled);
 
 	return ret;
 }
 
-static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
+static bool rtl8366rb_is_vlan_valid(struct realtek_priv *priv, unsigned int vlan)
 {
 	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
-	if (smi->vlan4k_enabled)
+	if (priv->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
 
 	if (vlan > max)
@@ -1623,23 +1623,23 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 	return true;
 }
 
-static int rtl8366rb_enable_vlan(struct realtek_smi *smi, bool enable)
+static int rtl8366rb_enable_vlan(struct realtek_priv *priv, bool enable)
 {
-	dev_dbg(smi->dev, "%s VLAN\n", enable ? "enable" : "disable");
-	return regmap_update_bits(smi->map,
+	dev_dbg(priv->dev, "%s VLAN\n", enable ? "enable" : "disable");
+	return regmap_update_bits(priv->map,
 				  RTL8366RB_SGCR, RTL8366RB_SGCR_EN_VLAN,
 				  enable ? RTL8366RB_SGCR_EN_VLAN : 0);
 }
 
-static int rtl8366rb_enable_vlan4k(struct realtek_smi *smi, bool enable)
+static int rtl8366rb_enable_vlan4k(struct realtek_priv *priv, bool enable)
 {
-	dev_dbg(smi->dev, "%s VLAN 4k\n", enable ? "enable" : "disable");
-	return regmap_update_bits(smi->map, RTL8366RB_SGCR,
+	dev_dbg(priv->dev, "%s VLAN 4k\n", enable ? "enable" : "disable");
+	return regmap_update_bits(priv->map, RTL8366RB_SGCR,
 				  RTL8366RB_SGCR_EN_VLAN_4KTB,
 				  enable ? RTL8366RB_SGCR_EN_VLAN_4KTB : 0);
 }
 
-static int rtl8366rb_phy_read(struct realtek_smi *smi, int phy, int regnum)
+static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 {
 	u32 val;
 	u32 reg;
@@ -1648,32 +1648,32 @@ static int rtl8366rb_phy_read(struct realtek_smi *smi, int phy, int regnum)
 	if (phy > RTL8366RB_PHY_NO_MAX)
 		return -EINVAL;
 
-	ret = regmap_write(smi->map, RTL8366RB_PHY_ACCESS_CTRL_REG,
+	ret = regmap_write(priv->map, RTL8366RB_PHY_ACCESS_CTRL_REG,
 			   RTL8366RB_PHY_CTRL_READ);
 	if (ret)
 		return ret;
 
 	reg = 0x8000 | (1 << (phy + RTL8366RB_PHY_NO_OFFSET)) | regnum;
 
-	ret = regmap_write(smi->map, reg, 0);
+	ret = regmap_write(priv->map, reg, 0);
 	if (ret) {
-		dev_err(smi->dev,
+		dev_err(priv->dev,
 			"failed to write PHY%d reg %04x @ %04x, ret %d\n",
 			phy, regnum, reg, ret);
 		return ret;
 	}
 
-	ret = regmap_read(smi->map, RTL8366RB_PHY_ACCESS_DATA_REG, &val);
+	ret = regmap_read(priv->map, RTL8366RB_PHY_ACCESS_DATA_REG, &val);
 	if (ret)
 		return ret;
 
-	dev_dbg(smi->dev, "read PHY%d register 0x%04x @ %08x, val <- %04x\n",
+	dev_dbg(priv->dev, "read PHY%d register 0x%04x @ %08x, val <- %04x\n",
 		phy, regnum, reg, val);
 
 	return val;
 }
 
-static int rtl8366rb_phy_write(struct realtek_smi *smi, int phy, int regnum,
+static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 			       u16 val)
 {
 	u32 reg;
@@ -1682,34 +1682,34 @@ static int rtl8366rb_phy_write(struct realtek_smi *smi, int phy, int regnum,
 	if (phy > RTL8366RB_PHY_NO_MAX)
 		return -EINVAL;
 
-	ret = regmap_write(smi->map, RTL8366RB_PHY_ACCESS_CTRL_REG,
+	ret = regmap_write(priv->map, RTL8366RB_PHY_ACCESS_CTRL_REG,
 			   RTL8366RB_PHY_CTRL_WRITE);
 	if (ret)
 		return ret;
 
 	reg = 0x8000 | (1 << (phy + RTL8366RB_PHY_NO_OFFSET)) | regnum;
 
-	dev_dbg(smi->dev, "write PHY%d register 0x%04x @ %04x, val -> %04x\n",
+	dev_dbg(priv->dev, "write PHY%d register 0x%04x @ %04x, val -> %04x\n",
 		phy, regnum, reg, val);
 
-	ret = regmap_write(smi->map, reg, val);
+	ret = regmap_write(priv->map, reg, val);
 	if (ret)
 		return ret;
 
 	return 0;
 }
 
-static int rtl8366rb_reset_chip(struct realtek_smi *smi)
+static int rtl8366rb_reset_chip(struct realtek_priv *priv)
 {
 	int timeout = 10;
 	u32 val;
 	int ret;
 
-	realtek_smi_write_reg_noack(smi, RTL8366RB_RESET_CTRL_REG,
+	realtek_smi_write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
 				    RTL8366RB_CHIP_CTRL_RESET_HW);
 	do {
 		usleep_range(20000, 25000);
-		ret = regmap_read(smi->map, RTL8366RB_RESET_CTRL_REG, &val);
+		ret = regmap_read(priv->map, RTL8366RB_RESET_CTRL_REG, &val);
 		if (ret)
 			return ret;
 
@@ -1718,21 +1718,21 @@ static int rtl8366rb_reset_chip(struct realtek_smi *smi)
 	} while (--timeout);
 
 	if (!timeout) {
-		dev_err(smi->dev, "timeout waiting for the switch to reset\n");
+		dev_err(priv->dev, "timeout waiting for the switch to reset\n");
 		return -EIO;
 	}
 
 	return 0;
 }
 
-static int rtl8366rb_detect(struct realtek_smi *smi)
+static int rtl8366rb_detect(struct realtek_priv *priv)
 {
-	struct device *dev = smi->dev;
+	struct device *dev = priv->dev;
 	int ret;
 	u32 val;
 
 	/* Detect device */
-	ret = regmap_read(smi->map, 0x5c, &val);
+	ret = regmap_read(priv->map, 0x5c, &val);
 	if (ret) {
 		dev_err(dev, "can't get chip ID (%d)\n", ret);
 		return ret;
@@ -1745,11 +1745,11 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
 		return -ENODEV;
 	case 0x5937:
 		dev_info(dev, "found an RTL8366RB switch\n");
-		smi->cpu_port = RTL8366RB_PORT_NUM_CPU;
-		smi->num_ports = RTL8366RB_NUM_PORTS;
-		smi->num_vlan_mc = RTL8366RB_NUM_VLANS;
-		smi->mib_counters = rtl8366rb_mib_counters;
-		smi->num_mib_counters = ARRAY_SIZE(rtl8366rb_mib_counters);
+		priv->cpu_port = RTL8366RB_PORT_NUM_CPU;
+		priv->num_ports = RTL8366RB_NUM_PORTS;
+		priv->num_vlan_mc = RTL8366RB_NUM_VLANS;
+		priv->mib_counters = rtl8366rb_mib_counters;
+		priv->num_mib_counters = ARRAY_SIZE(rtl8366rb_mib_counters);
 		break;
 	default:
 		dev_info(dev, "found an Unknown Realtek switch (id=0x%04x)\n",
@@ -1757,7 +1757,7 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
 		break;
 	}
 
-	ret = rtl8366rb_reset_chip(smi);
+	ret = rtl8366rb_reset_chip(priv);
 	if (ret)
 		return ret;
 
@@ -1787,7 +1787,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_max_mtu = rtl8366rb_max_mtu,
 };
 
-static const struct realtek_smi_ops rtl8366rb_smi_ops = {
+static const struct realtek_ops rtl8366rb_ops = {
 	.detect		= rtl8366rb_detect,
 	.get_vlan_mc	= rtl8366rb_get_vlan_mc,
 	.set_vlan_mc	= rtl8366rb_set_vlan_mc,
@@ -1803,9 +1803,9 @@ static const struct realtek_smi_ops rtl8366rb_smi_ops = {
 	.phy_write	= rtl8366rb_phy_write,
 };
 
-const struct realtek_smi_variant rtl8366rb_variant = {
+const struct realtek_variant rtl8366rb_variant = {
 	.ds_ops = &rtl8366rb_switch_ops,
-	.ops = &rtl8366rb_smi_ops,
+	.ops = &rtl8366rb_ops,
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
 	.cmd_write = 0xa8,
-- 
2.34.0

