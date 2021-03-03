Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1447332C4A0
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449691AbhCDAPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:40 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31520 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387218AbhCCT47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 14:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614801418; x=1646337418;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YQZZr1Q/M8gsdlmJ5YhEx/5S+0W4ZZJJvP4e0J9q47c=;
  b=Lb5vyKi8GFCVLZsEotzgbgSfd1kY304fSzmQd+DS/jKEcOANQJAgvizY
   6pnjaIEnFT+yssAkqX0bzWbIqbwcHpkHKOFMKi2aJAaNf6T/VVBxDYRlF
   KByrNBwNxBHhP4JqbEyYhmc5pY79u2YRBEfnFmTxgn8/Ql7wTuhmYfe7J
   JTnW3BFiBrdzioz0Au6k9+JTtT4AdGtYOJsnMgrWSAJabhh8O/PCY6p4a
   kfNG3YFq057mOsMa3M5KKJwYDlk2unrg8ZHE+P+DnmEJoePrCQwj/50d+
   jXqyxwIEWuS5vEi7rsMVU6J4T3ofVLboSHFykZfO+9fGuAQS1X7leRFn/
   Q==;
IronPort-SDR: Nuc/tXM/KVlC5QL1fDmMksO1llz3f/L2ujThSrxDCICbpV66sky34Wgk8bt/IEIQXPVGd+xPRR
 uQ546/fVlxmT1KYL4YjHULpUDhjUhQH1ckNe3NohRbIkU7RKfVJVWRe8VCsDmS8dwI6s4V3bzy
 +XdQpp81lovdCIGtjVvWmpC9WTWskMirDQuZpG1O1iBLBOuCq50oqE3nFInTrNGImJLUNp/n3g
 MxyoNFF6rysX5MmbdC87KyxF8uthlB/cXCBxIz/SzwGLiDJWcW+bt8mQu9AvoLrA2Zp45vReoI
 1fk=
X-IronPort-AV: E=Sophos;i="5.81,220,1610380800"; 
   d="scan'208";a="161299056"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2021 03:55:53 +0800
IronPort-SDR: /2lL4vSUSd/FY5qRX1dDNW9Ck7NTD0eiIax+lPozKnfN6qx0LHj8fuYLgq5LcIBN1kY1P6IV6H
 186TRnRjuQF9DRN6Io8X+KcmuZVW1X/dPNfG0ylhfnAglF6PYQ/jqBgxSNgULIsD+yJyltuLgR
 9DOdWHCuno7VmFTzBIYJxbK93rjrSXM4Fl/tlpm8I+8IgnmFHgoNS/jiHuPR6rcxnzwaP/A7QL
 75qqgDmYI35Nsd7JGNlDh+5s9apSoXbfm1j69/Pd+qZH24vb3BCzfPeSeNvpvvDKa7c/o2GAwP
 NMVUZW9E7X09LH2pgfxr5DUi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 11:37:07 -0800
IronPort-SDR: aA9PibPpuN5h1J2zrUi7sGuXYjOQVSq+7PnWx5uJkyKI7yYldV7LAYnZy6LCWehn6O6fw8RjTn
 /pr5rL4TUGXzBQDNy8DlZn2i8hq74s8RA6SrmiLaTtQR2ewEoHjID5QCz1VOQsdEFmH5JQnb2j
 nls98LABz0esKxwkpaRpVUfr53TM1CwpMQV8djUIi0zR9FOsT0KhS5vWaKkDimr1uoVw8coIsm
 +wbRIXd0mRq902OvSpKGZH6ajk3FTclA0Z3C4zU1KUf6opZhj1onUn4JZmxbp8uYXPUWKkp6+b
 cYw=
WDCIronportException: Internal
Received: from ind002560.ad.shared (HELO jedi-01.hgst.com) ([10.86.48.105])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2021 11:55:53 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     netdev@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4] net: macb: Add default usrio config to default gem config
Date:   Wed,  3 Mar 2021 11:55:49 -0800
Message-Id: <20210303195549.1823841-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no usrio config defined for default gem config leading to
a kernel panic devices that don't define a data. This issue can be
reprdouced with microchip polar fire soc where compatible string
is defined as "cdns,macb".

Fixes: edac63861db7 ("add userio bits as platform configuration")

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes from v3->v4:
1. Moved the macb_default_usrio out of OF_FDT to make buildbots happy.
Changes from v2->v3:
1. Fixed the typo in fixes tag.
Changes from v1->v2:
1. Fixed the fixes tag.
---
 drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 472bf8f220bc..15362d016a87 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3954,6 +3954,13 @@ static int macb_init(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct macb_usrio_config macb_default_usrio = {
+	.mii = MACB_BIT(MII),
+	.rmii = MACB_BIT(RMII),
+	.rgmii = GEM_BIT(RGMII),
+	.refclk = MACB_BIT(CLKEN),
+};
+
 #if defined(CONFIG_OF)
 /* 1518 rounded up */
 #define AT91ETHER_MAX_RBUFF_SZ	0x600
@@ -4439,13 +4446,6 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
-static const struct macb_usrio_config macb_default_usrio = {
-	.mii = MACB_BIT(MII),
-	.rmii = MACB_BIT(RMII),
-	.rgmii = GEM_BIT(RGMII),
-	.refclk = MACB_BIT(CLKEN),
-};
-
 static const struct macb_usrio_config sama7g5_usrio = {
 	.mii = 0,
 	.rmii = 1,
@@ -4594,6 +4594,7 @@ static const struct macb_config default_gem_config = {
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 	.jumbo_max_len = 10240,
 };
 
-- 
2.25.1

