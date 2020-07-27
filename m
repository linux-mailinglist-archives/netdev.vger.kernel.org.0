Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7760722F64C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgG0RNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:13:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:43933 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbgG0RNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:45 -0400
IronPort-SDR: wMbjElH1YZ2qwV8HeeVWi94EYJd2zxf+CI5t7CwXe9J7d/On4hz52eJLJHDI8ebgZ7tEY14te5
 cOeSkDA1eCHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130631833"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="130631833"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 10:13:44 -0700
IronPort-SDR: AMi/I6+LhviOi7mwA1arZxRqHpYv/Y+F+KDa/kobVpYJxnJh0L46hqxgDZCw+vCds/KyvcDVDp
 3vhN4EPR4rWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="394048638"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 10:13:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next v2 0/8][pull request] 1GbE Intel Wired LAN Driver Updates 2020-07-27
Date:   Mon, 27 Jul 2020 10:13:30 -0700
Message-Id: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha cleans up double definitions, unneeded and non applicable
registers, and removes unused fields in structs. Ensures the Receive
Descriptor Minimum Threshold Count is cleared and fixes a static checker
error.

v2: Remove fields from hw_stats in patches that removed their uses.
Reworded patch descriptions for patches 1, 2, and 4.

The following are changes since commit a57066b1a01977a646145f4ce8dfb4538b08368a:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Sasha Neftin (8):
  igc: Remove unneeded variable
  igc: Add Receive Descriptor Minimum Threshold Count to clear HW
    counters
  igc: Remove unneeded ICTXQMTC register
  igc: Fix registers definition
  igc: Remove ledctl_ fields from the mac_info structure
  igc: Clean up the mac_info structure
  igc: Clean up the hw_stats structure
  igc: Fix static checker warning

 drivers/net/ethernet/intel/igc/igc_hw.h   | 20 --------------------
 drivers/net/ethernet/intel/igc/igc_mac.c  | 12 ++----------
 drivers/net/ethernet/intel/igc/igc_main.c |  8 --------
 drivers/net/ethernet/intel/igc/igc_regs.h | 14 --------------
 4 files changed, 2 insertions(+), 52 deletions(-)

-- 
2.26.2

