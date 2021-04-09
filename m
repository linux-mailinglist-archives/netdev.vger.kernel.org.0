Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED2935A685
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhDITB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:01:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:13022 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234869AbhDITBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:01:54 -0400
IronPort-SDR: ARbmJWN6bUXHAAtBqwty+og6w2JqXlO8IWYpuJi7lpPpjpnlkIT9WkiqjRUCv03HCCYubBBxZo
 QTSfC69WmZfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="191674933"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="191674933"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:01:32 -0700
IronPort-SDR: ULvlmbd5WFFQ+h1TqE+SZVz0dezjstXkMtlw4jy4H1Rgd70RACqhVHqQXZiWzhgvGbHbnSXbCG
 nWEB7qbdbZWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="449181582"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Apr 2021 12:01:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/4][pull request] 10GbE Intel Wired LAN Driver Updates 2021-04-09
Date:   Fri,  9 Apr 2021 12:03:10 -0700
Message-Id: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ixgbevf driver.

Jostar Yang adds support for BCM54616s PHY for ixgbe.

Radoslaw aggregates additional Rx errors to be reported to netdev on
ixgbe.

Chen Lin removes an unused function pointer for ixgbe and ixgbevf.

Bhaskar Chowdhury fixes a typo in ixgbe.

The following are changes since commit 4438669eb703d1a7416c2b19a8a15b0400b36738:
  Merge tag 'for-net-next-2021-04-08' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Bhaskar Chowdhury (1):
  net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c

Chen Lin (1):
  net: intel: Remove unused function pointer typedef ixgbe_mc_addr_itr

Jostar Yang (1):
  ixgbe: Support external GBE SerDes PHY BCM54616s

Radoslaw Tyl (1):
  ixgbe: aggregate of all receive errors through netdev's rx_errors

 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   | 11 ++++++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c    |  3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |  5 +----
 drivers/net/ethernet/intel/ixgbevf/vf.h         |  3 ---
 5 files changed, 15 insertions(+), 9 deletions(-)

-- 
2.26.2

