Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B14D5C11
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 09:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbfJNHPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 03:15:25 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:61513 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730226AbfJNHPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 03:15:24 -0400
X-UUID: f548acda1bcc44399b57afa078ee64aa-20191014
X-UUID: f548acda1bcc44399b57afa078ee64aa-20191014
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1620613341; Mon, 14 Oct 2019 15:15:20 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 14 Oct 2019 15:15:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 14 Oct 2019 15:15:18 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v3 0/2] Update MT7629 to support PHYLINK API
Date:   Mon, 14 Oct 2019 15:15:16 +0800
Message-ID: <20191014071518.11923-1-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set has two goals :
	1. Fix mt7629 GMII mode issue after apply mediatek
	   PHYLINK support patch.
	2. Update mt7629 dts to reflect the latest dt-binding
	   with PHYLINK support.

MarkLee (2):
  net: ethernet: mediatek: Fix MT7629 missing GMII mode support
  arm: dts: mediatek: Update mt7629 dts to reflect the latest dt-binding

 arch/arm/boot/dts/mt7629-rfb.dts            | 13 ++++++++++++-
 arch/arm/boot/dts/mt7629.dtsi               |  2 --
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.17.1

