Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0EB44BD01
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhKJIm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:42:57 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:49108 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229653AbhKJIm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:42:56 -0500
X-UUID: 605f5c25076d4934906011bd96077482-20211110
X-UUID: 605f5c25076d4934906011bd96077482-20211110
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 861002986; Wed, 10 Nov 2021 16:40:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 10 Nov 2021 16:40:06 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Wed, 10 Nov 2021 16:40:05 +0800
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
Subject: [PATCH 0/5] MediaTek Ethernet Patches on MT8195
Date:   Wed, 10 Nov 2021 16:39:43 +0800
Message-ID: <20211110083948.6082-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 .../bindings/net/mediatek-dwmac.yaml          | 179 ++++++++++
 arch/arm64/boot/dts/mediatek/mt8195-evb.dts   |  92 +++++
 arch/arm64/boot/dts/mediatek/mt8195.dtsi      |  70 ++++
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 313 ++++++++++++++++--
 5 files changed, 632 insertions(+), 113 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

--
2.18.0


