Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A57646E649
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhLIKMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:12:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:6778 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhLIKMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:12:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="224933548"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="224933548"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 02:08:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="516236592"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga008.jf.intel.com with ESMTP; 09 Dec 2021 02:08:34 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net 0/3] net: wwan: iosm: bug fixes
Date:   Thu,  9 Dec 2021 15:46:26 +0530
Message-Id: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series brings in IOSM driver bug fixes. Patch details are
explained below.

PATCH1:
 * stop sending unnecessary doorbell in IP tx flow.
PATCH2:
 * Restore the IP channel configuration after fw flash.
PATCH3:
 * Removed the unnecessary check around control port TX transfer.

M Chetan Kumar (3):
  net: wwan: iosm: fixes unnecessary doorbell send
  net: wwan: iosm: fixes net interface nonfunctional after fw flash
  net: wwan: iosm: fixes unable to send AT command during mbim tx

 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 26 +++++++++++++++--------
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |  4 +---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c |  7 +-----
 3 files changed, 19 insertions(+), 18 deletions(-)

--
2.25.1

