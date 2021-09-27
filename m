Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023A5419C1D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbhI0RZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 13:25:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:34651 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236736AbhI0RWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="224170675"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="224170675"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 10:12:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="475989749"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 27 Sep 2021 10:12:34 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-09-27
Date:   Mon, 27 Sep 2021 10:16:38 -0700
Message-Id: <20210927171640.1842507-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e100 driver only.

Jake corrects under allocation of register buffer due to incorrect
calculations and fixes buffer overrun of register dump.

The following are changes since commit 3b1b6e82fb5e08e2cb355d7b2ee8644ec289de66:
  net: phy: enhance GPY115 loopback disable function
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Jacob Keller (2):
  e100: fix length calculation in e100_get_regs_len
  e100: fix buffer overrun in e100_get_regs

 drivers/net/ethernet/intel/e100.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

-- 
2.26.2

