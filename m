Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8928F1B2
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgJOL77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:59:59 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:50676 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730026AbgJOL4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602762974; x=1634298974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R65Ti4HQOkTqVP6ETdhIqwWLL3lTi5K1nZtuHvKEhMQ=;
  b=jCljV91/g9dyZXM2m7xrTzTG7qX/TIBbUwlnNkh2MsuHph6OKEClN7D7
   VhbhhABYZjk9Dbn2WGrwToV6OW2EJN7zQbiRPi8MzEICFeUBRGftljmkq
   KLsZCWpL0tKY7a54/F19QjL3StVG5n7Rf8J9UJDE0a8bIDecR5rYt3Eec
   PD9FwShkfmGjRD/cTqiBeEoTzCt07ooStfFNi65cnOo74riQqu075AFHk
   OIkoKzO74EPj59gNyk1fsm17rFQa4sx0FiO9wYwoROD7DWvTpLIJQKDbr
   tMfE00JKB60VzOaYrdqJo4FJM9tK2os82+WQRSDb0R9+Td4Q65SZ2fXnE
   Q==;
IronPort-SDR: UC/F3XKTMKmHrDRluuf2XxEbq0g6pSvk+cHoWPKqDJ5XPGiAkCk7IqcLSUliC57PXZUl1+oSss
 YfB3+9UlV76kW404sXKD+NvfO1rzXT2lHRkEk+ysnNDRMCF7gYuZGXLMtg5q7QSlxjqI6IsEmf
 itph0p0wZwfVz9jCTqx6ZIEh1RGoctVLNuQVhe/zQ4Id7TDlLZfD4/GTlPOIX38krq/8aOwQpp
 lW4kTTqqJfTVRMApF7dytAjpqNe/r00tPjjPXMCDHItYcOSQJd0lpHTRawE90hU9eM7fRxprV0
 BKQ=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="94717850"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:56:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:56:12 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 15 Oct 2020 04:56:09 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v6 03/10] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Thu, 15 Oct 2020 11:54:11 +0000
Message-ID: <20201015115418.2711454-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
References: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This EtherType is used by all CFM protocal frames transmitted
according to 802.1Q section 12.14.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index d6de2b167448..a0b637911d3c 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -99,6 +99,7 @@
 #define ETH_P_1588	0x88F7		/* IEEE 1588 Timesync */
 #define ETH_P_NCSI	0x88F8		/* NCSI protocol		*/
 #define ETH_P_PRP	0x88FB		/* IEC 62439-3 PRP/HSRv0	*/
+#define ETH_P_CFM	0x8902		/* Connectivity Fault Management */
 #define ETH_P_FCOE	0x8906		/* Fibre Channel over Ethernet  */
 #define ETH_P_IBOE	0x8915		/* Infiniband over Ethernet	*/
 #define ETH_P_TDLS	0x890D          /* TDLS */
-- 
2.28.0

