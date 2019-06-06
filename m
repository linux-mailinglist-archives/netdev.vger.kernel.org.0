Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E4D38083
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfFFWWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:22:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:40656 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbfFFWWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 18:22:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 15:22:35 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2019 15:22:34 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v2 5/6] tc: etf: Add documentation for skip-skb-check.
Date:   Thu,  6 Jun 2019 15:22:14 -0700
Message-Id: <1559859735-17237-5-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
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

