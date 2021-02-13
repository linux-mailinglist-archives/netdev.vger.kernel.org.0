Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE19E31A9CB
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 04:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhBMDr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 22:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbhBMDrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 22:47:19 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311ABC0613D6;
        Fri, 12 Feb 2021 19:46:39 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b145so747616pfb.4;
        Fri, 12 Feb 2021 19:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I7/OiWQ7uKmbM6Wg07lX4shzHb0RXi59L/RFCz3mRC4=;
        b=glXfZHSDtuqjvOjobAXOc9eUg7nN8zjPSvWAHyAKPHHoomAV+IBLJrAbAgZQd9y1/u
         CT3goqFI5pjLusL5yFLNp5arcXm/DMTcFwcK+Tn2Fn06Q0JeooiG9slI18Z6lN2mTD1q
         Vq0bnTjK7dZFPfAluSSpV6QAGPciN1wAVF7Ajon05meTgp/+4BVQ+vqVdREvrKpR3oil
         zb2GVm+vZFZ4JN+qcQqJZFwA/MYGQb67PJ4wiZiqYDWz6FeuBnV8XpCUkhsfv2kPyPIe
         SbKNRMhwTWe7UVyN6FwyfYvqYT2fAmFcEtWkFjkMXjg8teNS9dku969O9WVjgqN4NWPL
         Iuaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I7/OiWQ7uKmbM6Wg07lX4shzHb0RXi59L/RFCz3mRC4=;
        b=jd2Ci0VhmZgG8JlvHbXPm7gLIMRG7FoEqDG9snz9oKfNcrMfdOf6AYvP8nZifrXf32
         Hs067PFeMUTq5p0r4f0M3stgqKc4tdTmLnLp7G9Q6ngGqqoCBCqBw5yXunx37TcmDGg/
         TnK2am6Ar4Lkjly5I1wKQeU4j5tj+ZBnDm2zRB3S9Mxk8I6+ZhRkqzMXmnvrKh1+KuPt
         ehwCugskY8AVL+RltouADaWMCIdDyTS6rc/i2Fy2Zfhn9J76mHh0JQL85Lrackm1DW2P
         r2d33fiYMT4RHS/XTdREnM45bfLi5eaxoSI9HWgfr14tOnzpeDHoBN0Ae1pV3wQI0yfT
         lWFQ==
X-Gm-Message-State: AOAM530NpEJVRRnNIJPCC4N9LZgcIVIggDjm7me/A3gP7gg2dmLbNoHd
        PNrjG2pFnIhQw/zCvCiulDYAU10ZlLM=
X-Google-Smtp-Source: ABdhPJwTnFsTERtm8RsIDCqFJEF8WG6yL8zlABOixglufssDXGRYKK6RulOSK+RZwIqJRe7+oJ5qkw==
X-Received: by 2002:a65:4083:: with SMTP id t3mr6075260pgp.150.1613187998355;
        Fri, 12 Feb 2021 19:46:38 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y14sm10399057pfg.9.2021.02.12.19.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:46:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list),
        olteanv@gmail.com, michael@walle.cc
Subject: [PATCH net-next v2 2/3] net: phy: broadcom: Remove unused flags
Date:   Fri, 12 Feb 2021 19:46:31 -0800
Message-Id: <20210213034632.2420998-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213034632.2420998-1-f.fainelli@gmail.com>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a number of unused flags defined today and since we are scarce
on space and may need to introduce new flags in the future remove and
shift every existing flag down into a contiguous assignment.
PHY_BCM_FLAGS_MODE_1000BX was only used internally for the BCM54616S
PHY, so we allocate a driver private structure instead to store that
flag instead of canibalizing one from phydev->dev_flags for that
purpose.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 19 ++++++++++++++++---
 include/linux/brcmphy.h    | 21 ++++++++-------------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 4142f69c1530..3ce266ab521b 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -381,10 +381,21 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
 	return ret;
 }
 
+struct bcm54616s_phy_priv {
+	bool mode_1000bx_en;
+};
+
 static int bcm54616s_probe(struct phy_device *phydev)
 {
+	struct bcm54616s_phy_priv *priv;
 	int val, intf_sel;
 
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
 	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
 	if (val < 0)
 		return val;
@@ -407,7 +418,7 @@ static int bcm54616s_probe(struct phy_device *phydev)
 		 * 1000BASE-X configuration.
 		 */
 		if (!(val & BCM54616S_100FX_MODE))
-			phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
+			priv->mode_1000bx_en = true;
 
 		phydev->port = PORT_FIBRE;
 	}
@@ -417,10 +428,11 @@ static int bcm54616s_probe(struct phy_device *phydev)
 
 static int bcm54616s_config_aneg(struct phy_device *phydev)
 {
+	struct bcm54616s_phy_priv *priv = phydev->priv;
 	int ret;
 
 	/* Aneg firstly. */
-	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
+	if (priv->mode_1000bx_en)
 		ret = genphy_c37_config_aneg(phydev);
 	else
 		ret = genphy_config_aneg(phydev);
@@ -433,9 +445,10 @@ static int bcm54616s_config_aneg(struct phy_device *phydev)
 
 static int bcm54616s_read_status(struct phy_device *phydev)
 {
+	struct bcm54616s_phy_priv *priv = phydev->priv;
 	int err;
 
-	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
+	if (priv->mode_1000bx_en)
 		err = genphy_c37_read_status(phydev);
 	else
 		err = genphy_read_status(phydev);
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index de9430d55c90..844dcfe789a2 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -61,19 +61,14 @@
 #define PHY_BCM_OUI_5			0x03625e00
 #define PHY_BCM_OUI_6			0xae025000
 
-#define PHY_BCM_FLAGS_MODE_COPPER	0x00000001
-#define PHY_BCM_FLAGS_MODE_1000BX	0x00000002
-#define PHY_BCM_FLAGS_INTF_SGMII	0x00000010
-#define PHY_BCM_FLAGS_INTF_XAUI		0x00000020
-#define PHY_BRCM_WIRESPEED_ENABLE	0x00000100
-#define PHY_BRCM_AUTO_PWRDWN_ENABLE	0x00000200
-#define PHY_BRCM_RX_REFCLK_UNUSED	0x00000400
-#define PHY_BRCM_STD_IBND_DISABLE	0x00000800
-#define PHY_BRCM_EXT_IBND_RX_ENABLE	0x00001000
-#define PHY_BRCM_EXT_IBND_TX_ENABLE	0x00002000
-#define PHY_BRCM_CLEAR_RGMII_MODE	0x00004000
-#define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00008000
-#define PHY_BRCM_EN_MASTER_MODE		0x00010000
+#define PHY_BRCM_AUTO_PWRDWN_ENABLE	0x00000001
+#define PHY_BRCM_RX_REFCLK_UNUSED	0x00000002
+#define PHY_BRCM_STD_IBND_DISABLE	0x00000004
+#define PHY_BRCM_EXT_IBND_RX_ENABLE	0x00000008
+#define PHY_BRCM_EXT_IBND_TX_ENABLE	0x00000010
+#define PHY_BRCM_CLEAR_RGMII_MODE	0x00000020
+#define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00000040
+#define PHY_BRCM_EN_MASTER_MODE		0x00000080
 
 /* Broadcom BCM7xxx specific workarounds */
 #define PHY_BRCM_7XXX_REV(x)		(((x) >> 8) & 0xff)
-- 
2.25.1

