Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E213CE5F0
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348841AbhGSPzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:55:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:56128 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349214AbhGSPuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="191369962"
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="191369962"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 09:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="631955278"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 19 Jul 2021 09:28:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@kpanic.de
Subject: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2021-07-19
Date:   Mon, 19 Jul 2021 09:31:51 -0700
Message-Id: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf and i40e drivers.

Stefan Assmann adds locking to a path that does not acquire a spinlock
where needed for i40e. He also adjusts locking of critical sections to
help avoid races and removes overriding of the adapter state during
pending reset for iavf driver.

The following are changes since commit 0d6835ffe50c9c1f098b5704394331710b67af48:
  net: phy: Fix data type in DP83822 dp8382x_disable_wol()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Stefan Assmann (3):
  i40e: improve locking of mac_filter_hash
  iavf: do not override the adapter state in the watchdog task
  iavf: fix locking of critical sections

 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 +++++++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 58 ++++++++++++++++---
 2 files changed, 70 insertions(+), 11 deletions(-)

-- 
2.26.2

