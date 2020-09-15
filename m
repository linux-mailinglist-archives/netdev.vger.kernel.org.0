Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE8269B7C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgIOBpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:45:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:12848 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgIOBpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:45:24 -0400
IronPort-SDR: L6WWUd0KKhCHa2ctJINVH/k3Sr3cQTQtOxFOpRHprTg5yOsWQif+gElyAj9oSa4Ge8x24VmrXU
 spU3GUUcMAFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220742449"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220742449"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
IronPort-SDR: Q2nDp9z1fc0bjKDl9lWnLXr/ztUAxzc4B996ko2pSY+xFmrRj2AHtZ7zK++yMhtc/ImVK9iUcE
 kxxUYGPDiWHg==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482571960"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v2 08/10] drivers/net/ethernet: remove incorrectly formatted doc
Date:   Mon, 14 Sep 2020 18:44:53 -0700
Message-Id: <20200915014455.1232507-9-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the W=1 series for ethernet, these drivers were discovered to
be using kdoc style comments but were not actually doing kdoc. The kernel
uses kdoc style when documenting code, not doxygen or other styles.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 26 +++++++++----------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 452e66b39a17..6967d40b5ac7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -603,7 +603,7 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
 	return ret;
 }
 
-/**
+/*
  * Set the LLQ configurations of the firmware
  *
  * The driver provides only the enabled feature values to the device,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 8941ac4df9e3..9f1b15077e7d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1536,7 +1536,7 @@ static int hw_atl_b0_hw_fl2_clear(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-/**
+/*
  * @brief Set VLAN filter table
  * @details Configure VLAN filter table to accept (and assign the queue) traffic
  *  for the particular vlan ids.
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9a15f14daa47..60c199fcb91e 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -106,7 +106,7 @@ static bool hard_acs_rdy_or_timeout(struct temac_local *lp, ktime_t timeout)
  */
 #define HARD_ACS_RDY_POLL_NS (20 * NSEC_PER_MSEC)
 
-/**
+/*
  * temac_indirect_busywait - Wait for current indirect register access
  * to complete.
  */
@@ -121,7 +121,7 @@ int temac_indirect_busywait(struct temac_local *lp)
 		return 0;
 }
 
-/**
+/*
  * temac_indirect_in32 - Indirect register read access.  This function
  * must be called without lp->indirect_lock being held.
  */
@@ -136,7 +136,7 @@ u32 temac_indirect_in32(struct temac_local *lp, int reg)
 	return val;
 }
 
-/**
+/*
  * temac_indirect_in32_locked - Indirect register read access.  This
  * function must be called with lp->indirect_lock being held.  Use
  * this together with spin_lock_irqsave/spin_lock_irqrestore to avoid
@@ -164,7 +164,7 @@ u32 temac_indirect_in32_locked(struct temac_local *lp, int reg)
 	return temac_ior(lp, XTE_LSW0_OFFSET);
 }
 
-/**
+/*
  * temac_indirect_out32 - Indirect register write access.  This function
  * must be called without lp->indirect_lock being held.
  */
@@ -177,7 +177,7 @@ void temac_indirect_out32(struct temac_local *lp, int reg, u32 value)
 	spin_unlock_irqrestore(lp->indirect_lock, flags);
 }
 
-/**
+/*
  * temac_indirect_out32_locked - Indirect register write access.  This
  * function must be called with lp->indirect_lock being held.  Use
  * this together with spin_lock_irqsave/spin_lock_irqrestore to avoid
@@ -202,7 +202,7 @@ void temac_indirect_out32_locked(struct temac_local *lp, int reg, u32 value)
 	WARN_ON(temac_indirect_busywait(lp));
 }
 
-/**
+/*
  * temac_dma_in32_* - Memory mapped DMA read, these function expects a
  * register input that is based on DCR word addresses which are then
  * converted to memory mapped byte addresses.  To be assigned to
@@ -218,7 +218,7 @@ static u32 temac_dma_in32_le(struct temac_local *lp, int reg)
 	return ioread32(lp->sdma_regs + (reg << 2));
 }
 
-/**
+/*
  * temac_dma_out32_* - Memory mapped DMA read, these function expects
  * a register input that is based on DCR word addresses which are then
  * converted to memory mapped byte addresses.  To be assigned to
@@ -240,7 +240,7 @@ static void temac_dma_out32_le(struct temac_local *lp, int reg, u32 value)
  */
 #ifdef CONFIG_PPC_DCR
 
-/**
+/*
  * temac_dma_dcr_in32 - DCR based DMA read
  */
 static u32 temac_dma_dcr_in(struct temac_local *lp, int reg)
@@ -248,7 +248,7 @@ static u32 temac_dma_dcr_in(struct temac_local *lp, int reg)
 	return dcr_read(lp->sdma_dcrs, reg);
 }
 
-/**
+/*
  * temac_dma_dcr_out32 - DCR based DMA write
  */
 static void temac_dma_dcr_out(struct temac_local *lp, int reg, u32 value)
@@ -256,7 +256,7 @@ static void temac_dma_dcr_out(struct temac_local *lp, int reg, u32 value)
 	dcr_write(lp->sdma_dcrs, reg, value);
 }
 
-/**
+/*
  * temac_dcr_setup - If the DMA is DCR based, then setup the address and
  * I/O  functions
  */
@@ -293,7 +293,7 @@ static int temac_dcr_setup(struct temac_local *lp, struct platform_device *op,
 
 #endif
 
-/**
+/*
  * temac_dma_bd_release - Release buffer descriptor rings
  */
 static void temac_dma_bd_release(struct net_device *ndev)
@@ -323,7 +323,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
 				  lp->tx_bd_v, lp->tx_bd_p);
 }
 
-/**
+/*
  * temac_dma_bd_init - Setup buffer descriptor rings
  */
 static int temac_dma_bd_init(struct net_device *ndev)
@@ -593,7 +593,7 @@ static struct temac_option {
 	{}
 };
 
-/**
+/*
  * temac_setoptions
  */
 static u32 temac_setoptions(struct net_device *ndev, u32 options)
-- 
2.28.0

