Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A18F4F1AF5
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379325AbiDDVTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379999AbiDDShE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:37:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC77C31376
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 11:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649097307; x=1680633307;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7yBSgCzuva6drTNuw1+H+UY3WSyalGVqy9I37LZdQTM=;
  b=lkkjukGxZWS5rUlqdcd7LJeWsaPDkDCME4B3PMwMBPpSlG2hdczQqBOl
   Y6sX6C4FDItBFm2Pi+ZJARimDkzPZpmfFCDxEH9t3B95iE1mhp7BuLsMg
   Y2iT6aHcC2koA/QpB/BoSWN8usPlJcuKlmPt83HAiv24+US0r9Tu5afZt
   eyGjxpZI+reRfsfrAMy2Kc/w8ngUnzlZftHXoRQq4ULIsj9lE6StazIUV
   j/g4zMlIQoBZLO+L5WH/rtWZDFpkwrTUZ/pfNHobLVX9ZV4R+DbTXk1C5
   /HSBYgMiLbCMGo/d4BL+9+L/Flz/ow8dlJsYKcoqyektjT/CEwe89ppWB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="242726699"
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="242726699"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 11:35:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="789578299"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 04 Apr 2022 11:35:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        alice.michael@intel.com
Subject: [PATCH net v2 0/2][pull request] ice bug fixes
Date:   Mon,  4 Apr 2022 11:35:46 -0700
Message-Id: <20220404183548.3422851-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alice Michael says:

There were a couple of bugs that have been found and
fixed by Anatolii in the ice driver.  First he fixed
a bug on ring creation by setting the default value
for the teid.  Anatolli also fixed a bug with deleting
queues in ice_vc_dis_qs_msg based on their enablement.

---
v2: Remove empty lines between tags

The following are changes since commit 458f5d92df4807e2a7c803ed928369129996bf96:
  sfc: Do not free an empty page_ring
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anatolii Gerasymenko (2):
  ice: Set txq_teid to ICE_INVAL_TEID on ring creation
  ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

 drivers/net/ethernet/intel/ice/ice_lib.c      | 1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.31.1

