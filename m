Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D055B16F6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiIHI2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIHI2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:28:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8614E8E0D0;
        Thu,  8 Sep 2022 01:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662625730; x=1694161730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F+RgC+OQrORfKx9UdsUHlfI9mE9xgmUjahcnd4o5ziw=;
  b=GS6gExDG+n3JD2f9pObRcpRz9peDadK6e/NCASocFqWxSeDdxjHP5la6
   sSml6gP86LHJvpL0/VHojK1H/lzen/TIJOhQW2/xr2NqWg9CehGwWpHJx
   Ub6dBw/HAFDOoTDKNQZtyMFTsJb2N/2LptVJMH8ssTCWj5EEAptkKStuH
   yLxIsdOVynFYmUzkDBs9AOJDu2pFgYhjZyD8NGdnnGFa9W3QAqT/pHfjn
   uSEqLinEvpjeEhQwmO+q7WSzL7YuBgGfn8WXk7dPvjYT0qz8B5Cpw3xH+
   mPdqUmFOMrcQneh5271AptWl60tAFsiidWolJCgHwjTz4aDaeVdaPRRlr
   w==;
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="112701442"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2022 01:28:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Sep 2022 01:28:48 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 8 Sep 2022 01:28:45 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V2 0/2] net: lan743x: Fix to use multiqueue start/stop APIs 
Date:   Thu, 8 Sep 2022 13:58:32 +0530
Message-ID: <20220908082834.5070-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series address the fix to use multiqueue start/stop APIs and Add Rx IP and TCP checksum offload
                                                                                
Changes:                                                                        
========                                                                        
V1 -> V2:
 - Fix the sparse warnings

V0 -> V1:                                                                       
 - Remove chip SKU check conditionals                                           
 - Update the changes description 

Raju Lakkaraju (2):
  net: lan743x: Fix to use multiqueue start/stop APIs
  net: lan743x: Add support for Rx IP & TCP checksum offload

 drivers/net/ethernet/microchip/lan743x_main.c | 64 +++++++++++--------
 drivers/net/ethernet/microchip/lan743x_main.h | 10 ++-
 2 files changed, 45 insertions(+), 29 deletions(-)

-- 
2.25.1

