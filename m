Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F84E4E5CB6
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 02:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347157AbiCXBXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 21:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244361AbiCXBWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 21:22:53 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7789D92874;
        Wed, 23 Mar 2022 18:21:22 -0700 (PDT)
X-UUID: c871d5990f834fa483ca767a3b2c6b37-20220324
X-UUID: c871d5990f834fa483ca767a3b2c6b37-20220324
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1428822690; Thu, 24 Mar 2022 09:21:17 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 24 Mar 2022 09:21:15 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Mar 2022 09:21:14 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>
Subject: [PATCH net-next] dt-bindings: net: snps,dwmac: modify available values of PBL
Date:   Thu, 24 Mar 2022 09:21:12 +0800
Message-ID: <20220324012112.7016-2-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220324012112.7016-1-biao.huang@mediatek.com>
References: <20220324012112.7016-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PBL can be any of the following values: 1, 2, 4, 8, 16 or 32
according to the datasheet, so modify available values of PBL in
snps,dwmac.yaml.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 42689b7d03a2..856cd0b7a5b0 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -334,21 +334,21 @@ allOf:
           description:
             Programmable Burst Length (tx and rx)
           $ref: /schemas/types.yaml#/definitions/uint32
-          enum: [2, 4, 8]
+          enum: [1, 2, 4, 8, 16, 32]
 
         snps,txpbl:
           description:
             Tx Programmable Burst Length. If set, DMA tx will use this
             value rather than snps,pbl.
           $ref: /schemas/types.yaml#/definitions/uint32
-          enum: [2, 4, 8]
+          enum: [1, 2, 4, 8, 16, 32]
 
         snps,rxpbl:
           description:
             Rx Programmable Burst Length. If set, DMA rx will use this
             value rather than snps,pbl.
           $ref: /schemas/types.yaml#/definitions/uint32
-          enum: [2, 4, 8]
+          enum: [1, 2, 4, 8, 16, 32]
 
         snps,no-pbl-x8:
           $ref: /schemas/types.yaml#/definitions/flag
-- 
2.25.1

