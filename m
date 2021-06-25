Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5973B4904
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFYS5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:57:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:14426 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFYS5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:57:04 -0400
IronPort-SDR: 3/xAKREKLVjmmkD0CgZ7aNZsBF2a1/Lovu8N1Q8+whwptt9deI5moHHUQeBFN+/jLtLOdSdW5g
 EUipzeCL2I9Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229326796"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="229326796"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 11:54:43 -0700
IronPort-SDR: TC/PV43n92hZCO35Kii2YCu5uVzO1MxD3de61+szcQAAEl720p187K3FnuyQ//ttz/cvOn7zGh
 lq60CiBzmZvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="491655918"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2021 11:54:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver Updates 2021-06-25
Date:   Fri, 25 Jun 2021 11:57:28 -0700
Message-Id: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jesse adds support for tracepoints to aide in debugging.

Maciej adds support for PTP auxiliary pin support.

Victor removes the VSI info from the old aggregator when moving the VSI
to another aggregator.

Tony removes an unnecessary VSI assignment.

Christophe Jaillet fixes a memory leak for failed allocation in
ice_pf_dcb_cfg().

The following are changes since commit 19938bafa7ae8fc0a4a2c1c1430abb1a04668da1:
  net: bcmgenet: Add mdio-bcm-unimac soft dependency
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Christophe JAILLET (1):
  ice: Fix a memory leak in an error handling path in 'ice_pf_dcb_cfg()'

Jesse Brandeburg (1):
  ice: add tracepoints

Maciej Machnikowski (1):
  ice: add support for auxiliary input/output pins

Tony Nguyen (1):
  ice: remove unnecessary VSI assignment

Victor Raj (1):
  ice: remove the VSI info from previous agg

 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   6 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  18 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  20 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 293 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  43 +++
 drivers/net/ethernet/intel/ice/ice_sched.c    |  24 +-
 drivers/net/ethernet/intel/ice/ice_trace.h    | 232 ++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   9 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   1 -
 9 files changed, 641 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_trace.h

-- 
2.26.2

