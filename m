Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FC6318A40
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhBKMRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhBKMNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:13:43 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22690C061786;
        Thu, 11 Feb 2021 04:13:03 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id m22so7781951lfg.5;
        Thu, 11 Feb 2021 04:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lAf/efFvJkR44ix7CEFq+qMsVF4H4ZJn+sIO16zj+qo=;
        b=plx65wUlIOmKbBNLUGuKE88slSV8xTw6TYqfaWs5egF+aABaBhKNUrvzg9KGXESOv5
         eDhXyR+RoTHL4PDWRvNkLoZ7UzppLOJGdOBgpf9NMjtQ5U0HlOqHL6fpwpIN+qfskSO3
         t/y3ZwT6omKIpAC0USAfRl8Hz6u4B2NckU/em4IDMXJVKm4DwknT/aGXS5cbdDFOGnGw
         7g9PEdWP51PKbPVZoyUYmD9rInryR+1OBgz/G3nCfljbUTCXVU4N+CMhgok43M5lJAXv
         otNu1WiscoabES9fRdHhbCz0u9UyEiZUor4U/DMMilNw5jYfRaCMCQjTquZviO2coUJt
         5Hig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lAf/efFvJkR44ix7CEFq+qMsVF4H4ZJn+sIO16zj+qo=;
        b=b5HjjeCSjEDp9Sk8KB5RtZ5SBkVuJsABbW3OT7lV+XVVg0/vyxMtfna3pfxGYlkBkW
         ohvdNNekNAiepv5O3oYsmFPyXrtgngOtaypoY9LbnKehte/w35owEOG7UnkPPTBBmwAt
         zwRpAnqLhzlS4TiChPitrPSCoqtgCjGdfPbkFlVqNukpafypW9G1TaoMvxED8KAqEbGr
         jfD4V7D+83hLJy5rr2Mvc5S86yfoIgQ5OxeYp5Ah5CBpuShkuC23pwlC8HX1QqsmE8ad
         F/TY/UnLb+fGG/Ct2r/YWavdaeSYnMMoXCbwGdeX+QTktEr+7NrYoulZIlASHqM3szsA
         2kqw==
X-Gm-Message-State: AOAM532dsg7WQTspttT6bCd2n5F5+zMIsr1xCbMEADR9C/W/mDhJIXkg
        DkS6kVCeQGqD9O5SuNgLzQI=
X-Google-Smtp-Source: ABdhPJy7N8QFA/x3WOXkKZScEMrOMQ7zLrV2EK0bpjcvZUQLMue91Xazizt6AGm68o9gvkKTcH1XCw==
X-Received: by 2002:a19:48c2:: with SMTP id v185mr1730985lfa.375.1613045581569;
        Thu, 11 Feb 2021 04:13:01 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:01 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 5.12 1/8] dt-bindings: net: rename BCM4908 Ethernet binding
Date:   Thu, 11 Feb 2021 13:12:32 +0100
Message-Id: <20210211121239.728-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Rob pointed out that a normal convention is "brcm,bcm4908-enet" so
update whole binding to match it.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../net/{brcm,bcm4908enet.yaml => brcm,bcm4908-enet.yaml}   | 6 +++---
 MAINTAINERS                                                 | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/net/{brcm,bcm4908enet.yaml => brcm,bcm4908-enet.yaml} (85%)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
similarity index 85%
rename from Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
rename to Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
index 5f12f51c5b19..c70f222365c0 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/net/brcm,bcm4908enet.yaml#
+$id: http://devicetree.org/schemas/net/brcm,bcm4908-enet.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Broadcom BCM4908 Ethernet controller
@@ -13,7 +13,7 @@ maintainers:
 
 properties:
   compatible:
-    const: brcm,bcm4908enet
+    const: brcm,bcm4908-enet
 
   reg:
     maxItems: 1
@@ -37,7 +37,7 @@ examples:
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
     ethernet@80002000 {
-        compatible = "brcm,bcm4908enet";
+        compatible = "brcm,bcm4908-enet";
         reg = <0x80002000 0x1000>;
 
         interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/MAINTAINERS b/MAINTAINERS
index 0bbd95b73c39..63fb312dedcf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3450,7 +3450,7 @@ M:	Rafał Miłecki <rafal@milecki.pl>
 M:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
+F:	Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
 F:	drivers/net/ethernet/broadcom/bcm4908enet.*
 F:	drivers/net/ethernet/broadcom/unimac.h
 
-- 
2.26.2

