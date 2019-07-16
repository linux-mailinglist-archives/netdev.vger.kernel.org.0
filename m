Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06B36B01E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbfGPTxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:53:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:53334 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbfGPTxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 15:53:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 12:53:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="342818265"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2019 12:53:15 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v4 1/6] Update kernel headers
Date:   Tue, 16 Jul 2019 12:53:04 -0700
Message-Id: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type for txtime-delay parameter will change from s32 to u32. So,
make the corresponding change in the ABI file as well.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 include/uapi/linux/pkt_sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 1f623252abe8..18f185299f47 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1174,7 +1174,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
-	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
+	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
-- 
2.7.3

