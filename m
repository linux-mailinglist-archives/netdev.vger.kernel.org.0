Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D5A571C4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfFZTai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:41406 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfFZTaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762472"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/10] i40e: fix incorrect function documentation comment
Date:   Wed, 26 Jun 2019 12:30:58 -0700
Message-Id: <20190626193103.2169-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 439c35f0c581..11394a52e21c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -140,8 +140,7 @@ static int i40e_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
  * @ptp: The PTP clock structure
  * @delta: Offset in nanoseconds to adjust the PHC time by
  *
- * Adjust the frequency of the PHC by the indicated parts per billion from the
- * base frequency.
+ * Adjust the current clock time by a delta specified in nanoseconds.
  **/
 static int i40e_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-- 
2.21.0

