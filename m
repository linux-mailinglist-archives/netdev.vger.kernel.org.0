Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2264B542FB1
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiFHMEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiFHMD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:03:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A283117656;
        Wed,  8 Jun 2022 05:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654689839; x=1686225839;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u6KvyscW+4tTQVyeDXB/L7hOF5WmF9Q2JgTsY/byqX8=;
  b=BDuo+189zgj3lo+J7oubfiPlYapl26R9bm6fsaONmfLt2bf9FD33yF30
   qHKrMgVxT1gD7nTtK67peWmeFnJmwb1ZPNblopYL9jnUrTgmXoLGAMQgt
   0OcQARtT/eb+/lADcGtGbT7Sks7F+tMGgL00wwoLh3xHVBuFhY2GLCgHs
   kK17mjKPDZfWkguhegR1wP9nR+pThFu6EO9fY4azDa3Cc4s7xYItu3UQR
   mO8LgcyHF3FpyOVjWRYDmgwNrDWaX7cFEekmUTja1hnSiI1rucf2Zsoe2
   LQ96lFb0+JpNT8b1n2Y+BNIyouUOfwZrrBGbTx0Pg2rNU7xieMruqC7hR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256701612"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="256701612"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:03:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="636792039"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jun 2022 05:03:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id A2D8E1F8; Wed,  8 Jun 2022 15:03:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v1 0/5] ptp_ocp: set of small cleanups
Date:   Wed,  8 Jun 2022 15:03:53 +0300
Message-Id: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set of (independent) cleanups against ptp_ocp driver.
Each patch has its own description, no need to repeat it here.

Andy Shevchenko (5):
  ptp_ocp: use dev_err_probe()
  ptp_ocp: use bits.h macros for all masks
  ptp_ocp: drop duplicate NULL check in ptp_ocp_detach()
  ptp_ocp: do not call pci_set_drvdata(pdev, NULL)
  ptp_ocp: replace kzalloc(x*y) by kcalloc(y, x)

 drivers/ptp/ptp_ocp.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

-- 
2.35.1

