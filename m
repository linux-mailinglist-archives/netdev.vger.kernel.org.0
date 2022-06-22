Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29265546C9
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356480AbiFVJGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356202AbiFVJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:06:07 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7C92183E;
        Wed, 22 Jun 2022 02:06:06 -0700 (PDT)
X-UUID: df49e412c5984e699a4d32213b8e3d9a-20220622
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:705fdb46-5241-4df8-9d6f-acca5dcf3741,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:b14ad71,CLOUDID:fccbbd2d-1756-4fa3-be7f-474a6e4be921,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: df49e412c5984e699a4d32213b8e3d9a-20220622
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 963363311; Wed, 22 Jun 2022 17:05:58 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 22 Jun 2022 17:05:57 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 22 Jun 2022 17:05:56 +0800
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
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 07/10] dt-bindings: net: mtk-star-emac: add description for new properties
Date:   Wed, 22 Jun 2022 17:05:42 +0800
Message-ID: <20220622090545.23612-8-biao.huang@mediatek.com>
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

Add description for new properties which will be parsed in driver.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/mediatek,star-emac.yaml         | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
index 6b0769e831a6..64c893c98d80 100644
--- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
@@ -48,6 +48,22 @@ properties:
       Phandle to the device containing the PERICFG register range. This is used
       to control the MII mode.
 
+  mediatek,rmii-rxc:
+    type: boolean
+    description:
+      If present, indicates that the RMII reference clock, which is from external
+      PHYs, is connected to RXC pin. Otherwise, is connected to TXC pin.
+
+  mediatek,rxc-inverse:
+    type: boolean
+    description:
+      If present, indicates that clock on RXC pad will be inversed.
+
+  mediatek,txc-inverse:
+    type: boolean
+    description:
+      If present, indicates that clock on TXC pad will be inversed.
+
   mdio:
     $ref: mdio.yaml#
     unevaluatedProperties: false
-- 
2.25.1

