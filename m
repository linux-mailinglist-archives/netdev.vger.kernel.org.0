Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C49B4BAFF8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiBRDDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiBRDDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E95959A53
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153400; x=1676689400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U1szUR6pqUI2yP1NLV6igd+jmVjkx9CEqyJEDcke89k=;
  b=bLQ2AoyWpkOB+QvxLoq+DvYhutUvWSMjBGM808WfruoOQQaYVFl3WQN9
   ow+oLYuELv26uM0SN+QshLCnd8JuOzHgLv9SWcSOMQ+zkEwRyftOnZays
   gEIlW4cXQdGPygvMI3KU2MBdG3FGaJqA3aQsU0NtWe5liA6N5o0Oy5eZT
   LgY9ik5glRjWgffp3uR3JDptJaWyxo90PfUN7u3ZXQp+dE0xGoVmu8DFn
   cfqCrEOamDs4YH83LXC8z6xMk3zUdmkC5edGfiNIjZ6Aar725AUHa8LAp
   Vk/SXZSoBZTt233U+7mqcafRfASesZvzjQXl+cXnZvqrnVhOErxQsPl5Z
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794596"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794596"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431917"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:18 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/7] selftests: mptcp: join: remove unused vars
Date:   Thu, 17 Feb 2022 19:03:08 -0800
Message-Id: <20220218030311.367536-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Shellcheck found that these variables were set but never used.

Note that rndh is no longer prefixed with '0-' but it doesn't change
anything.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 1a881a21e7ef..c6379093f38a 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -42,7 +42,7 @@ init()
 {
 	capout=$(mktemp)
 
-	rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
+	rndh=$(mktemp -u XXXXXX)
 
 	ns1="ns1-$rndh"
 	ns2="ns2-$rndh"
@@ -665,8 +665,6 @@ run_tests()
 	addr_nr_ns2="${6:-0}"
 	speed="${7:-fast}"
 	sflags="${8:-""}"
-	lret=0
-	oldin=""
 
 	# create the input file for the failure test when
 	# the first failure test run
@@ -694,7 +692,6 @@ run_tests()
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
 		${test_linkfail} ${addr_nr_ns1} ${addr_nr_ns2} ${speed} ${sflags}
-	lret=$?
 }
 
 dump_stats()
-- 
2.35.1

