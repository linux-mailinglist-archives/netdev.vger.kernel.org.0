Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88C39C756
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFEKMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:12:37 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4320 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhFEKMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:12:22 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxwHv0c9Xz1BHT3;
        Sat,  5 Jun 2021 18:05:47 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:10:33 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:10:33 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 08/13] sch_htb: fix doc warning in htb_change_class_mode()
Date:   Sat, 5 Jun 2021 18:18:40 +0800
Message-ID: <20210605101845.1264706-9-yukuai3@huawei.com>
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

Add description for parameters of htb_change_class_mode()
to fix gcc W=1 warnings:

net/sched/sch_htb.c:533: warning: Function parameter or member 'q' not described in 'htb_change_class_mode'
net/sched/sch_htb.c:533: warning: Function parameter or member 'cl' not described in 'htb_change_class_mode'
net/sched/sch_htb.c:533: warning: Function parameter or member 'diff' not described in 'htb_change_class_mode'

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/sched/sch_htb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 062ddf88ce22..875ef6cd2ce0 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -540,6 +540,9 @@ htb_class_mode(struct htb_class *cl, s64 *diff)
 
 /**
  * htb_change_class_mode - changes classe's mode
+ * @q: the priority event queue
+ * @cl: the target class
+ * @diff: diff time in microseconds
  *
  * This should be the only way how to change classe's mode under normal
  * circumstances. Routine will update feed lists linkage, change mode
-- 
2.31.1

