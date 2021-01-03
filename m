Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0AD2E8BE3
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbhACLSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:18:38 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:38097 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbhACLSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:18:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 8129E554;
        Sun,  3 Jan 2021 06:17:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 03 Jan 2021 06:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=0iZ+8I2vhcGKG
        OS3MTEj028/bvfO5WdjDUade1mx8mM=; b=SCxPQeXteWOqWKOQL26Jc54vLalZc
        Wi6vYAQxSaMZUJhelkTg/Bd5okVlbs76hqj/bbPfWuSKOZLlnRFFyp7dwNe4wCO8
        ACDvWZENXNjQFql/uqOI3oPAToLVUA6VtYePuY5OwAH36/xpaSTylnjnQHkqs3bA
        81IOOvBXExAXswJAjcqzdCEoDoxalEvA5l2QbNdMZES3F1UVVBMMPNtLfo7Z0WWk
        6led8Ub0+FtyqiEn2hi3sBNJaGpYJkl5/r/t66Xnitwua8ifG4aIHF7Njea9KM/2
        GQc/mOJAyki2QwvxgW98orr96jmrqNz/tEXfTwox/xevh1VzbO38tgC8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0iZ+8I2vhcGKGOS3MTEj028/bvfO5WdjDUade1mx8mM=; b=aILljLwS
        Zx4KBH3CcHQG1ZGbDwWiPlXMDgg3ksA1Ss5T30+2OH2vVJJ7XVmk9l1U60oewPHt
        ZNL5VXqtMiETHSApdC6npl+0oxF/YxaIlx+U9eEQtDyR4DNYQNOvJ49iGckbsA+V
        sVhoQ/9zLlquX+LLyg3XvLwsj+tUHPyEOUmIk2EF1OLMrL6Zs95ZCUN5oF4V3ptE
        MxF3M5f9/79BJalUMMg8EU9CcgjJYVOd1wcBoqNS8e9o1Cn2qGpVgAm7Zg99qgnV
        CpphtGRLi1Hn7Bnt/4dJusgY4ZqVZILXtd4kUAWsY9pTaHc850rO3Lgs4V5qazr9
        +f/JlXNwARv9VQ==
X-ME-Sender: <xms:26fxX4K54hMZKoFolbZudGPvjnBQGG0-loiDuhDeET7pqJ5lnwmWIQ>
    <xme:26fxX8ezo4dC6T2P3vcI7_JSddBuZzotB6tsNldXJm50niprfphRRNBr6Zyu8IzBR
    lA9NOxrq_vu8aM5_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:26fxX30IQf0DVUcMJbfEB3kYQLcqXo8ZT62soeYXjxE7SeJzKd8Aog>
    <xmx:26fxX9jiXi0FdmXn4nNrGexMktZw6qu1-AOzr0YKkfMqIyn4MtkZOQ>
    <xmx:26fxX1Su0jS_aAfbeGXglAU-GlZ4c_GXBeC9AtmasGGpMMKMKoN3sQ>
    <xmx:3KfxX8ApuIxUhz7C0RrRl1qnhgnvIgsA0mNMSDkJcxGlbDLrBIm9Y1YzN2M>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0111E108005C;
        Sun,  3 Jan 2021 06:17:46 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>
Subject: [PATCH net 4/4] net: stmmac: dwmac-sun8i: Balance syscon (de)initialization
Date:   Sun,  3 Jan 2021 05:17:44 -0600
Message-Id: <20210103111744.34989-5-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103111744.34989-1-samuel@sholland.org>
References: <20210103111744.34989-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, sun8i_dwmac_set_syscon was called from a chain of functions
in several different files:
    sun8i_dwmac_probe
      stmmac_dvr_probe
        stmmac_hw_init
          stmmac_hwif_init
            sun8i_dwmac_setup
              sun8i_dwmac_set_syscon
which made the lifetime of the syscon values hard to reason about. Part
of the problem is that there is no similar platform driver callback from
stmmac_dvr_remove. As a result, the driver unset the syscon value in
sun8i_dwmac_exit, but this leaves it uninitialized after a suspend/
resume cycle. It was also unset a second time (outside sun8i_dwmac_exit)
in the probe error path.

Move the init to the earliest available place in sun8i_dwmac_probe
(after stmmac_probe_config_dt, which initializes plat_dat), and the
deinit to the corresponding position in the cleanup order.

Since priv is not filled in until stmmac_dvr_probe, this requires
changing the sun8i_dwmac_set_syscon parameters to priv's two relevant
members.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index e2c25c1c702a..a5e0eff4a387 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -898,22 +898,23 @@ static int sun8i_dwmac_register_mdio_mux(struct stmmac_priv *priv)
 	return ret;
 }
 
