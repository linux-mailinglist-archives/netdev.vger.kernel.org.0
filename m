Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7643865E23D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjAEBH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjAEBHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:07:46 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9782C47301;
        Wed,  4 Jan 2023 17:07:20 -0800 (PST)
X-UUID: 38fbeae31509422197a3de9e5fb210df-20230105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=vZIxcWR779ldyt1fvZOQIpom6NbLwQbTa9jDKIb5dmY=;
        b=WMUzEngBUooNAQ2d02YpgjogtZTRM5Iax8vItJF6pWHhh/ozTndrTOUgZQj4pPE/vtvd29o+qZWpHNRZc2SxZzh62QKG4RbLQZYWeDvO/KIFmd/7fVdfbaVGZJkdCfaNvNrJYwupOq6XTMf5IAo9tQF6wFEwBpF5KfMlLgT9+cw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.16,REQID:d73ce66f-9340-4f7e-a1b4-b3c8a64743a1,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:09771b1,CLOUDID:ab00aa53-dd49-462e-a4be-2143a3ddc739,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: 38fbeae31509422197a3de9e5fb210df-20230105
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1295684331; Thu, 05 Jan 2023 09:07:16 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 5 Jan 2023 09:07:15 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 5 Jan 2023 09:07:14 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Biao Huang" <biao.huang@mediatek.com>, <macpaul.lin@mediatek.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v8 0/2] arm64: dts: mt8195: Add Ethernet controller
Date:   Thu, 5 Jan 2023 09:07:10 +0800
Message-ID: <20230105010712.10116-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v8:
1. add reviewed-by as Andrew's comments.

Changes in v7:
1. move mdio node to .dtsi, and remove the compatible
property in ethernet-phy node as Andrew's comments.
2. add netdev@ to cc list as Jakub's reminder.

Changes in v6:
1. add reviewed-by as Angelo's comments
2. remove fix_mac_speed in driver as Andrew's comments.

Changes in v5:
1. reorder the clocks as Angelo's comments
2. add a driver patch to fix rgmii-id issue, then we can
use a ususal way rgmii/rgmii-id as Andrew's comments.

Changes in v4:
1. remove {address,size}-cells = <0> to avoid warning as Angelo's feedback.
2. Add reviewd-by as Angelo's comments.

Changes in v3:
1. move stmmac-axi-config, rx-queues-config, tx-queues-configs inside ethernet
node as Angelo's comments.
2. add {address,size}-cells = <0> in ethernet node as Angelo's comments.

Changes in v2:
1. modify pinctrl node used by ethernet to match rules in pinctrl-mt8195.yaml,
which is pointed by Krzysztof.
2. remove "mac-address" property in ethernet node as comments of Krzysztof.

Changes in v1:
add dts node for MT8195 Ethernet controller

Biao Huang (2):
  stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed
  arm64: dts: mt8195: Add Ethernet controller

 arch/arm64/boot/dts/mediatek/mt8195-demo.dts  | 77 ++++++++++++++++
 arch/arm64/boot/dts/mediatek/mt8195.dtsi      | 92 +++++++++++++++++++
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 26 ------
 3 files changed, 169 insertions(+), 26 deletions(-)

-- 
2.25.1


