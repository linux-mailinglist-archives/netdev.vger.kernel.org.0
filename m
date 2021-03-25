Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B959334981F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCYReZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:34:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:57950 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhCYReM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:34:12 -0400
IronPort-SDR: gJ/n/6PCDRkl8cJ6G7vRtlTFvGau1KWklpOjESEEHwN4EazM/5Tw0GYgCyZBDa05fFVhjyOX3T
 PXEaVCeiMz8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="178105030"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="178105030"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:34:11 -0700
IronPort-SDR: 9YmMhz0+uRVUwlGWpEue8VBU64p7OgE04s8ZEhcZO2UG5RHejlphQCuow5CGSyxF4a2IfURziS
 VzrsqBCq4BDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="391828625"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 25 Mar 2021 10:34:09 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 290C01ED; Thu, 25 Mar 2021 19:34:22 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Date:   Thu, 25 Mar 2021 19:34:07 +0200
Message-Id: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series provides one fix (patch 1) for GPIO to be able to wait for
the GPIO driver to appear. This is separated from the conversion to
the GPIO descriptors (patch 2) in order to have a possibility for
backporting. Patches 3 and 4 fix a minor warnings from Sparse while
moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.

Tested on Intel Minnowboard (v1).

Since v2:
- added a few cleanups on top of the fix

Andy Shevchenko (5):
  net: pch_gbe: Propagate error from devm_gpio_request_one()
  net: pch_gbe: Convert to use GPIO descriptors
  net: pch_gbe: use readx_poll_timeout_atomic() variant
  net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
  net: pch_gbe: remove unneeded MODULE_VERSION() call

 .../net/ethernet/oki-semi/pch_gbe/pch_gbe.h   |   2 -
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   2 +
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 103 +++++++++---------
 3 files changed, 54 insertions(+), 53 deletions(-)

-- 
2.30.2

