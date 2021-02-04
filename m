Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB0A30E8CE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhBDApy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:45:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234567AbhBDApa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:45:30 -0500
IronPort-SDR: 2FalntsixpTMB1Vkh6LjXWKkMRzGZtMHQPSiI+gz1C2GNlhIt7T5Vdm/SjplfQ9OqcpiVy+LZw
 ZCAVAC6k324Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638237"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638237"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:14 -0800
IronPort-SDR: Q2GYiARGyG0kYLJM3uScxcYCt3lf6EqFOQxb3IIOEXHUw9Kt/GKmHrcg9n8uyxdAmkMNIsC+Uy
 7Jw+Mke62tEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687519"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 13/15] igb: remove h from printk format specifier
Date:   Wed,  3 Feb 2021 16:42:57 -0800
Message-Id: <20210204004259.3662059-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 23e50de94474..bd0594ac3ae7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3156,7 +3156,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * the PCIe SR-IOV capability.
 	 */
 	if (pdev->is_virtfn) {
-		WARN(1, KERN_ERR "%s (%hx:%hx) should not be a VF!\n",
+		WARN(1, KERN_ERR "%s (%x:%x) should not be a VF!\n",
 			pci_name(pdev), pdev->vendor, pdev->device);
 		return -EINVAL;
 	}
-- 
2.26.2

