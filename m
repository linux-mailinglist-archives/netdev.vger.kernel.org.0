Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBA94D9477
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiCOGST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiCOGST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:18:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3159849FA2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647325029; x=1678861029;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zkPIMmWea8ZTh/+6XKnUQGqbluBBv+laa4zwt9AKlgU=;
  b=OMTToFGk7g3P7GceTylzRY/mAEKbfbSaQaKAsjVdJTXShApHxdLjU9yx
   YghhxBwejjrek1go1L7F2Macy6fFz2ANy9jagF5FyaK3hm7bOQba7LjuS
   X+aeXlwX0cSwDPYzsqLc5rC2jKpx70aZB2hU3sUmE0gJwdQDWLY5/et3j
   IfrGrlsqRpGDvjg3cvH/IMhAoHIgFPbjnl4dLxZMtW+uTgW2WaosiyvCb
   ztP09FNaCVyzVLDq2gtf2mvwDhojbZbZM0hJ91/D+ST5xl0tUOmM4q1jv
   QeGic39j+bNjBR2I+q92BpygjWSvb4VrSGidQRE9K7u8bHuK5eig32mKc
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,182,1643698800"; 
   d="scan'208";a="149191677"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Mar 2022 23:17:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 14 Mar 2022 23:17:07 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 14 Mar 2022 23:17:05 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 0/5] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Tue, 15 Mar 2022 11:46:56 +0530
Message-ID: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series continues with the addition of supported features
for the Ethernet function of the PCI11010 / PCI11414 devices to
the LAN743x driver.

Raju Lakkaraju (5):
  net: lan743x: Add support to display Tx Queue statistics
  net: lan743x: Add support for EEPROM
  net: lan743x: Add support for OTP
  net: lan743x: Add support for PTP-IO Event Input External Timestamp
    (extts)
  net: lan743x: Add support for PTP-IO Event Output (Periodic Output)

 .../net/ethernet/microchip/lan743x_ethtool.c  | 405 ++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +
 drivers/net/ethernet/microchip/lan743x_main.h | 159 +++++
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 546 ++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_ptp.h  |  10 +
 5 files changed, 1076 insertions(+), 46 deletions(-)

-- 
2.25.1

