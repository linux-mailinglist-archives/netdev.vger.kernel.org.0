Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF194457F68
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 17:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhKTQRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 11:17:12 -0500
Received: from mga07.intel.com ([134.134.136.100]:21604 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhKTQRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 11:17:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10174"; a="297998427"
X-IronPort-AV: E=Sophos;i="5.87,250,1631602800"; 
   d="scan'208";a="297998427"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2021 08:14:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,250,1631602800"; 
   d="scan'208";a="455775524"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga003.jf.intel.com with ESMTP; 20 Nov 2021 08:14:05 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V3 net-next 0/2] net: wwan: debugfs support for wwan device logging
Date:   Sat, 20 Nov 2021 21:51:53 +0530
Message-Id: <20211120162155.1216081-1-m.chetan.kumar@linux.intel.com>
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

Changes since v2:
PATCH1:
  * Removed unnecessary checks & empty lines before error checks.
PATCH2:
  * Removed empty lines before error checks.

Changes since v1:
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
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 173 ++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_trace.h    |  51 +++++++
 drivers/net/wwan/wwan_core.c              |  31 +++-
 include/linux/wwan.h                      |   2 +
 10 files changed, 302 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.h

--
2.25.1

