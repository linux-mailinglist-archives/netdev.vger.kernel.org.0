Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589194D08BC
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbiCGUpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbiCGUpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09628811B2
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685887; x=1678221887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lmWvw4D5PKVHts20BdUYWt5NY1uF+i3noijxyyVdqiU=;
  b=Ddm6+xKpezNLgPDTG1OTOvmlsVpjWw/vODFP2MpfSZGJ3ZRbefrZkDtq
   sBFzmS1JM7A5eTZCftrHine443awNCZTSQ8wIrYPQCckItoej1I0XJrKn
   u48hChPw7DTr18viZdlF7+DAR7ALpgE0udp9EGZfxCdepOaxTPrkVVmYV
   xraPZ2+cmZqhx9hHMQhdzi475aTKOrqlmsMuabYv6BH/KCl2q0M60dSzA
   VhbTmHdgIbkKMKb3GnHypf3KXW8sNsOXneUUChTjutsr3ZfGWj8rNkSYo
   MM3adfh/jCo8p0ry6KpZOCwPNWJIWzuyfXjGGZb3Bwoj2QRbtXfAlNv8/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440163"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440163"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320486"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/9] selftests: mptcp: Rename wait function
Date:   Mon,  7 Mar 2022 12:44:34 -0800
Message-Id: <20220307204439.65164-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
References: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "selftests: mptcp: improve 'fair usage on close' stability" commit
changed that self test to check the TcpAttemptFails MIB instead of
looking for TW sockets. The associated bash function wasn't renamed in
that commit because of the merge conflicts it would cause, so this
commit updates the function name as Paolo originally intended.

Cc: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 309d06781ae7..d4769bc0d842 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1242,7 +1242,7 @@ chk_link_usage()
 	fi
 }
 
-wait_for_tw()
+wait_attempt_fail()
 {
 	local timeout_ms=$((timeout_poll * 1000))
 	local time=0
@@ -1361,7 +1361,7 @@ subflows_error_tests()
 	TEST_COUNT=$((TEST_COUNT+1))
 
 	# mpj subflow will be in TW after the reset
-	wait_for_tw $ns2
+	wait_attempt_fail $ns2
 	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	wait
 
-- 
2.35.1

