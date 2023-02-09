Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27B669033A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBIJTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjBIJTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:19:12 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 01:18:55 PST
Received: from mr85p00im-ztdg06021801.me.com (mr85p00im-ztdg06021801.me.com [17.58.23.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A53B61847
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934334; bh=zCmgb/TUYcxcPFcGKNVmXau6gFCFFzIlp/y6/FM/zpY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=xbzWqQ7GvziqX8vIL2uDuVkWcwR8M6YrqDAZ1Sjieug1L7slxTRRnZbK1J9F17XaM
         rI/slyIhzlpdv8/MfcVKWf7Vlcqsc9lAxlmuH5InQAA/7a6w16+Lx7AmMT5YEJDeXJ
         9xeD+3p4Q/dMz4jx4Cjm1ArvaxRFSW67EWyZZOy3W+gZPJmrCdkLBlvuPyL1rQtVRq
         SW2GkmsHVhoacxVRFxYryAnU419aZXyd3WMOXGejZq8bFj9mJ+r3JxmHOicYvsscTK
         Ee62e4Mi7tajU0DS7D2GEgtUTMwc6QE/v+gwP9sVjXp0RE1v8dBeDDwRoPYCG+7kAj
         LBxvMXXzfzX9A==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06021801.me.com (Postfix) with ESMTPSA id 30740D02993;
        Thu,  9 Feb 2023 09:18:54 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org, Alain Volmat <avolmat@me.com>
Subject: [PATCH 04/11] dt-bindings: irqchip: sti: remove stih415/stih416 and stid127
Date:   Thu,  9 Feb 2023 10:16:52 +0100
Message-Id: <20230209091659.1409-5-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove bindings for the stih415/stih416/stid127 since they are
not supported within the kernel anymore.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 .../bindings/interrupt-controller/st,sti-irq-syscfg.txt  | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
index ced6014061a3..977d7ed3670e 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
@@ -6,11 +6,7 @@ and PL310 L2 Cache IRQs are controlled using System Configuration registers.
 This driver is used to unmask them prior to use.
 
 Required properties:
-- compatible	: Should be set to one of:
-			"st,stih415-irq-syscfg"
-			"st,stih416-irq-syscfg"
-			"st,stih407-irq-syscfg"
-			"st,stid127-irq-syscfg"
+- compatible	: Should be "st,stih407-irq-syscfg"
 - st,syscfg	: Phandle to Cortex-A9 IRQ system config registers
 - st,irq-device	: Array of IRQs to enable - should be 2 in length
 - st,fiq-device	: Array of FIQs to enable - should be 2 in length
@@ -25,11 +21,10 @@ Optional properties:
 Example:
 
 irq-syscfg {
-	compatible    = "st,stih416-irq-syscfg";
+	compatible    = "st,stih407-irq-syscfg";
 	st,syscfg     = <&syscfg_cpu>;
 	st,irq-device = <ST_IRQ_SYSCFG_PMU_0>,
 			<ST_IRQ_SYSCFG_PMU_1>;
 	st,fiq-device = <ST_IRQ_SYSCFG_DISABLED>,
 			<ST_IRQ_SYSCFG_DISABLED>;
-	st,invert-ext = <(ST_IRQ_SYSCFG_EXT_1_INV | ST_IRQ_SYSCFG_EXT_3_INV)>;
 };
-- 
2.34.1

