Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F91F232C8B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 09:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgG3H3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 03:29:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8301 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728645AbgG3H3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 03:29:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 98FDACF1B7DEE6E0CB59;
        Thu, 30 Jul 2020 15:28:54 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 15:28:49 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>, <paulb@mellanox.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net] net/sched: The error lable position is corrected in ct_init_module
Date:   Thu, 30 Jul 2020 16:14:28 +0800
Message-ID: <20200730081428.35904-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liujian <liujian56@huawei.com>

Exchange the positions of the err_tbl_init and err_register labels in
ct_init_module function.

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Signed-off-by: liujian <liujian56@huawei.com>
---
 net/sched/act_ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 5928efb6449c..6ed1652d1e26 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1543,10 +1543,10 @@ static int __init ct_init_module(void)
 
 	return 0;
 
-err_tbl_init:
-	destroy_workqueue(act_ct_wq);
 err_register:
 	tcf_ct_flow_tables_uninit();
+err_tbl_init:
+	destroy_workqueue(act_ct_wq);
 	return err;
 }
 
-- 
2.17.1

