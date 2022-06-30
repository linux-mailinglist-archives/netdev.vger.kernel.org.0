Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45618561DC4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbiF3OTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiF3OSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:18:02 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA0C50736;
        Thu, 30 Jun 2022 07:02:50 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CDA4C2224E;
        Thu, 30 Jun 2022 16:02:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656597769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3CR+PnyevN7pgniuldx+d+XwCOYJhZzOjzZDWONl6gI=;
        b=R02lbuCh2RmzAMQ4bLQsGfBhtYPwp6ltpBggNoL4dL04NWUS8Orjjp5OQuXDY/PaDwES34
        Q3m3VvDI/gJ/AnOzjG4eFXo+Rny4MdpjHE03aTTKU9hkRieUYMb1HGeiFNv2A0TKlSo39u
        rIqkIEw2XnNfT/zYHQpayydWU7YxOyM=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 4/4] ARM: dts: lan966x: use new microchip,lan9668-switch compatible
Date:   Thu, 30 Jun 2022 16:02:37 +0200
Message-Id: <20220630140237.692986-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630140237.692986-1-michael@walle.cc>
References: <20220630140237.692986-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old generic microchip,lan966x-switch compatible string was
deprecated. Use the new one.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 arch/arm/boot/dts/lan966x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/lan966x.dtsi b/arch/arm/boot/dts/lan966x.dtsi
index 48971d80c82c..da0657c57cdf 100644
--- a/arch/arm/boot/dts/lan966x.dtsi
+++ b/arch/arm/boot/dts/lan966x.dtsi
@@ -85,7 +85,7 @@ soc {
 		ranges;
 
 		switch: switch@e0000000 {
-			compatible = "microchip,lan966x-switch";
+			compatible = "microchip,lan9668-switch";
 			reg = <0xe0000000 0x0100000>,
 			      <0xe2000000 0x0800000>;
 			reg-names = "cpu", "gcb";
-- 
2.30.2

