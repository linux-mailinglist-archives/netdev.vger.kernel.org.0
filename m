Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FD08644E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfHHO1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:27:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57880 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728327AbfHHO1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 10:27:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D5730FB2B49F9E3BD75A;
        Thu,  8 Aug 2019 22:26:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Thu, 8 Aug 2019
 22:26:46 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <vinicius.gomes@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] taprio: remove unused variable 'entry_list_policy'
Date:   Thu, 8 Aug 2019 22:26:23 +0800
Message-ID: <20190808142623.69188-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/sched/sch_taprio.c:680:32: warning:
 entry_list_policy defined but not used [-Wunused-const-variable=]

It is not used since commit a3d43c0d56f1 ("taprio: Add
support adding an admin schedule")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/sched/sch_taprio.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c39db50..046fd2c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -677,10 +677,6 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]  = { .type = NLA_U32 },
 };
 
-static const struct nla_policy entry_list_policy[TCA_TAPRIO_SCHED_MAX + 1] = {
-	[TCA_TAPRIO_SCHED_ENTRY] = { .type = NLA_NESTED },
-};
-
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
 		.len = sizeof(struct tc_mqprio_qopt)
-- 
2.7.4


