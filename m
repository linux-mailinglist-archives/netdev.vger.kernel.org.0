Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8CA5117CB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiD0MXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiD0MXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:23:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC71EAB
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651062002; x=1682598002;
  h=from:to:subject:date:message-id:mime-version;
  bh=jngo0xI2tntRJaPuP0nS6VDX5kMXd5DHASC64mioMMY=;
  b=EejBX2SjxjRwpdLVHZrkiF5rj4KeuEGurVXir40VMU9wiW5zkJ28zt5v
   ew39HZvu43ExWXNX9xoDy11IsluuBkZWc6wpPwrUgURAVGJI8m9LGU0r5
   nVGsRhQCtl2ANRKlSUfsZ7oKq1OQEuOgJLnUjdUecINCCQAOKQqvYncae
   hs4CNhKHQantTuBhddMaFk5y8dUciS9IjSPH7/LrmzRCBLfzNvUxsrkvL
   j3DpHdpp9kSKMEnRQu9QcYSPd09X0zd3BFeSHwIiPcN7OfPSE+z6Txdc+
   AmT1XqwqmUOoXYOWRSP5MdTJMe2Xug87H5nK9jQPYLJwuJT3V3bjxqlEq
   A==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="153999426"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 05:20:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 05:19:59 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 05:19:59 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 0/2] net: phy: add LAN8742 phy support
Date:   Wed, 27 Apr 2022 05:19:55 -0700
Message-ID: <20220427121957.13099-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add LAN8742 phy support
update LAN88xx phy ID and phy ID mask so that it can coexist with LAN8742

The current phy IDs on the available hardware.
    LAN8742 0x0007C130, 0x0007C131
    LAN88xx 0x0007C132

v1->v2:
-removed "REVIEW REQUEST3" from the PATCH 1/2.

Yuiko Oshino (2):
  net: phy: microchip: update LAN88xx phy ID and phy ID mask.
  net: phy: smsc: add LAN8742 phy support.

 drivers/net/phy/microchip.c |  6 +++---
 drivers/net/phy/smsc.c      | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

-- 
2.25.1

