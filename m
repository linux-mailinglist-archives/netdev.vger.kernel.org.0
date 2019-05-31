Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A96309EE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfEaIPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfEaIPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:13 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/13] iavf: update comments and file checks to match iavf
Date:   Fri, 31 May 2019 01:15:18 -0700
Message-Id: <20190531081518.16430-14-jeffrey.t.kirsher@intel.com>
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

Some small things were missed with recent name changes
from i40e to iavf.  Having a separate patch allows to
correct the small misses in one place.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_client.c   | 4 ++--
 drivers/net/ethernet/intel/iavf/iavf_common.c   | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_trace.h    | 4 ++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
index f7414769fda5..0c77e4171808 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
@@ -498,7 +498,7 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
 }
 
 /**
- * iavf_register_client - Register a i40e client driver with the L2 driver
+ * iavf_register_client - Register a iavf client driver with the L2 driver
  * @client: pointer to the iavf_client struct
  *
  * Returns 0 on success or non-0 on error
@@ -549,7 +549,7 @@ int iavf_register_client(struct iavf_client *client)
 EXPORT_SYMBOL(iavf_register_client);
 
 /**
- * iavf_unregister_client - Unregister a i40e client driver with the L2 driver
+ * iavf_unregister_client - Unregister a iavf client driver with the L2 driver
  * @client: pointer to the iavf_client struct
  *
  * Returns 0 on success or non-0 on error
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 05ae5ce06537..8547fc8fdfd6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -515,7 +515,7 @@ enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
  * IF NOT iavf_ptype_lookup[ptype].known
  * THEN
  *      Packet is unknown
- * ELSE IF iavf_ptype_lookup[ptype].outer_ip == I40E_RX_PTYPE_OUTER_IP
+ * ELSE IF iavf_ptype_lookup[ptype].outer_ip == IAVF_RX_PTYPE_OUTER_IP
  *      Use the rest of the fields to look at the tunnels, inner protocols, etc
  * ELSE
  *      Use the enum iavf_rx_l2_ptype to decode the packet type
diff --git a/drivers/net/ethernet/intel/iavf/iavf_trace.h b/drivers/net/ethernet/intel/iavf/iavf_trace.h
index 1474f5539751..1058e68a02b4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_trace.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_trace.h
@@ -17,8 +17,8 @@
 /* See trace-events-sample.h for a detailed description of why this
  * guard clause is different from most normal include files.
  */
-#if !defined(_I40E_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
-#define _I40E_TRACE_H_
+#if !defined(_IAVF_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _IAVF_TRACE_H_
 
 #include <linux/tracepoint.h>
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index b9f73154dcee..3eea35cee25a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -41,7 +41,7 @@ static int iavf_send_pf_msg(struct iavf_adapter *adapter,
  *
  * Send API version admin queue message to the PF. The reply is not checked
  * in this function. Returns 0 if the message was successfully
- * sent, or one of the I40E_ADMIN_QUEUE_ERROR_ statuses if not.
+ * sent, or one of the IAVF_ADMIN_QUEUE_ERROR_ statuses if not.
  **/
 int iavf_send_api_ver(struct iavf_adapter *adapter)
 {
@@ -123,7 +123,7 @@ int iavf_verify_api_ver(struct iavf_adapter *adapter)
  *
  * Send VF configuration request admin queue message to the PF. The reply
  * is not checked in this function. Returns 0 if the message was
- * successfully sent, or one of the I40E_ADMIN_QUEUE_ERROR_ statuses if not.
+ * successfully sent, or one of the IAVF_ADMIN_QUEUE_ERROR_ statuses if not.
  **/
 int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 {
-- 
2.21.0

