Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32E7354B25
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbhDFDSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:18:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14695 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhDFDSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 23:18:41 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FDt2X50k6znYs2;
        Tue,  6 Apr 2021 11:15:48 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.176.196) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 11:18:26 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qiheng Lin <linqiheng@huawei.com>
Subject: [PATCH net-next] netdevsim: remove unneeded semicolon
Date:   Tue, 6 Apr 2021 11:18:13 +0800
Message-ID: <20210406031813.7103-1-linqiheng@huawei.com>
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
 drivers/net/netdevsim/fib.c:569:2-3: Unneeded semicolon

Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 drivers/net/netdevsim/fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index fda6f37e7055..213d3e5056c8 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -566,7 +566,7 @@ nsim_fib6_rt_create(struct nsim_fib_data *data,
 err_fib6_rt_nh_del:
 	for (i--; i >= 0; i--) {
 		nsim_fib6_rt_nh_del(fib6_rt, rt_arr[i]);
-	};
+	}
 	nsim_fib_rt_fini(&fib6_rt->common);
 	kfree(fib6_rt);
 	return ERR_PTR(err);
-- 
2.31.1

