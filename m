Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B031B0F8E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgDTPMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:12:18 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3847 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgDTPMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395536; x=1618931536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/a06eLKwrmchk7Eu2hL2TIyOwHuzsjEV6uhDIv8BGsk=;
  b=yo+eGNJ0lPBpHgq2pff2JbEIRb33+sd5+UUf9/tENWf+RwQwK/2Zv+9L
   3a2NA/zZq1KHrnBgP43N/YX0Npmeck2sbgRlVLQ6nHKEnWJsSW2KKOF/m
   0G9KBVWfTiqBqNbcIzwtk+DuIHfxYjz36dFyzyRHHMPTHwAot3MV4qjtG
   J57+9A1JCL6xKys6SU0QZtzQFXQqY/tvmWWuQ/+ytsELqW7YwtbKk1UBb
   w+j7/aAFIGYPPUW1+egPrljugdKsCDXS6an2pdyz5d8jEvQ0FfZpRqxZ8
   tgM69MEaJK+JpAHS3wArgryrLLu8uHTzI30O3zn2RnLg8txG6bibGko87
   Q==;
IronPort-SDR: QTG2gt5Sku8tnRuUixmFxtlfSHod/6/4tG7OhdeCjOQRG4WWPb7JDvgf4QX70/jku/aAblMpi+
 ZwBuuyProCI3JHRs2POjGPaCZRhDi+c/i0Zng2wlyRoKBJrC9piLWcrKjtpamKF6LX0R9GTrI5
 4dR2KlJZFd+wvOPMtmw5jjn/whG4SA7utAB2I2QytxaDYAwLm22CeceycoZtxMsSlwsma9RIqG
 hOEfL0qGyicS9sBdorl2M9dpMNNAHUY2VmQeKq9+x0tkJbdnd/2DbJL9vxcgTcOQO8tqODf08A
 t2A=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="73911640"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:12:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:12:22 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 11/13] bridge: mrp: Update Makefile
Date:   Mon, 20 Apr 2020 17:09:45 +0200
Message-ID: <20200420150947.30974-12-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420150947.30974-1-horatiu.vultur@microchip.com>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all new mrp files to be compiled.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 49da7ae6f077..9bf3e1be3328 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -25,3 +25,5 @@ bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_opt
 bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 
 obj-$(CONFIG_NETFILTER) += netfilter/
+
+bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp.o br_mrp_netlink.o br_mrp_switchdev.o
-- 
2.17.1

