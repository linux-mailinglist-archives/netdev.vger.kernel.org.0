Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCCB2F25B5
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbhALBsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:48:39 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:29904 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732842AbhALBsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 20:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610416118; x=1641952118;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dlCHOB3Ti2DgGBpPG4Ve2ANlg4WwvNDedArtgYUa+lE=;
  b=aYY9mFCj8l82SgwHlbyK5oGLX83BILEac0eIy0MYFodwjVN49p/dJiHN
   gKY2bf32OONocZvV/H3oW5Q4uQUoQq8DuAezz1OG3Ey7o0SNxcX/xLFDg
   P+zLAnoItAltP99mm6Qfkcg+xHZIH6SE0je/5ea0xQrsaMv+qKZhm5MQs
   snlkBQbMk3ul+4WoFlVkbAnwFyUP/KjPlHgl0ISbHXvQNP5OVenAHzXM0
   LvhCtjtTEm4VcXbC1cXOERApCCfedYUMVO5xBOsfbddSsQbJDOtu+uzsL
   ht/navqpZ7TGDqnge0BzmeKXsos0QNaltPl/uJhtZkR3LMpZPRxydzAF9
   g==;
IronPort-SDR: DSxk3LhnEGeXaIwZIhsMY267XzkSfEMsfd3jwV1XPRftM5cQxmKWCRQgR4w6HuSnPIdOLJ3cnC
 ZPY/dc3dSKFnmON9tUVOKSxwZVJ5ILpG7gffBHElGgEQeG30uKOxgI0CvRxj6+A2XiPfRrClRA
 GKpVVxGJ7YVZQVdJyWMSFUSZSas0ebWlrmMlVEx3BAI1zzIIscVC4U1C1/XpTkTCBZLTr37GW/
 YcosYfpAPwFINZxNhDSu8gajix1plXcrKZQqeR2kakrTTaFDNd5LnFXJxW8u0P1gGBEIu/ROQm
 x3w=
X-IronPort-AV: E=Sophos;i="5.79,340,1602518400"; 
   d="scan'208";a="161638105"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 09:47:32 +0800
IronPort-SDR: yo9C7VupjK86xBRYb8HjJVZ+AhHaKFoB6c2UsB//PN07GO3La6lcntHRy5kJTmlRWBajaUxi5t
 FGjF1wxX47LKcEI0cc+H5jlKNkZx515wBxmNKbykmgPOFFUQZAuF6OEUDBtGR9BgyKena0RAwh
 /CPD/LplHvNRp4BuxfjEKwjkiykab0bZ59ne3FP06Hx9p0btERW0gcavtfAyrcAbPOsk0pO4tw
 LV12kw0HWL0sQ/Cu/kzrCgxk7PlOJjLjHbAkm5GMu1un2Ru1l7FjOL3dSDVcd8EW7/MkpjsV6x
 5WxxjiRyERPu+4pDjmrZO7mB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 17:32:18 -0800
IronPort-SDR: BlkGa27+RowfRkAAGqCVVwa+dp+22sMCSnjR8wtkPD0hp+dQLVpOmuQ2HVsllnIBFnEGVYxxGu
 OSKYDeAAwWJb1WvYFh047GHpjwrmhhRp3bc2mrQmR2nd6PBKS35kkme6Ova1MFH5LRBYNGmmoU
 uIonYL+MIDAclqHXLvDJB19ZHH5Bs08vV6DZZc7kJPuJKoOLAdxMEzw8Cwep1jDssECLQ4yn3L
 3pcnII8X1gt0r3YrETTE/XkolsVy7tYfX/aoS9MweEHSkKhLKIOluo/VWj4HQDlOSzVZ0Opc9E
 7hQ=
WDCIronportException: Internal
Received: from usa002483.ad.shared (HELO jedi-01.hgst.com) ([10.86.62.194])
  by uls-op-cesaip01.wdc.com with ESMTP; 11 Jan 2021 17:47:32 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     netdev@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH net v2] net: macb: Add default usrio config to default gem config
Date:   Mon, 11 Jan 2021 17:47:28 -0800
Message-Id: <20210112014728.3788473-1-atish.patra@wdc.com>
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

Fixes: edac63861db7 ("net: macb: Add default usrio config to default gem config")
Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
Changes from v1->v2:
1. Fixed that fixes tag.
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

