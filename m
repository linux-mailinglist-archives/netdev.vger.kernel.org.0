Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6835446E9E1
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 15:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbhLIO2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:28:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:10959 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhLIO2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 09:28:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="236843910"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="236843910"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 06:24:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="516672802"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 09 Dec 2021 06:24:27 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 0/4] net: wwan: iosm: improvements
Date:   Thu,  9 Dec 2021 20:02:26 +0530
Message-Id: <20211209143230.3054755-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series brings in IOSM driver improvments. Patch details are
explained below.

PATCH1:
 * Set tx queue len.
PATCH2:
 * Release data channel if there is no active IP session.
PATCH3:
 * Removes dead code.
PATCH4:
 * Correct open parenthesis alignment.

M Chetan Kumar (4):
  net: wwan: iosm: set tx queue len
  net: wwan: iosm: release data channel in case no active IP session
  net: wwan: iosm: removed unused function decl
  net: wwan: iosm: correct open parenthesis alignment

 drivers/net/wwan/iosm/iosm_ipc_imem.c      |  1 -
 drivers/net/wwan/iosm/iosm_ipc_mmio.c      |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.c       | 28 ++++++++++++++--------
 drivers/net/wwan/iosm/iosm_ipc_mux.h       |  1 -
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 18 +++++++-------
 drivers/net/wwan/iosm/iosm_ipc_wwan.c      |  3 ++-
 drivers/net/wwan/iosm/iosm_ipc_wwan.h      | 10 --------
 7 files changed, 30 insertions(+), 33 deletions(-)

--
2.25.1

