Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1624947A9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358756AbiATHCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:02:35 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:59624 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229678AbiATHCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:02:35 -0500
X-UUID: e410b2d803cb413baa54991685138eb3-20220120
X-UUID: e410b2d803cb413baa54991685138eb3-20220120
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 122149460; Thu, 20 Jan 2022 15:02:31 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 20 Jan 2022 15:02:29 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 15:02:28 +0800
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
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v1 0/9] add more features support for mtk-star-emac
Date:   Thu, 20 Jan 2022 15:02:17 +0800
Message-ID: <20220120070226.1492-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add more features support for mtk-star-emac:
1. add reference clock pad selection for RMII;
2. add simple timing adjustment for RMII;
3. add support for MII;
4. add support for new IC MT8365;
5. separate tx/rx interrupt handling.

Biao Huang (8):
  net: ethernet: mtk-star-emac: modify IRQ trigger flags
  net: ethernet: mtk-star-emac: add support for MT8365 SoC
  dt-bindings: net: mtk-star-emac: add support for MT8365
  net: ethernet: mtk-star-emac: add clock pad selection for RMII
  net: ethernet: mtk-star-emac: add timing adjustment support
  dt-bindings: net: mtk-star-emac: add description for new  properties
  net: ethernet: mtk-star-emac: add support for MII interface
  net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs

Fabien Parent (1):
  net: ethernet: mtk-star-emac: store bit_clk_div in compat structure

 .../bindings/net/mediatek,star-emac.yaml      |  17 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 473 ++++++++++++------
 2 files changed, 337 insertions(+), 153 deletions(-)

-- 
2.18.0



