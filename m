Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E043222DE
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhBVX6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:58:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:20936 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231905AbhBVX6Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 18:58:25 -0500
IronPort-SDR: PQ8GAEd4/xvxCo0xDDRNua8K8u9scFHCdIMgoGLu/eGUbmTmmCOQUL+x+pDkNcFEsc3VgzJ7Cj
 miBbx4CbMuiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="184751840"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="184751840"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 15:57:13 -0800
IronPort-SDR: 8yotf6UVFaYz9Tn7fQcyGi08u8tyy8O7SDD4MhakZJ5wg9x/Qf0SzYyrsjvW70w0n7HxpJ1lUO
 PpdpOIZqwdQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="592882892"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2021 15:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-02-22
Date:   Mon, 22 Feb 2021 15:58:09 -0800
Message-Id: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dave corrects reporting of max TCs to use the value from hardware
capabilities and setting of DCBx capability bits when changing between
SW and FW LLDP.

Brett fixes trusted VF multicast promiscuous not receiving expected
packets and corrects VF max packet size when a port VLAN is configured.

Henry updates available RSS queues following a change in channel count
with a user defined LUT.

The following are changes since commit 3a2eb515d1367c0f667b76089a6e727279c688b8:
  octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (2):
  ice: Set trusted VF as default VSI when setting allmulti on
  ice: Account for port VLAN in VF max packet size calculation

Dave Ertman (2):
  ice: report correct max number of TCs
  ice: Fix state bits on LLDP mode switch

Henry Tieman (1):
  ice: update the number of available RSS queues

 drivers/net/ethernet/intel/ice/ice.h          |  2 --
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  6 +++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 34 +++++++++++++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 35 +++++++++++++++++--
 4 files changed, 64 insertions(+), 13 deletions(-)

-- 
2.26.2

