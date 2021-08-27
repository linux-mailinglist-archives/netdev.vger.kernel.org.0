Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A973FA0BD
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhH0Ul2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:41:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:60752 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhH0UlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:41:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="197589400"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="197589400"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 13:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="685587299"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 27 Aug 2021 13:40:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-08-27
Date:   Fri, 27 Aug 2021 13:43:53 -0700
Message-Id: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake corrects the iterator used for looping Tx timestamp and removes
dead code related to pin configuration. He also adds locking around
flushing of the Tx tracker and restarts the periodic clock following
time changes.

Brett corrects the locking around updating netdev dev_addr.

The following are changes since commit 5fe2a6b4344cbb2120d6d81e371b7ec8e75f03e2:
  Merge tag 'mlx5-fixes-2021-08-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (1):
  ice: Only lock to update netdev dev_addr

Jacob Keller (4):
  ice: fix Tx queue iteration for Tx timestamp enablement
  ice: remove dead code for allocating pin_config
  ice: add lock around Tx timestamp tracker flush
  ice: restart periodic outputs around time changes

 drivers/net/ethernet/intel/ice/ice_main.c | 13 +++--
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 66 ++++++++++++++++++-----
 2 files changed, 63 insertions(+), 16 deletions(-)

-- 
2.26.2

