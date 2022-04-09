Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4378B4FAA2F
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbiDISlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiDISlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:41:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C7829B118;
        Sat,  9 Apr 2022 11:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649529539; x=1681065539;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iTpdkwqgLHup5YPtaYoOxFVyIRojkyKTjjTXGCM9ZWM=;
  b=fKmXZR/3R2JEbq71wbDUMysnvC9Tm2X4S6QjOXgSTCRmJHpf+wp+/ELi
   wOiDtXgjZWWBMApZSVmeD/8QazftJbTs9pniW06ZDQIK+giuHyAmCC2cE
   n/ywZcdbJDbFUsdGbiS6Nj1QACJyi6tweBpc5MH5CjbXnGr3/ztw69RMr
   aavtXNgrITbObuAnUfzRQCDgBxwzxt/tCwYSeRMPD0QpC8J2XBa6cCnk4
   zA2eV+/RLizVUAEd6IXP+6YTmpew4NIeFuos5O2biQ3LKtScOZTvUMaEO
   VbbhCfqicyJR/5Z4I1WjG9jOHev/kvVyEXbf6+HiX6OKEUYRgaw41uirR
   g==;
X-IronPort-AV: E=Sophos;i="5.90,248,1643698800"; 
   d="scan'208";a="159534947"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Apr 2022 11:38:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 9 Apr 2022 11:38:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 9 Apr 2022 11:38:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 0/4] net: lan966x: lan966x fixes
Date:   Sat, 9 Apr 2022 20:41:39 +0200
Message-ID: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This contains different fixes for lan966x in different areas like PTP, MAC,
Switchdev and IGMP processing.

Horatiu Vultur (4):
  net: lan966x: Update lan966x_ptp_get_nominal_value
  net: lan966x: Fix IGMP snooping when frames have vlan tag
  net: lan966x: Fix when a port's upper is changed.
  net: lan966x: Stop processing the MAC entry is port is wrong.

 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c      | 6 ++++--
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c     | 6 ++++++
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c      | 8 ++++----
 .../net/ethernet/microchip/lan966x/lan966x_switchdev.c    | 3 +--
 4 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.33.0

