Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18FD397E26
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFBBj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:59 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3377 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhFBBj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 21:39:59 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fvs5L517Tz67kb;
        Wed,  2 Jun 2021 09:34:30 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 09:38:12 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <rjui@broadcom.com>, <sbranden@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <narmstrong@baylibre.com>,
        <khilman@baylibre.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-amlogic@lists.infradead.org>
CC:     <opendmb@gmail.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <jbrunet@baylibre.com>,
        <martin.blumenstingl@googlemail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 net-next] net: mdio: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 09:51:51 +0800
Message-ID: <20210602015151.4135891-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

informations  ==> information
typicaly  ==> typically
derrive  ==> derive
eventhough  ==> even though
hz ==> Hz

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/mdio/mdio-bcm-unimac.c     | 2 +-
 drivers/net/mdio/mdio-mux-bcm-iproc.c  | 2 +-
 drivers/net/mdio/mdio-mux-meson-g12a.c | 2 +-
 drivers/net/mdio/of_mdio.c             | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index 5d171e7f118d..63348716b426 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -203,7 +203,7 @@ static void unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
 		return;
 	}
 
-	/* The MDIO clock is the reference clock (typicaly 250Mhz) divided by
+	/* The MDIO clock is the reference clock (typically 250MHz) divided by
 	 * 2 x (MDIO_CLK_DIV + 1)
 	 */
 	reg = unimac_mdio_readl(priv, MDIO_CFG);
diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 03261e6b9ceb..239e88c7a272 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -65,7 +65,7 @@ static void mdio_mux_iproc_config(struct iproc_mdiomux_desc *md)
 	writel(val, md->base + MDIO_SCAN_CTRL_OFFSET);
 
 	if (md->core_clk) {
-		/* use rate adjust regs to derrive the mdio's operating
+		/* use rate adjust regs to derive the mdio's operating
 		 * frequency from the specified core clock
 		 */
 		divisor = clk_get_rate(md->core_clk) / MDIO_OPERATING_FREQUENCY;
diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index bf86c9c7a288..b8866bc3f2e8 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -95,7 +95,7 @@ static int g12a_ephy_pll_enable(struct clk_hw *hw)
 
 	/* Poll on the digital lock instead of the usual analog lock
 	 * This is done because bit 31 is unreliable on some SoC. Bit
-	 * 31 may indicate that the PLL is not lock eventhough the clock
+	 * 31 may indicate that the PLL is not lock even though the clock
 	 * is actually running
 	 */
 	return readl_poll_timeout(pll->base + ETH_PLL_CTL0, val,
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 094494a68ddf..8e97d5b825f5 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -466,7 +466,7 @@ EXPORT_SYMBOL(of_phy_get_and_connect);
  * of_phy_is_fixed_link() and of_phy_register_fixed_link() must
  * support two DT bindings:
  * - the old DT binding, where 'fixed-link' was a property with 5
- *   cells encoding various informations about the fixed PHY
+ *   cells encoding various information about the fixed PHY
  * - the new DT binding, where 'fixed-link' is a sub-node of the
  *   Ethernet device.
  */
-- 
2.25.1

