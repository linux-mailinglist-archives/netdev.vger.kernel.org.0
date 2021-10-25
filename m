Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD214439E05
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhJYR7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:59:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:30381 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhJYR7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:59:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="229575733"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="229575733"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 10:56:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="554291190"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2021 10:56:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4][pull request] 40GbE Intel Wired LAN Driver Updates 2021-10-25
Date:   Mon, 25 Oct 2021 10:55:04 -0700
Message-Id: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e, ice, igb, and ixgbevf drivers.

Caleb Sander adds cond_resched() call to yield CPU, if needed, for long
delayed admin queue calls for i40e.

Yang Li simplifies return statements of bool values for i40e and ice.

Jan Kundrát corrects problems with I2C bit-banging for igb.

Colin Ian King removes unneeded variable initialization for ixgbevf.

The following are changes since commit 3fb59a5de5cbb04de76915d9f5bff01d16aa1fc4:
  net/tls: getsockopt supports complete algorithm list
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Caleb Sander (1):
  i40e: avoid spin loop in i40e_asq_send_command()

Colin Ian King (1):
  net: ixgbevf: Remove redundant initialization of variable ret_val

Jan Kundrát (1):
  igb: unbreak I2C bit-banging on i350

Yang Li (1):
  intel: Simplify bool conversion

 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  6 ++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 23 ++++++++++++-------
 drivers/net/ethernet/intel/ixgbevf/vf.c       |  2 +-
 5 files changed, 21 insertions(+), 14 deletions(-)

-- 
2.31.1

