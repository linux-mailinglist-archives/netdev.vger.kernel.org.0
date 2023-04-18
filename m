Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690646E643F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjDRMri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjDRMrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:47:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F375FBBB5;
        Tue, 18 Apr 2023 05:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681822044; x=1713358044;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tjtNEvQJVPMM+PQu4z589VL4YnCwraIRjmgULwRhcGM=;
  b=MA5vZupcqL3qEh6VzxOwXjoLRDA/gWOQfSysrvSm2hfnCtm+pQL4XgdO
   G052orgjTjOyGy5Yd6qo6YP640TEG6LK2EAceENmCjCe2nZW1olE6jt15
   5XH62TY8nrCvIeeXQxGC7Rr2CLgmnsax+uUqbq0GOxaQtpR9+nPwg4IxP
   IOAYyISVrN18PCSBDvCRvXReAM3LNoQ6wIiJ+lvWxqmFsPsdEsgRvLuqF
   kRohDqiE/EuRi40cB0kiUJTF8wLG4LshZqVGvJRdqd/2FvNzbVP3doiAL
   94Acagp30vA2h66jJjs+2LaXgpPE5yDxzi+mdTrzh6NKeH1OGMWz2SOeS
   g==;
X-IronPort-AV: E=Sophos;i="5.99,207,1677567600"; 
   d="scan'208";a="209604619"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2023 05:47:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 18 Apr 2023 05:47:18 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 18 Apr 2023 05:47:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: micrel: Update the list of supported phys
Date:   Tue, 18 Apr 2023 14:47:13 +0200
Message-ID: <20230418124713.2221451-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the beginning of the file micrel.c there is list of supported PHYs.
Extend this list with the following PHYs lan8841, lan8814 and lan8804,
as these PHYs were added but the list was not updated.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 382144a6306f0..e7082862786d2 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -10,13 +10,13 @@
  * Copyright (c) 2014 Johan Hovold <johan@kernel.org>
  *
  * Support : Micrel Phys:
- *		Giga phys: ksz9021, ksz9031, ksz9131
+ *		Giga phys: ksz9021, ksz9031, ksz9131, lan8841, lan8814
  *		100/10 Phys : ksz8001, ksz8721, ksz8737, ksz8041
  *			   ksz8021, ksz8031, ksz8051,
  *			   ksz8081, ksz8091,
  *			   ksz8061,
  *		Switch : ksz8873, ksz886x
- *			 ksz9477
+ *			 ksz9477, lan8804
  */
 
 #include <linux/bitfield.h>
-- 
2.38.0

