Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32152342786
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhCSVQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:16:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:20600 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhCSVP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:15:58 -0400
IronPort-SDR: JyXKjJCqttnEnbEG7I8Ha3GJIeZaNFKVM37RGIO//Z8klZwFadaH5rtDRGue0N6wTy1RCzxdA8
 UP8VYkpqYvWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="177554724"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="177554724"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 14:15:57 -0700
IronPort-SDR: 9jR19DwfZcicSenZrn4e4K8KqDCc9pogtk5UIg3fmKgzSJ507XCOihaOv9QR4LlU0GmcbVjbEr
 lYCLEQWhV7TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="451005067"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 14:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Subject: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2021-03-19
Date:   Fri, 19 Mar 2021 14:17:18 -0700
Message-Id: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and e1000e drivers.

Sasha removes unused defines in igc driver.

Jiapeng Zhong changes bool assignments from 0/1 to false/true for igc.

Wei Yongjun marks e1000e_pm_prepare() as __maybe_unused to resolve a
defined but not used warning under certain configurations.

The following are changes since commit c2ed62b9975e3e47a8b12f5fc4ed7958104b427b:
  Merge branch 'net-xps-improve-the-xps-maps-handling'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Jiapeng Zhong (1):
  igc: Assign boolean values to a bool variable

Sasha Neftin (3):
  igc: Remove unused MII_CR_RESET
  igc: Remove unused MII_CR_SPEED
  igc: Remove unused MII_CR_LOOPBACK

Wei Yongjun (1):
  e1000e: Mark e1000e_pm_prepare() as __maybe_unused

 drivers/net/ethernet/intel/e1000e/netdev.c   |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  5 -----
 drivers/net/ethernet/intel/igc/igc_main.c    | 16 ++++++++--------
 3 files changed, 9 insertions(+), 14 deletions(-)

-- 
2.26.2

