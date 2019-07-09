Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466F362E39
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfGICgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:36:45 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:10001 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726394AbfGICgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:36:44 -0400
X-UUID: 40d671520f5b410e8d94f18279514482-20190709
X-UUID: 40d671520f5b410e8d94f18279514482-20190709
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 851567057; Tue, 09 Jul 2019 10:36:36 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 9 Jul 2019 10:36:34 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 9 Jul 2019 10:36:34 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>,
        <boon.leong.ong@intel.com>
Subject: [PATCH 0/2 net-next] fix out-of-boundary issue and add taller hash table support
Date:   Tue, 9 Jul 2019 10:36:21 +0800
Message-ID: <20190709023623.8358-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix mac address out-of-boundary issue in net-next tree.
and resend the patch which was discussed in
https://lore.kernel.org/patchwork/patch/1082117
but with no further progress.

Biao Huang (2):
  net: stmmac: dwmac4: mac address array boudary violation issue
  net: stmmac: add support for hash table size 128/256 in dwmac4

 drivers/net/ethernet/stmicro/stmmac/common.h  |  7 +--
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  4 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 51 +++++++++++--------
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++
 5 files changed, 43 insertions(+), 26 deletions(-)

-- 
2.18.0


