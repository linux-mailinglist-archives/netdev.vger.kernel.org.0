Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9658349EDCA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiA0Vwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:52:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:32606 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240951AbiA0Vwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 16:52:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643320362; x=1674856362;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0KDdF5YFGYhqt6b36IAp57+mt1TmAgNqX9tooQy7Sck=;
  b=l9r5I/K3pidQn9NQgin80T5X/4UqERX3RAemQttp7El8ojVIhgnV5bKg
   8pFFb3TRt6Tx9ghG3GVD69hSh2+sSrBShSdpqBEYoE/2yGd5ChaLXK4/0
   96GNYtnB38MKm69uxSjbwoPDuEl664jx2U/Of9eFRsOnAh6URd+fBayob
   cSMDU3f2kkZeNKW8VlzoIGax3/WDG/rdAlPeRb+/1ydcoCywg/ycX7at1
   GxaMsn5tjPNIzZy9/6lkwCAMqDHsDkfsOAV/OHdbPRZzHZRup9S2pUBYW
   BqWiRmODfnREDRB8Ic7vgDmNIDWWIjrTsYxJCzgC3Cj9ZfhUzINYex7ey
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246918932"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246918932"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:52:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="625391762"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 13:52:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/10][pull request] 1GbE Intel Wired LAN Driver Updates 2022-01-27
Date:   Thu, 27 Jan 2022 13:52:14 -0800
Message-Id: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe Jaillet removes useless DMA-32 fallback calls from applicable
Intel drivers and simplifies code as a result of the removal.

The following are changes since commit e2cf07654efb0fd7bbcb475c6f74be7b5755a8fd:
  ptp: replace snprintf with sysfs_emit
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Christophe JAILLET (10):
  ixgb: Remove useless DMA-32 fallback configuration
  ixgbe: Remove useless DMA-32 fallback configuration
  ixgbevf: Remove useless DMA-32 fallback configuration
  i40e: Remove useless DMA-32 fallback configuration
  e1000e: Remove useless DMA-32 fallback configuration
  iavf: Remove useless DMA-32 fallback configuration
  ice: Remove useless DMA-32 fallback configuration
  igc: Remove useless DMA-32 fallback configuration
  igb: Remove useless DMA-32 fallback configuration
  igbvf: Remove useless DMA-32 fallback configuration

 drivers/net/ethernet/intel/e1000e/netdev.c    | 22 ++++++-------------
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  9 +++-----
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  9 +++-----
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 --
 drivers/net/ethernet/intel/igb/igb_main.c     | 19 +++++-----------
 drivers/net/ethernet/intel/igbvf/netdev.c     | 22 +++++--------------
 drivers/net/ethernet/intel/igc/igc_main.c     | 19 +++++-----------
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   | 19 +++++-----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 ++++++-----------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 20 +++++------------
 10 files changed, 49 insertions(+), 112 deletions(-)

-- 
2.31.1

