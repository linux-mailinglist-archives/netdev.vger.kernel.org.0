Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19AF39C752
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhFEKMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:12:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3070 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhFEKMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:12:24 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxwHw33lKzWrt3;
        Sat,  5 Jun 2021 18:05:48 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:10:35 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:10:34 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 11/13] sch_htb: fix doc warning in htb_charge_class()
Date:   Sat, 5 Jun 2021 18:18:43 +0800
Message-ID: <20210605101845.1264706-12-yukuai3@huawei.com>
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

Add description for parameters of htb_charge_class()
to fix gcc W=1 warnings:

net/sched/sch_htb.c:663: warning: Function parameter or member 'q' not described in 'htb_charge_class'
net/sched/sch_htb.c:663: warning: Function parameter or member 'cl' not described in 'htb_charge_class'
net/sched/sch_htb.c:663: warning: Function parameter or member 'level' not described in 'htb_charge_class'
net/sched/sch_htb.c:663: warning: Function parameter or member 'skb' not described in 'htb_charge_class'

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/sched/sch_htb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9d4c5370257d..a6cd3f18ff87 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -675,6 +675,10 @@ static inline void htb_accnt_ctokens(struct htb_class *cl, int bytes, s64 diff)
 
 /**
  * htb_charge_class - charges amount "bytes" to leaf and ancestors
+ * @q: the priority event queue
+ * @cl: the class to start iterate
+ * @level: the minimum level to account
+ * @skb: the socket buffer
  *
  * Routine assumes that packet "bytes" long was dequeued from leaf cl
  * borrowing from "level". It accounts bytes to ceil leaky bucket for
-- 
2.31.1

