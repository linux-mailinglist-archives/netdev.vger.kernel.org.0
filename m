Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41FE660919
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbjAFV7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbjAFV7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:59:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE53728AD;
        Fri,  6 Jan 2023 13:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042359; x=1704578359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TG7M7IO4ZvGwossk/dYz2Y4AzoE+L3tw+oWib10OPcY=;
  b=nPl9yFLbhZaXSjVC+bhLEfhaZQ34AQ2zowslFCo3vaSI2vecw/vstnfm
   0OffP2CiZ6PsVinvya8f+zrQnNqTL7eR1GGbRCaVWdqxEIkcHG+zMrhbD
   kPsKi1uatCqgR0Jt74hQIWnURdbuR8/T/YJSoliaQ9qMeekWzcZSaQL4j
   WI2AzgRfp3WnXhUZ6soAwDyLqNtDR/Oy3v/Azf+MCczgJsZIlqfecnjyJ
   +2YEaRgYCeiYY/ZbWwv2lTcNFq8OcXe0MmwW3BMIaQEGLC5jxaunyj6I9
   ijdK9hOYeEHcMMrXDCbXJSzkA/69TBsrziJmjL0IiqT4nZBBt+rvuFLh+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="387030705"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="387030705"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:59:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763652881"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763652881"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.60])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 13:59:16 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 2/7] PCI: Remove PCI IDs used by the Sun Cassini driver
Date:   Fri,  6 Jan 2023 14:00:15 -0800
Message-Id: <20230106220020.1820147-3-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch removed the Cassini driver (drivers/net/ethernet/sun).
With this, PCI_DEVICE_ID_NS_SATURN and PCI_DEVICE_ID_SUN_CASSINI are
unused. Remove them.

Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 include/linux/pci_ids.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b362d90..eca2340 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -433,7 +433,6 @@
 #define PCI_DEVICE_ID_NS_CS5535_AUDIO	0x002e
 #define PCI_DEVICE_ID_NS_CS5535_USB	0x002f
 #define PCI_DEVICE_ID_NS_GX_VIDEO	0x0030
-#define PCI_DEVICE_ID_NS_SATURN		0x0035
 #define PCI_DEVICE_ID_NS_SCx200_BRIDGE	0x0500
 #define PCI_DEVICE_ID_NS_SCx200_SMI	0x0501
 #define PCI_DEVICE_ID_NS_SCx200_IDE	0x0502
@@ -1047,7 +1046,6 @@
 #define PCI_DEVICE_ID_SUN_SABRE		0xa000
 #define PCI_DEVICE_ID_SUN_HUMMINGBIRD	0xa001
 #define PCI_DEVICE_ID_SUN_TOMATILLO	0xa801
-#define PCI_DEVICE_ID_SUN_CASSINI	0xabba
 
 #define PCI_VENDOR_ID_NI		0x1093
 #define PCI_DEVICE_ID_NI_PCI2322	0xd130
-- 
2.37.2

