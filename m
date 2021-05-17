Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B416A3825FB
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhEQIAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3567 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhEQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:11 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBK53w6HzmV5w;
        Mon, 17 May 2021 15:56:09 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
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
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>
Subject: [PATCH v2 06/24] net: brocade: bna: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:17 +0800
Message-ID: <20210517044535.21473-7-shenyang39@huawei.com>
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

 drivers/net/ethernet/brocade/bna/bfa_cee.c:91: warning: expecting prototype for bfa_cee_get_attr_isr(). Prototype was for bfa_cee_get_stats_isr() instead

Cc: Rasesh Mody <rmody@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/brocade/bna/bfa_cee.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_cee.c b/drivers/net/ethernet/brocade/bna/bfa_cee.c
index 06f221c44802..eeb05e31713f 100644
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
2.17.1

