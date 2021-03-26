Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C28349FCB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhCZC1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:27:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14140 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhCZC1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 22:27:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F65QQ2bdsznWpc;
        Fri, 26 Mar 2021 10:24:30 +0800 (CST)
Received: from huawei.com (10.175.104.82) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 10:26:53 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <nbd@nbd.name>, <sean.wang@mediatek.com>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>, <hulkcommits@huawei.com>
Subject: [PATCH net-next] net: ethernet: remove duplicated include
Date:   Fri, 26 Mar 2021 10:40:46 +0800
Message-ID: <20210326024046.2800216-1-xujia39@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicated include from mtk_ppe_offload.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index d0c46786571f..4975106fbc42 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -5,7 +5,6 @@
 
 #include <linux/if_ether.h>
 #include <linux/rhashtable.h>
-#include <linux/if_ether.h>
 #include <linux/ip.h>
 #include <net/flow_offload.h>
 #include <net/pkt_cls.h>
-- 
2.25.1

