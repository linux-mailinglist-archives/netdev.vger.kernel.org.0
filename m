Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159BC440090
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJ2Quw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:50:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:36794 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230064AbhJ2Quv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 12:50:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="211473791"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="211473791"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 09:48:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="466576770"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 29 Oct 2021 09:48:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2021-10-29
Date:   Fri, 29 Oct 2021 09:46:38 -0700
Message-Id: <20211029164641.2714265-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e, ice, igb, and ixgbevf drivers.

Yang Li simplifies return statements of bool values for i40e and ice.

Jan Kundrát corrects problems with I2C bit-banging for igb.

Colin Ian King removes unneeded variable initialization for ixgbevf.
---
v2: Dropped patch 1; awaiting changes from author

The following are changes since commit 7444d706be31753f65052c7f6325fc8470cc1789:
  ifb: fix building without CONFIG_NET_CLS_ACT
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Colin Ian King (1):
  net: ixgbevf: Remove redundant initialization of variable ret_val

Jan Kundrát (1):
  igb: unbreak I2C bit-banging on i350

Yang Li (1):
  intel: Simplify bool conversion

 drivers/net/ethernet/intel/i40e/i40e_xsk.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c   |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c  | 23 ++++++++++++++--------
 drivers/net/ethernet/intel/ixgbevf/vf.c    |  2 +-
 4 files changed, 18 insertions(+), 11 deletions(-)

-- 
2.31.1

