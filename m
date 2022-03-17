Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED24DCAB0
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbiCQQEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiCQQEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:04:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037392013CB
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647532963; x=1679068963;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gscJ6RGqi8djbjQmOAfu7SJhrhyEsShZQZ1fpfB4RBo=;
  b=aIonEpMzFRX3W+CbZuzM0rZ2txcYdAPv5qxU+8RKqPJM61isZ8kLqWgZ
   Edrh1gDnOQmQkYSAVH0lwnS/sv8160PbnXqQRLmrrT5F6knTWmjIVCILl
   WNy31PofCDzIQZGT2PAKHKawedVJNHqnWbzPwX06jMMYoS+iv17hZhwHy
   LJxqrjwbyFGuu/itytlo0nyIxgoeGCc6ujvrLAxVOEjqR1kuaBWS0fiQA
   U8GzPd01PCqLo+ZkzditWfAKZtAPmMHa+Z9GLzTweN6KpLFqRkEQqO91k
   mOYgdKgT6HGbkiJ3tQuB6M2qpqjlLZOhpamLPqZQ3xPwecEnIUtHsstPP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="236845990"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="236845990"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 09:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="581339478"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2022 09:02:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver Updates 2022-03-17
Date:   Thu, 17 Mar 2022 09:02:34 -0700
Message-Id: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and igb drivers.

Tom Rix moves a conversion to little endian to occur only when the
value is used for i40e. He also zeros out a structure to resolve
possible use of garbage value for igb as reported by clang.

The following are changes since commit 1abea24af42c35c6eb537e4402836e2cde2a5b13:
  selftests: net: fix array_size.cocci warning
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Tom Rix (2):
  i40e: little endian only valid checksums
  igb: zero hwtstamp by default

 drivers/net/ethernet/intel/i40e/i40e_nvm.c | 5 +++--
 drivers/net/ethernet/intel/igb/igb_ptp.c   | 6 ++----
 2 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.31.1

