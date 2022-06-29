Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30A55FB28
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiF2I6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiF2I6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:58:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86C5EA2;
        Wed, 29 Jun 2022 01:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656493101; x=1688029101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=aoJmPGKIcS8XTj5C1QD22ntbzSWhQn2blmJ2LJGeDJ0=;
  b=lv2xPv2VOs2da3EBXSmnEFethsw/Gr8LY0ZIpMr6Mg+T8Z1K8aHriFaS
   4ri5RC10lnpuutUABxNfvd5qd8eqD7v6Y/x3E8leewPQzSKIM1xKCN7G1
   Yzwh2PlTeC6aHvYkCu/4hhU+o0W9pWrD5EdvgF1crws6zkVEd/l/NkoJm
   3CBiwafM7tPpuAkbRbzl69Iaomk5lAt6dMJLWnN3Uo9ptp4JY9ADxFgI4
   SY388gKbgSgT13nIDICrlnhl3PfQm6XdplaRJd8swlob17uNA1xrz6mQu
   65NSsWjPKyahUANCL6f4KDqP2n7Z2UBpFxnM5JZMMW6BAZ7a0cThC5J5i
   A==;
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="162545746"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2022 01:58:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 29 Jun 2022 01:58:16 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 29 Jun 2022 01:58:11 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v2 net-next 1/2] dt-bindings: net: Updated micrel,led-mode for LAN8814 PHY
Date:   Wed, 29 Jun 2022 14:27:59 +0530
Message-ID: <20220629085800.11600-2-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220629085800.11600-1-Divya.Koppera@microchip.com>
References: <20220629085800.11600-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable led-mode configuration for LAN8814 phy

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v1 -> v2:
- Updated micrel,led-mode property for LAN8814 PHY

 Documentation/devicetree/bindings/net/micrel.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
index a9ed691ffb03..a407dd1b4614 100644
--- a/Documentation/devicetree/bindings/net/micrel.txt
+++ b/Documentation/devicetree/bindings/net/micrel.txt
@@ -16,6 +16,7 @@ Optional properties:
 	KSZ8051: register 0x1f, bits 5..4
 	KSZ8081: register 0x1f, bits 5..4
 	KSZ8091: register 0x1f, bits 5..4
+	LAN8814: register EP5.0, bit 6
 
 	See the respective PHY datasheet for the mode values.
 
-- 
2.17.1

