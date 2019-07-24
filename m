Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4392B740CF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbfGXV0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:26:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:63560 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfGXV0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 17:26:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 14:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="scan'208";a="160700654"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 24 Jul 2019 14:26:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2019-07-24
Date:   Wed, 24 Jul 2019 14:26:08 -0700
Message-Id: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and e1000e client drivers only.

Sasha provides a couple of cleanups to remove code that is not needed
and reduce structure sizes.  Updated the MAC reset flow to use the
device reset flow instead of a port reset flow.  Added addition device
id's that will be supported.

Kai-Heng Feng provides a workaround for a possible stalled packet issue
in our ICH devices due to a clock recovery from the PCH being too slow.

v2: removed the last patch in the series that supposedly fixed a MAC/PHY
    de-sync potential issue while waiting for additional information from
    hardware engineers.

The following are changes since commit 92493a2f8a8d5a5bc1188fc71ef02df859ebd932:
  Build fixes for skb_frag_size conversion
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Kai-Heng Feng (1):
  e1000e: add workaround for possible stalled packet

Sasha Neftin (4):
  igc: Remove the polarity field from a PHY information structure
  igc: Remove the unused field from a device specification structure
  igc: Update the MAC reset flow
  igc: Add more SKUs for i225 device

 drivers/net/ethernet/intel/e1000e/ich8lan.c  | 10 ++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h  |  2 +-
 drivers/net/ethernet/intel/igc/igc_base.c    |  5 ++++-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +-
 drivers/net/ethernet/intel/igc/igc_hw.h      | 14 +++-----------
 drivers/net/ethernet/intel/igc/igc_main.c    |  3 +++
 6 files changed, 22 insertions(+), 14 deletions(-)

-- 
2.21.0

