Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABAC6B020
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbfGPTxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:53:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:53334 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388676AbfGPTxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 15:53:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 12:53:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="342818284"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2019 12:53:18 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v4 5/6] tc: etf: Add documentation for skip-skb-check.
Date:   Tue, 16 Jul 2019 12:53:08 -0700
Message-Id: <1563306789-2908-5-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
References: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the newly added option (skip-skb-check) on the etf man-page.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 man/man8/tc-etf.8 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/man/man8/tc-etf.8 b/man/man8/tc-etf.8
index 30a12de7d2c7..2e01a591dbaa 100644
--- a/man/man8/tc-etf.8
+++ b/man/man8/tc-etf.8
@@ -106,6 +106,16 @@ referred to as "Launch Time" or "Time-Based Scheduling" by the
 documentation of network interface controllers.
 The default is for this option to be disabled.
 
+.TP
+skip_skb_check
+.br
+.BR etf(8)
+currently drops any packet which does not have a socket associated with it or
+if the socket does not have SO_TXTIME socket option set. But, this will not
+work if the launchtime is set by another entity inside the kernel (e.g. some
+other Qdisc). Setting the skip_skb_check will skip checking for a socket
+associated with the packet.
+
 .SH EXAMPLES
 
 ETF is used to enforce a Quality of Service. It controls when each
-- 
2.7.3

