Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB70144D239
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 08:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhKKHPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 02:15:13 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:50744 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229649AbhKKHPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 02:15:12 -0500
X-UUID: d256bc8e433a42a28496a25a41389d46-20211111
X-UUID: d256bc8e433a42a28496a25a41389d46-20211111
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1191703551; Thu, 11 Nov 2021 15:12:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 11 Nov 2021 15:12:18 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 11 Nov 2021 15:12:17 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>
Subject: [PATCH v2 0/5] MediaTek Ethernet Patches on MT8195
Date:   Thu, 11 Nov 2021 15:12:09 +0800
Message-ID: <20211111071214.21027-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
1. fix errors/warnings in mediatek-dwmac.yaml with upgraded dtschema tools

This series include 5 patches:
1. add platform level clocks management for dwmac-mediatek
2. resue more common features defined in stmmac_platform.c
3. add ethernet entry for mt8195
4. convert mediatek-dwmac.txt to mediatek-dwmac.yaml
5. add ethernet device node for mt8195

Biao Huang (5):
  net: stmmac: dwmac-mediatek: add platform level clocks management
  net: stmmac: dwmac-mediatek: Reuse more common features
  net: stmmac: dwmac-mediatek: add support for mt8195
  dt-bindings: net: dwmac: Convert mediatek-dwmac to DT schema
  arm64: dts: mt8195: add ethernet device node

 .../bindings/net/mediatek-dwmac.txt           |  91 -----
 .../bindings/net/mediatek-dwmac.yaml          | 211 ++++++++++++
 arch/arm64/boot/dts/mediatek/mt8195-evb.dts   |  92 +++++
 arch/arm64/boot/dts/mediatek/mt8195.dtsi      |  70 ++++
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 313 ++++++++++++++++--
 5 files changed, 664 insertions(+), 113 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

--
2.18.0


