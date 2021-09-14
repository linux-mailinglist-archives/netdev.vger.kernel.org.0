Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1306F40BBC1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 00:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhINWmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 18:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhINWmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 18:42:13 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1053C061574;
        Tue, 14 Sep 2021 15:40:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y8so782376pfa.7;
        Tue, 14 Sep 2021 15:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ju9VZyqP21j8Scdz8OFW5dsbT6zZUxqBw2Xl/YF0nKI=;
        b=KESGAPRIlqJz1bY9DWhdFrkTb8CR9fi+TfyHuZN5UQe7H/vc0me4eou2ycW2wOy8/f
         nhInEoOOCgOV43QpQUWilSGwVwu08mP9Ei+jCDVRfgzLp1MTwbRkxzatTwcNBygh65mn
         rLWimZuUO7vM6rr6WN1vysr3tIlSeQI/C0sXHDcNvz0woJx8fL4csCS7V88MryjAQtBS
         NLEjeexdjmzbYZOtxUg+bLC/WOAEu1+D8p8OEHWOr71EV0mINfjnPYkMUCGpTUr8a9Q8
         /G1E56l82gE7gosFl+w/3IvmYKSeTpl+MAfj55FJYTC7hSGiZh/w24pvcVSVQCRQzVT5
         PeDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ju9VZyqP21j8Scdz8OFW5dsbT6zZUxqBw2Xl/YF0nKI=;
        b=SBxXZlUCwaknc82AuxmAdqvz96p0d7k2zQpFwIZ1Ceskj+T6nkQUsgprCttXLKb4TY
         wPERiEZlyYVP+8uqgXSvNMRMAm4lCU9rigpN6e2m4DvpZf8GQrqwCQNE3Rk6P8JmtKKw
         D1JzmwIzXZsBGjUImEssPOfSZ/JA4dWVO/A0goF38ASgbac0oqZkZ25k9lplN5tu+lBs
         mFKUgANjOwXaJREKucYcYGaqdNmIkfN3XJSKgfbs4w2Ru2eV+3MDgvN5rUA2/FFxjq+e
         5FO8uPQFvtDEgY5VCNFlnEnFFOLC9utN395cBgAr+C2EO4J8hBGDvPeAoFd5AfJrvbW9
         sxRQ==
X-Gm-Message-State: AOAM533ZnvJQXPrk6VigmNymIBdSg1LcNRcHofmpDeeQiZwzsamc4sM1
        ubte47ExObFCyddIXT9IHPX+Uc7tbds=
X-Google-Smtp-Source: ABdhPJzbABhOOHmOVLpdF+OYqigx4ocH172Z/Q3cbmCl7RwJaPmgaIrmf/A+FcIlD7T/FHEvxnzaXA==
X-Received: by 2002:a65:67d6:: with SMTP id b22mr17355642pgs.430.1631659254015;
        Tue, 14 Sep 2021 15:40:54 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g4sm12243158pgs.42.2021.09.14.15.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 15:40:53 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: bcm7xxx: Add EPHY entry for 72165
Date:   Tue, 14 Sep 2021 15:40:41 -0700
Message-Id: <20210914224042.418365-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

72165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
create a new macro and set of functions for this different process type.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 200 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h   |   1 +
 2 files changed, 201 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index e79297a4bae8..f6912a77a378 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -398,6 +398,189 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
 	return bcm7xxx_28nm_ephy_apd_enable(phydev);
 }
 
