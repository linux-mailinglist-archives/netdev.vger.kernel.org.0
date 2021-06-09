Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252653A1E3A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 22:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFIUrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 16:47:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:64108 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhFIUra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 16:47:30 -0400
IronPort-SDR: 4LLxRdv9WR3WMS+5so4ddxxGCfY7ntZQxCIs3M6KdAmC7P7kY8lu2QC3PDXcrlabyMkuo0Slek
 RLaipS02L/rw==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="266318585"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="266318585"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 13:45:30 -0700
IronPort-SDR: sL2RUBF+uP1nGYY1M862KBPphKqNEwbpO9KeqP5EJ5A3bvgkD/rndQsEB7pvgrBvxLxb/RQNj5
 G44AJjwgxo+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="413861105"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2021 13:45:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-06-09
Date:   Wed,  9 Jun 2021 13:48:01 -0700
Message-Id: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Maciej informs the user when XDP is not supported due to the driver
being in the 'safe mode' state. He also adds a parameter to Tx queue
configuration to resolve an issue in configuring XDP queues as it cannot
rely on using the number Tx or Rx queues.

The following are changes since commit f2386cf7c5f4ff5d7b584f5d92014edd7df6c676:
  net: lantiq: disable interrupt before sheduling NAPI
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Maciej Fijalkowski (2):
  ice: add ndo_bpf callback for safe mode netdev ops
  ice: parameterize functions responsible for Tx ring management

 drivers/net/ethernet/intel/ice/ice_lib.c  | 18 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_main.c | 15 +++++++++++++++
 2 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.26.2

