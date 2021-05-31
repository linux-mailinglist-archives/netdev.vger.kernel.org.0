Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F823953BC
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 03:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhEaBsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 21:48:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2475 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhEaBsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 21:48:53 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FtdPY0Xhdz67LQ;
        Mon, 31 May 2021 09:44:17 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 09:47:11 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: sched: Fix spelling mistakes
Date:   Mon, 31 May 2021 10:00:48 +0800
Message-ID: <20210531020048.2920054-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
sevaral  ==> several
sugestion  ==> suggestion
unregster  ==> unregister
suplied  ==> supplied
cirsumstances  ==> circumstances

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/sched/cls_rsvp.h | 2 +-
 net/sched/ematch.c   | 2 +-
 net/sched/sch_gred.c | 2 +-
 net/sched/sch_htb.c  | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 2e288f88ff02..27a4b6dbcf57 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -7,7 +7,7 @@
 
 /*
    Comparing to general packet classification problem,
-   RSVP needs only sevaral relatively simple rules:
+   RSVP needs only several relatively simple rules:
 
    * (dst, protocol) are always specified,
      so that we are able to hash them.
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index f885bea5b452..4ce681361851 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -141,7 +141,7 @@ int tcf_em_register(struct tcf_ematch_ops *ops)
 EXPORT_SYMBOL(tcf_em_register);
 
 /**
- * tcf_em_unregister - unregster and extended match
+ * tcf_em_unregister - unregister and extended match
  *
  * @ops: ematch operations lookup table
  *
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index f4132dc25ac0..621dc6afde8f 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -6,7 +6,7 @@
  *
  *             991129: -  Bug fix with grio mode
  *		       - a better sing. AvgQ mode with Grio(WRED)
- *		       - A finer grained VQ dequeue based on sugestion
+ *		       - A finer grained VQ dequeue based on suggestion
  *		         from Ren Liu
  *		       - More error checks
  *
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 081c11d5717c..282614614905 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -52,7 +52,7 @@
 */
 
 static int htb_hysteresis __read_mostly = 0; /* whether to use mode hysteresis for speedup */
-#define HTB_VER 0x30011		/* major must be matched with number suplied by TC as version */
+#define HTB_VER 0x30011		/* major must be matched with number supplied by TC as version */
 
 #if HTB_VER >> 16 != TC_HTB_PROTOVER
 #error "Mismatched sch_htb.c and pkt_sch.h"
@@ -523,7 +523,7 @@ htb_class_mode(struct htb_class *cl, s64 *diff)
  * htb_change_class_mode - changes classe's mode
  *
  * This should be the only way how to change classe's mode under normal
- * cirsumstances. Routine will update feed lists linkage, change mode
+ * circumstances. Routine will update feed lists linkage, change mode
  * and add class to the wait event queue if appropriate. New mode should
  * be different from old one and cl->pq_key has to be valid if changing
  * to mode other than HTB_CAN_SEND (see htb_add_to_wait_tree).
-- 
2.25.1

