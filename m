Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8E6B6E25
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjCMDrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCMDqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:46:51 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594F13B87E;
        Sun, 12 Mar 2023 20:46:50 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 28A4B24E389;
        Mon, 13 Mar 2023 11:46:49 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 13 Mar
 2023 11:46:49 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Mon, 13 Mar 2023 11:46:48 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Samin Guo <samin.guo@starfivetech.com>
Subject: [PATCH v6 2/8] net: stmmac: platform: Add snps,dwmac-5.20 IP compatible string
Date:   Mon, 13 Mar 2023 11:46:39 +0800
Message-ID: <20230313034645.5469-3-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230313034645.5469-1-samin.guo@starfivetech.com>
References: <20230313034645.5469-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

Add "snps,dwmac-5.20" compatible string for 5.20 version that can avoid
to define some platform data in the glue layer.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 067a40fe0a23..eb0b2898daa3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -519,7 +519,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
-	    of_device_is_compatible(np, "snps,dwmac-5.10a")) {
+	    of_device_is_compatible(np, "snps,dwmac-5.10a") ||
+	    of_device_is_compatible(np, "snps,dwmac-5.20")) {
 		plat->has_gmac4 = 1;
 		plat->has_gmac = 0;
 		plat->pmt = 1;
-- 
2.17.1

