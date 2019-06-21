Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3A54EDD4
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfFUR2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:28:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:30242 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfFUR2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 13:28:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 10:28:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="171282979"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga002.jf.intel.com with ESMTP; 21 Jun 2019 10:28:50 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v5 4/7] taprio: Remove inline directive
Date:   Fri, 21 Jun 2019 10:28:25 -0700
Message-Id: <1561138108-12943-5-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1561138108-12943-1-git-send-email-vedang.patel@intel.com>
References: <1561138108-12943-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove inline directive from length_to_duration(). We will let the compiler
make the decisions.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a41d7d4434ee..6ef0cc03fdb9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -168,7 +168,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
-static inline int length_to_duration(struct taprio_sched *q, int len)
+static int length_to_duration(struct taprio_sched *q, int len)
 {
 	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
 }
-- 
2.7.3

