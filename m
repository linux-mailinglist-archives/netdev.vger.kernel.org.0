Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC27A5546E3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357088AbiFVJGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356308AbiFVJGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:06:12 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFFB2251E;
        Wed, 22 Jun 2022 02:06:07 -0700 (PDT)
X-UUID: c50ded026a214356aade371bea5fc932-20220622
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:f81614f0-ff3f-4552-bf4e-6190cdfff317,OB:10,L
        OB:30,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,
        ACTION:release,TS:100
X-CID-INFO: VERSION:1.1.6,REQID:f81614f0-ff3f-4552-bf4e-6190cdfff317,OB:10,LOB
        :30,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,
        ACTION:quarantine,TS:100
X-CID-META: VersionHash:b14ad71,CLOUDID:79ccbd2d-1756-4fa3-be7f-474a6e4be921,C
        OID:9e1b96a75a71,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: c50ded026a214356aade371bea5fc932-20220622
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 699344263; Wed, 22 Jun 2022 17:06:02 +0800
Received: from mtkmbs07n1.mediatek.inc (172.21.101.16) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 22 Jun 2022 17:06:01 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 22 Jun 2022 17:06:00 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 22 Jun 2022 17:05:59 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v3 10/10] net: ethernet: mtk-star-emac: enable half duplex hardware support
Date:   Wed, 22 Jun 2022 17:05:45 +0800
Message-ID: <20220622090545.23612-11-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622090545.23612-1-biao.huang@mediatek.com>
References: <20220622090545.23612-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver don't support 100/10M duplex half function.
This patch enable half duplex capability in hardware.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 30 ++++++++-----------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 87e5bc9c343a..67e85705b770 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -883,32 +883,26 @@ static void mtk_star_phy_config(struct mtk_star_priv *priv)
 	val <<= MTK_STAR_OFF_PHY_CTRL1_FORCE_SPD;
 
 	val |= MTK_STAR_BIT_PHY_CTRL1_AN_EN;
-	val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_RX;
-	val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_TX;
-	/* Only full-duplex supported for now. */
-	val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_DPX;
-
-	regmap_write(priv->regs, MTK_STAR_REG_PHY_CTRL1, val);
-
 	if (priv->pause) {
-		val = MTK_STAR_VAL_FC_CFG_SEND_PAUSE_TH_2K;
-		val <<= MTK_STAR_OFF_FC_CFG_SEND_PAUSE_TH;
-		val |= MTK_STAR_BIT_FC_CFG_UC_PAUSE_DIR;
+		val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_RX;
+		val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_TX;
+		val |= MTK_STAR_BIT_PHY_CTRL1_FORCE_DPX;
 	} else {
-		val = 0;
+		val &= ~MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_RX;
+		val &= ~MTK_STAR_BIT_PHY_CTRL1_FORCE_FC_TX;
+		val &= ~MTK_STAR_BIT_PHY_CTRL1_FORCE_DPX;
 	}
+	regmap_write(priv->regs, MTK_STAR_REG_PHY_CTRL1, val);
 
+	val = MTK_STAR_VAL_FC_CFG_SEND_PAUSE_TH_2K;
+	val <<= MTK_STAR_OFF_FC_CFG_SEND_PAUSE_TH;
+	val |= MTK_STAR_BIT_FC_CFG_UC_PAUSE_DIR;
 	regmap_update_bits(priv->regs, MTK_STAR_REG_FC_CFG,
 			   MTK_STAR_MSK_FC_CFG_SEND_PAUSE_TH |
 			   MTK_STAR_BIT_FC_CFG_UC_PAUSE_DIR, val);
 
-	if (priv->pause) {
-		val = MTK_STAR_VAL_EXT_CFG_SND_PAUSE_RLS_1K;
-		val <<= MTK_STAR_OFF_EXT_CFG_SND_PAUSE_RLS;
-	} else {
-		val = 0;
-	}
-
+	val = MTK_STAR_VAL_EXT_CFG_SND_PAUSE_RLS_1K;
+	val <<= MTK_STAR_OFF_EXT_CFG_SND_PAUSE_RLS;
 	regmap_update_bits(priv->regs, MTK_STAR_REG_EXT_CFG,
 			   MTK_STAR_MSK_EXT_CFG_SND_PAUSE_RLS, val);
 }
-- 
2.25.1

