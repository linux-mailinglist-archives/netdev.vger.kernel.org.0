Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B319968D4E2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjBGKwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjBGKwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:52:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750823865A;
        Tue,  7 Feb 2023 02:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675767166; x=1707303166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uTyEa8tBOAoolMma82PHYYpQ0LrQR2wtodhEJDNFPG0=;
  b=mJ+MnEvs0OtN5wAbl1MMjPRedC9AcYGkd4wEa26wO2PkllMbb5Dr0KV4
   6KlA7OCfmh+44tURHu3uNN9varRpGBAlK83cLph1LpSe4eZR5kwKb4Izg
   yO7wL2e4RiKGFzW6HEqyQxktGTJ6jiwSvxaLDxp4TcaeHjRkctKx8JZ5y
   h5UeExRaANTzCHMSRE72h5TVizbwrHc18fpp5K1GWDxnYllf0Q5MCZTHi
   l3XYpzs3vdZSiolx5pJN71/gEuvxSBl3XlXzaNlaDygU2sVvanau1y924
   VAaugj8wqxnTBA3qpYv2tM138yu3ZdBWFDTdIL7KFNL1/xa9WAsWNli0g
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669100400"; 
   d="scan'208";a="199639763"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2023 03:52:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 03:52:45 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 03:52:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next v4 2/2] dt-bindings: net: micrel-ksz90x1.txt: Update for lan8841
Date:   Tue, 7 Feb 2023 11:52:12 +0100
Message-ID: <20230207105212.1275396-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230207105212.1275396-1-horatiu.vultur@microchip.com>
References: <20230207105212.1275396-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lan8841 has the same bindings as ksz9131, so just reuse the entire
section of ksz9131.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 Documentation/devicetree/bindings/net/micrel-ksz90x1.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
index df9e844dd6bc6..2681168777a1e 100644
--- a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
@@ -158,6 +158,7 @@ KSZ9031:
         no link will be established.
 
 KSZ9131:
+LAN8841:
 
   All skew control options are specified in picoseconds. The increment
   step is 100ps. Unlike KSZ9031, the values represent picoseccond delays.
-- 
2.38.0

