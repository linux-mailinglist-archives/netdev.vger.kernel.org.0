Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE2926CDD6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 23:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIPVFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 17:05:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12791 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726304AbgIPQO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:14:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C4C71CAE6EA42423FFAE;
        Wed, 16 Sep 2020 22:16:43 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 22:16:33 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/sched: Remove unused function qdisc_queue_drop_head()
Date:   Wed, 16 Sep 2020 22:16:29 +0800
Message-ID: <20200916141629.24032-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not used since commit a09ceb0e0814 ("sched: remove qdisc->drop")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/sch_generic.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d60e7c39d60c..6c762457122f 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1047,12 +1047,6 @@ static inline unsigned int __qdisc_queue_drop_head(struct Qdisc *sch,
 	return 0;
 }
 
-static inline unsigned int qdisc_queue_drop_head(struct Qdisc *sch,
-						 struct sk_buff **to_free)
-{
-	return __qdisc_queue_drop_head(sch, &sch->q, to_free);
-}
-
 static inline struct sk_buff *qdisc_peek_head(struct Qdisc *sch)
 {
 	const struct qdisc_skb_head *qh = &sch->q;
-- 
2.17.1

