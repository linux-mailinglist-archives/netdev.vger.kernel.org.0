Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948F528BA2C
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbgJLOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:06:32 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:55727 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgJLOGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602511590; x=1634047590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R65Ti4HQOkTqVP6ETdhIqwWLL3lTi5K1nZtuHvKEhMQ=;
  b=zIODCKuPjk/+EyE/t6QJWSnLJWriqlphU1UnWfXlUeuGlLWHDt5G2L52
   8kxqYsiim9EJyllptkqz+FuVp8CqBfroVwSmHYxaeAMN1lPqIGYz7lE/H
   TuKuYme5GCReB3eJrsg7rFIAYYcRsLq2NOqSohiESOCbK6awokGR1UMQc
   94SgxKs2XbKglspcRaOiqGfUcqp5jnBpomvBBh1fvwrpru9bWGmM6+atE
   Xh1DTxTb4tfWPlFX2BHdh+9tf45lO3/liNulx9mSsgLrXB5/ZpYYaHx2B
   TANxkBueCkypz2N5YLOorrdoQJcQp2m47yzR42qWZqw0UNbVglaxPCWUk
   Q==;
IronPort-SDR: ONYuTM4IgVxRfPhZqFU2HSe7CM5xGb/hw2g+GKY5xBx00TYOXa/noxT81+F1OAEvJB96nnkuep
 WOpBjpdBXhMbXDLzqc1enaJ51oBjZYyBeDF9GFkat/qtlh2/UhK3B5+ib3h0bgEv4N+8JIOLiK
 NpPDk2i2F1v2fqj8VTi1eQKYG3soIpKX5SbiVsycdzCF0c7M9URrLypCRX/R0cLb0TykAvXjD/
 /eqAU7MBzZInZIuzN4MaawLnVznJyfPBsaAoWNv19anlPexAnmTlS33KNCicSGSEYcsxjbiZXX
 d+o=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="95019166"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 07:06:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 07:06:29 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 12 Oct 2020 07:06:27 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 03/10] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Mon, 12 Oct 2020 14:04:21 +0000
Message-ID: <20201012140428.2549163-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
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

