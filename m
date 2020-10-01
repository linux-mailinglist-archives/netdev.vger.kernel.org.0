Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E327FD8E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgJAKj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:39:56 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57700 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:39:50 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 06:39:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548789; x=1633084789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X+rhw3KgzIRLpsdigUrD+tQE1r7KIIaMNAMTXbB17Qc=;
  b=kpOP7UyPMe7OJbf4BsR0ovpzCMwy78F5j0qD3ckpBvWC4J/HSZqRy5E8
   vLsW3rd9W6vqTurEI0D+PVvALARysI26KlrGP8p2fEgiHGAf5rKwPuyIy
   bGNRforh+cp7tik6T7XDnpY89gWecgbnRnMPzQmfOGoYHbJLZgVkR5nvG
   hiHaJOLXyS8RTYrDTNHe/wSgtLS76ul4ooKDInvyFJIGq8vvpQmNVNXMh
   bDkghgux70Ssz7xjsa24rhbk3/xuHl03e1rN9rpxSObd0wVVQalWC1xxI
   p6QaOiyJa0CXYZZ6ZIyF7K1WmCTsHWqlB0xxF9Tcvzi0n3W59QJy17CJ1
   g==;
IronPort-SDR: nfms1yhBZgOibkeecEb+ypahwB1V73fBYScyGzQ5Bz1xMgcePUWUqPM3cRaVMwdC2ut3z5gnaw
 KAknoqKdoULEHae3VYldvhUEYORvaM3rCIv+7e2Hkw8JW8B3zloP2swZx0qbPGoc6IlG+gc8nw
 ryfojKlqRVhYR7ZjrZiFFA3KRvCdNC8BheEF+00VE2DBmUw+3+sHiWIwh4bI//ZO2ofIGrpyzW
 bJIsPF9FvsvSqMZZezBkdd7rzW4rXGCL7/s3nIVo/2LKsiWhUn2jRa5ITDAPEjM0/9pobhvd+T
 6iY=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="91069527"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:32:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:32:18 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:15 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 03/11] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Thu, 1 Oct 2020 10:30:11 +0000
Message-ID: <20201001103019.1342470-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This EtherType is used by all CFM protocal frames transmitted
according to 802.1Q section 12.14.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
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

