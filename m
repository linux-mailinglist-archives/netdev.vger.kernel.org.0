Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024C4DEB43
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 13:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfJULpI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Oct 2019 07:45:08 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:32320 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbfJULpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 07:45:08 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 2B0DD870B525E6AC6AFD;
        Mon, 21 Oct 2019 19:45:06 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x9LBigDo090126;
        Mon, 21 Oct 2019 19:44:42 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019102119444801-57393 ;
          Mon, 21 Oct 2019 19:44:48 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     jhs@mojatatu.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn, up2wing@gmail.com,
        wang.liang82@zte.com.cn
Subject: [PATCH] net: sched: taprio: fix -Wmissing-prototypes warnings
Date:   Mon, 21 Oct 2019 19:47:04 +0800
Message-Id: <1571658424-4273-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-10-21 19:44:48,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-10-21 19:44:44
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-MAIL: mse-fl1.zte.com.cn x9LBigDo090126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We get one warnings when build kernel W=1:
net/sched/sch_taprio.c:1155:6: warning: no previous prototype for ‘taprio_offload_config_changed’ [-Wmissing-prototypes]

Make the function static to fix this.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6719a65..2121187 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1152,7 +1152,7 @@ void taprio_offload_free(struct tc_taprio_qopt_offload *offload)
  * offload state (PENDING, ACTIVE, INACTIVE) so it can be visible in dump().
  * This is left as TODO.
  */
-void taprio_offload_config_changed(struct taprio_sched *q)
+static void taprio_offload_config_changed(struct taprio_sched *q)
 {
 	struct sched_gate_list *oper, *admin;
 
-- 
1.8.3.1

