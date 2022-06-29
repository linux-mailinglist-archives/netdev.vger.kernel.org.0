Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2775755F397
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiF2Cvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiF2Cvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:51:31 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2846E22B12;
        Tue, 28 Jun 2022 19:51:29 -0700 (PDT)
X-UUID: dec8dfa0de7a416da9a8aa243eec2b53-20220629
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:999cf2b7-7187-440c-8dc6-3d120489eeba,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:100
X-CID-INFO: VERSION:1.1.7,REQID:999cf2b7-7187-440c-8dc6-3d120489eeba,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:100
X-CID-META: VersionHash:87442a2,CLOUDID:640f1ad6-5d6d-4eaf-a635-828a3ee48b7c,C
        OID:de6b7c378676,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: dec8dfa0de7a416da9a8aa243eec2b53-20220629
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 41037509; Wed, 29 Jun 2022 10:51:20 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 29 Jun 2022 10:51:19 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 29 Jun 2022 10:51:18 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Fabien Parent" <fparent@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        "Rob Herring" <robh@kernel.org>
Subject: [PATCH net-next v4 04/10] dt-bindings: net: mtk-star-emac: add support for MT8365
Date:   Wed, 29 Jun 2022 10:51:03 +0800
Message-ID: <20220629025109.21933-5-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629025109.21933-1-biao.huang@mediatek.com>
References: <20220629025109.21933-1-biao.huang@mediatek.com>
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

Add binding document for Ethernet on MT8365.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/mediatek,star-emac.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
index def994c9cbb4..6b0769e831a6 100644
--- a/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
@@ -23,6 +23,7 @@ properties:
       - mediatek,mt8516-eth
       - mediatek,mt8518-eth
       - mediatek,mt8175-eth
+      - mediatek,mt8365-eth
 
   reg:
     maxItems: 1
-- 
2.25.1

