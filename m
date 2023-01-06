Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6655866092A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbjAFV7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbjAFV7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:59:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEB2728AD;
        Fri,  6 Jan 2023 13:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042361; x=1704578361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AI0odRghP/P2eZTU9+vUvGrnUWUgK7vgCVx3xkIU9s=;
  b=I1PcuUKOF1qxryEjviOCk2Q/LT0NFLlqxVVmdatbpPrT7NPUjburRl5G
   V28RpTk/E0xXGgs3C/daHNlwUUuQbojodQF1Irc2c/iq0jUvMSjPQSclN
   8/q5oN0jAHaCKyU7TmA/8cRDbNDpJ13ps/KRgpVLSHJyckPS7S0FF4Omk
   6XHYXdo8c1b6Q3/GwPB8epW3SoW7xHho3bwLX+CZQy6qgZgdJzdGhrNyK
   ZRjq7sT+bV/XFfJ/wJg1mgWkyGL8i8IGqp4CXJTFa/93yiMgGq3xw/qCn
   ctHuaawCT6apjgSTO5eP60VHd6UtvqqeOvxUXpyhnHJKUp89qg18jtuXT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="387030720"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="387030720"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:59:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763652899"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763652899"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.60])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 13:59:17 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 7/7] sparc: configs: Remove references to CONFIG_SUNVNET and CONFIG_LDMVSW
Date:   Fri,  6 Jan 2023 14:00:20 -0800
Message-Id: <20230106220020.1820147-8-anirudh.venkataramanan@intel.com>
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

An earlier patch removed the Sun LDOM vswitch and sunvnet drivers. Remove
references to CONFIG_SUNVNET and CONFIG_LDMVSW from the sparc64 defconfig.

Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 arch/sparc/configs/sparc64_defconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 1809909..a2c76e8 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -95,8 +95,6 @@ CONFIG_MII=m
 CONFIG_SUNLANCE=m
 CONFIG_HAPPYMEAL=y
 CONFIG_SUNGEM=m
-CONFIG_SUNVNET=m
-CONFIG_LDMVSW=m
 CONFIG_NET_PCI=y
 CONFIG_E1000=m
 CONFIG_E1000E=m
-- 
2.37.2

