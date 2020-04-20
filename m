Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6AC1B1A3C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDTXnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:14655 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTXnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:16 -0400
IronPort-SDR: MKE77FUEQnvURCyefyJBOcsVxlNuD1GWRvgR6+Ff3JK3jw+Vn0729durJtYtIaPmhjs9YUnNEO
 Q/PVYK018dxQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:15 -0700
IronPort-SDR: mMsC5D8tHoqHBcJUpNxFPgHx1err3qvCrXLt7k4Mt0TsBVZ+dfGqX1HkcEfMOg59SlFR7m4ya8
 DxzABpBHtzew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428835"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:15 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/13][pull request] 1GbE Intel Wired LAN Driver Updates 2020-04-20
Date:   Mon, 20 Apr 2020 16:43:00 -0700
Message-Id: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
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

Vitaly adds support for interrupt, EEPROM, register and link ethtool
self-tests.

The following are changes since commit 82ebc889091a488b4dd95e682b3c3b889a50713c:
  qed: use true,false for bool variables
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (9):
  igc: Use netdev log helpers in igc_main.c
  igc: Use netdev log helpers in igc_ethtool.c
  igc: Use netdev log helpers in igc_ptp.c
  igc: Use netdev log helpers in igc_dump.c
  igc: Use netdev log helpers in igc_base.c
  igc: Remove '\n' from log strings in igc_i225.c
  igc: Remove '\n' from log strings in igc_mac.c
  igc: Remove '\n' from log messages in igc_nvm.c
  igc: Remove '\n' from log strings in igc_phy.c

Sasha Neftin (3):
  igc: Add ECN support for TSO
  igc: Remove unneeded definition
  igc: Remove unneeded register

Vitaly Lifshits (1):
  igc: add support to interrupt, eeprom, registers and link self-tests

 drivers/net/ethernet/intel/igc/Makefile      |   2 +-
 drivers/net/ethernet/intel/igc/igc.h         |   4 +
 drivers/net/ethernet/intel/igc/igc_base.c    |  16 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |   1 -
 drivers/net/ethernet/intel/igc/igc_diag.c    | 336 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_diag.h    |  37 ++
 drivers/net/ethernet/intel/igc/igc_dump.c    | 109 +++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  96 +++++-
 drivers/net/ethernet/intel/igc/igc_i225.c    |  22 +-
 drivers/net/ethernet/intel/igc/igc_mac.c     |  42 +--
 drivers/net/ethernet/intel/igc/igc_main.c    | 134 ++++----
 drivers/net/ethernet/intel/igc/igc_nvm.c     |  12 +-
 drivers/net/ethernet/intel/igc/igc_phy.c     |  52 +--
 drivers/net/ethernet/intel/igc/igc_ptp.c     |  12 +-
 drivers/net/ethernet/intel/igc/igc_regs.h    |   3 +-
 15 files changed, 653 insertions(+), 225 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.h

-- 
2.25.3

