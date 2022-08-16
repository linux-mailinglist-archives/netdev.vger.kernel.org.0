Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA76D596279
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiHPS2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiHPS23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:28:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72433C154
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660674506; x=1692210506;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NttqC0q5IgpseXqY3/wPco2ulghb0VZym/WIoCokxXA=;
  b=WGVHbte7R51gFIypa9qyBDyTHfHb0oiFcocgU3lr9nhXKEpUF9jLX+rK
   waAPS2qBzwaQeFbWO/oHVMKoxfTcaTjK9FotUAKyFkMqQIXubEYEGMpSM
   ZNQthO2nbshR35zyTMNwQtfs6QIrwjLKSrmyxT/iMhtXpOeaBMbqQXoDt
   SyInKqtMHyV/7kzTUE18Kl83FJMF76iKnONw6DEgRnOhitM6BL/5kAbnp
   Oy3y7zwpSslIr4MV4bjmCmlRUCy0qOgeZ3dp2Jpj9Xini0YLFXlDKAMNH
   Y8xJsL+lUZ0n8b7MU6ktPVW9YHjchR3qv733rI8N2Tza/8saj+PwXiNvC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293572972"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="293572972"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:27:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="710246344"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2022 11:27:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-08-16 (i40e)
Date:   Tue, 16 Aug 2022 11:27:49 -0700
Message-Id: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Przemyslaw fixes issue with checksum offload on VXLAN tunnels.

Alan disables VSI for Tx timeout when all recovery methods have failed.

The following are changes since commit ae806c7805571a9813e41bf6763dd08d0706f4ed:
  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Alan Brady (1):
  i40e: Fix to stop tx_timeout recovery if GLOBR fails

Przemyslaw Patynowski (1):
  i40e: Fix tunnel checksum offload with fragmented traffic

 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 +++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.35.1

