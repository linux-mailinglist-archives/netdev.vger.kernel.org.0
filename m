Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559F6463DD9
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245488AbhK3Sdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:33:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:53991 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239539AbhK3Sdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:33:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="260251838"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="260251838"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:14:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="499878822"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 30 Nov 2021 10:14:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com
Subject: [PATCH net-next 0/2][pull request] 100GbE Intel Wired LAN Driver Updates 2021-11-30
Date:   Tue, 30 Nov 2021 10:12:41 -0800
Message-Id: <20211130181243.3707618-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Shiraz corrects assignment of boolean variable and removes an unused
enum.

The following are changes since commit 196073f9c44be0b4758ead11e51bc2875f98df29:
  net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Shiraz Saleem (2):
  net/ice: Fix boolean assignment
  net/ice: Remove unused enum

 drivers/net/ethernet/intel/ice/ice_devlink.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.h | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

-- 
2.31.1

