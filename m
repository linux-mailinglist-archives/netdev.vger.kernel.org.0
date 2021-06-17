Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094773ABA21
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhFQRBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:63633 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhFQRBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:18 -0400
IronPort-SDR: ngPs4YkFhyP7XVRvLZEGysfBfU2Lee9Dhva5OgUdWu9/EUDoAYs3AWKkWWKZN0089Cnzr81fQm
 8xMiMjh2nR9A==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723043"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723043"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: gmxRLDtWw4UfGPo4j7T9nPygKBkhrUto0Tqr28x9NOLbYv+wL2IFwZW46UopJkQ1AmUqjs1O/G
 S5GXuA14aA3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706789"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/8][pull request] 100GbE Intel Wired LAN Driver Updates 2021-06-17
Date:   Thu, 17 Jun 2021 10:01:37 -0700
Message-Id: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake corrects a couple of entries in the PTYPE table to properly
reflect the datasheet and removes unneeded NULL checks for some
PTP calls.

Paul reduces the scope of variables and removes the use of a local
variable.

Shaokun Zhang removes a duplicate function declaration.

Lorenzo Bianconi fixes a compilation warning if PTP_1588_CLOCK is
disabled.

Colin Ian King changes a for loop to remove an unneeded 'continue'.

The following are changes since commit 0c33795231bff5df410bd405b569c66851e92d4b:
  Merge tag 'wireless-drivers-next-2021-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Colin Ian King (1):
  ice: remove redundant continue statement in a for-loop

Jacob Keller (3):
  ice: fix incorrect payload indicator on PTYPE
  ice: mark PTYPE 2 as reserved
  ice: remove unnecessary NULL checks before ptp_read_system_*

Lorenzo Bianconi (1):
  net: ice: ptp: fix compilation warning if PTP_1588_CLOCK is disabled

Paul M Stillwell Jr (2):
  ice: reduce scope of variables
  ice: remove local variable

Shaokun Zhang (1):
  ice: Remove the repeated declaration

 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h |  4 ++--
 drivers/net/ethernet/intel/ice/ice_lib.c       |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c      |  7 +++----
 drivers/net/ethernet/intel/ice/ice_ptp.c       | 12 ++++--------
 drivers/net/ethernet/intel/ice/ice_ptp.h       |  2 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c    | 10 ++++------
 drivers/net/ethernet/intel/ice/ice_switch.h    |  1 -
 7 files changed, 18 insertions(+), 26 deletions(-)

-- 
2.26.2

