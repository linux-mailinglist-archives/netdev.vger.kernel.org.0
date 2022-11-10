Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA65624E6A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiKJXXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiKJXXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:23:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D060813D44
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668122611; x=1699658611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xvk3tuG4Q6CxP2j8xPqItoatn5Nmz7kyPpuaoZ8mcA8=;
  b=fcSwoOGXnJb+yreBQzJJpNRHSY6RpU5ePhW7t5OAWsyVCqZbFi24ywMJ
   wex5v9mGWjUJrOF1cmMAPaQwGhMuTpZRW7A9fXdqbGZXz3HRXUw7YFMsz
   ZCLi+S4wuz1cq3EATd7hJBF4v6V4aw+cyL7EqFfsG/Q8jnImdpu/vVxbo
   uCX+xZuoGsR1lF3SZUIpfOphED7bjgm1fCGi3qt84UfVz5nmg3LljkgY1
   4QpzJCI3Nm9rU4vEj2Z7ZeOsIuR9ryNrCvZgsD6ZtcohvOT3zRn/IBg/U
   IbbGNQ/i6HKvyUIR///jf43S9856VBFpSPBjpx6XcG0ygwdCR+WGP+KC2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309093998"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="309093998"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="637367376"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="637367376"
Received: from jsandova-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.89])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 5/5] mptcp: Fix grammar in a comment
Date:   Thu, 10 Nov 2022 15:23:22 -0800
Message-Id: <20221110232322.125068-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
References: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We kept getting initial patches from new contributors to remove a
duplicate 'the' (since grammar checking scripts flag it), but submitters
never followed up after code review.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/token.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index f52ee7b26aed..65430f314a68 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -287,8 +287,8 @@ EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
  * This function returns the first mptcp connection structure found inside the
  * token container starting from the specified position, or NULL.
  *
- * On successful iteration, the iterator is move to the next position and the
- * the acquires a reference to the returned socket.
+ * On successful iteration, the iterator is moved to the next position and
+ * a reference to the returned socket is acquired.
  */
 struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
 					 long *s_num)
-- 
2.38.1

