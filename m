Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA58039C748
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFEKMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:12:23 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4368 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFEKMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:12:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FxwJz4hkqz68Dj;
        Sat,  5 Jun 2021 18:06:43 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:10:31 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:10:30 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 03/13] sch_htb: fix doc warning in htb_add_class_to_row()
Date:   Sat, 5 Jun 2021 18:18:35 +0800
Message-ID: <20210605101845.1264706-4-yukuai3@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210605101845.1264706-1-yukuai3@huawei.com>
References: <20210605101845.1264706-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for parameters of htb_add_class_to_row() to fix
gcc W=1 warnings:

net/sched/sch_htb.c:351: warning: Function parameter or member 'q' not described in 'htb_add_class_to_row'
net/sched/sch_htb.c:351: warning: Function parameter or member 'cl' not described in 'htb_add_class_to_row'
net/sched/sch_htb.c:351: warning: Function parameter or member 'mask' not described in 'htb_add_class_to_row'

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/sched/sch_htb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5ad28df6b18c..97a9df42849e 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -349,6 +349,9 @@ static inline void htb_next_rb_node(struct rb_node **n)
 
 /**
  * htb_add_class_to_row - add class to its row
+ * @q: the priority event queue
+ * @cl: the class to add
+ * @mask: the given priorities in class in bitmap
  *
  * The class is added to row at priorities marked in mask.
  * It does nothing if mask == 0.
-- 
2.31.1

