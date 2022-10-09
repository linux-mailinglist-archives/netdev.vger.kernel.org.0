Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670585F8C4F
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiJIQX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 12:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJIQXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 12:23:48 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD06275F4;
        Sun,  9 Oct 2022 09:23:45 -0700 (PDT)
X-QQ-mid: bizesmtp62t1665332603tajhpaln
Received: from localhost.localdomain ( [58.247.70.42])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 10 Oct 2022 00:23:22 +0800 (CST)
X-QQ-SSF: 01100000002000G0Z000B00A0000000
X-QQ-FEAT: mlDbtcwYxrVsM9VTgGAbvh4oG3QjwoeoEFhNYsme4c5jkDKr6BAO1CfmBt1Gy
        tN1lsTeUJt/FPdnTy/v83ed5zK6L2/sLjdNIKwiYlwEjubdUNB/qTqVv/QG22mtXn4JpG6Y
        EhlP67yAK2C/Gm53vqlPuk7g2E8EOtF6WwANdVaS4l4Gy5dXAPR3xxjjzT3EOP9y5Iqtnse
        rOen6Z1IWFhpNxLBUvl17riuHy1VMBlfS8qPaNjQ1F/hCCP9vWShPZIvbDqSlPD16+ij4pe
        yj+PbLqsaYN3AWKTiOla0X5TgbHP8tumx3lLB2GnUjQa4XLbPMEWzN9cNsTfa1Vv0QqEhsY
        XlOFL8IaB9RAKAFwzUglWNFBQAQNYH86WMKVxZq7KxkAAtCmRRL92mu3v210g==
X-QQ-GoodBg: 0
From:   Soha Jin <soha@lohu.info>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yangyu Chen <cyy@cyyself.name>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Soha Jin <soha@lohu.info>
Subject: [PATCH 3/3] net: stmmac: switch to stmmac_platform_{probe,remove}_config
Date:   Mon, 10 Oct 2022 00:22:47 +0800
Message-Id: <20221009162247.1336-4-soha@lohu.info>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009162247.1336-1-soha@lohu.info>
References: <20221009162247.1336-1-soha@lohu.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since stmmac_{probe,remove}_config_dt are renamed to
stmmac_platform_{probe,remove}_config, change all calls to the two
functions to the new name.

Signed-off-by: Soha Jin <soha@lohu.info>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 6 +++---
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c         | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c  | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c    | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c       | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c       | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c          | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c     | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c         | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c       | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c       | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c       | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c    | 6 +++---
 19 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
