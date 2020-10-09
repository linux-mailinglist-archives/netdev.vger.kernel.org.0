Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C0288B8F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbgJIOiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:38:08 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51452 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388822AbgJIOh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602254277; x=1633790277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R65Ti4HQOkTqVP6ETdhIqwWLL3lTi5K1nZtuHvKEhMQ=;
  b=mtIGjlyMmjcwiwQIyapSjFW54yoYjlp5X85u7+PNHy9QFSaEv6HAdqO6
   SZA+Rjhdls4sKX5gYFfUM59h44HMnhOGzZxstvc/DTzBAMYB3tNHOm3gt
   bXguCVBwykJRWbUTtrJAphKDYLNZdsqKiEqwXWsMIseq+t13aPN4Bcnwo
   c+yX4umJPUbYtn9fZzliH7DkQjgVhb9QLoGEPsqbWAOZ7WRbclUQpiFqG
   cLt68owasqNuT0Cu5JQL+7Uld4avSNkZo8TenbVqecvFcVsSwJknLsWRX
   Ybg4469oGl5GfMAzoPIfQYUiVH9+lgpS6xLC1ZomN+ooNzePLnygQ8ZbR
   g==;
IronPort-SDR: qkBMJXICe6tTHPCs0pmOexIShTJvJsaWCjTMorHBd0s69E0GFSFgxraI7Fo4IF94YHXW6QUeic
 jdUWoZITpOorPo9iReFRb8ES7j2eM78AaeritgTNTueIbE/EUrIAAxmsA+/fsKOSPvZfHvEZvV
 ylhjTAX9PRjOad8r5OSJQq5e8WEEyyP0F6dC6UkA1I4rCWJugoHT2XKfSRpXrJESnPu0I0EZI2
 GFYhsMpOSs4zmfYrSgO69eMoKk9qLTflFGlXRuRSebuRf5LA/m/mFqOa+cYQ6yZL+jYfwXOiJd
 UFo=
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="92058323"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Oct 2020 07:37:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 07:37:22 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 9 Oct 2020 07:37:54 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 03/10] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Fri, 9 Oct 2020 14:35:23 +0000
Message-ID: <20201009143530.2438738-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
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

