Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309745BE056
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiITIiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiITIhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:37:47 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB4B6AA2D;
        Tue, 20 Sep 2022 01:36:36 -0700 (PDT)
X-UUID: 25260e49659347a690f10739ad28870f-20220920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=os0PbrdHlHnruzg6s40DMxywV3fPZwOCIS3lqIlzsCw=;
        b=hLq+H9AikZD1AXsAiK3wVwh55072XeXMIQpymaVSCjRY5/FH+AHz7XEfKm6ni4bQ1YXVIUVp1TwojwdHbgWSFdzGn74YScG3jNPZG2dl1TEJKHQxc1xAQSB4Lto9ZQYrQwTSnh/loOOMZK8HcODrPQUD4wjAR0kN/62dxJqdjPA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:60738bc5-a876-413a-a57f-21d2e2729fc6,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.11,REQID:60738bc5-a876-413a-a57f-21d2e2729fc6,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:39a5ff1,CLOUDID:6aef425e-5ed4-4e28-8b00-66ed9f042fbd,B
        ulkID:220920163627CB5MTEEL,BulkQuantity:1,Recheck:0,SF:28|17|19|48|823|824
        ,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:
        0
X-UUID: 25260e49659347a690f10739ad28870f-20220920
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1715138971; Tue, 20 Sep 2022 16:36:25 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 20 Sep 2022 16:36:24 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 20 Sep 2022 16:36:23 +0800
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
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
        Jianguo Zhang <jianguo.zhang@mediatek.com>
Subject: [PATCH 1/2] dt-bindings: net: mediatek-dwmac: add support for mt8188
Date:   Tue, 20 Sep 2022 16:36:16 +0800
Message-ID: <20220920083617.4177-2-jianguo.zhang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220920083617.4177-1-jianguo.zhang@mediatek.com>
References: <20220920083617.4177-1-jianguo.zhang@mediatek.com>
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
---
 .../devicetree/bindings/net/mediatek-dwmac.yaml        | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
index 61b2fb9e141b..eaf7e8d53432 100644
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -20,6 +20,7 @@ select:
         enum:
           - mediatek,mt2712-gmac
           - mediatek,mt8195-gmac
+          - mediatek,mt8188-gmac
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
+      For MT8195/MT8188 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
       or will round down. Range 0~31*290.
 
   mediatek,rx-delay-ps:
@@ -84,7 +90,7 @@ properties:
       or will round down. Range 0~31*170.
       For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
       or will round down. Range 0~31*550.
-      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
+      For MT8195/MT8188 RGMII/RMII/MII interface, Allowed value need to be a multiple
       of 290, or will round down. Range 0~31*290.
 
   mediatek,rmii-rxc:
-- 
2.25.1

