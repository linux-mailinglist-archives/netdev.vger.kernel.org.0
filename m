Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BED1C686F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgEFGVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:21:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3857 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbgEFGVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:21:30 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E8BFBC046390BB51FE86;
        Wed,  6 May 2020 14:21:28 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 6 May 2020 14:21:19 +0800
From:   Samuel Zou <zou_wei@huawei.com>
To:     <nbd@openwrt.org>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <Mark-MC.Lee@mediatek.com>, <davem@davemloft.net>,
        <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Samuel Zou" <zou_wei@huawei.com>
Subject: [PATCH -next] net: ethernet: mediatek: Make mtk_m32 static
Date:   Wed, 6 May 2020 14:27:30 +0800
Message-ID: <1588746450-35911-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

drivers/net/ethernet/mediatek/mtk_eth_soc.c:68:5: warning:
symbol 'mtk_m32' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Samuel Zou <zou_wei@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0904710..2822268 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -65,7 +65,7 @@ u32 mtk_r32(struct mtk_eth *eth, unsigned reg)
 	return __raw_readl(eth->base + reg);
 }
 
-u32 mtk_m32(struct mtk_eth *eth, u32 mask, u32 set, unsigned reg)
+static u32 mtk_m32(struct mtk_eth *eth, u32 mask, u32 set, unsigned reg)
 {
 	u32 val;
 
-- 
2.6.2

