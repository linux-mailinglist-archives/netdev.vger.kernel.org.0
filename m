Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670B05ED8D6
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiI1JXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbiI1JXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:23:24 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E5EACA32;
        Wed, 28 Sep 2022 02:23:22 -0700 (PDT)
X-UUID: 3ceede385b6d4e5686df32ff77bebdac-20220928
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=oVDBocalE6iH6BUbpNZ/+kTn1nGjDCnsZXt//IzMZh0=;
        b=EYGDfCU/QEIUz1FkSN97nBKh8xquMrznVONw6/UXRDLxV7rXSsdJsP1opBmKFfwpfsYeoUHLliFVXdVnyxd/A72+WL7/IT/oFUOEX4eWZpDIGZVJghdYECNW0n5fXcNrZSgNeRlTMagpCgquEaWQv3rx52/kyXLadkINtNMaAoc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:9eb96133-3a5c-4c2c-bcd1-54205daca566,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.11,REQID:9eb96133-3a5c-4c2c-bcd1-54205daca566,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:39a5ff1,CLOUDID:659782e4-87f9-4bb0-97b6-34957dc0fbbe,B
        ulkID:220928171106ITR6S7KD,BulkQuantity:4,Recheck:0,SF:38|28|17|19|48|823|
        824,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:41,QS:nil,BEC:nil,C
        OL:0
X-UUID: 3ceede385b6d4e5686df32ff77bebdac-20220928
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 628848197; Wed, 28 Sep 2022 17:23:16 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 28 Sep 2022 17:23:14 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 28 Sep 2022 17:23:13 +0800
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
Subject: [resend PATCH v6 2/4] dt-bindings: net: snps,dwmac: add new property snps,clk-csr
Date:   Wed, 28 Sep 2022 17:23:06 +0800
Message-ID: <20220928092308.26019-3-jianguo.zhang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928092308.26019-1-jianguo.zhang@mediatek.com>
References: <20220928092308.26019-1-jianguo.zhang@mediatek.com>
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

Add description for new property snps,clk-csr in binding file

Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 491597c02edf..4d5a56661322 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -288,6 +288,11 @@ properties:
       is supported. For example, this is used in case of SGMII and
       MAC2MAC connection.
 
+  snps,clk-csr:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Frequency division factor for MDC clock.
+
   mdio:
     $ref: mdio.yaml#
     unevaluatedProperties: false
-- 
2.25.1

