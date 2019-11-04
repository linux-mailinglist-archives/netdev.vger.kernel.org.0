Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152A0EEB0D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfKDVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:23:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:13955 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728778AbfKDVXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:23:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:23:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219715339"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:23:50 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 6/7] i40e: enable X710 support
Date:   Mon,  4 Nov 2019 13:23:47 -0800
Message-Id: <20191104212348.9625-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
References: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

The I40E_DEV_ID_10G_BASE_T_BC device id was added previously,
but was not enabled in all the appropriate places.  Adding it
to enable it's use.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 8b25a6d9c81d..a0791447849a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -29,6 +29,7 @@ i40e_status i40e_set_mac_type(struct i40e_hw *hw)
 		case I40E_DEV_ID_QSFP_C:
 		case I40E_DEV_ID_10G_BASE_T:
 		case I40E_DEV_ID_10G_BASE_T4:
+		case I40E_DEV_ID_10G_BASE_T_BC:
 		case I40E_DEV_ID_10G_B:
 		case I40E_DEV_ID_10G_SFP:
 		case I40E_DEV_ID_20G_KR2:
@@ -4910,6 +4911,7 @@ i40e_status i40e_write_phy_register(struct i40e_hw *hw,
 		break;
 	case I40E_DEV_ID_10G_BASE_T:
 	case I40E_DEV_ID_10G_BASE_T4:
+	case I40E_DEV_ID_10G_BASE_T_BC:
 	case I40E_DEV_ID_10G_BASE_T_X722:
 	case I40E_DEV_ID_25G_B:
 	case I40E_DEV_ID_25G_SFP28:
-- 
2.21.0

