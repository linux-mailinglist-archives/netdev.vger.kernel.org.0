Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9BE2C9012
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388595AbgK3VaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:30:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:5349 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388580AbgK3VaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 16:30:15 -0500
IronPort-SDR: VolDcKJMxFZFmNh2cpb4RLMQLigZ+O9YE+vt1/DjVKVWgd/gNqlxmeCgtjBRdviTBtRk0g86wS
 v7En0Zyn8/KA==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="172815009"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="172815009"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 13:29:19 -0800
IronPort-SDR: anXuyV7rD347FIjLGrOGT5wCuVuhTuX1gDvdUu2tF7gFORV8NW6de3tUpU4rJ85F/fDbrx/n2G
 YVrUyh0tlyFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="329719695"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2020 13:29:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mario Limonciello <mario.limonciello@dell.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Yijun Shen <Yijun.shen@dell.com>
Subject: [net-next 3/4] e1000e: Add more Dell CML systems into s0ix heuristics
Date:   Mon, 30 Nov 2020 13:29:06 -0800
Message-Id: <20201130212907.320677-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

These comet lake systems are not yet released, but have been validated
on pre-release hardware.

This is being submitted separately from released hardware in case of
a regression between pre-release and release hardware so this commit
can be reverted alone.

Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/param.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
index d05f55201541..e7b7afc6c74a 100644
--- a/drivers/net/ethernet/intel/e1000e/param.c
+++ b/drivers/net/ethernet/intel/e1000e/param.c
@@ -273,6 +273,27 @@ static const struct dmi_system_id s0ix_supported_systems[] = {
 			DMI_MATCH(DMI_PRODUCT_SKU, "09C4"),
 		},
 	},
+	{
+		/* Dell Notebook 0x0A40 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "0A40"),
+		},
+	},
+	{
+		/* Dell Notebook 0x0A41 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "0A41"),
+		},
+	},
+	{
+		/* Dell Notebook 0x0A42 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "0A42"),
+		},
+	},
 	{ }
 };
 
-- 
2.26.2

