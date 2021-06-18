Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA19B3AD05A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhFRQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:29:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:5462 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234029AbhFRQ3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:29:02 -0400
IronPort-SDR: KXTiDv2u9QRxVf30GKsGTIHlx2hOR6DQjy3ZiwfLpHtjobnCz5eeG7hd6f/uYioqluhZh/lTaz
 rHnEj7C/9TKg==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="193895223"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="193895223"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 09:26:53 -0700
IronPort-SDR: 3xVoOMCdtZUexibtmI1K8iuOwrbo5AC6DildO667OP/+dIxl6Gna2EkyDav3Td4jKdIJT7h4Ur
 Pk1cH90YSDxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="554781627"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2021 09:26:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, jesse.brandeburg@intel.com
Subject: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver Updates 2021-06-18
Date:   Fri, 18 Jun 2021 09:29:29 -0700
Message-Id: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesse Brandeburg says:

Update three of the Intel Ethernet drivers with similar (but not the
same) improvements to simplify the packet type table init, while removing
an unused structure entry. For the ice driver, the table is extended
to 10 bits, which is the hardware limit, and for now is initialized
to zero.

The end result is slightly reduced memory usage, removal of a bunch
of code, and more specific initialization.

The following are changes since commit 8fe088bd4fd12f4c8899b51d5bc3daad98767d49:
  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jesse Brandeburg (3):
  ice: report hash type such as L2/L3/L4
  i40e: clean up packet type lookup table
  iavf: clean up packet type lookup table

 drivers/net/ethernet/intel/i40e/i40e_common.c | 124 +--------------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   1 -
 drivers/net/ethernet/intel/iavf/iavf_common.c | 124 +--------------
 drivers/net/ethernet/intel/iavf/iavf_type.h   |   1 -
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 147 ++++--------------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  23 ++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   2 +-
 9 files changed, 62 insertions(+), 364 deletions(-)

-- 
2.26.2