-static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
+static int sun8i_dwmac_set_syscon(struct device *dev,
+				  struct plat_stmmacenet_data *plat)
 {
-	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
-	struct device_node *node = priv->device->of_node;
+	struct sunxi_priv_data *gmac = plat->bsp_priv;
+	struct device_node *node = dev->of_node;
 	int ret;
 	u32 reg, val;
 
 	ret = regmap_field_read(gmac->regmap_field, &val);
 	if (ret) {
-		dev_err(priv->device, "Fail to read from regmap field.\n");
+		dev_err(dev, "Fail to read from regmap field.\n");
 		return ret;
 	}
 
 	reg = gmac->variant->default_syscon_value;
 	if (reg != val)
-		dev_warn(priv->device,
+		dev_warn(dev,
 			 "Current syscon value is not the default %x (expect %x)\n",
 			 val, reg);
 
@@ -926,9 +927,9 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 		/* Force EPHY xtal frequency to 24MHz. */
 		reg |= H3_EPHY_CLK_SEL;
 
-		ret = of_mdio_parse_addr(priv->device, priv->plat->phy_node);
+		ret = of_mdio_parse_addr(dev, plat->phy_node);
 		if (ret < 0) {
-			dev_err(priv->device, "Could not parse MDIO addr\n");
+			dev_err(dev, "Could not parse MDIO addr\n");
 			return ret;
 		}
 		/* of_mdio_parse_addr returns a valid (0 ~ 31) PHY
@@ -944,17 +945,17 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 
 	if (!of_property_read_u32(node, "allwinner,tx-delay-ps", &val)) {
 		if (val % 100) {
-			dev_err(priv->device, "tx-delay must be a multiple of 100\n");
+			dev_err(dev, "tx-delay must be a multiple of 100\n");
 			return -EINVAL;
 		}
 		val /= 100;
-		dev_dbg(priv->device, "set tx-delay to %x\n", val);
+		dev_dbg(dev, "set tx-delay to %x\n", val);
 		if (val <= gmac->variant->tx_delay_max) {
 			reg &= ~(gmac->variant->tx_delay_max <<
 				 SYSCON_ETXDC_SHIFT);
 			reg |= (val << SYSCON_ETXDC_SHIFT);
 		} else {
-			dev_err(priv->device, "Invalid TX clock delay: %d\n",
+			dev_err(dev, "Invalid TX clock delay: %d\n",
 				val);
 			return -EINVAL;
 		}
@@ -962,17 +963,17 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 
 	if (!of_property_read_u32(node, "allwinner,rx-delay-ps", &val)) {
 		if (val % 100) {
-			dev_err(priv->device, "rx-delay must be a multiple of 100\n");
+			dev_err(dev, "rx-delay must be a multiple of 100\n");
 			return -EINVAL;
 		}
 		val /= 100;
-		dev_dbg(priv->device, "set rx-delay to %x\n", val);
+		dev_dbg(dev, "set rx-delay to %x\n", val);
 		if (val <= gmac->variant->rx_delay_max) {
 			reg &= ~(gmac->variant->rx_delay_max <<
 				 SYSCON_ERXDC_SHIFT);
 			reg |= (val << SYSCON_ERXDC_SHIFT);
 		} else {
-			dev_err(priv->device, "Invalid RX clock delay: %d\n",
+			dev_err(dev, "Invalid RX clock delay: %d\n",
 				val);
 			return -EINVAL;
 		}
@@ -983,7 +984,7 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 	if (gmac->variant->support_rmii)
 		reg &= ~SYSCON_RMII_EN;
 
-	switch (priv->plat->interface) {
+	switch (plat->interface) {
 	case PHY_INTERFACE_MODE_MII:
 		/* default */
 		break;
@@ -997,8 +998,8 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 		reg |= SYSCON_RMII_EN | SYSCON_ETCS_EXT_GMII;
 		break;
 	default:
-		dev_err(priv->device, "Unsupported interface mode: %s",
-			phy_modes(priv->plat->interface));
+		dev_err(dev, "Unsupported interface mode: %s",
+			phy_modes(plat->interface));
 		return -EINVAL;
 	}
 
@@ -1023,8 +1024,6 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 			sun8i_dwmac_unpower_internal_phy(gmac);
 	}
 
-	sun8i_dwmac_unset_syscon(gmac);
-
 	clk_disable_unprepare(gmac->tx_clk);
 
 	if (gmac->regulator)
@@ -1059,16 +1058,11 @@ static struct mac_device_info *sun8i_dwmac_setup(void *ppriv)
 {
 	struct mac_device_info *mac;
 	struct stmmac_priv *priv = ppriv;
-	int ret;
 
 	mac = devm_kzalloc(priv->device, sizeof(*mac), GFP_KERNEL);
 	if (!mac)
 		return NULL;
 
-	ret = sun8i_dwmac_set_syscon(priv);
-	if (ret)
-		return NULL;
-
 	mac->pcsr = priv->ioaddr;
 	mac->mac = &sun8i_dwmac_ops;
 	mac->dma = &sun8i_dwmac_dma_ops;
@@ -1224,10 +1218,14 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	plat_dat->exit = sun8i_dwmac_exit;
 	plat_dat->setup = sun8i_dwmac_setup;
 
-	ret = sun8i_dwmac_init(pdev, plat_dat->bsp_priv);
+	ret = sun8i_dwmac_set_syscon(&pdev->dev, plat_dat);
 	if (ret)
 		goto dwmac_deconfig;
 
+	ret = sun8i_dwmac_init(pdev, plat_dat->bsp_priv);
+	if (ret)
+		goto dwmac_syscon;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto dwmac_exit;
@@ -1256,11 +1254,12 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 dwmac_mux:
 	reset_control_put(gmac->rst_ephy);
 	clk_put(gmac->ephy_clk);
-	sun8i_dwmac_unset_syscon(gmac);
 dwmac_remove:
 	stmmac_dvr_remove(&pdev->dev);
 dwmac_exit:
 	sun8i_dwmac_exit(pdev, gmac);
+dwmac_syscon:
+	sun8i_dwmac_unset_syscon(gmac);
 dwmac_deconfig:
 	stmmac_remove_config_dt(pdev, plat_dat);
 
@@ -1281,6 +1280,7 @@ static int sun8i_dwmac_remove(struct platform_device *pdev)
 	}
 
 	stmmac_pltfr_remove(pdev);
+	sun8i_dwmac_unset_syscon(gmac);
 
 	return 0;
 }
-- 
2.26.2

