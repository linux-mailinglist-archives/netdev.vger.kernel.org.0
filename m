Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A8939C74D
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhFEKM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:12:28 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4321 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFEKMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:12:23 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxwHw0scfz1BHt7;
        Sat,  5 Jun 2021 18:05:48 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:10:34 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:10:34 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 10/13] sch_htb: fix doc warning in htb_deactivate()
Date:   Sat, 5 Jun 2021 18:18:42 +0800
Message-ID: <20210605101845.1264706-11-yukuai3@huawei.com>
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

Add description for parameters of htb_deactivate()
to fix gcc W=1 warnings:

net/sched/sch_htb.c:578: warning: Function parameter or member 'q' not described in 'htb_deactivate'
net/sched/sch_htb.c:578: warning: Function parameter or member 'cl' not described in 'htb_deactivate'

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/sched/sch_htb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 1ee47de6f72c..9d4c5370257d 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -594,6 +594,8 @@ static inline void htb_activate(struct htb_sched *q, struct htb_class *cl)
 
 /**
  * htb_deactivate - remove leaf cl from active feeds
+ * @q: the priority event queue
+ * @cl: the target class
  *
  * Make sure that leaf is active. In the other words it can't be called
  * with non-active leaf. It also removes class from the drop list.
-- 
2.31.1

