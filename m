Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095D4ECF8
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbfD2Wwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:52:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:42478 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbfD2Wwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:52:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:52:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072980"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:52:32 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: [PATCH iproute2 net-next v1 1/3] Update headers with taprio changes [DO NOT MERGE]
Date:   Mon, 29 Apr 2019 15:52:17 -0700
Message-Id: <20190429225219.18984-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be updated when the kernel headers are updated.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/uapi/linux/pkt_sched.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 7ee74c34..ac9f7eab 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1148,6 +1148,19 @@ enum {
 
 #define TCA_TAPRIO_SCHED_MAX (__TCA_TAPRIO_SCHED_MAX - 1)
 
+/* The format for the admin sched (dump only):
+ * [TCA_TAPRIO_SCHED_ADMIN_SCHED]
+ *   [TCA_TAPRIO_ATTR_SCHED_BASE_TIME]
+ *   [TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST]
+ *     [TCA_TAPRIO_ATTR_SCHED_ENTRY]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_CMD]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_GATES]
+ *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
+ */
+
+#define TCA_TAPRIO_ATTR_OFFLOAD_FLAG_FULL_OFFLOAD 0x1
+#define TCA_TAPRIO_ATTR_OFFLOAD_FLAG_TXTIME_OFFLOAD 0x2
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1156,6 +1169,11 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY, /* single entry */
 	TCA_TAPRIO_ATTR_SCHED_CLOCKID, /* s32 */
 	TCA_TAPRIO_PAD,
+	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
+	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
+	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
+	TCA_TAPRIO_ATTR_FRAME_PREEMPTION, /* u32 */
+	TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, /* u32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
-- 
2.21.0