+static int bcm7xxx_16nm_ephy_afe_config(struct phy_device *phydev)
+{
+	int tmp, rcalcode, rcalnewcodelp, rcalnewcode11, rcalnewcode11d2;
+
+	/* Reset PHY */
+	tmp = genphy_soft_reset(phydev);
+	if (tmp)
+		return tmp;
+
+	/* Reset AFE and PLL */
+	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0006);
+	/* Clear reset */
+	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0000);
+
+	/* Write PLL/AFE control register to select 54MHz crystal */
+	bcm_phy_write_misc(phydev, 0x0030, 0x0001, 0x0000);
+	bcm_phy_write_misc(phydev, 0x0031, 0x0000, 0x044a);
+
+	/* Change Ka,Kp,Ki to pdiv=1 */
+	bcm_phy_write_misc(phydev, 0x0033, 0x0002, 0x71a1);
+	/* Configuration override */
+	bcm_phy_write_misc(phydev, 0x0033, 0x0001, 0x8000);
+
+	/* Change PLL_NDIV and PLL_NUDGE */
+	bcm_phy_write_misc(phydev, 0x0031, 0x0001, 0x2f68);
+	bcm_phy_write_misc(phydev, 0x0031, 0x0002, 0x0000);
+
+	/* Reference frequency is 54Mhz, config_mode[15:14] = 3 (low
+	 * phase) */
+	bcm_phy_write_misc(phydev, 0x0030, 0x0003, 0xc036);
+
+	/* Initialize bypass mode */
+	bcm_phy_write_misc(phydev, 0x0032, 0x0003, 0x0000);
+	/* Bypass code, default: VCOCLK enabled */
+	bcm_phy_write_misc(phydev, 0x0033, 0x0000, 0x0002);
+	/* LDOs at default setting */
+	bcm_phy_write_misc(phydev, 0x0030, 0x0002, 0x01c0);
+	/* Release PLL reset */
+	bcm_phy_write_misc(phydev, 0x0030, 0x0001, 0x0001);
+
+	/* Bandgap curvature correction to correct default */
+	bcm_phy_write_misc(phydev, 0x0038, 0x0000, 0x0010);
+
+	/* Run RCAL */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0003, 0x0038);
+	bcm_phy_write_misc(phydev, 0x0039, 0x0003, 0x003b);
+	udelay(2);
+	bcm_phy_write_misc(phydev, 0x0039, 0x0003, 0x003f);
+	mdelay(5);
+
+	/* AFE_CAL_CONFIG_0, Vref=1000, Target=10, averaging enabled */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x1c82);
+	/* AFE_CAL_CONFIG_0, no reset and analog powerup */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9e82);
+	udelay(2);
+	/* AFE_CAL_CONFIG_0, start calibration */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9f82);
+	udelay(100);
+	/* AFE_CAL_CONFIG_0, clear start calibration, set HiBW */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9e86);
+	udelay(2);
+	/* AFE_CAL_CONFIG_0, start calibration with hi BW mode set */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9f86);
+	udelay(100);
+
+	/* Adjust 10BT amplitude additional +7% and 100BT +2% */
+	bcm_phy_write_misc(phydev, 0x0038, 0x0001, 0xe7ea);
+	/* Adjust 1G mode amplitude and 1G testmode1 */
+	bcm_phy_write_misc(phydev, 0x0038, 0x0002, 0xede0);
+
+	/* Read CORE_EXPA9 */
+	tmp = bcm_phy_read_exp(phydev, 0x00a9);
+	/* CORE_EXPA9[6:1] is rcalcode[5:0] */
+	rcalcode = (tmp & 0x7e) / 2;
+	/* Correct RCAL code + 1 is -1% rprogr, LP: +16 */
+	rcalnewcodelp = rcalcode + 16;
+	/* Correct RCAL code + 1 is -15 rprogr, 11: +10 */
+	rcalnewcode11 = rcalcode + 10;
+	/* Saturate if necessary */
+	if (rcalnewcodelp > 0x3f)
+		rcalnewcodelp = 0x3f;
+	if (rcalnewcode11 > 0x3f)
+		rcalnewcode11 = 0x3f;
+	/* REXT=1 BYP=1 RCAL_st1<5:0>=new rcal code */
+	tmp = 0x00f8 + rcalnewcodelp * 256;
+	/* Program into AFE_CAL_CONFIG_2 */
+	bcm_phy_write_misc(phydev, 0x0039, 0x0003, tmp);
+	/* AFE_BIAS_CONFIG_0 10BT bias code (Bias: E4) */
+	bcm_phy_write_misc(phydev, 0x0038, 0x0001, 0xe7e4);
+	/* invert adc clock output and 'adc refp ldo current To correct
+	 * default
+	 */
+	bcm_phy_write_misc(phydev, 0x003b, 0x0000, 0x8002);
+	/* 100BT stair case, high BW, 1G stair case, alternate encode */
+	bcm_phy_write_misc(phydev, 0x003c, 0x0003, 0xf882);
+	/* 1000BT DAC transition method per Erol, bits[32], DAC Shuffle
+	 * sequence 1 + 10BT imp adjust bits
+	 */
+	bcm_phy_write_misc(phydev, 0x003d, 0x0000, 0x3201);
+	/* Non-overlap fix */
+	bcm_phy_write_misc(phydev, 0x003a, 0x0002, 0x0c00);
+
+	/* pwdb override (rxconfig<5>) to turn on RX LDO indpendent of
+	 * pwdb controls from DSP_TAP10
+	 */
+	bcm_phy_write_misc(phydev, 0x003a, 0x0001, 0x0020);
+
+	/* Remove references to channel 2 and 3 */
+	bcm_phy_write_misc(phydev, 0x003b, 0x0002, 0x0000);
+	bcm_phy_write_misc(phydev, 0x003b, 0x0003, 0x0000);
+
+	/* Set cal_bypassb bit rxconfig<43> */
+	bcm_phy_write_misc(phydev, 0x003a, 0x0003, 0x0800);
+	udelay(2);
+
+	/* Revert pwdb_override (rxconfig<5>) to 0 so that the RX pwr
+	 * is controlled by DSP.
+	 */
+	bcm_phy_write_misc(phydev, 0x003a, 0x0001, 0x0000);
+
+	/* Drop LSB */
+	rcalnewcode11d2 = (rcalnewcode11 & 0xfffe) / 2;
+	tmp = bcm_phy_read_misc(phydev, 0x003d, 0x0001);
+	/* Clear bits [11:5] */
+	tmp &= ~0xfe0;
+	/* set txcfg_ch0<5>=1 (enable + set local rcal) */
+	tmp |= 0x0020 | (rcalnewcode11d2 * 64);
+	bcm_phy_write_misc(phydev, 0x003d, 0x0001, tmp);
+	bcm_phy_write_misc(phydev, 0x003d, 0x0002, tmp);
+
+	tmp = bcm_phy_read_misc(phydev, 0x003d, 0x0000);
+	/* set txcfg<45:44>=11 (enable Rextra + invert fullscaledetect)
+	 */
+	tmp &= ~0x3000;
+	tmp |= 0x3000;
+	bcm_phy_write_misc(phydev, 0x003d, 0x0000, tmp);
+
+	return 0;
+}
+
+static int bcm7xxx_16nm_ephy_config_init(struct phy_device *phydev)
+{
+	int ret, val;
+
+	ret = bcm7xxx_16nm_ephy_afe_config(phydev);
+	if (ret)
+		return ret;
+
+	ret = bcm_phy_set_eee(phydev, true);
+	if (ret)
+		return ret;
+
+	ret = bcm_phy_read_shadow(phydev, BCM54XX_SHD_SCR3);
+	if (ret < 0)
+		return ret;
+
+	val = ret;
+
+	/* Auto power down of DLL enabled,
+	 * TXC/RXC disabled during auto power down.
+	 */
+	val &= ~BCM54XX_SHD_SCR3_DLLAPD_DIS;
+	val |= BIT(8);
+
+	ret = bcm_phy_write_shadow(phydev, BCM54XX_SHD_SCR3, val);
+	if (ret < 0)
+		return ret;
+
+	return bcm_phy_enable_apd(phydev, true);
+}
+
+static int bcm7xxx_16nm_ephy_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Re-apply workarounds coming out suspend/resume */
+	ret = bcm7xxx_16nm_ephy_config_init(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_config_aneg(phydev);
+}
+
 static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -610,9 +793,25 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.resume         = bcm7xxx_config_init,				\
 }
 
