Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222EB65CA20
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjACXEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjACXEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:04:15 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5818140BC
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787054; x=1704323054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rDqG93G5C6nNLCLx8xwz5R98HgHyvTh6Rk8VgJBQK9I=;
  b=Si7Q0dzhXwDtW0dP4ZBpInhSU3g70bVWWAu98dA+MqU7LuLIfjM2VVkp
   WZY5Dia7EwxX/d13J53I/kwHoVKRMFBnQDUMbejs4PHUc44JmzJajSgoU
   /e5GyXHj4B2oTTEZXW28bFTejk02yJaqrkVyKZbRKnXCr/axD79qBsWBw
   y7I9vV9ORQKQrTKSlN5W0Llk1EnTbuUgm5WvamwC2rmy8i5cJ8CcLb6aK
   V6B/NzVhrAwqo+LK//kpYbR4cmFeZAWf9CqTX6tEXBhS2IkTJHl14x3PG
   bqs6NNTeQ6UoamYsTYTdV/pYwiBdwqBHXelA6XpwUhmNJrYXcD9LZTo4p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="302152106"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="302152106"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:04:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="723427615"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="723427615"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jan 2023 15:04:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        muhammad.husaini.zulkifli@intel.com, sasha.neftin@intel.com
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2023-01-03 (igc)
Date:   Tue,  3 Jan 2023 15:05:00 -0800
Message-Id: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Muhammad Husaini Zulkifli says:

Improvements to the Time-Sensitive Networking (TSN) Qbv Scheduling
capabilities were included in this patch series for I226 SKU.

An overview of each patch series is given below:

Patch 1: To enable basetime scheduling in the future, remove the existing
restriction for i226 stepping while maintain the restriction for i225.
Patch 2: Remove the restriction which require a controller reset when
setting the basetime register for new i226 steps and enable the second
GCL configuration.
Patch 3: Remove the power reset adapter during disabling the tsn config.
---
Patches remaining from initial PR:
https://lore.kernel.org/netdev/20221205212414.3197525-1-anthony.l.nguyen@intel.com/

after sending net patches:
https://lore.kernel.org/netdev/20221215230758.3595578-1-anthony.l.nguyen@intel.com/

Note: patch 3 is an additional patch from the initial PR.

The following are changes since commit c183e6c3ec342624c43269c099050d01eeb67e63:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Muhammad Husaini Zulkifli (2):
  igc: remove I226 Qbv BaseTime restriction
  igc: Remove reset adapter task for i226 during disable tsn config

Tan Tee Min (1):
  igc: enable Qbv configuration for 2nd GCL

 drivers/net/ethernet/intel/igc/igc_base.c    | 29 ++++++++++
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    |  8 ++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 56 ++++++++++++--------
 5 files changed, 73 insertions(+), 23 deletions(-)

-- 
2.38.1

