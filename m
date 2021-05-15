Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904543817E4
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhEOK5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3540 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbhEOKzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn4k0HzsRFy;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:27 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Cyril Chemparathy <cyril@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 21/34] net: ti: Fix wrong struct name in comments
Date:   Sat, 15 May 2021 18:53:46 +0800
Message-ID: <1621076039-53986-22-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/ti/cpsw_ale.c:88: warning: expecting prototype for struct ale_dev_id. Prototype was for struct cpsw_ale_dev_id instead

Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index d828f85..0c75e05 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -70,7 +70,7 @@ enum {
 };
 
 /**
- * struct ale_dev_id - The ALE version/SoC specific configuration
+ * struct cpsw_ale_dev_id - The ALE version/SoC specific configuration
  * @dev_id: ALE version/SoC id
  * @features: features supported by ALE
  * @tbl_entries: number of ALE entries
-- 
2.7.4

