Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADBB348CFB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhCYJcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:32:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14533 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCYJcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:32:10 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5fvM0CJMzPlJ7;
        Thu, 25 Mar 2021 17:29:35 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.177.129) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 17:32:00 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Qiheng Lin <linqiheng@huawei.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: remove unused variable 'count'
Date:   Thu, 25 Mar 2021 17:31:51 +0800
Message-ID: <20210325093151.5913-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.174.177.129]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC reports the following warning with W=1:

drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:80:9: warning:
 variable 'count' set but not used [-Wunused-but-set-variable]
   80 |  int i, count;
      |         ^~~~~

This variable is not used in function , this commit
remove it to fix the warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 8ae9efab6d02..98b1d3577bcd 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -77,9 +77,9 @@ static int
 mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 {
 	struct mtk_ppe *ppe = m->private;
-	int i, count;
+	int i;
 
-	for (i = 0, count = 0; i < MTK_PPE_ENTRIES; i++) {
+	for (i = 0; i < MTK_PPE_ENTRIES; i++) {
 		struct mtk_foe_entry *entry = &ppe->foe_table[i];
 		struct mtk_foe_mac_info *l2;
 		struct mtk_flow_addr_info ai = {};
