Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C00041F221
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354862AbhJAQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:29:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:30799 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhJAQ3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 12:29:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="248048335"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="248048335"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:20:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="556389928"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2021 09:20:16 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id A80E9B8; Fri,  1 Oct 2021 19:20:22 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] ptp_pch: Load module automatically if ID matches
Date:   Fri,  1 Oct 2021 19:20:14 +0300
Message-Id: <20211001162014.13541-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can't be loaded automatically because it misses
module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
call to the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_pch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index a17e8cc642c5..8070f3fd98f0 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -644,6 +644,7 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	 },
 	{0}
 };
+MODULE_DEVICE_TABLE(pci, pch_ieee1588_pcidev_id);
 
 static SIMPLE_DEV_PM_OPS(pch_pm_ops, pch_suspend, pch_resume);
 
-- 
2.33.0

