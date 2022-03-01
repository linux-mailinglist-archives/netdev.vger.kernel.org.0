Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C84C93B4
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiCATAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiCATAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ED438A5
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161170; x=1677697170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VYekS4vq+PGqXhGBHW/W1Lm6x57K0zOqkI2MPAL+3Yc=;
  b=Z1IAVyCmDG+09lN1/b8SIGzauQNqNEmRt3tyNz5xX4TMArjSImiZtmT4
   ucO9RKFOW29sJ57VpqyNGRGbvb09M9MbpVpu5VOUCZazz4DlCg+DDomN/
   AtL4TVz++VwWzZTdf42QThrw2+D3F5APHHz5iogBGWYTPBCM2SyiTCzyg
   3PhGih1Ibgw1/6CaczhHydXoY4tLlP/BCfxR8Us2JHuWfTvcQbCgKey33
   4A2neCiXgMqi/4Bcff04VXGDZywO8XkBGY8c/3poH4H9w94FBGws8hyOk
   T64UwA17mrS3834NWQYaOIDMoaPoBGZR6BehCqFIm9AFCRTk3mqtuJ9xL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042323"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042323"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908267"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Minghao Chi <chi.minghao@zte.com.cn>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 4/7] iavf: remove redundant ret variable
Date:   Tue,  1 Mar 2022 10:59:36 -0800
Message-Id: <20220301185939.3005116-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value directly instead of taking this in another redundant
variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f339b78262d3..25796d07d1e1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1523,7 +1523,6 @@ static void iavf_fill_rss_lut(struct iavf_adapter *adapter)
 static int iavf_init_rss(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	int ret;
 
 	if (!RSS_PF(adapter)) {
 		/* Enable PCTYPES for RSS, TCP/UDP with IPv4/IPv6 */
@@ -1539,9 +1538,8 @@ static int iavf_init_rss(struct iavf_adapter *adapter)
 
 	iavf_fill_rss_lut(adapter);
 	netdev_rss_key_fill((void *)adapter->rss_key, adapter->rss_key_size);
-	ret = iavf_config_rss(adapter);
 
-	return ret;
+	return iavf_config_rss(adapter);
 }
 
 /**
@@ -4745,8 +4743,6 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
-	int ret;
-
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
@@ -4757,8 +4753,7 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
-	ret = pci_register_driver(&iavf_driver);
-	return ret;
+	return pci_register_driver(&iavf_driver);
 }
 
 module_init(iavf_init_module);
-- 
2.31.1

