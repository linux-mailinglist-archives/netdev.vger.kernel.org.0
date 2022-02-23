Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199A24C1B2A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244028AbiBWSyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiBWSyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:54:44 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166963ED16
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 10:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645642457; x=1677178457;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KnuUT6h3K0G11oxFdApCH9U/KAV0KwdR2qkjHwyjHa0=;
  b=T2cSxGC3jABnB7sXCJiVOFl69dXQKBicWtX9JrGdE4DqVLIHliDOGGAb
   iri9S6XIonnq6D/YJjyj1GxFOKtMN578jLXq2tt0eWWBqInSqm8HbLGnH
   nFgtBjS+MXfQlhEc4cYmcSS7rYcbSufiBOWgnNLNvnSPcv9UgdFeyscZr
   sJJMkFgJ0+sRKaVDWjYtLsBK7+EPLdDfWx8K29lKDquK1genTaLflM+/U
   7Eh02wEyGUu7/5bHM+ENMihJoXx97Zmtn4JBJ1PyduMsUedCPVn5UQJtl
   GIHIrtX6OWans/dC4PBZuh3xIgrevqxaP30qAB3NZThzEW8rZOzqvmES8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="338492242"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="338492242"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 10:54:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="508557514"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 23 Feb 2022 10:54:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver Updates 2022-02-23
Date:   Wed, 23 Feb 2022 10:54:22 -0800
Message-Id: <20220223185424.2129067-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
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

This series contains updates to ixgbe and ixgbevf drivers.

Yang Li fixes incorrect indenting as reported by smatch for ixgbevf.

Piotr removes non-inclusive language from ixgbe driver.

The following are changes since commit 6ce71687d4f4105350ddbc92aa12e6bc9839f103:
  Merge branch 'locked-bridge-ports'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Piotr Skajewski (1):
  ixgbe: Remove non-inclusive language

Yang Li (1):
  ixgbevf: clean up some inconsistent indenting

 .../net/ethernet/intel/ixgbe/ixgbe_common.c   | 36 +++++++++----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 10 +++---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 4 files changed, 26 insertions(+), 26 deletions(-)

-- 
2.31.1

