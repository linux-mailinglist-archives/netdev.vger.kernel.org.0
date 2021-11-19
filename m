Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63E4456CE5
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhKSKCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:02:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:24868 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhKSKCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 05:02:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="258181631"
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="258181631"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 01:59:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="737335284"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga005.fm.intel.com with ESMTP; 19 Nov 2021 01:59:38 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 net-next 0/2] net: wwan: debugfs support for wwan device logging
Date:   Fri, 19 Nov 2021 15:37:18 +0530
Message-Id: <20211119100720.1112978-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series brings in
1) A common debugfs base directory i.e. /sys/kernel/debugfs/wwan/
in WWAN Subsystem for a WWAN device instance.

2) And support for Device trace collection in IOSM Diver using relayfs
interface.

Changes since v0:
PATCH1:
  * Changes in WWAN Subsystem to support common debugfs base directory.
PATCH2:
  * IOSM Driver adaption to get WWAN device dentry.
  * Removed unnecessary checks.

M Chetan Kumar (2):
  net: wwan: common debugfs base dir for wwan device
  net: wwan: iosm: device trace collection using relayfs

 drivers/net/wwan/iosm/Makefile            |   3 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c     |  13 ++
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |   2 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c |  31 +++-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |   9 +-
 drivers/net/wwan/iosm/iosm_ipc_port.c     |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 174 ++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_trace.h    |  51 +++++++
 drivers/net/wwan/wwan_core.c              |  35 ++++-
 include/linux/wwan.h                      |   2 +
 10 files changed, 307 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.h

--
2.25.1

