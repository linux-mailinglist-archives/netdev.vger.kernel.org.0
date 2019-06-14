Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7F6468AC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfFNUPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:15:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:59939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNUPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:54 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 02/12] i40e: let untrusted VF to create up to 16 VLANs
Date:   Fri, 14 Jun 2019 13:16:00 -0700
Message-Id: <20190614201610.13566-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

This patch lets untrusted VF to create up to 16 VLANs.
It was implemented by increasing I40E_VC_MAX_VLAN_PER_VF up to 16.
Without this patch untrusted VF could create only up to 8 VLANs.

Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 09a7fd4d24e8..2390bfff7581 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2509,7 +2509,7 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * MAC filters: 16 for multicast, 1 for MAC, 1 for broadcast
  */
 #define I40E_VC_MAX_MAC_ADDR_PER_VF (16 + 1 + 1)
-#define I40E_VC_MAX_VLAN_PER_VF 8
+#define I40E_VC_MAX_VLAN_PER_VF 16
 
 /**
  * i40e_check_vf_permission
-- 
2.21.0

