Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B34346855
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhCWTAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:00:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:10824 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhCWTAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:25 -0400
IronPort-SDR: Z8VXUyKSxlunoXXGptaOQ62ua3lEFS+4y/7pS9u48DDPjoPjFw9sdCTGuFIJxp5095mZioO2aX
 i7A39f4he8eA==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545839"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545839"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:24 -0700
IronPort-SDR: QzBIs/xUzt4g/ydZj+7bAnhrym7OO4sl+LSSGIcrhhSuDrM3zr/iphWhdUD/XOb1Gtip+eyv+O
 CvLXUOyxzu9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460632"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN Driver Updates 2021-03-23
Date:   Tue, 23 Mar 2021 12:01:39 -0700
Message-Id: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice, fm10k, i40e, iavf, ixgbe, ixgbevf,
igb, e1000e, and e1000 drivers.

Tony fixes prototype warnings for mismatched header for ice driver.

Sasha fixes prototype warnings for mismatched header for igc and e1000e
driver.

Jesse fixes prototype warnings for mismatched header for the remaining
Intel drivers: fm10k, i40e, iavf, igb, ixgbe, and ixgbevf.

Gustavo A. R. Silva explicitly adds a break instead of falling through
in preparation of -Wimplicit-fallthrough for Clang to ice, fm10k,
ixgbe, igb, ixgbevf, and e1000 drivers,

The following are changes since commit 9a255a0635fedda1499635f1c324347b9600ce70:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Gustavo A. R. Silva (6):
  ice: Fix fall-through warnings for Clang
  fm10k: Fix fall-through warnings for Clang
  ixgbe: Fix fall-through warnings for Clang
  igb: Fix fall-through warnings for Clang
  ixgbevf: Fix fall-through warnings for Clang
  e1000: Fix fall-through warnings for Clang

Jesse Brandeburg (1):
  intel: clean up mismatched header comments

Sasha Neftin (2):
  igc: Fix prototype warning
  e1000e: Fix prototype warning

Tony Nguyen (1):
  ice: Fix prototype warnings

 drivers/net/ethernet/intel/e1000/e1000_hw.c    |  1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c    |  4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c     |  6 +++---
 drivers/net/ethernet/intel/e1000e/phy.c        |  2 +-
 drivers/net/ethernet/intel/e1000e/ptp.c        |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_dcbnl.c |  4 ++--
 .../net/ethernet/intel/fm10k/fm10k_debugfs.c   |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c  |  4 ++--
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c   |  4 +++-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c  |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_dcb.c     |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c  |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_ddp.c     |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c     |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c     |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c     |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c    |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c    |  2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c    |  4 ++--
 drivers/net/ethernet/intel/ice/ice_common.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c       |  2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c      |  4 ++--
 drivers/net/ethernet/intel/ice/ice_sched.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c  |  1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c   |  4 ++--
 drivers/net/ethernet/intel/igb/e1000_mbx.c     |  2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c     |  1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c   |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c      |  6 +++---
 drivers/net/ethernet/intel/igb/igb_ptp.c       |  1 +
 drivers/net/ethernet/intel/igc/igc_i225.c      |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c |  4 +++-
 .../net/ethernet/intel/ixgbe/ixgbe_common.c    | 16 ++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c   |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |  4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c   |  5 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c   |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c  |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c  |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  1 +
 drivers/net/ethernet/intel/ixgbevf/vf.c        | 18 +++++++++++++-----
 48 files changed, 90 insertions(+), 69 deletions(-)

-- 
2.26.2

