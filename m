Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEECC3441
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733157AbfJAMcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:32:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56282 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726137AbfJAMcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 08:32:25 -0400
X-UUID: d84f881d32554addb10ab7d01c848247-20191001
X-UUID: d84f881d32554addb10ab7d01c848247-20191001
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1705135427; Tue, 01 Oct 2019 20:32:21 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 1 Oct 2019 20:32:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 1 Oct 2019 20:32:17 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@openwrt.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net 0/2] Update MT7629 to support PHYLINK API
Date:   Tue, 1 Oct 2019 20:31:48 +0800
Message-ID: <20191001123150.23135-1-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch target to update mt7629 eth driver and dts to
support PHYLINK API

MarkLee (2):
  net: ethernet: mediatek: Fix MT7629 missing GMII mode support
  arm: dts: mediatek: Fix mt7629 dts to reflect the latest dt-binding

 arch/arm/boot/dts/mt7629-rfb.dts            | 13 ++++++++++++-
 arch/arm/boot/dts/mt7629.dtsi               |  2 --
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.17.1

