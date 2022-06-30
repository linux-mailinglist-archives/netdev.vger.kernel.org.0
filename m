Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC78C562555
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiF3VfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiF3VfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B637A50723
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624910; x=1688160910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o8ImLm3/AMEfN+jSoEiiy4WFUblDIvsJsys5VmtVHXY=;
  b=f1SKac8tfS9d8hZldcjjiGOuNCjO0lqPhBwurwxdDkxoba5Bjbf4UnHe
   U+cjS6+ED4bkITHOV/AhwkIzA/wuu1SqvJ05QbsYoKZrpzUOa74y2BmVA
   1d6wxYGiiZTVWz84l+szKUGru6Wr/ZJRG1e9lQ1zifl4wq7AGXEmAoHWg
   7mAiqDYkyyakKG+2bKoEvMsejxZYl1lIAqTmX7azZWUOYJY5Pg1JI7L67
   M47FbVpIG5sG9UMBJDdm+L1zdvZUr2fOZRbbKZp2fib7JwWZbhs4ky7TB
   9vLoYqhlUc05VyJiknLJCMsueqdQ94bYSPvtB963Wj2oXtHxAIlRN869R
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507735"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507735"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771782"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/15][pull request] 1GbE Intel Wired LAN Driver Updates 2022-06-30
Date:   Thu, 30 Jun 2022 14:31:53 -0700
Message-Id: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to misc Intel drivers.

Jesse removes unused macros from e100, e1000, e1000e, i40e, iavf, igc,
ixgb, ixgbe, and ixgbevf drivers.

Jiang Jian removes repeated words from ixgbe, fm10k, igb, and ixgbe
drivers.

Jilin Yuan removes repeated words from e1000, e1000e, fm10k, i40e, iavf,
igb, igbvf, igc, ixgbevf, and ice drivers.

The following are changes since commit bf48c3fae6d78d6418f62bd3259cd62dd16f83ec:
  Merge branch 'net-neigh-introduce-interval_probe_time-for-periodic-probe'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Jesse Brandeburg (1):
  intel: remove unused macros

Jiang Jian (4):
  ixgbe: remove unexpected word "the"
  fm10k: remove unexpected word "the"
  igb: remove unexpected word "the"
  ixgbe: drop unexpected word 'for' in comments

Jilin Yuan (10):
  intel/e1000:fix repeated words in comments
  intel/e1000e:fix repeated words in comments
  intel/fm10k:fix repeated words in comments
  intel/i40e:fix repeated words in comments
  intel/iavf:fix repeated words in comments
  intel/igb:fix repeated words in comments
  intel/igbvf:fix repeated words in comments
  intel/igc:fix repeated words in comments
  intel/ixgbevf:fix repeated words in comments
  intel/ice:fix repeated words in comments

 drivers/net/ethernet/intel/e100.c                 | 1 -
 drivers/net/ethernet/intel/e1000/e1000_hw.c       | 2 +-
 drivers/net/ethernet/intel/e1000/e1000_param.c    | 2 --
 drivers/net/ethernet/intel/e1000e/mac.c           | 2 +-
 drivers/net/ethernet/intel/e1000e/param.c         | 2 --
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c      | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c      | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    | 2 --
 drivers/net/ethernet/intel/i40e/i40e_main.c       | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c        | 1 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c       | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c   | 4 ----
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c    | 2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c      | 2 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c        | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c         | 4 ++--
 drivers/net/ethernet/intel/igbvf/igbvf.h          | 2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c         | 2 +-
 drivers/net/ethernet/intel/igc/igc_mac.c          | 2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c          | 1 -
 drivers/net/ethernet/intel/ixgb/ixgb_main.c       | 1 -
 drivers/net/ethernet/intel/ixgb/ixgb_param.c      | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c   | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c      | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c     | 4 ++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c      | 4 ----
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c           | 2 +-
 31 files changed, 20 insertions(+), 46 deletions(-)

-- 
2.35.1

