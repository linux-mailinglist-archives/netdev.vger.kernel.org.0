Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3064590424
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbiHKQpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiHKQpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:45:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCFEC4C90
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660234647; x=1691770647;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LR8dT98IJrAOKb7u/KxwRXL7wq1fI7q9KUSwZaTYX1M=;
  b=f+VSr1aykdgR6y2tGLtg+tnScYOArwKsHLGYGWiy+R9nBXCma6F9KRGJ
   Jen58HYBG4md37MTuM+vPrYZQSwQuZavHwbjtaLHReHgW+Cygd/fUTBun
   bnrHlrqbSCK1yhUipVhQ9brXhB7EgylLqJKsxmoKC+Md+zOuK9NENtffX
   Q4leQkaG3rjDaLamyPWVmOHBGMY3nXTnc4dJBB3a9wa99karumQ2bQFdY
   fMsOQOzbMikzcOIsLLUZWNjoOA6mCiIVkxX1afES44KbDfDUtz8MhjLPR
   YSuLxZXg1oTVjJ6WNqQH8WECOHI0UPO1ufsEvq/9+ViiNCa1pWpioFzF3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="274448353"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="274448353"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 09:17:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="731928496"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Aug 2022 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-08-11 (ice)
Date:   Thu, 11 Aug 2022 09:17:12 -0700
Message-Id: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Benjamin corrects a misplaced parenthesis for a WARN_ON check.

Michal removes WARN_ON from a check as its recoverable and not
warranting of a call trace.

The following are changes since commit 84ba28901629cd3aa3b24d359bc4da3ac24c2329:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Benjamin Mikailenko (1):
  ice: Fix VSI rebuild WARN_ON check for VF

Michal Jaron (1):
  ice: Fix call trace with null VSI during VF reset

 drivers/net/ethernet/intel/ice/ice_lib.c    | 2 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.35.1

