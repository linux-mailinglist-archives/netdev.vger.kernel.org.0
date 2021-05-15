Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79283817D2
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhEOK4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:56:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3540 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhEOKzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:47 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh50wqzsR9v;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:22 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>
Subject: [PATCH 06/34] net: brocade: bna: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:31 +0800
Message-ID: <1621076039-53986-7-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/brocade/bna/bfa_cee.c:91: warning: expecting prototype for bfa_cee_get_attr_isr(). Prototype was for bfa_cee_get_stats_isr() instead

Cc: Rasesh Mody <rmody@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/brocade/bna/bfa_cee.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_cee.c b/drivers/net/ethernet/brocade/bna/bfa_cee.c
index 06f221c..eeb05e3 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_cee.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_cee.c
@@ -82,7 +82,7 @@ bfa_cee_get_attr_isr(struct bfa_cee *cee, enum bfa_status status)
 }
 
 /**
- * bfa_cee_get_attr_isr - CEE ISR for get-stats responses from f/w
+ * bfa_cee_get_stats_isr - CEE ISR for get-stats responses from f/w
  *
  * @cee: Pointer to the CEE module
  * @status: Return status from the f/w
-- 
2.7.4

