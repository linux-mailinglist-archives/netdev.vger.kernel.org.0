Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9355585239
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbiG2PSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237326AbiG2PSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:18:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFBA8245A;
        Fri, 29 Jul 2022 08:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659107915; x=1690643915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RqIPaWspUXcggEiJPI0oGNwgnlO19dGMWZo/n/wJKQM=;
  b=o/29bpne0D1XpO4cHK9oYfbbRViTGlJwr4Nl7zqlzlcta1SeRW50EPpu
   qUbjYdob/Ex7aXZIgar0eUU/uOFGciHXpFlNWUB/UHwqmE+pm6vWEm5gy
   HETHpLfOlH5KZx9oNmTkvewlziL0Bfs/uoievquGxiYDWFCYUIn/bkb12
   zwWvWf9l/eNZJTC+cvW2cv7rB7jKXTJ2HZA9CMkrY+noOKjvaoPCJnOyO
   mTGlzNoRW0lZo06J7aKo7YY3gExLiCcwVgZ1EAkhLN2iYqlfG45guTgkf
   1CQvkzOY5ObRB+9fCjRBNGxsT5TBCHPJp1P3iqp8CdALCb7EFZXPWXQG/
   g==;
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="166987979"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2022 08:18:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 08:18:28 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 29 Jul 2022 08:18:17 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch RFC net-next 2/4] net: dsa: microchip: lan937x: remove vlan_filtering_is_global flag
Date:   Fri, 29 Jul 2022 20:47:31 +0530
Message-ID: <20220729151733.6032-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220729151733.6032-1-arun.ramadoss@microchip.com>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To have the similar implementation among the ksz switches, removed the
vlan_filtering_is_global flag which is only present in the lan937x.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index daedd2bf20c1..9c1fe38efd1a 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -401,11 +401,6 @@ int lan937x_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
-	/* The VLAN aware is a global setting. Mixed vlan
-	 * filterings are not supported.
-	 */
-	ds->vlan_filtering_is_global = true;
-
 	/* Enable aggressive back off for half duplex & UNH mode */
 	lan937x_cfg(dev, REG_SW_MAC_CTRL_0,
 		    (SW_PAUSE_UNH_MODE | SW_NEW_BACKOFF | SW_AGGR_BACKOFF),
-- 
2.36.1

