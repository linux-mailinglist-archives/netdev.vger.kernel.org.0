Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DE6082F6
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJVApx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJVApw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:45:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41371F0417
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 17:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666399550; x=1697935550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ert+uCzj8lEVkCVt2SylFgKBcnqr6mCJxyZDd/56H+o=;
  b=RQEdn+M8oBzZZ0XYk8g92fvosc0FdVHrfnrOPghEBadygVf4d2PggTmt
   gr2ZqI/RhR3oSggXSjg4HbSYnhHlo39dRgZlNBapb8TN2fZ617V5BVfqe
   X5Ur2Cgb8gvyh+N0Go6TybHVJbbLR3NkB2sn0mQ5m+hdfyxnybfN89mFb
   idh7ULYVRVBw3TMrdY6XjccvqQwSNGh4TssjGvDbYn2nRMmNB8aIzFREg
   crh9vJSHdSlho32FYpe02fepdTeZpBVkBWHvT6nN+LEJESdSgI0vvzkoC
   x2G/AM49NYjuwv2Zk+O9o0yXn+Jw7wDDFeNp4vidtz9qJZN70EhlkBNKW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="304748914"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="304748914"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="581795617"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="581795617"
Received: from tremple-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.81])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:45:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/3] mptcp: Socket option updates
Date:   Fri, 21 Oct 2022 17:45:02 -0700
Message-Id: <20221022004505.160988-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1 and 3 refactor a recent socket option helper function for more
generic use, and make use of it in a couple of places.

Patch 2 adds TCP_FASTOPEN_NO_COOKIE functionality to MPTCP sockets,
similar to TCP_FASTOPEN_CONNECT support recently added in v6.1


Matthieu Baerts (3):
  mptcp: sockopt: make 'tcp_fastopen_connect' generic
  mptcp: add TCP_FASTOPEN_NO_COOKIE support
  mptcp: sockopt: use new helper for TCP_DEFER_ACCEPT

 net/mptcp/sockopt.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)


base-commit: 3bd5549bd479d4451cf20be077fa7646f9ffc56f
-- 
2.38.1

