Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2161A284E65
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgJFOzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:55:53 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32918 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgJFOzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601996148; x=1633532148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R65Ti4HQOkTqVP6ETdhIqwWLL3lTi5K1nZtuHvKEhMQ=;
  b=nhuWduEMBq8BJO/MvLyC8qEA6qepflgdpfX5XuR7JBPqH4ptF/D0oyDy
   1WqYOU615RrrGq1+XJGldL+TsjN9e4Q31Iem7BB15XKvhwh+a1DoohJJB
   OrIFJAsh1vCmvAhDt486ZTbbXPPYU6DCg+y0rOMxyLCym7uKUR2JXlqEc
   euIH7gj4d69i8CmoOWlme17Vk8LXMp/LuIBnTHft16ZtXAtC5cytGhnqP
   yqSmhb7qp1kFAPbl/JgnA7VjCE9TjlpgpkWGjBAA8aon+16+NrpNe2ZwY
   9K20w6WDVbGPIhOPEqnnMjxB6fjbaFnNPeOz7hivrcm9efxrzksx64SMY
   w==;
IronPort-SDR: M2DuSGOrTnBv6N1GkA452Y2MnOgwn3CJCtovmA9Xrb0LJrn2G7p4O8tpq3dFfVbM6doAXAqq0F
 9kKL52Zf87zJmnetosiAHr/jUdgwac4Y7pGLLm+qaH2sco7ic67C82p1FHrW0gHQYOH7fAFjAT
 g2rCgHvdOtdVkSySD+SqSmwso/xAoOgq2Vz+2Ap0/42ODlcCc8POBu5BRkMxjo8kx1qI0cyNqN
 FQwik37JnvSV7PKF+9ZiHC6f7ONzRhPVptbaeSYGPYx5ENmKuYkbBC0GXCxFljOSfzaFhvk1cG
 Deo=
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="94386901"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Oct 2020 07:55:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 6 Oct 2020 07:55:48 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 6 Oct 2020 07:55:45 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@resnulli.us>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v3 3/9] bridge: uapi: cfm: Added EtherType used by the CFM protocol.
Date:   Tue, 6 Oct 2020 14:53:32 +0000
Message-ID: <20201006145338.1956886-4-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201006145338.1956886-1-henrik.bjoernlund@microchip.com>
References: <20201006145338.1956886-1-henrik.bjoernlund@microchip.com>
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

