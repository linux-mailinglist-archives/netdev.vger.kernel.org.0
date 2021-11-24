Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C7D45B6B7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbhKXIpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:45:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35954 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241410AbhKXIoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637743264; x=1669279264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UIHMpNXddcd67qrfo49O4jdt/yShSMnZhW80ZeQOW54=;
  b=iLidyrd0jAoXcztiP4hOXJmBV8qZPinKB57zRBS1ipe3mUHOPvz2oWuI
   XQAUNCSxapELMDkoyqlQjWxWstJCB+TRbAZkibad+dZIlWWBTYBGU0XK5
   N4gPr5WXqEpSwty8hjrFDBcrYlTCune1noFq7/b77n9D+xJ3GKT2OID9C
   ehAnKoyOFBBwyifxRNC7gr0ylGdg4p39db63NK9KxUS+pgRXmjWE3OkCa
   ka59bLOiwpxwYSoCaOinCFzSqsxz2cSnK51m+Wl9dltRGcuPtW0CfV9V+
   L6akjqVLSfXJ9m7Cuvu10fxjwQcqiIg1ACVGO8u4EGV1TLZJ9mTc6Lh1L
   Q==;
IronPort-SDR: Hm3EhCbm/wvVsHvfi3G1ojrDmXhFFgPBZ1vArAo1qwgx1URL57KPK8PClXB/5uyl4mbQ/llOj3
 JMETNTkkYKLtoVXAtbs2NAT/LoTwmu0xvEYik9riTuPrjeF0QkXXRfeLRtBWo2Wl/GTa8QKi7k
 JXeoqGkvk2zM8WeJDc+Wy75VkWcrCLlfhk9MDqPPyWH8lM7ZbhGSEiZ3H68T1fiQF1CJHjOcPZ
 uKaamx+ROBN0RjvcNS5EY7dwa3EbuOADkMBDA/1r/Ns93uQiX2f7ZStRLpLovuoUYBZe8vFW2K
 4CNfPjTnE5DnyPeZIbhZLMMJ
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="153060774"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 01:41:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 01:40:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 24 Nov 2021 01:40:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 6/6] net: lan966x: Update MAINTAINERS to include lan966x driver
Date:   Wed, 24 Nov 2021 09:39:15 +0100
Message-ID: <20211124083915.2223065-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
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

