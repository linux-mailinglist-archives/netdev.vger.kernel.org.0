Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38F52261A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiEJVKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiEJVKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:10:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A6E293B67
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652217000; x=1683753000;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bPQ03jpHiGLYVBNp+Ql9qyvRD8Hmr9S2kE8v26SoqgU=;
  b=RlII2sVtewDychBagj612GkWZja8GvZi8p4nYGXtkFvoZ+9uzlUzwAXk
   jij+kqKw1ZBZ1mPH9i9ktUBYAAz78UgRDrgOtoawnlX3xSYLE62oNJUTV
   L3dGOgwcBoLVUpvsFTUTuaRUjHmY4+xg5d4c8P+Ql2f1tW/VRBNZJfphT
   R8HXNCA98kuTeQYZ6TyUxy7Q0tHxGsB62UmzyJ8LZzV2ly8MX6ez9KFP5
   DjXz1LSVpAmS1Q4m3PXL8gV19jToubgQVd3L9//C6PBlon2MzOru1j9oo
   /ezG8ScgN9a6kr4d6RAMGYUIwgcNh+U0FOpIoZsnBbu4ct/gqhkwN3BzN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="267096316"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="267096316"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 14:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="623648421"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2022 14:10:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver Updates 2022-05-10
Date:   Tue, 10 May 2022 14:06:53 -0700
Message-Id: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha cleans up the code by removing an unused function and removing an
enum for PHY type as there is only one PHY. The return type for
igc_check_downshift() is changed to void as it always returns success.

The following are changes since commit ecd17a87eb78b5bd5ca6d1aa20c39f2bc3591337:
  x25: remove redundant pointer dev
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Sasha Neftin (3):
  igc: Remove igc_set_spd_dplx method
  igc: Remove unused phy_type enum
  igc: Change type of the 'igc_check_downshift' method

 drivers/net/ethernet/intel/igc/igc.h      |  1 -
 drivers/net/ethernet/intel/igc/igc_base.c |  2 -
 drivers/net/ethernet/intel/igc/igc_hw.h   |  7 ----
 drivers/net/ethernet/intel/igc/igc_main.c | 50 -----------------------
 drivers/net/ethernet/intel/igc/igc_phy.c  | 16 ++------
 drivers/net/ethernet/intel/igc/igc_phy.h  |  2 +-
 6 files changed, 4 insertions(+), 74 deletions(-)

-- 
2.35.1

