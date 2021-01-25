Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287EF3034E5
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbhAZF35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:29:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:23609 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbhAYTE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:04:29 -0500
IronPort-SDR: oSuBUKVG/ncYNy9s9jyTWuJq77cdJbrpfEwyNU2y1tVwu6/yt5BG9+25TeAFJ/Djjh6gBYZLh5
 mbO5b9l4n/Lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264604211"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="264604211"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:27 -0800
IronPort-SDR: dq2Htcvba45YiG9g+hjaKZ0z4SJfpW8OilcQlFsaxigNuEevtfuxLJVGWA+YJe0CTOak/lvkau
 yQ5ioEDo3TKA==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="361637479"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.126.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/5] selftests: increase timeout to 10 min
Date:   Mon, 25 Jan 2021 10:59:04 -0800
Message-Id: <20210125185904.6997-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
References: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

On slow systems with kernel debug settings, we can reach the current
timeout when all tests are executed.

Likely some tests need be improved to remove some 'sleep' and wait
(less) for a specific action. This can also improve stability.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/settings b/tools/testing/selftests/net/mptcp/settings
index 026384c189c9..a62d2fa1275c 100644
--- a/tools/testing/selftests/net/mptcp/settings
+++ b/tools/testing/selftests/net/mptcp/settings
@@ -1 +1 @@
-timeout=450
+timeout=600
-- 
2.30.0

