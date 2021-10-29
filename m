Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6793F44015E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJ2Rpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:45:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:63747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhJ2Rpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:45:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="210767091"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="210767091"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 10:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="574760192"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2021 10:42:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver Updates 2021-10-29
Date:   Fri, 29 Oct 2021 10:40:58 -0700
Message-Id: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha removes an unnecessary media type check, adds a new device ID, and
changes a device reset to a port reset command.

The following are changes since commit 28131d896d6d316bc1f6f305d1a9ed6d96c3f2a1:
  Merge tag 'wireless-drivers-next-2021-10-29' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Sasha Neftin (3):
  igc: Remove media type checking on the PHY initialization
  igc: Add new device ID
  igc: Change Device Reset to Port Reset

 drivers/net/ethernet/intel/igc/igc_base.c    | 8 ++------
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 +-
 drivers/net/ethernet/intel/igc/igc_hw.h      | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 1 +
 4 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.31.1

