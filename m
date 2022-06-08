Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D78543CAF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 21:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiFHTTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiFHTTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 15:19:31 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378001409B
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654715970; x=1686251970;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NgCAFu644p+mL9pknZJLYxOx2NlTb8UgHMuWs+dGx4U=;
  b=l4yuSyQzH6wfKuOFApN8OXtAE9n02TXw57f4Z43s38+gDR2T2ZDt5HQD
   J1Fu3+6+0PkurUWqvGqb9pfW/E9Skrm+vEnqidaZ00y1k9I8RvLf9rtBc
   cV1XaswzJok1XrGEsgeCY1Pw0M9dMQD5s0Zz+LBmkbKcnbniFZVQptGoL
   DmfUhUWt/HDo7wXEDpWrO28bwzFlJ9IKyxzW2e3JUHrug3avoHeYjzBrY
   vF14DigdgFH1e0a4rxmLv5p0mqQBjaa0gBl+UGDGboQdUW+J2AdQY8RLt
   c8jBaJ5H8HBIMJs7nh/S6RfSyGU4jkRxeC0S2cjyrhTWaLEMLHj0zJa/3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="257442769"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="257442769"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 12:19:29 -0700
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="580206806"
Received: from pperi-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.138.161])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 12:19:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/2] mptcp: Header fixups
Date:   Wed,  8 Jun 2022 12:19:17 -0700
Message-Id: <20220608191919.327705-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 makes the linux/mptcp.h header easier to use in userspace.

Patch 2 cleans up a magic number.


Geliang Tang (1):
  mptcp: move MPTCPOPT_HMAC_LEN to net/mptcp.h

Ossama Othman (1):
  mptcp: fix conflict with <netinet/in.h>

 include/net/mptcp.h        | 3 ++-
 include/uapi/linux/mptcp.h | 9 +++++----
 net/mptcp/protocol.h       | 1 -
 3 files changed, 7 insertions(+), 6 deletions(-)


base-commit: a84a434baf9427a1c49782fb1f0973d1308016df
-- 
2.36.1

