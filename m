Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C46B63E0E1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiK3Tmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiK3Tmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:42:37 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1D2DC4
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837355; x=1701373355;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wuu4DRo8QuS6Gf6ourH30vV0MSUaxE//L6OlNg3qiOE=;
  b=PqYfPsXa39dnvNe/6So0VFgjFmIHYVGhSubh3Mn/1BE2bgjb1eVJzeN2
   YLPcxKRpFpumF3KA4E2crvHrQRVaa6lpgpVZYk4/WAmSivbKVHvItzTIA
   xvSdIfiK9W1i/d+b+EkJoNhv3/LqdgDeozXPZj9x38w8CH8udw2ujD5Pe
   3khgWqTQCZrSnLLmBfrQ1z30CSdBXShw0ot7SOKPDo4FjBzI7lLoM7JTc
   9HINt/JU70a/0R6R7jG/k0Lj8jaVkcWenx/lEM4RKDt9xiWycdtQkPaYC
   WbgeUnD3chgTy1n2+8ExV+5I9ppAhdJ9+6n7rTgJi8cOHYcKQoK/fqjSU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="315520736"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="315520736"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:42:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="646455608"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="646455608"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 30 Nov 2022 11:42:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-11-30 (e1000e, igb)
Date:   Wed, 30 Nov 2022 11:42:26 -0800
Message-Id: <20221130194228.3257787-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igb drivers.

Akihiko Odaki fixes calculation for checking whether space for next
frame exists for e1000e and properly sets MSI-X vector to fix failing
ethtool interrupt test for igb.

The following are changes since commit 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1:
  Merge tag 'net-6.1-rc8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Akihiko Odaki (2):
  e1000e: Fix TX dispatch condition
  igb: Allocate MSI-X vector when testing

 drivers/net/ethernet/intel/e1000e/netdev.c   | 4 ++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.35.1

