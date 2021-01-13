Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37E92F5375
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbhAMThy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:37:54 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41805 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbhAMThx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610566672; x=1642102672;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=px8POd9iZLVXoUksqJ7g9Ftny5iGGprwpexxGNpdJmg=;
  b=Wi/DtTDMgVH8Z5DwcD+7+uXDCKAe5qdKWBVCUED7TwSaB/JDpC1nl7x4
   cXOdNRuo9CVIlzqHlaF+hXx3wGQlkzbNFK5dlMM0ugeSb8pDfbliBuZlf
   hl/h3vf+XlpBbEhbtlSZtjLL+DzQOqmAeA2vvdT30FrLT2aDGP9+7wNit
   VzIhiBDq3ifU0gy4PdEq/yO2VGpdRJVmpzsCKuxYY1dbwa7aeIRgIFM9T
   Rcw49N18vqUy2rh+IutQAp3AYhAfZOgW09nw72Gc+HHfuaWG62Dxr5Vr+
   e30AhTNhP+XDtER7QO9feWvz887GYpmVHwnBCueI8lo9XzWby+eXbUcNU
   g==;
IronPort-SDR: FxafAllPkvLXvMwAAkKef9yiJe1xgzYNUf7jPaibzBLj+JGWNzD9N6OnbvEzXX1kIlmvANvcvj
 13GRVzaJO/gG3UL5LZ1t7VSdnkZuqB+v60tGGtPVke/KQSYvUT5eh3SwR4C/vJdvetlRLKXa2g
 hYbuZ1O81O+XUqFZmoh6W9QJ1ESPfPiEZd0imxQxp3EIA4gSb+fZp+Lax9tARNtKg5EWEUdzXC
 rnNLvlSVkWvIpeivRr28x8Gd6nUefiM+ikl5bzPk18g2Hs6PEZmK6mgFpmuhbdvN9TVAwWs2nx
 b9g=
X-IronPort-AV: E=Sophos;i="5.79,345,1602518400"; 
   d="scan'208";a="157361767"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2021 03:36:47 +0800
IronPort-SDR: HAOpkpCtEW7xqSUPbLlGteFz4T0pawwZ+4h+4iA91kIjtdiThKSgWl3JPiVER5sDXuwYYJZMTM
 8k2IKmzSrsc9iaMIHdv0wkN7AuFfO8DMRyg8jGyFQ+N1ZkO/pAD0mOvPY143CDfHJtUicrPlVO
 cFzVQwagRrx0jbc0aKOEwEtjJdihblZPyzG21urm9nHXHmdoFtAOVwYLLD7p51m54SpBDlNm7f
 klIyD/6tBRVlvLnz1jpjY/LgKdnj4NFJgZv8w9MPJOL8Q5+4etfVYk6O34harxn2eTPHRVYq1B
 tej4gIVftwIbMAqEedhlPTHf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 11:21:31 -0800
IronPort-SDR: ctOKlWcC7ZKBukAZ/UTIzXDYRChzbVj+2r/P3c413dHa5RcD9dzb44lIQqfCZF170o1CDD4fM8
 5BFirLRj2vxF7U/4q4uR4gguTC3PGbmTDZCK746h3oP5x5NwKkMGdLJizCrQzfdCeTogjydn3Z
 u7y6+1yR7h/q4q2sGo3UnvTn5nnJ5g/XAdMjispm1x7wzHz6N0/u2VsIyKVeUXKJrVsxPCOXTg
 PJfRA0E1kHrpYQsHfKlIzvbxZKUUzihAmpvMKAO95E810K+2N+SMpYu0lFvl/cWXwIFPpXcUGF
 mrA=
WDCIronportException: Internal
Received: from usa003289.ad.shared (HELO jedi-01.hgst.com) ([10.86.62.202])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Jan 2021 11:36:47 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     netdev@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net v3] net: macb: Add default usrio config to default gem config
Date:   Wed, 13 Jan 2021 11:36:45 -0800
Message-Id: <20210113193645.3827034-1-atish.patra@wdc.com>
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

Fixes: edac63861db7 ("net: macb: add userio bits as platform configuration")
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
Changes from v2->v3:
1. Fixed the typo in fixes tag.
Changes from v1->v2:
1. Fixed the fixes tag.
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 814a5b10141d..47ee72ab7002 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4590,6 +4590,7 @@ static const struct macb_config default_gem_config = {
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 	.jumbo_max_len = 10240,
 };
 
-- 
2.25.1

