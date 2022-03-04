Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE3D4CD136
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbiCDJh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238137AbiCDJgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:36:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216C01A6F83;
        Fri,  4 Mar 2022 01:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646386552; x=1677922552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+GVnEIxX3qprHkzVKyxQf9h3DxqyhJEIuqDszfPtSMY=;
  b=VPWAkdhH1Hok43dhYJDQN77a2sVZgFmhL/cECl4+O4PoI0vg/5fp1SIJ
   8DtKFyvNiZZ7qg4LLnFfxJZZ9GW6nwk0rUvB6882z0ZEBN9MdpnGrQIwr
   pU2UZqm1edKn+tHRUU+j8sbpylZT21cVpbYIeXKGHz3OXgTIZNuKLUiFJ
   +bDvPkjTBCodZktEFcoSVRLtAA6U6VfydFEx74yffB5Id5zwvzs0jno4c
   nmW3/WDhfmG2C4SHRknhKNBoZV0hODVrsNMPEf4r3h+YLB7AV3V0rWZN1
   KGvNJvEKN4SUn5hASPeGrbzGKYsS0b3eGtCcbuDTA65d4jYkn1g6ZgAT/
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150846861"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:35:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:35:51 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:35:47 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <madhuri.sripada@microchip.com>, <manohar.puri@microchip.com>
Subject: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
Date:   Fri, 4 Mar 2022 15:04:17 +0530
Message-ID: <20220304093418.31645-3-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304093418.31645-1-Divya.Koppera@microchip.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supports configuring latency values and also adds
check for phy timestamping feature.

Signed-off-by: Divya Koppera<Divya.Koppera@microchip.com>
---
 .../devicetree/bindings/net/micrel.txt          | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
index 8d157f0295a5..c5ab62c39133 100644
--- a/Documentation/devicetree/bindings/net/micrel.txt
+++ b/Documentation/devicetree/bindings/net/micrel.txt
@@ -45,3 +45,20 @@ Optional properties:
 
 	In fiber mode, auto-negotiation is disabled and the PHY can only work in
 	100base-fx (full and half duplex) modes.
+
+ - lan8814,ignore-ts: If present the PHY will not support timestamping.
+
+	This option acts as check whether Timestamping is supported by
+	hardware or not. LAN8814 phy support hardware tmestamping.
+
+ - lan8814,latency_rx_10: Configures Latency value of phy in ingress at 10 Mbps.
+
+ - lan8814,latency_tx_10: Configures Latency value of phy in egress at 10 Mbps.
+
+ - lan8814,latency_rx_100: Configures Latency value of phy in ingress at 100 Mbps.
+
+ - lan8814,latency_tx_100: Configures Latency value of phy in egress at 100 Mbps.
+
+ - lan8814,latency_rx_1000: Configures Latency value of phy in ingress at 1000 Mbps.
+
+ - lan8814,latency_tx_1000: Configures Latency value of phy in egress at 1000 Mbps.
-- 
2.17.1

