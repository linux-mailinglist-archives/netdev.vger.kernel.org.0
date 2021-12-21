Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4C247C622
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbhLUSQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:10321 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241021AbhLUSQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110580; x=1671646580;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rgj7lQW9HflU6iFjeqGZPfUqQLkU3ohvucfBXcpAJc4=;
  b=ivdm/p9RIS2viaLjFk2TG+eRnEy5/MZHQtWlsOsImkjbUvA8lOP3zuEH
   vBDv5Wn7EMm6D9baHZrzq02rxfaUFtj6eiUF8+B0Y1HGEtNa+GV4VXgbT
   NpgkW9ejmgq/0QVH+ATwgPKdKVUc9oNSLSkJNYO/us8gXRy8ZCEIvrqLh
   M6nBeppO2MCz9LZVK8Wc5rtcfX82jpq+xRCfLT+GRa9+5R8o4OtKTgObq
   SaiJq1fOZpBmBX9Kis+BmhuiqEh+3JPKacY14lNfnCWvxVWmec1LOX1Q5
   Gq5hfKCc1fUPLZibIwobjh0TVIPviIu6IoXZ4Pig2Ut5duQxUUWlhHUjR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684207"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684207"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557826"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/8][pull request] 1GbE Intel Wired LAN Driver Updates 2021-12-21
Date:   Tue, 21 Dec 2021 10:01:52 -0800
Message-Id: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc, igb, igbvf, and fm10k drivers.

Sasha removes unused defines and enum values from igc driver.

Jason Wang removes a variable whose value never changes and, instead,
returns the value directly for igb.

Karen adjusts a reset message from warning to info for igbvf.

Xiang wangx removes a repeated word for fm10k.

The following are changes since commit 294e70c952b494918f139670cf5a89839a2e03e6:
  Merge tag 'mac80211-next-for-net-next-2021-12-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Jason Wang (1):
  igb: remove never changed variable `ret_val'

Karen Sornek (1):
  igbvf: Refactor trace

Sasha Neftin (5):
  igc: Remove unused _I_PHY_ID define
  igc: Remove unused phy type
  igc: Remove obsolete nvm type
  igc: Remove obsolete mask
  igc: Remove obsolete define

Xiang wangx (1):
  fm10k: Fix syntax errors in comments

 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c | 2 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c  | 3 +--
 drivers/net/ethernet/intel/igbvf/netdev.c    | 2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h | 7 -------
 drivers/net/ethernet/intel/igc/igc_hw.h      | 3 ---
 drivers/net/ethernet/intel/igc/igc_i225.c    | 2 --
 6 files changed, 3 insertions(+), 16 deletions(-)

-- 
2.31.1

