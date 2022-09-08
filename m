Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B2C5B24A9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiIHReC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIHReB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:34:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070CAA50E0
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662658441; x=1694194441;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5xkoLkvcc/mZPj5ujbF0iKcsInNuK/qSbRxnPCb6WQc=;
  b=O9A0L4CYwhWu9h/JbqHHmeldnyFlDL3C6WXd3PUkYnGfClj2HkOREE49
   SQNnmUD204mXd4cstJZVw2DJBHwuPVvacVftsAaooEnIX46mLLURmgqH1
   spHK89l/0kpNAQ7Go2GU89Nn4U3NRodB9R3JEmRgYg8HBi4qlbdnO415G
   JrbC9upaIupj3RPvdRL3caIHgaQ4gTQSdj3t3XpbAn2/GYi6XZEwjTgR2
   ShzYSydn1AIOvJiEqWfCGgaVqXGFx/Ig26/WEiWVIX2CxDcEvrA/vtaRb
   MKIR2hAQ17OxzRTPszlfqZu3YcpFQcR7I8l2LlhkEIVIS2e6tF55rHP1C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298611156"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298611156"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:33:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="790525751"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 08 Sep 2022 10:33:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next 0/2][pull request] Intel Wired LAN Driver Updates 2022-09-08 (e1000e, igc)
Date:   Thu,  8 Sep 2022 10:33:42 -0700
Message-Id: <20220908173344.1282736-1-anthony.l.nguyen@intel.com>
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

This series contains updates to e1000e and igc drivers.

Li Zhong adds checking and handling for failed PHY register reads for
e1000e.

Sasha removes an unused define for igc.

The following are changes since commit 75554fe00f941c3c3d9344e88708093a14d2b4b8:
  net: sparx5: fix function return type to match actual type
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Li Zhong (1):
  drivers/net/ethernet/e1000e: check return value of e1e_rphy()

Sasha Neftin (1):
  igc: Remove IGC_MDIC_INT_EN definition

 drivers/net/ethernet/intel/e1000e/phy.c      | 20 +++++++++++++++++---
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 -
 2 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.35.1

