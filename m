Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA15ED886
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiI1JL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiI1JLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:11:18 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AFE61D83;
        Wed, 28 Sep 2022 02:11:11 -0700 (PDT)
X-UUID: e3994a2d20534c51af314c113de65013-20220928
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=3cDQVA9bjdmMpcOqCndMC32qsr5AQsK3J0savjTAlgE=;
        b=gY9R8YK3d+oxSh6IIRkXt1uqvlsFrlpPM6KPZzxwPDVqyaOdruDr+bnKblctiMrSGx44lx2gMv+tkedEBT8NQ88oH7IOCrAUA0zk1b84VCRg4IUi6TcUuQ4k1KG+9txeVcdViofWh/axfBLDoKzfL34SouEa/G4u5Yk7B6Jk2t8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:52f7bde5-f76a-43a4-9b4e-be8f56fe004a,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:ab2982e4-87f9-4bb0-97b6-34957dc0fbbe,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e3994a2d20534c51af314c113de65013-20220928
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1842300603; Wed, 28 Sep 2022 17:11:05 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 28 Sep 2022 17:11:03 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 28 Sep 2022 17:11:02 +0800
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Jianguo Zhang <jianguo.zhang@mediatek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v6 1/4] dt-bindings: net: mediatek-dwmac: add support for mt8188
Date:   Wed, 28 Sep 2022 17:10:49 +0800
Message-ID: <20220928091052.18490-2-jianguo.zhang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928091052.18490-1-jianguo.zhang@mediatek.com>
References: <20220928091052.18490-1-jianguo.zhang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for the ethernet on mt8188

Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/net/mediatek-dwmac.yaml        | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
index 61b2fb9e141b..0fa2132fa4f4 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -19,6 +19,7 @@ select:
       contains:
         enum:
           - mediatek,mt2712-gmac
+          - mediatek,mt8188-gmac
           - mediatek,mt8195-gmac
   required:
     - compatible
@@ -37,6 +38,11 @@ properties:
           - enum:
               - mediatek,mt8195-gmac
           - const: snps,dwmac-5.10a
+      - items:
+          - enum:
+              - mediatek,mt8188-gmac
+          - const: mediatek,mt8195-gmac
+          - const: snps,dwmac-5.10a
 
   clocks:
     minItems: 5
@@ -74,7 +80,7 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
-      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
+      For MT8188/MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
       or will round down. Range 0~31*290.
 
   mediatek,rx-delay-ps:
@@ -84,7 +90,7 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
-      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
+      For MT8188/MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
       of 290, or will round down. Range 0~31*290.
 
   mediatek,rmii-rxc:
-- 
2.25.1

