Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1EC519B1B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346794AbiEDJIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346780AbiEDJIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:08:15 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE3D17E22;
        Wed,  4 May 2022 02:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1651655081; x=1683191081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ADa9vDLlj7ABb7S+Vm6m/1aWCYrLHTvVd3CY+5UjhoQ=;
  b=pmVuMuEr/ptIjf9feYrfAOdBGOBwFQF3Pg0s4bV1T9uD7Pt77lGA8I92
   Sf2FyT43nbKid99u9XpSpcxF0I57F1g92Z10HLL+c/SBBK5gF249KWvBN
   EYF5L/y5UVQ0K7gVUYANgxTwhCZmlESf0wJ93YkyHny4nO8d0H6e2m3zY
   M=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="119183648"
X-IronPort-AV: E=Sophos;i="5.91,197,1647298800"; 
   d="scan'208";a="119183648"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 11:04:39 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Wed,  4 May 2022 11:04:39 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 4 May 2022
 11:04:39 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 4 May 2022 11:04:38 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 1/2] dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
Date:   Wed, 4 May 2022 11:03:39 +0200
Message-ID: <64b59ca66cc22e6433a044e7bba2b3e97c810dc2.1651647576.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651647576.git.hakan.jansson@infineon.com>
References: <cover.1651647576.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE815.infineon.com (172.23.29.41) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
Autobaud mode can also be required on some boards where the controller
device is using a non-standard baud rate when first powered on.

This patch adds a property, "brcm,uses-autobaud-mode", to enable autobaud
mode selection.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
 .../devicetree/bindings/net/broadcom-bluetooth.yaml        | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index 5aac094fd217..26bba3f1c935 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -92,6 +92,13 @@ properties:
        pcm-sync-mode: slave, master
        pcm-clock-mode: slave, master
 
+  brcm,uses-autobaud-mode:
+    type: boolean
+    description: >
+      The controller should be started in autobaud mode by asserting
+      BT_UART_CTS_N (i.e. host RTS) during startup. Only HCI commands supported
+      in autobaud mode should be used until patch FW has been loaded.
+
   interrupts:
     items:
       - description: Handle to the line HOST_WAKE used to wake
-- 
2.25.1

