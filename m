Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704AF52EEB5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350621AbiETPHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344764AbiETPHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:07:36 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE28B0A4;
        Fri, 20 May 2022 08:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1653059255; x=1684595255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EqWptlm65K/aZUFe8FaK8aN2US122LKzpWh5yxjk5M8=;
  b=VsKv4gArlz3/owkdMfkDnoRenQUDaZ7H/y413+OFpCh/xoGEKCSuPJDK
   s5H3HR0SLWTqKMS90/AAWXyNoc/Sf7HiFWU88fTQGrC8r4EL8XPmxFgGK
   QaOHn+oH+AGwq3c+4E8NxFqPoTjweAFQ2tMPR/cAJVO9av80OeRZYjngV
   4=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="122053875"
X-IronPort-AV: E=Sophos;i="5.91,239,1647298800"; 
   d="scan'208";a="122053875"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 17:07:32 +0200
Received: from MUCSE803.infineon.com (MUCSE803.infineon.com [172.23.29.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Fri, 20 May 2022 17:07:31 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 20 May
 2022 17:07:31 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 20 May 2022 17:07:30 +0200
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
Subject: [PATCH v2 1/2] dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
Date:   Fri, 20 May 2022 17:07:13 +0200
Message-ID: <cb20a6f49c91521d54c847ee4dc14451b0ee91dd.1653057480.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653057480.git.hakan.jansson@infineon.com>
References: <cover.1653057480.git.hakan.jansson@infineon.com>
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
V1 -> V2: Modify property description

 .../devicetree/bindings/net/broadcom-bluetooth.yaml      | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index 5aac094fd217..a29f059c21cc 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -92,6 +92,15 @@ properties:
        pcm-sync-mode: slave, master
        pcm-clock-mode: slave, master
 
+  brcm,uses-autobaud-mode:
+    type: boolean
+    description: >
+      Setting this property will make the host (driver) assert the controller
+      chip's BT_UART_CTS_N prior to asserting BT_REG_ON. This will make the
+      controller start up in autobaud mode. The controller will then detect the
+      baud rate of the first incoming (HCI Reset) command from the host and
+      subsequently use that baud rate.
+
   interrupts:
     items:
       - description: Handle to the line HOST_WAKE used to wake
-- 
2.25.1

