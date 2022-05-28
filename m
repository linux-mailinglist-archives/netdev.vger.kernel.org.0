Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61F2536CE5
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 14:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiE1MdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 08:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355881AbiE1MdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 08:33:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062B920BEC
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 05:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653741190; x=1685277190;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uOo7myYBx/RcpwJItduBuV2bS3g6vCg6XkOlXq7505k=;
  b=mogTCqLOfIiVM/5hIKCchx8ykAGtTzCQ/ZjnGhHO7ssj0QWlrtcI/gJE
   BmKpwoPc4sKpw/BCDRPBS9Q29FZveeWohBUBoQ2N6UzFDduSruBvZs/C5
   4NeGs13m0+8dmTihHH0AiyuRjrGhpmDXNqQJjIeN9072EowURlGR8ekCd
   waL1hDMWEnMYUArUqTiCkwahqfRPkJBnYEDkrYtOH56ymGr0CK2OU1db6
   re0OQ3nBrZjO/aE8BFitU7FeYP4ozzPRYxPj0bY2O37d6jhCDCYvy58N5
   oR1HKRpCzoBhh1l7vQCayJPYZ4m9Z6RVgyrOYVVWnv+XBwn76GBMeqb9X
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="335321207"
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="335321207"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:10 -0700
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="604391824"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:08 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 0/3] Fix "VLAN filer" typos
Date:   Sat, 28 May 2022 20:31:20 +0800
Message-Id: <20220528123123.1851519-1-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My misspelled search keywords gave some results, guess we need to fix
them.

Jiaqing Zhao (3):
  e1000: Fix typos in comments
  ixgb: Fix typos in comments
  ixgbe: Fix typos in comments

 drivers/net/ethernet/intel/e1000/e1000_hw.c     | 4 ++--
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c       | 4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c  | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.34.1

