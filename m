Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B792871DD3
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391137AbfGWRhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:37:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:49104 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388454AbfGWRhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:37:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 10:37:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="197203605"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jul 2019 10:37:00 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/6][pull request] 1GbE Intel Wired LAN Driver Updates 2019-07-23
Date:   Tue, 23 Jul 2019 10:36:44 -0700
Message-Id: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
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
Also provided a fix where the MAC & PHY may become de-sync'd causing a
miss detection of link up events.

The following are changes since commit d5c3a62d0bb9b763e9378fe8f4cd79502e16cce8:
  Merge branch 'Convert-skb_frag_t-to-bio_vec'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Kai-Heng Feng (2):
  e1000e: add workaround for possible stalled packet
  e1000e: disable force K1-off feature

Sasha Neftin (4):
  igc: Remove the polarity field from a PHY information structure
  igc: Remove the unused field from a device specification structure
  igc: Update the MAC reset flow
  igc: Add more SKUs for i225 device

 drivers/net/ethernet/intel/e1000e/hw.h       |  1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c  | 13 +++++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h  |  2 +-
 drivers/net/ethernet/intel/igc/igc_base.c    |  5 ++++-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 +-
 drivers/net/ethernet/intel/igc/igc_hw.h      | 14 +++-----------
 drivers/net/ethernet/intel/igc/igc_main.c    |  3 +++
 7 files changed, 26 insertions(+), 14 deletions(-)

-- 
2.21.0

