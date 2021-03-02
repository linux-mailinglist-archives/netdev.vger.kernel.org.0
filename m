Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DE032A425
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379917AbhCBKLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 05:11:55 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60372 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349523AbhCBKEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:04:36 -0500
X-UUID: d85e679507fd40548ab343772d11f4c0-20210302
X-UUID: d85e679507fd40548ab343772d11f4c0-20210302
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 77389843; Tue, 02 Mar 2021 18:03:49 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 2 Mar 2021 18:03:47 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 18:03:47 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <biao.huang@mediatek.com>,
        <srv_heupstream@mediatek.com>
Subject: [v2 PATCH 0/1] net: ethernet: mtk-star-emac: fix wrong unmap in RX handling
Date:   Tue, 2 Mar 2021 18:03:44 +0800
Message-ID: <20210302100345.27982-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2:
    update the comment for unmapping the old skb

Biao Huang (1):
  net: ethernet: mtk-star-emac: fix wrong unmap in RX handling

 drivers/net/ethernet/mediatek/mtk_star_emac.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--
2.25.1


