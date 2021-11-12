Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2344E3F4
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 10:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhKLJmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 04:42:25 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:57792 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234761AbhKLJmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 04:42:24 -0500
X-UUID: a461190ad1864952a97ab231ead45302-20211112
X-UUID: a461190ad1864952a97ab231ead45302-20211112
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1047386741; Fri, 12 Nov 2021 17:39:28 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 12 Nov 2021 17:39:27 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Nov 2021 17:39:20 +0800
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
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: [PATCH v3 0/7] MediaTek Ethernet Patches on MT8195
Date:   Fri, 12 Nov 2021 17:39:11 +0800
Message-ID: <20211112093918.11061-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
1. Add prefix "net-next" to support new IC as Denis's suggestion.
2. Split dt-bindings to two patches, one for convertion, and the other for
   new IC.
3. add a new patch to update device node in mt2712-evb.dts to accommodate to
   changes in driver.
4. remove unnecessary wrapper as Angelo's suggestion.
5. Add acked-by in "net-next: stmmac: dwmac-mediatek: Reuse more common
   features" patch.

Changes in v2:
1. fix errors/warnings in mediatek-dwmac.yaml with upgraded dtschema tools

This series include 5 patches:
1. add platform level clocks management for dwmac-mediatek
2. resue more common features defined in stmmac_platform.c
3. add ethernet entry for mt8195
4. convert mediatek-dwmac.txt to mediatek-dwmac.yaml
5. add ethernet device node for mt8195

Biao Huang (7):
  net-next: stmmac: dwmac-mediatek: add platform level clocks management
  net-next: stmmac: dwmac-mediatek: Reuse more common features
  arm64: dts: mt2712: update ethernet device node
  net-next: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
  net-next: stmmac: dwmac-mediatek: add support for mt8195
  arm64: dts: mt8195: add ethernet device node
  net-next: dt-bindings: dwmac: add support for mt8195

 .../bindings/net/mediatek-dwmac.txt           |  91 ------
 .../bindings/net/mediatek-dwmac.yaml          | 211 ++++++++++++
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts   |   1 +
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi     |  14 +-
 arch/arm64/boot/dts/mediatek/mt8195-evb.dts   |  92 ++++++
 arch/arm64/boot/dts/mediatek/mt8195.dtsi      |  70 ++++
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 305 ++++++++++++++++--
 7 files changed, 666 insertions(+), 118 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

--
2.18.0


