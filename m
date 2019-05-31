Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F75F309F0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfEaIPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:64476 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfEaIPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:12 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/13] iavf: change remaining i40e defines to be iavf
Date:   Fri, 31 May 2019 01:15:16 -0700
Message-Id: <20190531081518.16430-12-jeffrey.t.kirsher@intel.com>
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

There were a couple of erroneously missed i40e names to
update to iavf left after the larger chunks.  Updated them
separately so now they should all be aligned as iavf.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c | 96 +++++++++----------
 drivers/net/ethernet/intel/iavf/iavf_adminq.h |  4 +-
 drivers/net/ethernet/intel/iavf/iavf_type.h   |  2 +-
 3 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index a764eb9838d1..9fa3fa99b4c2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -29,10 +29,10 @@ static void iavf_adminq_init_regs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_alloc_adminq_asq_ring - Allocate Admin Queue send rings
+ *  iavf_alloc_adminq_asq_ring - Allocate Admin Queue send rings
  *  @hw: pointer to the hardware structure
  **/
-static enum iavf_status i40e_alloc_adminq_asq_ring(struct iavf_hw *hw)
+static enum iavf_status iavf_alloc_adminq_asq_ring(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code;
 
@@ -56,10 +56,10 @@ static enum iavf_status i40e_alloc_adminq_asq_ring(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_alloc_adminq_arq_ring - Allocate Admin Queue receive rings
+ *  iavf_alloc_adminq_arq_ring - Allocate Admin Queue receive rings
  *  @hw: pointer to the hardware structure
  **/
-static enum iavf_status i40e_alloc_adminq_arq_ring(struct iavf_hw *hw)
+static enum iavf_status iavf_alloc_adminq_arq_ring(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code;
 
@@ -73,34 +73,34 @@ static enum iavf_status i40e_alloc_adminq_arq_ring(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_free_adminq_asq - Free Admin Queue send rings
+ *  iavf_free_adminq_asq - Free Admin Queue send rings
  *  @hw: pointer to the hardware structure
  *
  *  This assumes the posted send buffers have already been cleaned
  *  and de-allocated
  **/
-static void i40e_free_adminq_asq(struct iavf_hw *hw)
+static void iavf_free_adminq_asq(struct iavf_hw *hw)
 {
 	iavf_free_dma_mem(hw, &hw->aq.asq.desc_buf);
 }
 
 /**
- *  i40e_free_adminq_arq - Free Admin Queue receive rings
+ *  iavf_free_adminq_arq - Free Admin Queue receive rings
  *  @hw: pointer to the hardware structure
  *
  *  This assumes the posted receive buffers have already been cleaned
  *  and de-allocated
  **/
-static void i40e_free_adminq_arq(struct iavf_hw *hw)
+static void iavf_free_adminq_arq(struct iavf_hw *hw)
 {
 	iavf_free_dma_mem(hw, &hw->aq.arq.desc_buf);
 }
 
 /**
- *  i40e_alloc_arq_bufs - Allocate pre-posted buffers for the receive queue
+ *  iavf_alloc_arq_bufs - Allocate pre-posted buffers for the receive queue
  *  @hw: pointer to the hardware structure
  **/
-static enum iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
+static enum iavf_status iavf_alloc_arq_bufs(struct iavf_hw *hw)
 {
 	struct iavf_aq_desc *desc;
 	struct iavf_dma_mem *bi;
@@ -165,10 +165,10 @@ static enum iavf_status i40e_alloc_arq_bufs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_alloc_asq_bufs - Allocate empty buffer structs for the send queue
+ *  iavf_alloc_asq_bufs - Allocate empty buffer structs for the send queue
  *  @hw: pointer to the hardware structure
  **/
-static enum iavf_status i40e_alloc_asq_bufs(struct iavf_hw *hw)
+static enum iavf_status iavf_alloc_asq_bufs(struct iavf_hw *hw)
 {
 	struct iavf_dma_mem *bi;
 	enum iavf_status ret_code;
@@ -206,10 +206,10 @@ static enum iavf_status i40e_alloc_asq_bufs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_free_arq_bufs - Free receive queue buffer info elements
+ *  iavf_free_arq_bufs - Free receive queue buffer info elements
  *  @hw: pointer to the hardware structure
  **/
-static void i40e_free_arq_bufs(struct iavf_hw *hw)
+static void iavf_free_arq_bufs(struct iavf_hw *hw)
 {
 	int i;
 
@@ -225,10 +225,10 @@ static void i40e_free_arq_bufs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_free_asq_bufs - Free send queue buffer info elements
+ *  iavf_free_asq_bufs - Free send queue buffer info elements
  *  @hw: pointer to the hardware structure
  **/
-static void i40e_free_asq_bufs(struct iavf_hw *hw)
+static void iavf_free_asq_bufs(struct iavf_hw *hw)
 {
 	int i;
 
@@ -248,12 +248,12 @@ static void i40e_free_asq_bufs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_config_asq_regs - configure ASQ registers
+ *  iavf_config_asq_regs - configure ASQ registers
  *  @hw: pointer to the hardware structure
  *
  *  Configure base address and length registers for the transmit queue
  **/
-static enum iavf_status i40e_config_asq_regs(struct iavf_hw *hw)
+static enum iavf_status iavf_config_asq_regs(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
 	u32 reg = 0;
@@ -277,12 +277,12 @@ static enum iavf_status i40e_config_asq_regs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_config_arq_regs - ARQ register configuration
+ *  iavf_config_arq_regs - ARQ register configuration
  *  @hw: pointer to the hardware structure
  *
  * Configure base address and length registers for the receive (event queue)
  **/
-static enum iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
+static enum iavf_status iavf_config_arq_regs(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
 	u32 reg = 0;
@@ -309,7 +309,7 @@ static enum iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_init_asq - main initialization routine for ASQ
+ *  iavf_init_asq - main initialization routine for ASQ
  *  @hw: pointer to the hardware structure
  *
  *  This is the main initialization routine for the Admin Send Queue
@@ -321,7 +321,7 @@ static enum iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
  *  Do *NOT* hold the lock when calling this as the memory allocation routines
  *  called are not going to be atomic context safe
  **/
-static enum iavf_status i40e_init_asq(struct iavf_hw *hw)
+static enum iavf_status iavf_init_asq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
 
@@ -342,17 +342,17 @@ static enum iavf_status i40e_init_asq(struct iavf_hw *hw)
 	hw->aq.asq.next_to_clean = 0;
 
 	/* allocate the ring memory */
-	ret_code = i40e_alloc_adminq_asq_ring(hw);
+	ret_code = iavf_alloc_adminq_asq_ring(hw);
 	if (ret_code)
 		goto init_adminq_exit;
 
 	/* allocate buffers in the rings */
-	ret_code = i40e_alloc_asq_bufs(hw);
+	ret_code = iavf_alloc_asq_bufs(hw);
 	if (ret_code)
 		goto init_adminq_free_rings;
 
 	/* initialize base registers */
-	ret_code = i40e_config_asq_regs(hw);
+	ret_code = iavf_config_asq_regs(hw);
 	if (ret_code)
 		goto init_adminq_free_rings;
 
@@ -361,14 +361,14 @@ static enum iavf_status i40e_init_asq(struct iavf_hw *hw)
 	goto init_adminq_exit;
 
 init_adminq_free_rings:
-	i40e_free_adminq_asq(hw);
+	iavf_free_adminq_asq(hw);
 
 init_adminq_exit:
 	return ret_code;
 }
 
 /**
- *  i40e_init_arq - initialize ARQ
+ *  iavf_init_arq - initialize ARQ
  *  @hw: pointer to the hardware structure
  *
  *  The main initialization routine for the Admin Receive (Event) Queue.
@@ -380,7 +380,7 @@ static enum iavf_status i40e_init_asq(struct iavf_hw *hw)
  *  Do *NOT* hold the lock when calling this as the memory allocation routines
  *  called are not going to be atomic context safe
  **/
-static enum iavf_status i40e_init_arq(struct iavf_hw *hw)
+static enum iavf_status iavf_init_arq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
 
@@ -401,17 +401,17 @@ static enum iavf_status i40e_init_arq(struct iavf_hw *hw)
 	hw->aq.arq.next_to_clean = 0;
 
 	/* allocate the ring memory */
-	ret_code = i40e_alloc_adminq_arq_ring(hw);
+	ret_code = iavf_alloc_adminq_arq_ring(hw);
 	if (ret_code)
 		goto init_adminq_exit;
 
 	/* allocate buffers in the rings */
-	ret_code = i40e_alloc_arq_bufs(hw);
+	ret_code = iavf_alloc_arq_bufs(hw);
 	if (ret_code)
 		goto init_adminq_free_rings;
 
 	/* initialize base registers */
-	ret_code = i40e_config_arq_regs(hw);
+	ret_code = iavf_config_arq_regs(hw);
 	if (ret_code)
 		goto init_adminq_free_rings;
 
@@ -420,19 +420,19 @@ static enum iavf_status i40e_init_arq(struct iavf_hw *hw)
 	goto init_adminq_exit;
 
 init_adminq_free_rings:
-	i40e_free_adminq_arq(hw);
+	iavf_free_adminq_arq(hw);
 
 init_adminq_exit:
 	return ret_code;
 }
 
 /**
- *  i40e_shutdown_asq - shutdown the ASQ
+ *  iavf_shutdown_asq - shutdown the ASQ
  *  @hw: pointer to the hardware structure
  *
  *  The main shutdown routine for the Admin Send Queue
  **/
-static enum iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
+static enum iavf_status iavf_shutdown_asq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
 
@@ -453,7 +453,7 @@ static enum iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
 	hw->aq.asq.count = 0; /* to indicate uninitialized queue */
 
 	/* free ring buffers */
-	i40e_free_asq_bufs(hw);
+	iavf_free_asq_bufs(hw);
 
 shutdown_asq_out:
 	mutex_unlock(&hw->aq.asq_mutex);
@@ -461,12 +461,12 @@ static enum iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
 }
 
 /**
- *  i40e_shutdown_arq - shutdown ARQ
+ *  iavf_shutdown_arq - shutdown ARQ
  *  @hw: pointer to the hardware structure
  *
  *  The main shutdown routine for the Admin Receive Queue
  **/
-static enum iavf_status i40e_shutdown_arq(struct iavf_hw *hw)
+static enum iavf_status iavf_shutdown_arq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
 
@@ -487,7 +487,7 @@ static enum iavf_status i40e_shutdown_arq(struct iavf_hw *hw)
 	hw->aq.arq.count = 0; /* to indicate uninitialized queue */
 
 	/* free ring buffers */
-	i40e_free_arq_bufs(hw);
+	iavf_free_arq_bufs(hw);
 
 shutdown_arq_out:
 	mutex_unlock(&hw->aq.arq_mutex);
@@ -525,12 +525,12 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
 	hw->aq.asq_cmd_timeout = IAVF_ASQ_CMD_TIMEOUT;
 
 	/* allocate the ASQ */
-	ret_code = i40e_init_asq(hw);
+	ret_code = iavf_init_asq(hw);
 	if (ret_code)
 		goto init_adminq_destroy_locks;
 
 	/* allocate the ARQ */
-	ret_code = i40e_init_arq(hw);
+	ret_code = iavf_init_arq(hw);
 	if (ret_code)
 		goto init_adminq_free_asq;
 
@@ -538,7 +538,7 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
 	goto init_adminq_exit;
 
 init_adminq_free_asq:
-	i40e_shutdown_asq(hw);
+	iavf_shutdown_asq(hw);
 init_adminq_destroy_locks:
 
 init_adminq_exit:
@@ -556,19 +556,19 @@ enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
 	if (iavf_check_asq_alive(hw))
 		iavf_aq_queue_shutdown(hw, true);
 
-	i40e_shutdown_asq(hw);
-	i40e_shutdown_arq(hw);
+	iavf_shutdown_asq(hw);
+	iavf_shutdown_arq(hw);
 
 	return ret_code;
 }
 
 /**
- *  i40e_clean_asq - cleans Admin send queue
+ *  iavf_clean_asq - cleans Admin send queue
  *  @hw: pointer to the hardware structure
  *
  *  returns the number of free desc
  **/
-static u16 i40e_clean_asq(struct iavf_hw *hw)
+static u16 iavf_clean_asq(struct iavf_hw *hw)
 {
 	struct iavf_adminq_ring *asq = &hw->aq.asq;
 	struct iavf_asq_cmd_details *details;
@@ -583,8 +583,8 @@ static u16 i40e_clean_asq(struct iavf_hw *hw)
 			   "ntc %d head %d.\n", ntc, rd32(hw, hw->aq.asq.head));
 
 		if (details->callback) {
-			I40E_ADMINQ_CALLBACK cb_func =
-					(I40E_ADMINQ_CALLBACK)details->callback;
+			IAVF_ADMINQ_CALLBACK cb_func =
+					(IAVF_ADMINQ_CALLBACK)details->callback;
 			desc_cb = *desc;
 			cb_func(hw, &desc_cb);
 		}
@@ -708,7 +708,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 	/* the clean function called here could be called in a separate thread
 	 * in case of asynchronous completions
 	 */
-	if (i40e_clean_asq(hw) == 0) {
+	if (iavf_clean_asq(hw) == 0) {
 		iavf_debug(hw,
 			   IAVF_DEBUG_AQ_MESSAGE,
 			   "AQTX: Error queue is full.\n");
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
index 300320e034d2..baf2fe26f302 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
@@ -84,11 +84,11 @@ struct iavf_adminq_info {
 };
 
 /**
- * i40e_aq_rc_to_posix - convert errors to user-land codes
+ * iavf_aq_rc_to_posix - convert errors to user-land codes
  * aq_ret: AdminQ handler error code can override aq_rc
  * aq_rc: AdminQ firmware error code to convert
  **/
-static inline int i40e_aq_rc_to_posix(int aq_ret, int aq_rc)
+static inline int iavf_aq_rc_to_posix(int aq_ret, int aq_rc)
 {
 	int aq_to_posix[] = {
 		0,           /* IAVF_AQ_RC_OK */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index 4bc05d2837d7..7190a40c540c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -21,7 +21,7 @@
 
 /* forward declaration */
 struct iavf_hw;
-typedef void (*I40E_ADMINQ_CALLBACK)(struct iavf_hw *, struct iavf_aq_desc *);
+typedef void (*IAVF_ADMINQ_CALLBACK)(struct iavf_hw *, struct iavf_aq_desc *);
 
 /* Data type manipulation macros. */
 
-- 
2.21.0

