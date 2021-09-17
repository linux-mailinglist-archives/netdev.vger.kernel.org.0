Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B96240FF10
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344240AbhIQSRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhIQSRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:17:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D940C061574;
        Fri, 17 Sep 2021 11:15:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k23so7539473pji.0;
        Fri, 17 Sep 2021 11:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EtqkNTIaZiciUFYxH4TlMlF40yg9YCqiwfsTy5QbPBI=;
        b=AKmlktiFnfns3nn6gD/hiQO0Gno6XplpP3Bh+fJ+t1vvmXAlDIPriQfhaJ37mYQXQI
         cDCXdObrJRf7Qso7FeFmzbCGJo3ma28OOpj28iZ2wwC1dnyCDivTOqwYZcXnbXdPT8/e
         ng+YwpuEXAHn2s+6/wrspLzWRnOw1PUqg1swln+w1AOry9C0k8jjEGT0SwPeXxwovn1z
         uFOX54fmqZeuTSrA0lcoj6uAoWHzeg2LiOdIHMrNkyQbSYmkAjJ+o3QcC8t6v6iHI1UG
         m1gGoHOrCBxge/lK87dsg/XtULdo5CXtbbEmndwAX7YpBqWsIQIS5XgnaKzg7b9vGsnI
         IG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EtqkNTIaZiciUFYxH4TlMlF40yg9YCqiwfsTy5QbPBI=;
        b=VhJa2xCvdG61ifxfSekqL8NYC4O/e1Av3ZkaImUU6Ql4JuRbj085/yf9n2JjFsKoFm
         F9T1YNa0JGJuKyNNq1QKv4g9Cf6wADZjiRpa1J7yLTHhC1MUs1d2hOAarM+OgTKhs5AT
         fAXvMohx+irGEM0pba5Qu1JBqS5dSZIG3zznX3XlFFZeXcGjDdRdg1yeHhVlaPpo4sR1
         cWIrlIHDqT7Lufzs0oGOV3IVhiYdb9uxARQ2i9Uq0CxQSt0iSeoi6EQRzokwrjNcUa1J
         91YvqzSEKILICc7QHbhZnWpdrHjI1Y+iSGG1cEMExODrfkVHjv+y0C1K9POs9cf97wJX
         p3EQ==
X-Gm-Message-State: AOAM532PzxwOa/0KoBcPmlY4XU3mYDSGYCV1025f2xOu75D9eDN0VqsX
        dVjJ+A8Zv2dU+pvUeaRu//RJp++eT/g=
X-Google-Smtp-Source: ABdhPJxOZZf2gOArh1+pneTUx7gFBPf3Dfu2K57w/HWTA38q9gJAxxnxANTpqG+yTQeR0H7Kv1CL/Q==
X-Received: by 2002:a17:903:20d1:b0:13b:842b:a4e4 with SMTP id i17-20020a17090320d100b0013b842ba4e4mr10749644plb.9.1631902557447;
        Fri, 17 Sep 2021 11:15:57 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm8736401pjb.33.2021.09.17.11.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 11:15:56 -0700 (PDT)
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
Subject: [PATCH net-next v2] net: phy: bcm7xxx: Add EPHY entry for 72165
Date:   Fri, 17 Sep 2021 11:15:50 -0700
Message-Id: <20210917181551.2836036-1-f.fainelli@gmail.com>
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
Changes in v2:

- Fixed checkpatch complaint on a comment

- intentionally kep the 0x3000 clearing and setting since this is
  generated from a script

 drivers/net/phy/bcm7xxx.c | 201 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h   |   1 +
 2 files changed, 202 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index e79297a4bae8..3a29a1493ff1 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -398,6 +398,190 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
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
+	 * phase)
+	 */
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
@@ -610,9 +794,25 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
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
@@ -635,6 +835,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 static struct mdio_device_id __maybe_unused bcm7xxx_tbl[] = {
 	{ PHY_ID_BCM72113, 0xfffffff0 },
 	{ PHY_ID_BCM72116, 0xfffffff0, },
+	{ PHY_ID_BCM72165, 0xfffffff0, },
 	{ PHY_ID_BCM7250, 0xfffffff0, },
 	{ PHY_ID_BCM7255, 0xfffffff0, },
 	{ PHY_ID_BCM7260, 0xfffffff0, },
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 3308cebe1c19..07e1dfadbbdf 100644
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

