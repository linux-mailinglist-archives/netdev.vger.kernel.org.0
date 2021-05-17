Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5240B3825F4
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 09:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhEQIAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2995 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FkBKf6gPfzmWqG;
        Mon, 17 May 2021 15:56:38 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:53 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        <GR-everest-linux-l2@marvell.com>
Subject: [PATCH v2 05/24] net: broadcom: bnx2x: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:16 +0800
Message-ID: <20210517044535.21473-6-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13595: warning: expecting prototype for bnx2x_get_num_none_def_sbs(). Prototype was for bnx2x_get_num_non_def_sbs() instead
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:4165: warning: expecting prototype for atomic_add_ifless(). Prototype was for __atomic_add_ifless() instead
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:4193: warning: expecting prototype for atomic_dec_ifmoe(). Prototype was for __atomic_dec_ifmoe() instead

Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 281b1c2e04a7..2acbc73dcd18 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13586,7 +13586,7 @@ static int bnx2x_set_qm_cid_count(struct bnx2x *bp)
 }
 
 /**
- * bnx2x_get_num_none_def_sbs - return the number of none default SBs
+ * bnx2x_get_num_non_def_sbs - return the number of none default SBs
  * @pdev: pci device
  * @cnic_cnt: count
  *
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 6cd1523ad9e5..542c69822649 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -4152,7 +4152,7 @@ void bnx2x_init_mcast_obj(struct bnx2x *bp,
 /*************************** Credit handling **********************************/
 
 /**
- * atomic_add_ifless - add if the result is less than a given value.
+ * __atomic_add_ifless - add if the result is less than a given value.
  *
  * @v:	pointer of type atomic_t
  * @a:	the amount to add to v...
@@ -4180,7 +4180,7 @@ static inline bool __atomic_add_ifless(atomic_t *v, int a, int u)
 }
 
 /**
- * atomic_dec_ifmoe - dec if the result is more or equal than a given value.
+ * __atomic_dec_ifmoe - dec if the result is more or equal than a given value.
  *
  * @v:	pointer of type atomic_t
  * @a:	the amount to dec from v...
-- 
2.17.1

