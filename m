Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750D93F3040
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbhHTP4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:56:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:53677 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240952AbhHTP4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:56:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10082"; a="197050448"
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="197050448"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 08:55:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="680126965"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2021 08:55:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-08-20
Date:   Fri, 20 Aug 2021 08:59:11 -0700
Message-Id: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and e1000e drivers.

Aaron Ma resolves a page fault which occurs when thunderbolt is
unplugged for igc.

Toshiki Nishioka fixes Tx queue looping to use actual number of queues
instead of max value for igc.

Sasha fixes an incorrect latency comparison by decoding the values before
comparing and prevents attempted writes to read-only NVMs for e1000e.

The following are changes since commit ffc9c3ebb4af870a121da99826e9ccb63dc8b3d7:
  net: usb: pegasus: fixes of set_register(s) return value evaluation;
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Aaron Ma (1):
  igc: fix page fault when thunderbolt is unplugged

Sasha Neftin (2):
  e1000e: Fix the max snoop/no-snoop latency for 10M
  e1000e: Do not take care about recovery NVM checksum

Toshiki Nishioka (1):
  igc: Use num_tx_queues when iterating over tx_ring queue

 drivers/net/ethernet/intel/e1000e/ich8lan.c | 32 +++++++++++++-----
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 ++
 drivers/net/ethernet/intel/igc/igc_main.c   | 36 ++++++++++++---------
 drivers/net/ethernet/intel/igc/igc_ptp.c    |  3 +-
 4 files changed, 50 insertions(+), 24 deletions(-)

-- 
2.26.2

