Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF1225D488
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgIDJTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:19:17 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:43022 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgIDJTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:19:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599211154; x=1630747154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XG2WKbLHFnej+8AJLKZjXJ9YI92uDGizpyWGrWmiWBY=;
  b=MEBpGx/3Od6rqW5dsIT1ni76eHXw/EqlxBLY9Jfcu8hWDBu8pwrvxkiw
   wM9lLEkyCrS/q25gnrZVH6mQ06Sbo3cQ1TKPaqqDJ/VN93Pko8HH876xW
   mehND6qgstmnnvxOzI0YOwmGwwfvx4ZqQWPTyfyjogebH52QOPyQ5DvHU
   uji9wSYaJsZYQR2dChN7xPRY0VPbtx3FKLMArccC3smbbbHnykL9qC+1g
   dGJP6hC4mYFT7Q5Uac9nUDItHC2DC2M2VSsHyt/gYR7ox8wJ7Ag+gdB4P
   sCR+V3WbGNs8CaKote9VTcDSei9KziFrAdsi+5ck0u3UoL2j458j/Lzz1
   w==;
IronPort-SDR: g9tBrI7zoSO9FTiJE5lOuYWOYgLL3cW4NGfJ4Bvu3e/xWCUXvb4sOYbiGl8ZK1dV2C6EUnZgTc
 4oT9r+zUf+Opu35Sp/AIGyiHCVlHwBl3u1Txp+dFZ3JNzgVg3wrBtx45WIgQ3Av7FAz6IcrgXE
 ohzgMTaBSxqr41FIgZs7woqFl43do1rS7v0FkAXJBODTOHQ5xZ9rj5QMU5OfpfHZI7Zlj8swgi
 W6XuxoK4aCDjeJXQaZc50v/fig7HWXuOR+ZqVXHNoiTbsDJurZUyTE+CezUeJhw1fwLCsYxgcP
 1pg=
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="89829025"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Sep 2020 02:19:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 02:19:06 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Sep 2020 02:19:04 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH RFC 3/7] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Fri, 4 Sep 2020 09:15:23 +0000
Message-ID: <20200904091527.669109-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This EtherType is used by all CFM protocal frames transmitted
according to 802.1Q section 12.14.

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

