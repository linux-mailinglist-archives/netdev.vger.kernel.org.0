Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9894E154E45
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgBFVou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:44:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:55693 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbgBFVot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 16:44:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 13:44:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="225156052"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by orsmga008.jf.intel.com with ESMTP; 06 Feb 2020 13:44:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v4 3/5] taprio: Add missing policy validation for flags
Date:   Thu,  6 Feb 2020 13:46:08 -0800
Message-Id: <20200206214610.1307191-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200206214610.1307191-1-vinicius.gomes@intel.com>
References: <20200206214610.1307191-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netlink policy validation for the 'flags' argument was missing.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index e2d4283bea6d..b82a9769ab40 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -767,6 +767,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CLOCKID]              = { .type = NLA_S32 },
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]           = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
+	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 };
 
 static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
-- 
2.25.0

