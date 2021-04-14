Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36A335EAAD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 04:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbhDNCQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 22:16:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:22806 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhDNCP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 22:15:56 -0400
IronPort-SDR: KEstCtqZCiHOJYqw94Y4ybwpx3VpbyJLULnMA5Tnx3ABkwlUWZMPGCeRsM/4ktx/6DBodgEDhu
 oTvQQWWbHBew==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174651022"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174651022"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 19:15:35 -0700
IronPort-SDR: ZIh8OKZoxgPNviNf3gjts2K1+6MR0RCRhpksXRGZxwaoPRiabFU+Ip/Mlw2f7Qgi7DfqJdeGbW
 0y9YDl1R2psw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="615134061"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Apr 2021 19:15:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next v2 0/3][pull request] 10GbE Intel Wired LAN Driver Updates 2021-04-13
Date:   Tue, 13 Apr 2021 19:17:20 -0700
Message-Id: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ixgbevf driver.

Jostar Yang adds support for BCM54616s PHY for ixgbe.

Chen Lin removes an unused function pointer for ixgbe and ixgbevf.

Bhaskar Chowdhury fixes a typo in ixgbe.
---
v2:
- Dropped rx_error statistics patch

The following are changes since commit 5871d0c6b8ea805916c3135d0c53b095315bc674:
  ionic: return -EFAULT if copy_to_user() fails
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Bhaskar Chowdhury (1):
  net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c

Chen Lin (1):
  net: intel: Remove unused function pointer typedef ixgbe_mc_addr_itr

Jostar Yang (1):
  ixgbe: Support external GBE SerDes PHY BCM54616s

 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c    | 3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   | 5 +----
 drivers/net/ethernet/intel/ixgbevf/vf.h         | 3 ---
 4 files changed, 5 insertions(+), 8 deletions(-)

-- 
2.26.2

