Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E3F50E4DB
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiDYP6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiDYP6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:58:00 -0400
X-Greylist: delayed 322 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Apr 2022 08:54:56 PDT
Received: from mout.perfora.net (mout.perfora.net [74.208.4.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39C28930A
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:54:56 -0700 (PDT)
Received: from toolbox.int.toradex.com ([81.221.85.15]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MWj1Y-1nPCsS0WCG-00X6Jv;
 Mon, 25 Apr 2022 17:49:04 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     netdev@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v1] net: stmmac: dwmac-imx: comment spelling fix
Date:   Mon, 25 Apr 2022 17:48:56 +0200
Message-Id: <20220425154856.169499-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mu9bK8rJ3RbONCPFleKxVm8y/XpyuFrUVOlp1t0I5GIjR1cPhEp
 JXL2fZSF7pPFx+xTLi+Aq49pJ3HiFN7lMVBI5Ts7TddFRGXvGB8ygr02VXUz6QVaext0RNv
 +0P+v4g9NVXW08d3j/ux6QoYDTiJxxLU3Q2TBwAn2swEts57tAooR2Xv62D0OE3jtmYwz7X
 cYO02AscjIs8qBwD4vRNw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hc6RQQ0IfcI=:uwOrmQ8rU+7jQFMftyVz+W
 Um9hyolf7w07s9uAmth3EztoK4xt1a9uGFxotRtWhoPLkY8IFnbWSl7t/kYM/xOiX3pV8jKdK
 IUUls1Ayu8fyS0W+aTY/gu+oBr39/BGpqYbYJ46lSfc6HI/m1v2Zco7TijFHTFPhparAPnrQS
 PzTMXPMUESsa1LVJHF6wj4269lz8caI5a0g8pwnXYgWA62lhhxFIl8y98ht5Q4VLEJfMVAg+j
 1HeGkoVAEURAlzlHdCTq/HNFPX/dkCD0e7r8C1HhutBgLVutrjvbM3F9ZHKSReSvRz3a8a67R
 TocW1niS2iF4/63w2g/qFMV2QyGgAgibov7Jp6THDngF7GfXnbUq5vv/sAczNl4S7vPNjl3YP
 mc4ZCYna7TBIkLGm/YsLoPXbAjFwsCutH5rbMCMDnxDFWRKeIVUvatm5kEAtDamQybHS+rFDu
 sYFC6GyNYsR0mbR9qksYlunBWdAulloiKb7gh9/oyjlbCbUoW00w4IWumG9ItX38tQW4ycfMv
 0j+fD/IfywbhBg53gw3UokJII7yyE9jfR+1Mg6VprzBlC0UrrZh+aI7l57WC6xL6vGM2JDeLV
 lNK/BsWj3LEftyVrRJsDncz9KxBHM4a+8BlHTfIsGxghhxDthwCNs8x++qqT1KF2JovWYhZCm
 zHogce4K3nYP183USAxcTkZEHLY62ik0zRLcS7UQufOs/pCMMZssNYpfyq1eet+/6Jv8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

Fix spelling in comment.

Fixes: 94abdad6974a ("net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip")
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>

---

 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 84651207a1de..bd52fb7cf486 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -197,9 +197,9 @@ imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 	}
 
 	if (of_machine_is_compatible("fsl,imx8mp")) {
-		/* Binding doc describes the propety:
+		/* Binding doc describes the property:
 		   is required by i.MX8MP.
-		   is optinoal for i.MX8DXL.
+		   is optional for i.MX8DXL.
 		 */
 		dwmac->intf_regmap = syscon_regmap_lookup_by_phandle(np, "intf_mode");
 		if (IS_ERR(dwmac->intf_regmap))
-- 
2.35.1

