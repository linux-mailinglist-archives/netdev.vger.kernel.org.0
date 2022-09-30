Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718855F0F72
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiI3QBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiI3QAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:00:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782DC3AE7A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664553633; x=1696089633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zbjAqgfLY8M6/uhSJ6CwvuwEPeEkk88HC/IYtTMmiWM=;
  b=PvPRJIjTPCYWkUm5nEJLRPz+OzokMVtsbiPxDk8sO910MX2wLYKBau2D
   1kdOecNMDuyxuAZ4peEIE+MydvLh++xYvAPF9yG8ESfjNnL3eudkJgjWP
   WxgRp0ibKsiyeWNEZHuFRDITzWYhMpyUSIHfmCCEe0lJdb18nyVBfaEXh
   zjp0UMdlMe26WUILi2YnYQszo4FjH8h05vf9s4LS+tF/5ESYxXsWEqzFM
   BfECUv0mf9cUscc4E5CbZI5JDdGuAg242kdLSgbfIwgarh7A5dU9wuRHb
   I9oEr+z2smwBK7KurtgkDs3b1BOZDj2S/kLdg1EF4C81EEkbe6luhPXCA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="303132492"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="303132492"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:00:28 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="655996111"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="655996111"
Received: from cmforest-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.22.5])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:00:28 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] mptcp: update misleading comments.
Date:   Fri, 30 Sep 2022 08:59:34 -0700
Message-Id: <20220930155934.404466-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
References: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP data path is quite complex and hard to understend even
without some foggy comments referring to modified code and/or
completely misleading from the beginning.

Update a few of them to more accurately describing the current
status.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index acf44075ba40..f599ad44ed24 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -662,9 +662,9 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 
 		skb = skb_peek(&ssk->sk_receive_queue);
 		if (!skb) {
-			/* if no data is found, a racing workqueue/recvmsg
-			 * already processed the new data, stop here or we
-			 * can enter an infinite loop
+			/* With racing move_skbs_to_msk() and __mptcp_move_skbs(),
+			 * a different CPU can have already processed the pending
+			 * data, stop here or we can enter an infinite loop
 			 */
 			if (!moved)
 				done = true;
@@ -672,9 +672,9 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 		}
 
 		if (__mptcp_check_fallback(msk)) {
-			/* if we are running under the workqueue, TCP could have
-			 * collapsed skbs between dummy map creation and now
-			 * be sure to adjust the size
+			/* Under fallback skbs have no MPTCP extension and TCP could
+			 * collapse them between the dummy map creation and the
+			 * current dequeue. Be sure to adjust the map size.
 			 */
 			map_remaining = skb->len;
 			subflow->map_data_len = skb->len;
@@ -3768,7 +3768,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
-	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	/* This barrier is coupled with smp_wmb() in __mptcp_error_report() */
 	smp_rmb();
 	if (sk->sk_err)
 		mask |= EPOLLERR;
-- 
2.37.3

