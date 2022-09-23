Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9285E7369
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 07:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiIWF2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 01:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiIWF2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 01:28:52 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C0411C174;
        Thu, 22 Sep 2022 22:28:51 -0700 (PDT)
X-UUID: 44d21e3c74ca4372bc8406b2dd3138a1-20220923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zodG3TIj/bxvoQArJAAN1YPKHEtL0GfJ0B9pLll9oSI=;
        b=fILl0P663EdWcu2dytwg9tnH510Ui+nelhjvtbaNgT091OfoYjKWbswQACBk1ZApxcxUHQRcPylpcSuyrmWlBjycYHhpxyrdBfDzqW6den4vwnuOWD8Dn0/wFwWQOqKGKIuMKPdXgA1UmbnHUF9vGgWd+wLm8ivkb4Z43FSLTmg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:a84566eb-42f5-49a1-bc5a-af281a6c0e09,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:4897d1a2-dc04-435c-b19b-71e131a5fc35,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 44d21e3c74ca4372bc8406b2dd3138a1-20220923
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 670686664; Fri, 23 Sep 2022 13:28:46 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 23 Sep 2022 13:28:45 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Sep 2022 13:28:44 +0800
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
        Jianguo Zhang <jianguo.zhang@mediatek.com>
Subject: [PATCH v5 3/4] arm64: dts: mediatek: mt2712e: Update the name of property 'clk_csr'
Date:   Fri, 23 Sep 2022 13:28:27 +0800
Message-ID: <20220923052828.16581-4-jianguo.zhang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
References: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
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

Update the name of property 'clk_csr' as 'snps,clk-csr' to align with
the property name in the binding file.

Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index 4797537cb368..e6d7453e56e0 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -756,7 +756,7 @@ eth: ethernet@1101c000 {
 		snps,mtl-tx-config = <&mtl_tx_setup>;
 		snps,txpbl = <1>;
 		snps,rxpbl = <1>;
-		clk_csr = <0>;
+		snps,clk-csr = <0>;
 		status = "disabled";
 	};
 
-- 
2.25.1

