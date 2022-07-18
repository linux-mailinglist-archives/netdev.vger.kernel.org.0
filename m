Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD9578928
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiGRSET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiGRSES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:04:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEBD2CDDE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658167457; x=1689703457;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ctJgnBgXuToCLAcRINY9D2jJ2K/qeKUfvNwLHfysYg0=;
  b=cxEouBv4cufWpHjydblZH1QPFdVKuBAxz6jIHKm3tYWGSIsAGaS4A5d4
   yj4kMVbIVwXNJOb05NldPabmdhnAzjmOKtYZJ3fMc9H9UI8pUxeWzgi6C
   GECTtk2yneykpHsdcMQRKo2kRI5bxM7xwG0UbHdbyCuMacP8hWOPNd7Sm
   6yYKd9Lqbn6Sw+no1zFxUEkUCeg6IgfRmK3z7UFYwNtR+MgaO8nwTRyhg
   BfLfkv1gNx3AGgFe7h5Jc4PWfPHcZnVSCnfy1LmBySGHzly8l/oCTuHnL
   UvWCJ2c9n74vsYdpe0AOx4lG5uOC+m09zNTVs2H0NzhPjkOD5Mn7RyWDN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287434726"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287434726"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:04:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655392508"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 11:04:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver Updates 2022-07-18
Date:   Mon, 18 Jul 2022 11:01:06 -0700
Message-Id: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Kurt Kanzenbach adds support for Qbv schedules where one queue stays open
in consecutive entries.

Sasha removes an unused define and field.

The following are changes since commit 6e693a104207fbf5a22795c987e8964c0a1ffe2d:
  atl1c: use netif_napi_add_tx() for Tx NAPI
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Kurt Kanzenbach (1):
  igc: Lift TAPRIO schedule restriction

Sasha Neftin (2):
  igc: Remove MSI-X PBA Clear register
  igc: Remove forced_speed_duplex value

 drivers/net/ethernet/intel/igc/igc_hw.h   |  2 --
 drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
 drivers/net/ethernet/intel/igc/igc_regs.h |  3 ---
 3 files changed, 17 insertions(+), 11 deletions(-)

-- 
2.35.1

