Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C08B0210
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbfIKQub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:50:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:31968 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbfIKQuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:50:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385759068"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 11 Sep 2019 09:50:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 09/13] i40e: use BIT macro to specify the cloud filter field flags
Date:   Wed, 11 Sep 2019 09:50:10 -0700
Message-Id: <20190911165014.10742-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
References: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The macros used to specify the cloud filter fields are intended to be
individual bits. Declare them using the BIT() macro to make their
intention a little more clear.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index f1a1bd324b50..2af9f6308f84 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -243,11 +243,11 @@ struct i40e_fdir_filter {
 	u32 fd_id;
 };
 
-#define I40E_CLOUD_FIELD_OMAC	0x01
-#define I40E_CLOUD_FIELD_IMAC	0x02
-#define I40E_CLOUD_FIELD_IVLAN	0x04
-#define I40E_CLOUD_FIELD_TEN_ID	0x08
-#define I40E_CLOUD_FIELD_IIP	0x10
+#define I40E_CLOUD_FIELD_OMAC		BIT(0)
+#define I40E_CLOUD_FIELD_IMAC		BIT(1)
+#define I40E_CLOUD_FIELD_IVLAN		BIT(2)
+#define I40E_CLOUD_FIELD_TEN_ID		BIT(3)
+#define I40E_CLOUD_FIELD_IIP		BIT(4)
 
 #define I40E_CLOUD_FILTER_FLAGS_OMAC	I40E_CLOUD_FIELD_OMAC
 #define I40E_CLOUD_FILTER_FLAGS_IMAC	I40E_CLOUD_FIELD_IMAC
-- 
2.21.0

