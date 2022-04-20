Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB31A508E6E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381095AbiDTRcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381084AbiDTRcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:32:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE58946B11
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 10:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650475755; x=1682011755;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zOpxr0MwdqD4Lk6YBm1nI+oXVADtTPOc5JPUx1NoaAE=;
  b=Z6b5yJTGBHqICL5b6btceGrGh7IuPRlkqmhfXGFE0gIlrdaIc07PMW7s
   0wC1hSEy9mnulmDJA0qpcKO3aWFC+5uORnSYomCHYE1DezXf8EfEDRv1L
   isHaYLnff1Oqh6eZ09Y6Rp4PZ9flF4XF7zc9Bhj8CJotkGeRdJpIJ4NFK
   OgfJxTK3fNfCwcw4vwX1xuhAw7lS2azoXKDjop1kwMXZRURlXPE0HKb8Z
   85HqGN+N0u9fVDRg21YSWraYEJy409AtyJaAKy8msuWmqYPA0EQhNrXn7
   YNwINT5/sgkxymFcOLRQMGvq4t/J2broPlW4H5UcZB/U4CfDWTDbyGC3t
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244037001"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="244037001"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 10:29:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="727594571"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2022 10:29:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-04-20
Date:   Wed, 20 Apr 2022 10:26:22 -0700
Message-Id: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf and i40e drivers.

Michal adds a check for down states before changing ring parameters to
avoid possible corruption for iavf.

Xiaomeng Tong prevents possible use of incorrect 'ch' variable by
introducing an interim iterator variable for i40e.

The following are changes since commit 5e6242151d7f17b056a82ca7b860c4ec8eaa7589:
  selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted packets
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Michal Maloszewski (1):
  iavf: Fix error when changing ring parameters on ice PF

Xiaomeng Tong (1):
  i40e: i40e_main: fix a missing check on list iterator

 drivers/net/ethernet/intel/i40e/i40e_main.c   | 27 ++++++++++---------
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  5 ++++
 2 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.31.1

