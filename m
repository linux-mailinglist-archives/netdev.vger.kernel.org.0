Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F15B1AE50A
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbgDQSnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:43:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:56864 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729739AbgDQSmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:55 -0400
IronPort-SDR: SKhFb2oBgFoz03HxYogSWC2GHtp/awLFnHDRHRFfSLoubtK36XN+WDlHIoWSiy1Fns5GcxtSQH
 +rUqvv0i8jow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:53 -0700
IronPort-SDR: aIdJH8UEZHYHnpqCLqI3KQZryu806yPu9vG8g1TlP3Zqu7/oXQ2lOHBbgpOU6ncZjE12r641cz
 eLhUbwy8Wrsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294370"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/14] igc: Remove unused MDIC_DEST mask
Date:   Fri, 17 Apr 2020 11:42:42 -0700
Message-Id: <20200417184251.1962762-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Formally Destination bit should be kept reserved to
support legacy drivers and ignore on write/read
operation
Not applicable for i225 parts

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 1b0fd2ffd08d..d6e07f81ca4c 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -510,7 +510,6 @@
 #define IGC_MDIC_READY		0x10000000
 #define IGC_MDIC_INT_EN		0x20000000
 #define IGC_MDIC_ERROR		0x40000000
-#define IGC_MDIC_DEST		0x80000000
 
 #define IGC_N0_QUEUE		-1
 
-- 
2.25.2

