Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9990639C751
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFEKMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:12:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4487 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhFEKMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:12:24 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxwLD6Vs4zZcxq;
        Sat,  5 Jun 2021 18:07:48 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:10:35 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:10:35 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 12/13] sch_htb: fix doc warning in htb_do_events()
Date:   Sat, 5 Jun 2021 18:18:44 +0800
Message-ID: <20210605101845.1264706-13-yukuai3@huawei.com>
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

Add description for parameters of htb_do_events()
to fix gcc W=1 warnings:

net/sched/sch_htb.c:708: warning: Function parameter or member 'q' not described in 'htb_do_events'
net/sched/sch_htb.c:708: warning: Function parameter or member 'level' not described in 'htb_do_events'
net/sched/sch_htb.c:708: warning: Function parameter or member 'start' not described in 'htb_do_events'

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/sched/sch_htb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index a6cd3f18ff87..66c330244b9d 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -728,6 +728,9 @@ static void htb_charge_class(struct htb_sched *q, struct htb_class *cl,
 
 /**
  * htb_do_events - make mode changes to classes at the level
+ * @q: the priority event queue
+ * @level: which wait_pq in 'q->hlevel'
+ * @start: start jiffies
  *
  * Scans event queue for pending events and applies them. Returns time of
  * next pending event (0 for no event in pq, q->now for too many events).
-- 
2.31.1

