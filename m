Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB54B4FE821
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358745AbiDLSl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358750AbiDLSlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:41:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC985340DA
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649788774; x=1681324774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=selzUc8xExOqus6mJYFKMlWVM7A5gY3n8sqfsCY7lAM=;
  b=PeF/5mDDxjt2IthqodBTWMaLpx4ku/FEaifywIluR6DpkT6UdADFsxNo
   FbgvdkuTJbSlyZyJOTJMLMxMZVGfm/DX4wft4zlw2t1y1d8dQxCFRCuGM
   CVLniQxju7SWnoLWvOYpte9ivTgyquk12cMIo6ek0iHNJm396/wG4X1et
   qesaV4iTib10A3nu/NLxiWQymTV4Ook2W7TovhuVmE0A7c10JiPCSs1Ci
   ai+CX2nTQtZC95TtonE0svKv9UKC7I/GgWBRdgNYNl/zK0erNv5bMeIEu
   7tvuj6+UkunopnZ87yafrowGiWCWvxDkOg5L+6xiE7wnc/hjG/Q3WX4h8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="322919275"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="322919275"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="590453092"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2022 11:39:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/5] i40e: Add Ethernet Connection X722 for 10GbE SFP+ support
Date:   Tue, 12 Apr 2022 11:36:36 -0700
Message-Id: <20220412183636.1408915-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
References: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Add support for Ethernet Connection X722 for 10GbE SFP+ cards.
Make possible for the driver to bind to the card.

Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_devids.h | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 6aefffd83615..2819e261a126 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -47,6 +47,7 @@ i40e_status i40e_set_mac_type(struct i40e_hw *hw)
 		case I40E_DEV_ID_1G_BASE_T_X722:
 		case I40E_DEV_ID_10G_BASE_T_X722:
 		case I40E_DEV_ID_SFP_I_X722:
+		case I40E_DEV_ID_SFP_X722_A:
 			hw->mac.type = I40E_MAC_X722;
 			break;
 		default:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_devids.h b/drivers/net/ethernet/intel/i40e/i40e_devids.h
index 1bcb0ec0f0c0..2610338002fe 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_devids.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_devids.h
@@ -33,6 +33,7 @@
 #define I40E_DEV_ID_1G_BASE_T_X722	0x37D1
 #define I40E_DEV_ID_10G_BASE_T_X722	0x37D2
 #define I40E_DEV_ID_SFP_I_X722		0x37D3
+#define I40E_DEV_ID_SFP_X722_A		0x0DDA
 
 
 #endif /* _I40E_DEVIDS_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index fea40efbd1ca..358c2edc118d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -77,6 +77,7 @@ static const struct pci_device_id i40e_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_1G_BASE_T_X722), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_10G_BASE_T_X722), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_SFP_I_X722), 0},
+	{PCI_VDEVICE(INTEL, I40E_DEV_ID_SFP_X722_A), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_20G_KR2), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_20G_KR2_A), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_X710_N3000), 0},
-- 
2.31.1

