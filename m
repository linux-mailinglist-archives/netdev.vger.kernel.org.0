Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A7B2E4B9
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfE2Srv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:64223 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfE2Srq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Minor cleanup in ice_switch.h
Date:   Wed, 29 May 2019 11:47:51 -0700
Message-Id: <20190529184754.12693-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove duplicate define for ICE_INVAL_Q_HANDLE. Move defines to the
top of the file.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 732b0b9b2e15..cb123fbe30be 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -8,9 +8,11 @@
 
 #define ICE_SW_CFG_MAX_BUF_LEN 2048
 #define ICE_DFLT_VSI_INVAL 0xff
+#define ICE_FLTR_RX BIT(0)
+#define ICE_FLTR_TX BIT(1)
+#define ICE_FLTR_TX_RX (ICE_FLTR_RX | ICE_FLTR_TX)
 #define ICE_VSI_INVAL_ID 0xffff
 #define ICE_INVAL_Q_HANDLE 0xFFFF
-#define ICE_INVAL_Q_HANDLE 0xFFFF
 
 /* VSI queue context structure */
 struct ice_q_ctx {
@@ -69,9 +71,6 @@ struct ice_fltr_info {
 	/* rule ID returned by firmware once filter rule is created */
 	u16 fltr_rule_id;
 	u16 flag;
-#define ICE_FLTR_RX		BIT(0)
-#define ICE_FLTR_TX		BIT(1)
-#define ICE_FLTR_TX_RX		(ICE_FLTR_RX | ICE_FLTR_TX)
 
 	/* Source VSI for LOOKUP_TX or source port for LOOKUP_RX */
 	u16 src;
-- 
2.21.0

