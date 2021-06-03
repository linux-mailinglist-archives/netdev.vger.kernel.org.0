Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B31B39A2A3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhFCOAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:00:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3049 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhFCOAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 10:00:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwnRx249bzWlSW;
        Thu,  3 Jun 2021 21:53:49 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 21:58:33 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 3 Jun
 2021 21:58:33 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] sch_htb: fix doc warning in htb_add_to_id_tree()
Date:   Thu, 3 Jun 2021 22:07:49 +0800
Message-ID: <20210603140749.3045725-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for parameters of htb_add_to_id_tree() to fix
gcc W=1 warnings:
net/sched/sch_htb.c:282: warning: Function parameter or member 'root' not described in 'htb_add_to_id_tree'
net/sched/sch_htb.c:282: warning: Function parameter or member 'cl' not described in 'htb_add_to_id_tree'
net/sched/sch_htb.c:282: warning: Function parameter or member 'prio' not described in 'htb_add_to_id_tree'

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/sched/sch_htb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 282614614905..4f9304567dcc 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -273,6 +273,9 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 /**
  * htb_add_to_id_tree - adds class to the round robin list
+ * @root: the root of the tree
+ * @cl: the class to add
+ * @prio: the give prio in class
  *
  * Routine adds class to the list (actually tree) sorted by classid.
  * Make sure that class is not already on such list for given prio.
-- 
2.31.1

