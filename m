Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8F2AEFAB
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436863AbfIJQev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:34:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:21105 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436816AbfIJQei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 12:34:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 09:34:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="184223751"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 10 Sep 2019 09:34:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/14] i40e: mark additional missing bits as reserved
Date:   Tue, 10 Sep 2019 09:34:26 -0700
Message-Id: <20190910163434.2449-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
References: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Mark bits 0xD through 0xF for the command flags of a cloud filter as
reserved. These bits are not yet defined and are considered as reserved
in the data sheet.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 7ff768761659..530613f31527 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1394,6 +1394,9 @@ struct i40e_aqc_cloud_filters_element_data {
 #define I40E_AQC_ADD_CLOUD_FILTER_IMAC			0x000A
 #define I40E_AQC_ADD_CLOUD_FILTER_OMAC_TEN_ID_IMAC	0x000B
 #define I40E_AQC_ADD_CLOUD_FILTER_IIP			0x000C
+/* 0x000D reserved */
+/* 0x000E reserved */
+/* 0x000F reserved */
 /* 0x0010 to 0x0017 is for custom filters */
 #define I40E_AQC_ADD_CLOUD_FILTER_IP_PORT		0x0010 /* Dest IP + L4 Port */
 #define I40E_AQC_ADD_CLOUD_FILTER_MAC_PORT		0x0011 /* Dest MAC + L4 Port */
-- 
2.21.0

