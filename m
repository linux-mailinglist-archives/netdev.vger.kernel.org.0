Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B167A2F2025
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391150AbhAKT5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:57:01 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5473 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbhAKT5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610395020; x=1641931020;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p05V/E1mKMuBnzRUNmZbB0MsjjBf8xCWFxvPj/ti/0E=;
  b=r1sH5zRrbF9A2Barc8Yu+nPZ+c+kdMzFIusTnocr3+BI/suyML1tXjWr
   rDAiPcNb47GnfPJpNFUT2SfYIy+xVjGM5IKY+gibzCxOSkT51XGLp4EjY
   OSFz4nlHEFoV9ipEMfpNz0IHrqCXNNR0LOZmRGlZrM4TLpmQVXCtQKdo0
   UQm+79mBwWMeXww6UY1fezj70lA83QDYnOICVmMLKqf38AOrmwAlhyUFc
   nOi5jOdLyVCmAKj3ZeRF1DmBR0c2zSm2bKjFgPk2O/NmvmKOP7PhB9+rK
   egQEu8qfwyUg0TxfFhf3e67rFHuV2NR8tSnYr8j8eIpG/VmyFDn0ocZpe
   g==;
IronPort-SDR: 2QqRHRBdH5tEDr533xZGxLsnTYLHBjCnO8+I6X9hcEZ35PdAhNdQJrDt1QrMvw1+Y3jiLINNjM
 UcjNdDJlGtanGWH12yIJh4CiYxRTY92F5RJ9AvPHuAiZ4bwuzQnIf1/mb2tRJLYPOmObXDfDAc
 iaEbSXZU/y75FuOx4D21Uv6D84YKvO+JZpCUf0/HAiB8dI0T3cUURFN2DercYuZvFjQHJZYzqB
 D5Fo3J/lM+ZYNsT2Qbh49xqYzwCLrusf+05dr6+AtorUAmzvbSCwoXoPJ+qsJpn5cVVPvj3/dB
 Mb0=
X-IronPort-AV: E=Sophos;i="5.79,339,1602518400"; 
   d="scan'208";a="157172898"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 03:55:55 +0800
IronPort-SDR: X144SXCw4hORJaaV0NJJ5nk94kCs8jqFNmzMEzmgItO88XERF0ksO21Ssy6E1E6aohvvIPopvl
 kH3pm3ytewumNk+e5085PRvnHqWZp2XNhVwdmEPOT84KUw52MKbwNpOV5MVBmDRHSrnnNk+8fd
 ISwz1VUu7GKmg1/r4n6uAlgYzS9Z7dvlkiI6zw0sFCe0dhsGjpjtDYUKHGs85Rphurw/B/a7Zk
 P+iMfZkw4q/QWS36WGhuIQNg7sL+YQ6GerToeZ0v+kgI9ajBp84CXYjKHQWD2ds9s2p1aD5cWf
 lbifOfWkohztge4h403S0gdH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 11:40:41 -0800
IronPort-SDR: u8Y3MPRf3PuXZtxTc9KzFVeYfN3hqOrpKfdOHg48v3/4UKxbaT0CZLHfrbiXR1J/Gh3r3Z6oEW
 2MOpeQxKBuygErewu7IoazSCaq5XGW40SZzf0sbszvLo8PiiUPl2Z67CDpohwAH5Vy58CFjcHC
 ijJPeb356bFJr3OO8OkK2rdb4EqrnSs+HWb8QNrxbpFbPA6xEVPcfGxUjm9lPY6PyWIolEtWmx
 jHHH8Cbx5Qff8MkqFyightXx5nSNw0/SHUlUQ8pkEK5WYhyQSsMdQ8JleR46sBTWIWJF9QmW8k
 IEk=
WDCIronportException: Internal
Received: from usa002483.ad.shared (HELO jedi-01.hgst.com) ([10.86.62.194])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Jan 2021 11:55:55 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH] net: macb: Add default usrio config to default gem config
Date:   Mon, 11 Jan 2021 11:55:53 -0800
Message-Id: <20210111195553.3745008-1-atish.patra@wdc.com>
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

