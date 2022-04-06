Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1D4F66E3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbiDFROf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbiDFROX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:14:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC974D3C1E
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4lhcZU1UliNq09YYX/sPSI7uRvQe7Xolf5tmFxI5yGQ=; b=lyuERrSwwLXMMotNdfbfP154yg
        EcXdzfCtzc1xiePoX1FuqwOxU4h6KSKdoWL1OkOg3gVfoTzcYpxsPNmAmohz1w+CYC6MAjVv64ygV
        VUR8GrpUSYZllGQqPNRR5Bh99ki8qpFSJM1BDey2V8SRc023kOZpNIpOZHm0quBkBP57xZk1TwjA6
        1F6Ektr9q1pGuF8ZQbg6fujooOh3D3mZePT6b+oPvUPJt68vc/5cUQlKtH0XWVbGBZLELPJRLpCd0
        vK4ZcNR0lqPKrz/QBrKP0y6eOedG8RPwdW0wJN+viBUJ1C0asiWqWQQxnE4c/fdgnrR2798g/4Z/6
        IuUbZKRg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60664 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc6kT-0002u9-JT; Wed, 06 Apr 2022 15:35:05 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc6kS-004ijd-N4; Wed, 06 Apr 2022 15:35:04 +0100
In-Reply-To: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
References: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 02/12] net: mtk_eth_soc: remove unused sgmii
 flags
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc6kS-004ijd-N4@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 15:35:04 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "flags" member of struct mtk_sgmii appears to be unused, as are
the MTK_SGMII_PHYSPEED_* and MTK_HAS_FLAGS() macros. Remove them.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 2b690f8a5391..8a10761adda0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -859,23 +859,15 @@ struct mtk_soc_data {
 /* currently no SoC has more than 2 macs */
 #define MTK_MAX_DEVS			2
 
-#define MTK_SGMII_PHYSPEED_AN          BIT(31)
-#define MTK_SGMII_PHYSPEED_MASK        GENMASK(2, 0)
-#define MTK_SGMII_PHYSPEED_1000        BIT(0)
-#define MTK_SGMII_PHYSPEED_2500        BIT(1)
-#define MTK_HAS_FLAGS(flags, _x)       (((flags) & (_x)) == (_x))
-
 /* struct mtk_sgmii -  This is the structure holding sgmii regmap and its
  *                     characteristics
  * @regmap:            The register map pointing at the range used to setup
  *                     SGMII modes
- * @flags:             The enum refers to which mode the sgmii wants to run on
  * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
  */
 
 struct mtk_sgmii {
 	struct regmap   *regmap[MTK_MAX_DEVS];
-	u32             flags[MTK_MAX_DEVS];
 	u32             ana_rgc3;
 };
 
-- 
2.30.2

