Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BE4671D01
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjARNHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjARNHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:07:06 -0500
Received: from smtp-out-01.comm2000.it (smtp-out-01.comm2000.it [212.97.32.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D4EA3173;
        Wed, 18 Jan 2023 04:29:16 -0800 (PST)
Received: from francesco-nb.toradex.int (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-01.comm2000.it (Postfix) with ESMTPSA id 6194C843669;
        Wed, 18 Jan 2023 13:29:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674044948;
        bh=0bOuDHRgv4yI1qxuwgollvpptxyoZ4aEkCRt52XmrRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=nKFJ7CKstccVEJ/iPEqM3Y0bYu7k1rqaAq/vT4By6H0ZP7vT+uAh5quLoWbDIzuCe
         EOzB64Soex1PV6TvwqtHxI7Z97tMXsTIE+hSwMbdL3hCGin6sK11B8pBF92HhfPVzV
         0AGX26R2UxlWH+GqlLNSdhMuU22+73bHR05w/sGHWPpmZ7QWCx+dmy9hvdju5bGl7S
         gr76SElPl0O6nFzCU39+BZy0LOaXpZMYjl/doRxCXkmPga/hALn7+Z43awTKDMcSZx
         yrKIEUpdvexqmqu0jyfE8QZmoNFpJ1XnUk+EMS7vOJ8WpYme5gjP7d/D20lx0Heq05
         /ULIBRxG4dUvA==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v1 4/4] arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4
Date:   Wed, 18 Jan 2023 13:28:17 +0100
Message-Id: <20230118122817.42466-5-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118122817.42466-1-francesco@dolcini.it>
References: <20230118122817.42466-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

Use the serdev feature to load the driver for the 88W8997 bluetooth
driver.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi.dtsi
index 36289c175e6e..ef94f9a57e20 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi.dtsi
@@ -65,6 +65,11 @@ &uart4 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_bt_uart>;
 	status = "okay";
+
+	bluetooth {
+		compatible = "mrvl,88w8997";
+		max-speed = <921600>;
+	};
 };
 
 /* On-module Wi-Fi */
-- 
2.25.1

