Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528593D3E20
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhGWQZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:25:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:34405 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhGWQZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:25:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="191508229"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="191508229"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:05:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="663350239"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jul 2021 10:05:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver Updates 2021-07-23
Date:   Fri, 23 Jul 2021 10:09:07 -0700
Message-Id: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb and e100 drivers.

Grzegorz adds a timeout check to prevent possible infinite loop for igb.

Kees Cook adjusts memcpy() argument to represent the entire structure
to allow for appropriate bounds checking for igb and e100.

The following are changes since commit 356ae88f8322066a2cd1aee831b7fb768ff2905c:
  Merge branch 'bridge-tx-fwd'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Grzegorz Siwik (1):
  igb: Add counter to i21x doublecheck

Kees Cook (2):
  igb: Avoid memcpy() over-reading of ETH_SS_STATS
  e100: Avoid memcpy() over-reading of ETH_SS_STATS

 drivers/net/ethernet/intel/e100.c            | 4 ++--
 drivers/net/ethernet/intel/igb/e1000_mac.c   | 6 +++++-
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 +--
 3 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.26.2

