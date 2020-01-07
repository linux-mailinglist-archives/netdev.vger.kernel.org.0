Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C96132642
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 13:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgAGMfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 07:35:48 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:37356 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbgAGMfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 07:35:48 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6ECAB40658;
        Tue,  7 Jan 2020 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578400547; bh=qQZag1I8R5PX/PjsmWAZ3BDd3y8GbUX/piPPUPjODLw=;
        h=From:To:Cc:Subject:Date:From;
        b=eSWXXQ1XEyBAb94L/Tyjk35aD4jA749VPpIOlN92dbUc4+RbuSq/toh3E46/7Fgtt
         afCiwBfzvkyRYsS22krlg1wcwCgDUx7DCwefSq9+D1bLuZd7aIrQ0HFilFAAgFGyHx
         lZvwyRduqpK3GEZK8asUKf/SOosLZCZoRDBcWsEsKxfdpCoT921L/JOMMSl/Gpqgsv
         ZzCleRLHHNbjVCJ44qqD9j/YaLywNlTuARm8knGOSJSdcZ76v8xU3IWCgqasxs1mJL
         siY693svDVMEnytCYF2b3dB8XqyhQpweF3LFdIUPVf0wt6rY0zlIN4fuk2o5DaplL7
         bbDKWilKBiVbA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B3CDBA005C;
        Tue,  7 Jan 2020 12:35:43 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>,
        "kernelci . org bot" <bot@kernelci.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH net] net: stmmac: Fixed link does not need MDIO Bus
Date:   Tue,  7 Jan 2020 13:35:42 +0100
Message-Id: <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using fixed link we don't need the MDIO bus support.

Reported-by: Heiko Stuebner <heiko@sntech.de>
Reported-by: kernelci.org bot <bot@kernelci.org>
Fixes: d3e014ec7d5e ("net: stmmac: platform: Fix MDIO init for platforms without PHY")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: kernelci.org bot <bot@kernelci.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sriram Dash <sriram.dash@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index cc8d7e7bf9ac..4775f49d7f3b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -320,7 +320,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 			 struct device_node *np, struct device *dev)
 {
-	bool mdio = false;
+	bool mdio = !of_phy_is_fixed_link(np);
 	static const struct of_device_id need_mdio_ids[] = {
 		{ .compatible = "snps,dwc-qos-ethernet-4.10" },
 		{},
-- 
2.7.4