index dfbaea06d108..46521a0e0aed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
@@ -115,7 +115,7 @@ static int anarion_dwmac_probe(struct platform_device *pdev)
 	if (IS_ERR(gmac))
 		return PTR_ERR(gmac);
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -126,7 +126,7 @@ static int anarion_dwmac_probe(struct platform_device *pdev)
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret) {
-		stmmac_remove_config_dt(pdev, plat_dat);
+		stmmac_platform_remove_config(pdev, plat_dat);
 		return ret;
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 80efdeeb0b59..5bf77efd0a62 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -439,7 +439,7 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	if (IS_ERR(stmmac_res.addr))
 		return PTR_ERR(stmmac_res.addr);
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -463,7 +463,7 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 remove:
 	data->remove(pdev);
 remove_config:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
@@ -485,7 +485,7 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 	if (err < 0)
 		dev_err(&pdev->dev, "failed to remove subdriver: %d\n", err);
 
-	stmmac_remove_config_dt(pdev, priv->plat);
+	stmmac_platform_remove_config(pdev, priv->plat);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index bd52fb7cf486..ff90772c476e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -231,7 +231,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	if (!dwmac)
 		return -ENOMEM;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -280,7 +280,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 err_clks_config:
 err_parse_dt:
 err_match_data:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 378b4dd826bb..62c4223e1943 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -242,7 +242,7 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -305,7 +305,7 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 	return 0;
 
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index 06d287f104be..7c43235ff3b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -85,7 +85,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat)) {
 		dev_err(&pdev->dev, "dt configuration failed\n");
 		return PTR_ERR(plat_dat);
@@ -164,7 +164,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	return 0;
 
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index e888c8a9c830..1f8a86cd9cab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -384,7 +384,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	if (val)
 		return val;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -485,7 +485,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	err = -EINVAL;
 
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
index 9d77c647badd..b4c39dddd881 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
@@ -37,7 +37,7 @@ static int lpc18xx_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -70,7 +70,7 @@ static int lpc18xx_dwmac_probe(struct platform_device *pdev)
 	return 0;
 
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index d42e1afb6521..5db70110fe87 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -679,7 +679,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -699,7 +699,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 err_drv_probe:
 	mediatek_dwmac_clks_config(priv_plat, false);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
index 16fb66a0ca72..d2ea935db120 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
@@ -52,7 +52,7 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -78,7 +78,7 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
 	return 0;
 
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c7a6588d9398..66d7b02c97f8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -398,7 +398,7 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -490,7 +490,7 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 	return 0;
 
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
index 62a69a91ab22..d3683400f58a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
@@ -154,7 +154,7 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -203,7 +203,7 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
 err_dwmac_exit:
 	oxnas_dwmac_exit(pdev, plat_dat->bsp_priv);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 835caa15d55f..8f2f461b34a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -514,7 +514,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat)) {
 		dev_err(&pdev->dev, "dt configuration failed\n");
 		return PTR_ERR(plat_dat);
@@ -571,7 +571,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	ethqos_clks_config(ethqos, false);
 
 err_mem:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index b13e8f4e4bf5..b793f7daf756 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1868,7 +1868,7 @@ static int rk_gmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -1902,7 +1902,7 @@ static int rk_gmac_probe(struct platform_device *pdev)
 err_gmac_powerdown:
 	rk_gmac_powerdown(plat_dat->bsp_priv);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 6b447d8f0bd8..894321a8f48c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -397,7 +397,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -448,7 +448,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 err_dvr_remove:
 	stmmac_dvr_remove(&pdev->dev);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index 710d7435733e..485a5fc66130 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -325,7 +325,7 @@ static int sti_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -363,7 +363,7 @@ static int sti_dwmac_probe(struct platform_device *pdev)
 disable_clk:
 	clk_disable_unprepare(dwmac->clk);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 2b38a499a404..4a6c43ed0458 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -371,7 +371,7 @@ static int stm32_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -412,7 +412,7 @@ static int stm32_dwmac_probe(struct platform_device *pdev)
 err_clk_disable:
 	stm32_dwmac_clk_disable(dwmac);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 573e0e0e9eda..07855a598571 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1205,7 +1205,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return -EINVAL;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -1277,7 +1277,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 dwmac_syscon:
 	sun8i_dwmac_unset_syscon(gmac);
 dwmac_deconfig:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index fc3b0acc8f99..d2dfb9624752 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -108,7 +108,7 @@ static int sun7i_gmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -166,7 +166,7 @@ static int sun7i_gmac_probe(struct platform_device *pdev)
 err_gmac_exit:
 	sun7i_gmac_exit(pdev, plat_dat->bsp_priv);
 err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index c3f10a92b62b..c0d6acd0897c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -221,7 +221,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = stmmac_platform_probe_config(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
@@ -254,7 +254,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 remove:
 	visconti_eth_clock_remove(pdev);
 remove_config:
-	stmmac_remove_config_dt(pdev, plat_dat);
+	stmmac_platform_remove_config(pdev, plat_dat);
 
 	return ret;
 }
@@ -273,7 +273,7 @@ static int visconti_eth_dwmac_remove(struct platform_device *pdev)
 	if (err < 0)
 		dev_err(&pdev->dev, "failed to remove clock: %d\n", err);
 
-	stmmac_remove_config_dt(pdev, priv->plat);
+	stmmac_platform_remove_config(pdev, priv->plat);
 
 	return err;
 }
-- 
2.30.2