+#define BCM7XXX_16NM_EPHY(_oui, _name)					\
+{									\
+	.phy_id		= (_oui),					\
+	.phy_id_mask	= 0xfffffff0,					\
+	.name		= _name,					\
+	/* PHY_BASIC_FEATURES */					\
+	.flags		= PHY_IS_INTERNAL,				\
+	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
+	.config_init	= bcm7xxx_16nm_ephy_config_init,		\
+	.config_aneg	= genphy_config_aneg,				\
+	.read_status	= genphy_read_status,				\
+	.resume		= bcm7xxx_16nm_ephy_resume,			\
+}
+
 static struct phy_driver bcm7xxx_driver[] = {
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM72113, "Broadcom BCM72113"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM72116, "Broadcom BCM72116"),
+	BCM7XXX_16NM_EPHY(PHY_ID_BCM72165, "Broadcom BCM72165"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7250, "Broadcom BCM7250"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM7255, "Broadcom BCM7255"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM7260, "Broadcom BCM7260"),
@@ -635,6 +834,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 static struct mdio_device_id __maybe_unused bcm7xxx_tbl[] = {
 	{ PHY_ID_BCM72113, 0xfffffff0 },
 	{ PHY_ID_BCM72116, 0xfffffff0, },
+	{ PHY_ID_BCM72165, 0xfffffff0, },
 	{ PHY_ID_BCM7250, 0xfffffff0, },
 	{ PHY_ID_BCM7255, 0xfffffff0, },
 	{ PHY_ID_BCM7260, 0xfffffff0, },
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index c2c2147dfeb8..c2a5fc9f46c2 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -32,6 +32,7 @@
 
 #define PHY_ID_BCM72113			0x35905310
 #define PHY_ID_BCM72116			0x35905350
+#define PHY_ID_BCM72165			0x35905340
 #define PHY_ID_BCM7250			0xae025280
 #define PHY_ID_BCM7255			0xae025120
 #define PHY_ID_BCM7260			0xae025190
-- 
2.25.1

