Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5E95452BD
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbiFIRP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiFIRP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:15:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87BCC50BC
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654794957; x=1686330957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pAhSr/4Yqvlqw0BRAnnaj8dv3kjrLQw/VzTy4F+vINg=;
  b=iZdm3pDkhOAfC3vYhPCxXGR3sTL/DMBh/F0V3z9NmohQXXga+uREbJqc
   5f3u74F6kVDWFsmjFQjfYwnnc4k6vvbcr5/x2Oa1IfVWgP0mTdA54tZ0d
   umL9tmAQ14OEuQmez6Rh6ySIGuAy7JrNE58G9XPpceflMRGMBjo8q3vb/
   9EgqugHDoYpyjZwaVtbug9YB0+R9knCmqh1hPwbDGttg9PV+QCsn3cZ4q
   fH6nIttvkBZ5QZfArb9WrdirNBZJEndIKI4mdFc7F1r6thRKc4MUtVVuo
   NAsKU0dHgk2vRUXF7/q4mLvZ1Ug3ytjObv0Cetjx14oY/xJ7e9tKWXznD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276124437"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="276124437"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 10:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566487529"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2022 10:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6][pull request] 10GbE Intel Wired LAN Driver Updates 2022-06-09
Date:   Thu,  9 Jun 2022 10:12:51 -0700
Message-Id: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to misc Intel drivers.

Maximilian Heyne adds reporting of VF statistics on ixgbe via iproute2
interface.

Kai-Heng Feng removes duplicate defines from igb.

Jiaqing Zhao fixes typos in e1000, ixgb, and ixgbe drivers.

Julia Lawall fixes typos for fm10k, ixgbe, and ice drivers.

The following are changes since commit 263efe85a4b618037e1003c9636562d6cbb5f9f3:
  net: macb: change return type for gem_ptp_set_one_step_sync()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Jiaqing Zhao (3):
  e1000: Fix typos in comments
  ixgb: Fix typos in comments
  ixgbe: Fix typos in comments

Julia Lawall (1):
  drivers/net/ethernet/intel: fix typos in comments

Kai-Heng Feng (1):
  igb: Remove duplicate defines

Maximilian Heyne (1):
  drivers, ixgbe: export vf statistics

 drivers/net/ethernet/intel/e1000/e1000_hw.c   |  4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c  |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
 .../net/ethernet/intel/igb/e1000_defines.h    |  3 -
 drivers/net/ethernet/intel/igb/e1000_regs.h   |  1 -
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c     |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 34 ++++++++
 .../net/ethernet/intel/ixgbe/ixgbe_82598.c    |  2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 86 +++++++++++++++++++
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  7 ++
 12 files changed, 136 insertions(+), 13 deletions(-)

-- 
2.35.1

