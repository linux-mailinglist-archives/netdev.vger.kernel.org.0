Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D2F12F7F7
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgACMFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:05:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbgACMFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 07:05:35 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F3E375961CCE4472B071;
        Fri,  3 Jan 2020 20:05:25 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 3 Jan 2020
 20:05:15 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <rmody@marvell.com>, <skalluru@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH] bna: remove set but not used variable 'pgoff'
Date:   Fri, 3 Jan 2020 20:04:37 +0800
Message-ID: <20200103120437.46400-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/brocade/bna/bfa_ioc.c: In function
‘bfa_ioc_fwver_clear’:
drivers/net/ethernet/brocade/bna/bfa_ioc.c:1127:13: warning: variable
‘pgoff’ set but not used [-Wunused-but-set-variable]

It is never used, and so can be removed.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 drivers/net/ethernet/brocade/bna/bfa_ioc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index 4042c2185e98..e17bfc87da90 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -1124,11 +1124,10 @@ bfa_nw_ioc_sem_release(void __iomem *sem_reg)
 static void
 bfa_ioc_fwver_clear(struct bfa_ioc *ioc)
 {
-	u32 pgnum, pgoff, loff = 0;
+	u32 pgnum, loff = 0;
 	int i;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr) / sizeof(u32)); i++) {
-- 
2.17.2

