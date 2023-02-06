Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C4368B738
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjBFIXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjBFIXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:23:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128BD1633E;
        Mon,  6 Feb 2023 00:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675671814; x=1707207814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3KGAFBzCPbYMFhk7ZzTCvqoLQqIEKhK076j1qm6cWJc=;
  b=XgeJi7GL29BmzI6ndB1ZIv3+AfQYj/scJ03PRNPgU5hWtW6/1Q9ZiOuN
   GDajdiqs1DnU+RtYRgpr+LBWZJwKs0/7Km4Mb/ye8p96lOJX8DWLYt9je
   Z6LPU3bjLuYvIQfx++YDAC7lqQe86XF1KL40rQKxBQZdST4THVf3cBQo+
   CuWi8R2xmMnCSVHfLZd938uq6LxaI5L2IfMUWqUqYzd80pM8Tv88OHp3G
   Cn4IW9yVCMX6MNFnU4aCP3iZyX2hJRVAfVpk+lYFyJPoOwmEAi403STYq
   QI79BZDR7+ghjZ198oJCA2fouRKeIokx31rUEQlJf0GtnEsx/+lFK8iEc
   A==;
X-IronPort-AV: E=Sophos;i="5.97,276,1669100400"; 
   d="scan'208";a="135705495"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2023 01:23:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 01:23:32 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 01:23:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/2] dt-bindings: net: micrel-ksz90x1.txt: Update for lan8841
Date:   Mon, 6 Feb 2023 09:23:02 +0100
Message-ID: <20230206082302.958826-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230206082302.958826-1-horatiu.vultur@microchip.com>
References: <20230206082302.958826-1-horatiu.vultur@microchip.com>
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

