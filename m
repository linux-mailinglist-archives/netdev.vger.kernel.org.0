Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2327E6DAFA5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjDGPZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjDGPZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:25:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A759F61B3
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X3K7h09C9j8Z0TntfCgb0xN5xS9R+BUD+vkeGUZCJJ4=; b=HDwqa/IB9VWJQSP4nx5Wm/D4aS
        54hER2On/jYw4yoI7OVxy2vR84URB6q3nG8xFfQWcigtCsqhJ1W9gg6SlA+c8dlKZotGBeSLeqNKe
        SKiUoCh1gEp6RD6rEKrAIy6YiVSU2g5MM9vNyknk+4Xg1my7ubbxSnB3IcMCLhDH0g6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknxp-009jjj-R8; Fri, 07 Apr 2023 17:25:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3/3] ARM64: dts: freescale: ZII: Add missing phy-mode
Date:   Fri,  7 Apr 2023 17:25:03 +0200
Message-Id: <20230407152503.2320741-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407152503.2320741-1-andrew@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA framework has got more picky about always having a phy-mode
for the CPU port. The imx8mq Ethernet is being configured to RMII. Set
the switch phy-mode based on this.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
index 3a52679ecd68..3bf7850fbe9c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
@@ -177,7 +177,7 @@ port@1 {
 
 				port@2 {
 					reg = <2>;
-					label = "cpu";
+					phy-mode = "rmii";
 					ethernet = <&fec1>;
 
 					fixed-link {
-- 
2.40.0

