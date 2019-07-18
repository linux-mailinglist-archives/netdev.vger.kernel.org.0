Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4521E6D581
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391513AbfGRTzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:55:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:40934 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbfGRTzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:55:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:55:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="158881612"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 12:55:48 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v5 4/5] tc: etf: Add documentation for skip_sock_check.
Date:   Thu, 18 Jul 2019 12:55:42 -0700
Message-Id: <1563479743-8371-4-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
References: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the newly added option (skip_sock_check) on the etf man-page.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 man/man8/tc-etf.8 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/man/man8/tc-etf.8 b/man/man8/tc-etf.8
index 30a12de7d2c7..4cb3b9e02d6e 100644
--- a/man/man8/tc-etf.8
+++ b/man/man8/tc-etf.8
@@ -106,6 +106,16 @@ referred to as "Launch Time" or "Time-Based Scheduling" by the
 documentation of network interface controllers.
 The default is for this option to be disabled.
 
+.TP
+skip_sock_check
+.br
+.BR etf(8)
+currently drops any packet which does not have a socket associated with it or
+if the socket does not have SO_TXTIME socket option set. But, this will not
+work if the launchtime is set by another entity inside the kernel (e.g. some
+other Qdisc). Setting the skip_sock_check will skip checking for a socket
+associated with the packet.
+
 .SH EXAMPLES
 
 ETF is used to enforce a Quality of Service. It controls when each
-- 
2.7.3

