Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1A342A980
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhJLQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:1914 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhJLQhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:37:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227102066"
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="227102066"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 09:33:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="491050676"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 12 Oct 2021 09:33:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.machnikowski@intel.com, richardcochran@gmail.com
Subject: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-12
Date:   Tue, 12 Oct 2021 09:31:49 -0700
Message-Id: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Machnikowski says:

Extend the driver implementation to support PTP pins on E810-T and
derivative devices.

E810-T adapters are equipped with:
- 2 external bidirectional SMA connectors
- 1 internal TX U.FL shared with SMA1
- 1 internal RX U.FL shared with SMA2

The SMA and U.FL configuration is controlled by the external
multiplexer.

E810-T Derivatives are equipped with:
- 2 1PPS outputs on SDP20 and SDP22
- 2 1PPS inputs on SDP21 and SDP23

The following are changes since commit 177c92353be935db555d0d08729e871145ec698c:
  ethernet: tulip: avoid duplicate variable name on sparc
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Maciej Machnikowski (4):
  ice: Refactor ice_aqc_link_topo_addr
  ice: Implement functions for reading and setting GPIO pins
  ice: Add support for SMA control multiplexer
  ice: Implement support for SMA and U.FL on E810-T

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  20 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  87 +++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   7 +
 drivers/net/ethernet/intel/ice/ice_devids.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  15 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 370 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  20 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 156 ++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  22 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 12 files changed, 688 insertions(+), 14 deletions(-)

-- 
2.31.1

