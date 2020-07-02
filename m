Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B746212414
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgGBNE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:04:29 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35305 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgGBNE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593695068; x=1625231068;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AXbjniwuszyxWpVmXzYI6N4oJcnifghlxot0w5Is/xU=;
  b=KudU7RaNzTJWFH/rdEyLFMRjkdmcqwDuCQd5ozDf3L6Yi+L5dk85wSZ0
   MCN0aaduSFdz6DgcyVm5EGp/yEvAkp6uxVf1+3NWz7Um3Vr8xXOZ4Oe/6
   v9dcZKqMjhNBW0GuO1Bk/gVojvu8huy+5lQ3533cbpnHPcuEqma2/ek8o
   CLec38HYRc1wPEGZfSJCz9QdpljU+l3c9YJfOJhAuWrGQ4225HqbKcY2e
   HA7YTL0XrRNLDlgrFfs5+f6uyU97TsZWGfiShpwu9OhGjI2K0Sg/U8Xwr
   BEqprwWhW1M6n77wRw4x7msk4/JEvsl9SrJJNW77oxRfnE1lH4V0b4CA0
   g==;
IronPort-SDR: AFFxMP1lNuUdTuox+VSl6R5uLEwnBtFm3a94pektJdYNOMsLdOug1iHZJAVytmBN5GIItsbk7i
 LZPu8nmw8gVdu5IIZrJxyuNJoMCjAAhWFm1PqtGidvTQIb0mFmiPzCZZONTCPKUBFNzyPRwliY
 t/Ai3yWoz9jdLOBBH48txhvtk9rfX4xzrRCyYFpsQo9K4gSAjo++NrWpAXULCsiNEIyp/YjzMH
 LbLM2OfakTKsE/Y4ZweRqyX1BVj6t9C/mMb3bNfsFoP2/NgFTYKovF82eSSGKv+Qteb5VXb09g
 DPE=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="82389501"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 06:04:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 06:04:27 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 06:04:05 -0700
From:   <nicolas.ferre@microchip.com>
To:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH] MAINTAINERS: net: macb: add Claudiu as co-maintainer
Date:   Thu, 2 Jul 2020 15:00:21 +0200
Message-ID: <20200702130021.32694-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

I would like that Claudiu becomes co-maintainer of the Cadence macb
driver. He's already participating to lots of reviews and enhancements
to this driver and knows the different versions of this controller.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 63c4cc4a04d6..5f14938a5985 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2929,6 +2929,7 @@ F:	include/uapi/linux/atm*
 
 ATMEL MACB ETHERNET DRIVER
 M:	Nicolas Ferre <nicolas.ferre@microchip.com>
+M:	Claudiu Beznea <claudiu.beznea@microchip.com>
 S:	Supported
 F:	drivers/net/ethernet/cadence/
 
-- 
2.27.0

