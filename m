Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE2145966A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbhKVVPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:15:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:19479 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhKVVPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 16:15:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="215593730"
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="215593730"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 13:12:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="570478171"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2021 13:12:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com
Subject: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver Updates 2021-11-22
Date:   Mon, 22 Nov 2021 13:11:16 -0800
Message-Id: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shiraz Saleem says:

Currently E800 devices come up as RoCEv2 devices by default.

This series add supports for users to configure iWARP or RoCEv2 functionality
per PCI function. devlink parameters is used to realize this and is keyed
off similar work in [1].

[1] https://lore.kernel.org/linux-rdma/20210810132424.9129-1-parav@nvidia.com/

The following are changes since commit 3b0e04140bc30f9f5c254a68013a901e5390b0a8:
  Merge branch 'qca8k-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Shiraz Saleem (3):
  devlink: Add 'enable_iwarp' generic device param
  net/ice: Add support for enable_iwarp and enable_roce devlink param
  RDMA/irdma: Set protocol based on PF rdma_mode flag

 .../networking/devlink/devlink-params.rst     |   3 +
 drivers/infiniband/hw/irdma/main.c            |   3 +-
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 144 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   6 +
 drivers/net/ethernet/intel/ice/ice_idc.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   9 +-
 include/linux/net/intel/iidc.h                |   7 +-
 include/net/devlink.h                         |   4 +
 net/core/devlink.c                            |   5 +
 10 files changed, 180 insertions(+), 6 deletions(-)

-- 
2.31.1

