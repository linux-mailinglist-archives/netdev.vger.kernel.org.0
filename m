Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFB627941E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgIYWZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgIYWZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:06 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A7EC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u24so3777164pgi.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Mrq3VP2bPocjekpz5Xx7n5QuvdN17XgV4nUw//qoU4=;
        b=j3r2rBy/kaYoqdZbjECMJ4P+DQrlfXYgPfmjRzeqNX3579K6IM1wm9pyOfwlllBQKV
         6vFFB2jk24XsJgNPCLvWxNONtcTGPe64uJJXkQkhxO9APEsjm7fx2qUbUig055Asz5QL
         3TS//mrwnKgS0hdvXEC0+D6sujghn9wZImN+RIEoNFZmSDI2FyAL8kBpsXbqvknoKbA0
         f6v4qTv6VhbD0aKOwXmJYgbU8XWhE5Dqo5L6O4pI0MiOlG8mM81rJoA6E6yd/qk+5Kvi
         at6zW9hpOOeflpow7jUAfveg92X6nbO0JwPyoudE9QHBUvUw/oQrdehnXokkPm8TG0PT
         3m4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Mrq3VP2bPocjekpz5Xx7n5QuvdN17XgV4nUw//qoU4=;
        b=WPNbrVMKvkhhZKO0+3eJtms1WRqvxZPFZxwfRdfkF5g0W3+fjYHbTKL5zsdoIB/wFv
         g+hyFNNfayG9AMX1/P+V1qaOttueGzvMrF6RYGvOgu1vvWgWNpdyWpCHtRG1BjsERPNI
         eXEX1st/Mon/0n4Z1r4vOFV1WJ5FH/J7wa/mMY38E4QFwNNTz2JE3Di7F17WAiXQt7Oi
         OIXWi/2BKKbXubXsf8RtUWqLBBRwXhv6MuroOCmru0ILh8ywo00Fmx5Fb1n/KQzw77IG
         A9pmSnMnV/zrbU1HlIuwtD+pa8BW9lDR8iPEg4bxvuT/F5Nmz5ZXyjyFNtPMR2xt3B2c
         H1vA==
X-Gm-Message-State: AOAM531Hgjb1EPWaTRJfHh7YZ1DCDP8bp1+9TPh4AgdnSIopL5uujSZC
        wYI5s4Gdo86RGd/ZwELvI39bwXucRSkY0FRJ
X-Google-Smtp-Source: ABdhPJwfBf1wcWe2H44snno1JwZVSD70Z5QREJE1D6MFX8mKl1WPVTeVtX5+b5MP81ibn7opbEVwbw==
X-Received: by 2002:aa7:9ac9:0:b029:13e:d13d:a133 with SMTP id x9-20020aa79ac90000b029013ed13da133mr1201792pfp.27.1601072705897;
        Fri, 25 Sep 2020 15:25:05 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:05 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v3 7/9] drivers/net/ethernet: remove incorrectly formatted doc
Date:   Fri, 25 Sep 2020 15:24:43 -0700
Message-Id: <20200925222445.74531-8-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

As part of the W=1 series for ethernet, these drivers were
discovered to be using kdoc style comments but were not actually
doing kdoc. The kernel uses kdoc style when documenting code, not
doxygen or other styles.

