Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A992F6D580A
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 07:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjDDFgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 01:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjDDFgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 01:36:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D7E1705
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680586598; x=1712122598;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QEdbEBTeZ/k9SeYvsjiwNO+0ctA9A/bdx0T5HbgYfw8=;
  b=nwfDxG9cIXTO9vD6hpG2AOnvfpgfRDD58trIzyaOrxuflw+GmZmLHrUi
   YtZEqiobPlstPygDP7ed+M33f16F+/HFTkpZMiIUaSP1ygYBZOf/2xRc2
   sEdakkcPX73LpSExDrI0XZwPNNjnzEetkgwG1Sd/rpuqvfZSkkQ/qGKyZ
   Gap3vFDjbify4bmJ4UoRdmxqOAEfpYGKCUnQ6NaqLGDooz2JaqH2MXZV1
   RhrIBQlZi1mYFAIkw361d8/dPpsptP0sHlhIqex6aQ0vqr6UoJpSaf8ly
   eAxtcTlP2mkLPsaQE7eq+CW4g+bnPS7ra2Sy5JT/XTC/MwVUznvgFzM5w
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="340826299"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="340826299"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 22:36:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688760546"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="688760546"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2023 22:36:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id E7A69133; Tue,  4 Apr 2023 08:36:36 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 0/2] net: thunderbolt: Fix for sparse warnings and typo
Date:   Tue,  4 Apr 2023 08:36:34 +0300
Message-Id: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The first patch should get rid of the sparse reported warnings that
still exist in the driver. The second one is trivial fix for typo.

Mika Westerberg (2):
  net: thunderbolt: Fix sparse warnings
  net: thunderbolt: Fix typo in comment

 drivers/net/thunderbolt/main.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

-- 
2.39.2

