Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5A9391DF7
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhEZRXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:23:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:18091 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhEZRXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:23:35 -0400
IronPort-SDR: 4xUKmTFomnmd4nE4Ds0zi1cFzw7AYkwK9WDbQH+bc76uMaB4Qg3gFxWDUIJDUQWdE7RPlszyyg
 atAuTmYOFFMg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415783"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415783"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:26 -0700
IronPort-SDR: +tJf56ehKs8st8Yt9BhBAx3PQPwKD5sNW+WmULbYSqMBOhXKcbV1s49Q7OtINXMreUut4gLuZf
 YWpXw8Y1ozcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149190"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, jesse.brandeburg@intel.com
Subject: [PATCH net-next 00/11][pull request] 1GbE Intel Wired LAN Driver Updates 2021-05-26
Date:   Wed, 26 May 2021 10:23:35 -0700
Message-Id: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesse Brandeburg says:

In this series I address the C=2 (sparse) warnings. The goal is to be
completely sparse clean in the drivers/net/ethernet/intel directory.
This can help us run this tool for every patch, and helps the kernel
code by reducing technical debt.

NOTE: there is one warning left in ixgbe XDP code using rcu_assign_pointer().

The following are changes since commit e4e92ee78702b13ad55118d8b66f06e1aef62586:
  net: wwan: core: Add WWAN device index sysfs attribute
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Jesse Brandeburg (11):
  e100: handle eeprom as little endian
  intel: remove checker warning
  fm10k: move error check
  igb/igc: use strongly typed pointer
  igb: handle vlan types with checker enabled
  igb: fix assignment on big endian machines
  igb: override two checker warnings
  intel: call csum functions with well formatted arguments
  igbvf: convert to strongly typed descriptors
  ixgbe: use checker safe conversions
  ixgbe: reduce checker warnings

 drivers/net/ethernet/intel/e100.c             | 12 +++---
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  | 10 ++---
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 11 ++---
 drivers/net/ethernet/intel/igb/igb_ptp.c      |  4 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  6 +--
 drivers/net/ethernet/intel/igbvf/vf.h         | 42 +++++++++----------
 drivers/net/ethernet/intel/igc/igc_dump.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_82599.c    |  9 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |  8 ++--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 13 files changed, 56 insertions(+), 56 deletions(-)

-- 
2.26.2