Fixed Warnings:
drivers/net/ethernet/amazon/ena/ena_com.c:613: warning: Function parameter or member 'ena_dev' not described in 'ena_com_set_llq'
drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1540: warning: Cannot understand  * @brief Set VLAN filter table
drivers/net/ethernet/xilinx/ll_temac_main.c:114: warning: Function parameter or member 'lp' not described in 'temac_indirect_busywait'
drivers/net/ethernet/xilinx/ll_temac_main.c:129: warning: Function parameter or member 'lp' not described in 'temac_indirect_in32'
drivers/net/ethernet/xilinx/ll_temac_main.c:129: warning: Function parameter or member 'reg' not described in 'temac_indirect_in32'
drivers/net/ethernet/xilinx/ll_temac_main.c:147: warning: Function parameter or member 'lp' not described in 'temac_indirect_in32_locked'
drivers/net/ethernet/xilinx/ll_temac_main.c:147: warning: Function parameter or member 'reg' not described in 'temac_indirect_in32_locked'
drivers/net/ethernet/xilinx/ll_temac_main.c:172: warning: Function parameter or member 'lp' not described in 'temac_indirect_out32'
drivers/net/ethernet/xilinx/ll_temac_main.c:172: warning: Function parameter or member 'reg' not described in 'temac_indirect_out32'
drivers/net/ethernet/xilinx/ll_temac_main.c:172: warning: Function parameter or member 'value' not described in 'temac_indirect_out32'
drivers/net/ethernet/xilinx/ll_temac_main.c:188: warning: Function parameter or member 'lp' not described in 'temac_indirect_out32_locked'
drivers/net/ethernet/xilinx/ll_temac_main.c:188: warning: Function parameter or member 'reg' not described in 'temac_indirect_out32_locked'
drivers/net/ethernet/xilinx/ll_temac_main.c:188: warning: Function parameter or member 'value' not described in 'temac_indirect_out32_locked'
drivers/net/ethernet/xilinx/ll_temac_main.c:212: warning: Function parameter or member 'lp' not described in 'temac_dma_in32_be'
drivers/net/ethernet/xilinx/ll_temac_main.c:212: warning: Function parameter or member 'reg' not described in 'temac_dma_in32_be'
drivers/net/ethernet/xilinx/ll_temac_main.c:228: warning: Function parameter or member 'lp' not described in 'temac_dma_out32_be'
drivers/net/ethernet/xilinx/ll_temac_main.c:228: warning: Function parameter or member 'reg' not described in 'temac_dma_out32_be'
drivers/net/ethernet/xilinx/ll_temac_main.c:228: warning: Function parameter or member 'value' not described in 'temac_dma_out32_be'
drivers/net/ethernet/xilinx/ll_temac_main.c:247: warning: Function parameter or member 'lp' not described in 'temac_dma_dcr_in'
drivers/net/ethernet/xilinx/ll_temac_main.c:247: warning: Function parameter or member 'reg' not described in 'temac_dma_dcr_in'
drivers/net/ethernet/xilinx/ll_temac_main.c:255: warning: Function parameter or member 'lp' not described in 'temac_dma_dcr_out'
drivers/net/ethernet/xilinx/ll_temac_main.c:255: warning: Function parameter or member 'reg' not described in 'temac_dma_dcr_out'
drivers/net/ethernet/xilinx/ll_temac_main.c:255: warning: Function parameter or member 'value' not described in 'temac_dma_dcr_out'
drivers/net/ethernet/xilinx/ll_temac_main.c:265: warning: Function parameter or member 'lp' not described in 'temac_dcr_setup'
drivers/net/ethernet/xilinx/ll_temac_main.c:265: warning: Function parameter or member 'op' not described in 'temac_dcr_setup'
drivers/net/ethernet/xilinx/ll_temac_main.c:265: warning: Function parameter or member 'np' not described in 'temac_dcr_setup'
drivers/net/ethernet/xilinx/ll_temac_main.c:300: warning: Function parameter or member 'ndev' not described in 'temac_dma_bd_release'
drivers/net/ethernet/xilinx/ll_temac_main.c:330: warning: Function parameter or member 'ndev' not described in 'temac_dma_bd_init'
drivers/net/ethernet/xilinx/ll_temac_main.c:600: warning: Function parameter or member 'ndev' not described in 'temac_setoptions'
drivers/net/ethernet/xilinx/ll_temac_main.c:600: warning: Function parameter or member 'options' not described in 'temac_setoptions'

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v3: added warning detail
v2: first non-rfc version
---
 drivers/net/ethernet/amazon/ena/ena_com.c     |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 26 +++++++++----------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 34434c6b6000..5f8769aa469d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -579,7 +579,7 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
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
2.25.4

