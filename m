Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C11E1D4008
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgENVbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:31:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:27035 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgENVbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 17:31:19 -0400
IronPort-SDR: j9tQWB+uv1hp7kuimeAQ+YpnTDltbAFBPyDAirlt8w0W1b69NGlKmZ/MpTCQlgvPKxwwyzTbxo
 g733mcmFv48w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 14:31:19 -0700
IronPort-SDR: fOyK90IALQpQ62Gi/zpMXSZNw0fqJ7Wds3+chnr/FH3rt3mN5NDFJbD3x/gic0dh0MhydYD7lv
 vDYzLVzajhIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="438069897"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 14 May 2020 14:31:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/9][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-14
Date:   Thu, 14 May 2020 14:31:08 -0700
Message-Id: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha adds ECN support for TSO by adding the NETIF_F_TSO_ECN flag, which
aligns with other Intel drivers.  Also cleaned up defines that are not
supported or used in the igc driver.

Andre does most of the changes with updating the log messages for igc
driver.

Vitaly adds support for EEPROM, register and link ethtool
self-tests.

v2: Fixed up the added ethtool self-tests based on feedback from the
    community.  Dropped the four patches that removed '\n' from log
    messages.

The following are changes since commit c8a867a38fc8d88a096ebf8813d02bbf50f7335e:
  Merge branch 'net-hns3-add-some-cleanups-for-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (5):
  igc: Use netdev log helpers in igc_main.c
  igc: Use netdev log helpers in igc_ethtool.c
  igc: Use netdev log helpers in igc_ptp.c
  igc: Use netdev log helpers in igc_dump.c
  igc: Use netdev log helpers in igc_base.c

Sasha Neftin (3):
  igc: Add ECN support for TSO
  igc: Remove unneeded definition
  igc: Remove unneeded register

Vitaly Lifshits (1):
  igc: add support to eeprom, registers and link self-tests

 drivers/net/ethernet/intel/igc/Makefile      |   2 +-
 drivers/net/ethernet/intel/igc/igc.h         |   4 +
 drivers/net/ethernet/intel/igc/igc_base.c    |   6 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |   1 -
 drivers/net/ethernet/intel/igc/igc_diag.c    | 186 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_diag.h    |  30 +++
 drivers/net/ethernet/intel/igc/igc_dump.c    | 109 ++++++-----
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  93 ++++++++--
 drivers/net/ethernet/intel/igc/igc_main.c    | 120 ++++++------
 drivers/net/ethernet/intel/igc/igc_ptp.c     |  12 +-
 drivers/net/ethernet/intel/igc/igc_regs.h    |   3 +-
 11 files changed, 417 insertions(+), 149 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.h

-- 
2.26.2

