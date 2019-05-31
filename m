Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD7309EC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEaIPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:64476 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfEaIPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:11 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/13] iavf: rename i40e functions to be iavf
Date:   Fri, 31 May 2019 01:15:12 -0700
Message-Id: <20190531081518.16430-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Update the old i40e function names to be iavf

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c    | 6 +++---
 drivers/net/ethernet/intel/iavf/iavf_prototype.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 22d3b79a6049..59025172f3fa 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -8,12 +8,12 @@
 #include "iavf_prototype.h"
 
 /**
- *  i40e_adminq_init_regs - Initialize AdminQ registers
+ *  iavf_adminq_init_regs - Initialize AdminQ registers
  *  @hw: pointer to the hardware structure
  *
  *  This assumes the alloc_asq and alloc_arq functions have already been called
  **/
-static void i40e_adminq_init_regs(struct iavf_hw *hw)
+static void iavf_adminq_init_regs(struct iavf_hw *hw)
 {
 	/* set head and tail registers in our local struct */
 	hw->aq.asq.tail = IAVF_VF_ATQT1;
@@ -519,7 +519,7 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
 	}
 
 	/* Set up register offsets */
-	i40e_adminq_init_regs(hw);
+	iavf_adminq_init_regs(hw);
 
 	/* setup ASQ command write back timeout */
 	hw->aq.asq_cmd_timeout = I40E_ASQ_CMD_TIMEOUT;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_prototype.h b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
index 2ff49dc75e31..0dea4419c01f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_prototype.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
@@ -18,7 +18,7 @@
 /* adminq functions */
 enum iavf_status iavf_init_adminq(struct iavf_hw *hw);
 enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw);
-void i40e_adminq_init_ring_data(struct iavf_hw *hw);
+void iavf_adminq_init_ring_data(struct iavf_hw *hw);
 enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 					struct i40e_arq_event_info *e,
 					u16 *events_pending);
@@ -33,7 +33,7 @@ bool iavf_asq_done(struct iavf_hw *hw);
 void iavf_debug_aq(struct iavf_hw *hw, enum iavf_debug_mask mask,
 		   void *desc, void *buffer, u16 buf_len);
 
-void i40e_idle_aq(struct iavf_hw *hw);
+void iavf_idle_aq(struct iavf_hw *hw);
 void iavf_resume_aq(struct iavf_hw *hw);
 bool iavf_check_asq_alive(struct iavf_hw *hw);
 enum iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading);
-- 
2.21.0

