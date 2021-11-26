Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D671E45E9F2
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376261AbhKZJJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:09:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53208 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353708AbhKZJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 04:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637917453; x=1669453453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UIHMpNXddcd67qrfo49O4jdt/yShSMnZhW80ZeQOW54=;
  b=2SRNoek9REOkYjzjr3BGQ/dW5txAzmxWoQzqQsuCNzexcATEyNHQR0pp
   +1jaw9ocqZk8Lkdb7B0A9M9mBPHwahAN+wzs2NrKlGNpe2EclOA2/P5us
   MFeLMu5VaWUBxna1ry32YYd780wTQBbqMpX4QgTxUl7G8QFyBQAd3bwSb
   aYQgmzE8O9MpwC9P9c20CecKhEz0bzbneh9k7zqlQGlNnoMc3cJGZofKx
   yukXHUfzF703qbtR0Cwybd+uoM4LGnMMGedGbfVVsiGnrUUSpCG8Ipfwi
   6ThbDL+TA/A3FbT+buYB8JTRHAHY6OlZtMq+UUUxPrwJRJQL6Geu/5V0n
   A==;
IronPort-SDR: b5bNLm994v4U3Ri71JCUmrhtMsDXJ/K/gTmwzLI01R1ZAjVraTywacqqJfrKFjTc4uVm9jX6M3
 w0E+s+S5jwIXRooTrxwYoGD6oqqwTDEZqa+OAUzvdnHKOP/NlUH3xACZB3JmQFMpklItSudCaQ
 +gByivvQd1T/yZAJdFfEdwq4PCyA+nut9XYbW1FnX6zXG2su7b8NdXPbqgsu6KoQRvjYFAkJ2E
 HGE/TSJNdszGm+Y3LktSXTmGjIknLdx6cilxAbhM6r2BF3sLxEgN6/VnXqp+k5pQRePCX72XrM
 V1HhDxJteBSYEIr35itRusI9
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="77659900"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Nov 2021 02:04:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 26 Nov 2021 02:04:11 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 26 Nov 2021 02:04:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 6/6] net: lan966x: Update MAINTAINERS to include lan966x driver
Date:   Fri, 26 Nov 2021 10:05:40 +0100
Message-ID: <20211126090540.3550913-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MAINTAINERS to include lan966x driver

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10c8ae3a8c73..722a00d8df9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12513,6 +12513,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/microchip/lan743x_*
 
+MICROCHIP LAN966X ETHERNET DRIVER
+M:	Horatiu Vultur <horatiu.vultur@microchip.com>
+M:	UNGLinuxDriver@microchip.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/microchip/lan966x/*
+
 MICROCHIP LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@microchip.com>
 L:	linux-fbdev@vger.kernel.org
-- 
2.33.0

