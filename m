Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D1468B85
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhLEPA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:00:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:20582 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234836AbhLEPA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 10:00:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237132477"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="237132477"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 06:57:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514507275"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2021 06:56:58 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V2 net-next 0/7] net: wwan: iosm: Bug fixes
Date:   Sun,  5 Dec 2021 20:34:48 +0530
Message-Id: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series brings in IOSM driver bug fixes. Patch details
are explained below.

PATCH1:
 * stop sending unnecessary doorbell in IP tx flow.
PATCH2:
 * set tx queue len.
PATCH3:
 * Restore the IP channel configuration after fw flash.
PATCH4:
 * Release data channel if there is no active IP session.
PATCH5:
 * Removes dead code.
PATCH6:
 * Removed the unnecessary check around control port TX transfer.
PATCH7:
 * Correct open parenthesis alignment to fix checkpatch warning.

Changes since v1:
 * PATCH2:
   - For tx queue length use the common DEFAULT_TX_QUEUE_LEN macro instead
     of defining the new macro.
 * PATCH4:
   - Fix checkpath warning.

M Chetan Kumar (7):
  net: wwan: iosm: stop sending unnecessary doorbell
  net: wwan: iosm: set tx queue len
  net: wwan: iosm: wwan0 net interface nonfunctional after fw flash
  net: wwan: iosm: release data channel in case no active IP session
  net: wwan: iosm: removed unused function decl
  net: wwan: iosm: AT port is not working while MBIM TX is ongoing
  net: wwan: iosm: correct open parenthesis alignment

 drivers/net/wwan/iosm/iosm_ipc_imem.c      | 27 +++++++++++++--------
 drivers/net/wwan/iosm/iosm_ipc_imem.h      |  4 +---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c  |  7 +-----
 drivers/net/wwan/iosm/iosm_ipc_mmio.c      |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.c       | 28 ++++++++++++++--------
 drivers/net/wwan/iosm/iosm_ipc_mux.h       |  1 -
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 18 +++++++-------
 drivers/net/wwan/iosm/iosm_ipc_wwan.c      |  3 ++-
 drivers/net/wwan/iosm/iosm_ipc_wwan.h      | 10 --------
 9 files changed, 49 insertions(+), 51 deletions(-)

--
2.25.1

