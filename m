Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C30BEEB09
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfKDVXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:23:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:13954 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728778AbfKDVXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:23:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:23:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219715253"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:23:49 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 1/7] fm10k: add missing field initializers to TLV attributes)
Date:   Mon,  4 Nov 2019 13:23:42 -0800
Message-Id: <20191104212348.9625-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
References: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add the missing field initializers for a couple of the TLV attribute
macros. This resolves the last few -Wmissing-field-initializers warnings
for the fm10k Linux driver.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.h b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.h
index 160bc5b78f99..ceb9b791f799 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_tlv.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_tlv.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #ifndef _FM10K_TLV_H_
 #define _FM10K_TLV_H_
@@ -76,8 +76,8 @@ struct fm10k_tlv_attr {
 #define FM10K_TLV_ATTR_S32(id)		    { id, FM10K_TLV_SIGNED, 4 }
 #define FM10K_TLV_ATTR_S64(id)		    { id, FM10K_TLV_SIGNED, 8 }
 #define FM10K_TLV_ATTR_LE_STRUCT(id, len)   { id, FM10K_TLV_LE_STRUCT, len }
-#define FM10K_TLV_ATTR_NESTED(id)	    { id, FM10K_TLV_NESTED }
-#define FM10K_TLV_ATTR_LAST		    { FM10K_TLV_ERROR }
+#define FM10K_TLV_ATTR_NESTED(id)	    { id, FM10K_TLV_NESTED, 0 }
+#define FM10K_TLV_ATTR_LAST		    { FM10K_TLV_ERROR, 0, 0 }
 
 struct fm10k_msg_data {
 	unsigned int		    id;
-- 
2.21.0

