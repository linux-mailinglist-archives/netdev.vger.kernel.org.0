Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B90845A43D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbhKWN7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:59:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53003 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237357AbhKWN7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637675766; x=1669211766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UIHMpNXddcd67qrfo49O4jdt/yShSMnZhW80ZeQOW54=;
  b=z91OpbVJUqaFyK3rt/j5itstKBZCPoau4+UB11XjTiPCopFgj7wP9LE9
   2dKuA80VsHrOrWBqxweCLT0zpgjU0sX7VZgnO68dNXzRxvkOqt5bFrgXj
   Zp2OMqJrU1l892A6/QfLuZ+MYuN9eii8xcnHgpMikP73X8ycaqDojub4v
   SrTiErUtNG6hhLn6hul7von54We7BoDwl9DQ6O5eucfhdLXFpjzXZSmLV
   1M/XLz0eGGRgJrW3Koa0v5nTArnjtLtI3LgNRhUl2ct0vaw3P3sL8Ixa6
   cU8ybyLDiBJrkTZTX0fvFvV7V4h6vXUjM0fXGa5Nc0Ui7aDw0S7vPi+QI
   g==;
IronPort-SDR: IsFOhMTosrquAp8vHQHfgfUChWxyRHUdatRWzBe3f66Q4jUR3c5LpvohBKgCwrEjc33mIAbvDz
 6hAAk1eOgrC3X+Y0XG3MNUTTSeAq3y3j9fK1oZHuRBjEoBOq/j1ihEfZOcbpAvhN3UEEqlm0RL
 H3UnBze8jrW/uOAAGori55DRcmeObqhV2e4WtFKYhJHf+LYsTQiI82bIVSlAz9LvEsejchS+ts
 2f3sR5zxZKOqxIcibzMfosauxk8juQiUSbTK2n6o1vRPlY47+GObqCK0pIhChq881jaHaBMjgK
 sBe9xShD/LjspV+vsMP/8GVy
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="77316492"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2021 06:56:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 23 Nov 2021 06:56:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 23 Nov 2021 06:56:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 6/6] net: lan966x: Update MAINTAINERS to include lan966x driver
Date:   Tue, 23 Nov 2021 14:55:17 +0100
Message-ID: <20211123135517.4037557-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
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

