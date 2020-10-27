Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702AB29A8EE
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896283AbgJ0KE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:04:26 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:36267 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896062AbgJ0KEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603793063; x=1635329063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R65Ti4HQOkTqVP6ETdhIqwWLL3lTi5K1nZtuHvKEhMQ=;
  b=vkKv6nYZsDRz9vhzGroaO6ayzUnXJ14fvdbAa+VeIJ4RTVDcuS3/HIyD
   8B82LUzGT3PL8EOg9Lvd6N5UYuSfQ0tYjzUJwKu+kB//Dx8wwkL+vvez1
   gnMLWKmTXy86bb2DoFhlZqUdO1SKAQxfJsCA/q6Xyz76sxRWjqJf1xBd/
   RqWblM9Jfd/E0v+w1Fry95kc4uWUDTI636RwDTV93Zjz7AnhvtBjl2Enr
   2GhZzw2FCKeU9Vzth2N0SeSPWcIRFbHPh2pAPS3QyEMNP1muL0Jtrtksn
   l80MlIXi6yV8d5N46ELDmnu3GiGFKu7u42T37CX37zunhydsSictsxIAh
   w==;
IronPort-SDR: LMANZ6rPyQvZAUQdDRtR05BuOM/ziFebk9LjZP8QlkcMeKbVH4b+EAfnSR2dgI/7lkuYtIJbcM
 cP/3rZpvZu1D7KR0sLJBz5Tq166MmJDQOatJSi5b7e44SYtBkhXfKvSUDJ/6UyEB61fr5u+fdC
 Jyn7ZIwfpZ1Lck2b0wv1TZplx1y+SR+h+WWoWMoyjZgghI9r6/igHf9AeDKgYFWBGDg7ll/P1j
 UtSzeK/pRG0dOdR/IGoUuhBTgoWjq98E/RIChSJYOtIVVH/pklqfggrT8RtwNMx6VFHPEQtxVq
 PVc=
X-IronPort-AV: E=Sophos;i="5.77,423,1596524400"; 
   d="scan'208";a="96128325"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2020 03:04:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 03:04:21 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 27 Oct 2020 03:04:19 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v7 03/10] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Tue, 27 Oct 2020 10:02:44 +0000
Message-ID: <20201027100251.3241719-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
References: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
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

