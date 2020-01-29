Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E5514CFC8
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgA2RmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:42:12 -0500
Received: from mga12.intel.com ([192.55.52.136]:15194 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbgA2RmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 12:42:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 09:42:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,378,1574150400"; 
   d="scan'208";a="223898839"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.21.110])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2020 09:42:11 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net] Revert "MAINTAINERS: mptcp@ mailing list is moderated"
Date:   Wed, 29 Jan 2020 09:41:37 -0800
Message-Id: <20200129174137.22948-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 74759e1693311a8d1441de836c4080c192374238.

mptcp@lists.01.org accepts messages from non-subscribers. There was an
invisible and unexpected server-wide rule limiting the number of
recipients for subscribers and non-subscribers alike, and that has now
been turned off for this list.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 58e4eb554d0e..d51ce1a0a817 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11641,7 +11641,7 @@ NETWORKING [MPTCP]
 M:	Mat Martineau <mathew.j.martineau@linux.intel.com>
 M:	Matthieu Baerts <matthieu.baerts@tessares.net>
 L:	netdev@vger.kernel.org
-L:	mptcp@lists.01.org (moderated for non-subscribers)
+L:	mptcp@lists.01.org
 W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
 S:	Maintained
-- 
2.25.0

