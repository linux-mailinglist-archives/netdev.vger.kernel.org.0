Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973291B907E
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDZNX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:23:57 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:33733 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgDZNXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587907433; x=1619443433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Cs2IxwzEDfKTybGbgmEWRRh58Im0y8KqYjlGzy87Z/Q=;
  b=Qw5JHa85EsWgcvJvWy5BQwjDkz9xYuCHaOLowQfLgMB2TghMZgH149N7
   NCdYL2LBBKS+Oyvll5usMTXezBwAzaftLrOrsU/wJrPkw+3gQHTi2u4h7
   dsiYUEDC72G8K1gOkiZzHoXAY5ewI4u+3ndwAy1mo1kOZQ3F6LaMnfcKP
   BPUjLIWQpEyYu1wfd9PKEr0sajpjwDpGhKgsHqT6mBSvtltbDaqies3mN
   ivh+aRpMu21JBWfj5EOQVcqI9Vy6xELDVODWIlyXNUat6EPe8CmxGWjRf
   g0EroI6VgaHrAH5pchdd5qNIi0ptn+4yUtkJf49VP4YKmYop9ru989Rha
   Q==;
IronPort-SDR: 2ItX9eYv8BBI3uZwjpfd8PX8qSAUazK/xWCRreiUnaawradijSJjTiEoSRi/bPeE2HHV1fgoWL
 vETVN7EUo/HSsBDFKi8HP7txb/B4XfjcMYJcmVMShilWoHB3CLEHlVblrVyr8crQP24HupCsks
 EDpoeTfpHkLP8Ywt031hCIuPtVV83Rm+vSvRyJSZqs3oOYyLRb8x/79lSdOs+PNzDARt/gxh7K
 WNYRN0Og4/JIaAt2ICevGnPndGOtcywtFDTGIr8i4f7cFHlUhyCcaOJ2lZtTTJDHXmFWIJD0TQ
 aEA=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="74586822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 06:23:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 06:23:53 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sun, 26 Apr 2020 06:23:50 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 02/11] bridge: mrp: Update Kconfig
Date:   Sun, 26 Apr 2020 15:21:59 +0200
Message-ID: <20200426132208.3232-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426132208.3232-1-horatiu.vultur@microchip.com>
References: <20200426132208.3232-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the option BRIDGE_MRP to allow to build in or not MRP support.
The default value is N.

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index e4fb050e2078..51a6414145d2 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -61,3 +61,15 @@ config BRIDGE_VLAN_FILTERING
 	  Say N to exclude this support and reduce the binary size.
 
 	  If unsure, say Y.
+
+config BRIDGE_MRP
+	bool "MRP protocol"
+	depends on BRIDGE
+	default n
+	help
+	  If you say Y here, then the Ethernet bridge will be able to run MRP
+	  protocol to detect loops
+
+	  Say N to exclude this support and reduce the binary size.
+
+	  If unsure, say N.
-- 
2.17.1

