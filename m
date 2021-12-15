Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13BB4761CF
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhLOTfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:35:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:59490 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhLOTfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639596948; x=1671132948;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bCdjX9pIr3WhYSNPpSYa2jYT89vb2LJUx1BTuOU4nmo=;
  b=AK93OSFv6585zcuvSekYi8GZKfdbCm5D+ok/cHTB4WlxOCFGWlH/TgNz
   8Bc9GtJUoAayaV2bxOQ03NUUPuLQWxuecGwwOXd6yiSh/0IXC8+SaugNE
   KvIrj6nWjlDUonfUsEyhLeRvbmVyOndGs+gzrBRFyHXLSn0ttpZ1xD/To
   F9fIOlUt2CfEOhAOIKtqVxdEYWMkkeJHXeJ5CMmR38C1pMLdQ8adaGVUV
   is9HCgqmDoYVKQSrGyV34171Y52NHp+PLA9VWVXfzRASZBzV7U6nblkva
   jB3O4rYU5mdd4WAgq8GpKdbcDrHPLqf/7+wB6yfAGclUs7lDlBOsVjjCU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="236856406"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="236856406"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 11:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465746686"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 11:35:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-12-15
Date:   Wed, 15 Dec 2021 11:34:29 -0800
Message-Id: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, igbvf, igc and ixgbe drivers.

Karen moves checks for invalid VF MAC filters to occur earlier for
igb.

Letu Ren fixes a double free issue in igbvf probe.

Sasha fixes incorrect min value being used when calculating for max for
igc.

Robert Schlabbach adds documentation on enabling NBASE-T support for
ixgbe.

Cyril Novikov adds missing initialization of MDIO bus speed for ixgbe.

The following are changes since commit 1d1c950faa81e1c287c9e14f307f845b190eb578:
  Merge tag 'wireless-drivers-2021-12-15' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Cyril Novikov (1):
  ixgbe: set X550 MDIO speed before talking to PHY

Karen Sornek (1):
  igb: Fix removal of unicast MAC filters of VFs

Letu Ren (1):
  igbvf: fix double free in `igbvf_probe`

Robert Schlabbach (1):
  ixgbe: Document how to enable NBASE-T support

Sasha Neftin (1):
  igc: Fix typo in i225 LTR functions

 .../device_drivers/ethernet/intel/ixgbe.rst   | 16 +++++++++++
 drivers/net/ethernet/intel/igb/igb_main.c     | 28 +++++++++----------
 drivers/net/ethernet/intel/igbvf/netdev.c     |  1 +
 drivers/net/ethernet/intel/igc/igc_i225.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c |  3 ++
 6 files changed, 39 insertions(+), 15 deletions(-)

-- 
2.31.1

