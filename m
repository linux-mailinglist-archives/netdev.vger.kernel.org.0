Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33C64DD699
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 09:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiCRI5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 04:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiCRI5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 04:57:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931F31F6F32;
        Fri, 18 Mar 2022 01:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647593761; x=1679129761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M0gfP5Lho+73K76CJHMgytyB85l30uTjrKHhOak+u5A=;
  b=OwJccE7n0o9Knp0bYY+3v9ggK1Gb9fVGJKtpY2a8y2xGqHjwXgK27WNB
   K4MIj2q3MBnA2NvaXaQeF1oiWw6dDzAxyB3xf5uOAE9CgoSlSO+w+a40O
   TQAUDlVrt1Gl+FK0suEEQLXBMyNvEOlr/2/vKU2XgdM15r6qvCUt4BypR
   5fdbU+dRSEVqpIq9cGI/xPulnKpp+RAC+hKCVaSwW/QxTcZ6mKyjiNWH7
   A0cng9PqL2bzxWaLoic7oMDqli3y67ecNWcyYj0vZt1MVVUruA0pYeDw6
   9hesYgLG7Z98bhu4c0EmsMq0WCwPkQFGWNL1zixnjAdHHrHr2975es9gd
   A==;
X-IronPort-AV: E=Sophos;i="5.90,191,1643698800"; 
   d="scan'208";a="157367479"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 01:56:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 01:56:00 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Mar 2022 01:55:54 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v9 net-next 02/11] dt-bindings: net: add mdio property
Date:   Fri, 18 Mar 2022 14:25:31 +0530
Message-ID: <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio bus is applicable to any switch hence it is added as per the below request,
https://lore.kernel.org/netdev/1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com/

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..0f8426e219eb 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -31,6 +31,10 @@ properties:
       switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
       (single device hanging off a CPU port) must not specify this property
     $ref: /schemas/types.yaml#/definitions/uint32-array
+  
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
 
 patternProperties:
   "^(ethernet-)?ports$":
-- 
2.30.2

