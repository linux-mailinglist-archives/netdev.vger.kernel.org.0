Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B830245
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfE3Su5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:30429 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbfE3Suk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Update function header
Date:   Thu, 30 May 2019 11:50:42 -0700
Message-Id: <20190530185045.3886-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Add some details to the function header for ice_deinit_hw.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6988eb8695f1..1c94be588716 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -862,6 +862,10 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 /**
  * ice_deinit_hw - unroll initialization operations done by ice_init_hw
  * @hw: pointer to the hardware structure
+ *
+ * This should be called only during nominal operation, not as a result of
+ * ice_init_hw() failing since ice_init_hw() will take care of unrolling
+ * applicable initializations if it fails for any reason.
  */
 void ice_deinit_hw(struct ice_hw *hw)
 {
-- 
2.21.0

