Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EB55BEEC9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiITUxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiITUxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:53:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4FA76950
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663707232; x=1695243232;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=opsYbAz+XOtoDDF9JH2oVoaXX4jQZrrx/KbIudyMqp8=;
  b=fkYI+7jujhT46bXaKIZHGP0UjXP55Myth7Ekqpmx3v7NxNL4no/zqRlG
   OQCxD4iQkAKNKSdPuatNUSc6NTFymCQ5ut+IJyw28+LLeLtJwZPCD5Rmn
   xW72ey1npzfM3Y5q0myQGUrxY+cTtl9pe9bBSgY9zDTPahq45/Y+7DiE7
   KQ1QIYkwgwjlFnTuAQjh25R7WW57g2G7qCFZ19Rsu16l8O+Yeqto2HqCq
   Qk3ftp/Pfrzu8KWjOy0o3O7aX8v87kIBMZ0G+3DQt7FsfKo4G/pVZQZ6+
   LXasA6C2RvBpsqThDXUrXQyRoTaDfPZ7kKaArTx8lJecDrnn2mMq+N1HJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="386103558"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="386103558"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 13:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="722904465"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 20 Sep 2022 13:53:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-09-20 (ice)
Date:   Tue, 20 Sep 2022 13:53:42 -0700
Message-Id: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
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

This series contains updates to ice driver only.

Michal re-sets TC configuration when changing number of queues.

Mateusz moves the check and call for link-down-on-close to the specific
path for downing/closing the interface.

The following are changes since commit da847246ab80610c5acca34df5893bee1d8cf7c2:
  Merge branch 'fixes-for-tc-taprio-software-mode'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Mateusz Palczewski (1):
  ice: Fix interface being down after reset with link-down-on-close flag
    on

Michal Swiatkowski (1):
  ice: config netdev tc before setting queues number

 drivers/net/ethernet/intel/ice/ice_main.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
2.35.1

