Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12552354B14
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243503AbhDFDFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:05:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15483 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhDFDFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 23:05:21 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FDslq250BzwR2Z;
        Tue,  6 Apr 2021 11:03:03 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.176.196) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 11:05:05 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     <nbd@nbd.name>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <Mark-MC.Lee@mediatek.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Qiheng Lin" <linqiheng@huawei.com>
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: remove unneeded semicolon
Date:   Tue, 6 Apr 2021 11:04:33 +0800
Message-ID: <20210406030433.6540-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.176.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
 drivers/net/ethernet/mediatek/mtk_ppe.c:270:2-3: Unneeded semicolon

Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index a1a9959a2461..71e1ccea6e72 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -267,7 +267,7 @@ int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
 	default:
 		WARN_ON_ONCE(1);
 		return -EINVAL;
-	};
+	}
 
 	for (i = 0; i < 4; i++)
 		src[i] = be32_to_cpu(src_addr[i]);
-- 
2.31.1

