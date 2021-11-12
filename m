Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F2244EBB3
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhKLRBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbhKLRA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:00:59 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED886C061766;
        Fri, 12 Nov 2021 08:58:07 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z21so40205137edb.5;
        Fri, 12 Nov 2021 08:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFxHos6+nfMoiQmEudF08/34z+Vvn/sOnlO81tu6OjY=;
        b=A8Din55U1R9G4WopnAbY7XqGhIIsD2Hekk6twPyvjTUPq8qTpHQZEJFKbMA90ExbF9
         yE+m32s3hQwJA8lSeDL+uiX9QLm0aBNLerrISric6osU/dLkqEM3gnzCCWZQ7cKJuH4z
         FVfoh88MrazOIKMK8hPMjICZDCG+vjXawZuHoDJmOasp8iWtTCYWGWswxZ31aBW670mc
         bOBC6E9vFskIz9PgANAD3k12U4tEBt8frxbS9nSnc2yCmDJMX4eIeIBidrw7r/EpGqNe
         5iygV9ismhDGfw5/wXYtYqEMJAY0kLCkB52zbaP9MAnC5e+qXEjHtoMfetd4/oJCejkC
         7qLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFxHos6+nfMoiQmEudF08/34z+Vvn/sOnlO81tu6OjY=;
        b=Mojer4pOvusTaSseBGW++hnzOd/jhCvQV9NB8jZZeZ6ABwajpdgKx/QB8L3M4WO91h
         G8ORNVw7X2e3NmiXfX+J3LSQtEl4G2qxOZBwFTPUC06UHtPa3MEwjVF2EHaXy4azRqbw
         iW8Ki/tEVDqX/OGf+k2/MJYQlRaDV+B7ov2rItQ3Qf5l/FG9Z3C7CNkRRmwzRP83KeXo
         T6X3GJiFbfC/FwFH3SKHAJA3uvEQK2JLAIe46tEoOCMOK6Gxxod6Dlp20Ph5hy42fI4U
         FxMB6lKOaP7wuIX++ASxt7PCeVwRX5Gr0l/LxHnN0E6E1vUkkhv6sfwhLDw5xtKnkN72
         fcJQ==
X-Gm-Message-State: AOAM532R1WS1XNLLorPzGJ6d6vA9PJJCV0vdho+6eeuljs4NnXbhEoMT
        iawmXar5IsnehlkqSqSigYM=
X-Google-Smtp-Source: ABdhPJz/5Q5mujAW1rUrZMzXuMXNiA2IKTBkVKf0bKbHfN8cYcm/NE2Sbd1fZEXlHpuWION2gQwy2w==
X-Received: by 2002:a05:6402:184c:: with SMTP id v12mr23504646edy.242.1636736286413;
        Fri, 12 Nov 2021 08:58:06 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bo20sm3409492edb.31.2021.11.12.08.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:58:05 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH 2/2] dt-bindings: net: dsa: qca8k: improve port definition documentation
Date:   Fri, 12 Nov 2021 17:57:52 +0100
Message-Id: <20211112165752.1704-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112165752.1704-1-ansuelsmth@gmail.com>
References: <20211112165752.1704-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean and improve port definition for qca8k documentation by referencing
the dsa generic port definition and adding the additional specific port
definition.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 82 ++++++-------------
 1 file changed, 23 insertions(+), 59 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 48de0ace265d..9eb24cdf6cd4 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -99,65 +99,29 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        properties:
-          reg:
-            description: Port number
-
-          label:
-            description:
-              Describes the label associated with this port, which will become
-              the netdev name
-            $ref: /schemas/types.yaml#/definitions/string
-
-          link:
-            description:
-              Should be a list of phandles to other switch's DSA port. This
-              port is used as the outgoing port towards the phandle ports. The
-              full routing information must be given, not just the one hop
-              routes to neighbouring switches
-            $ref: /schemas/types.yaml#/definitions/phandle-array
-
-          ethernet:
-            description:
-              Should be a phandle to a valid Ethernet device node.  This host
-              device is what the switch port is connected to
-            $ref: /schemas/types.yaml#/definitions/phandle
-
-          phy-handle: true
-
-          phy-mode: true
-
-          fixed-link: true
-
-          mac-address: true
-
-          sfp: true
-
-          qca,sgmii-rxclk-falling-edge:
-            $ref: /schemas/types.yaml#/definitions/flag
-            description:
-              Set the receive clock phase to falling edge. Mostly commonly used on
-              the QCA8327 with CPU port 0 set to SGMII.
-
-          qca,sgmii-txclk-falling-edge:
-            $ref: /schemas/types.yaml#/definitions/flag
-            description:
-              Set the transmit clock phase to falling edge.
-
-          qca,sgmii-enable-pll:
-            $ref: /schemas/types.yaml#/definitions/flag
-            description:
-              For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
-              Signal Detection. On the QCA8327 this should not be enabled, otherwise
-              the SGMII port will not initialize. When used on the QCA8337, revision 3
-              or greater, a warning will be displayed. When the CPU port is set to
-              SGMII on the QCA8337, it is advised to set this unless a communication
-              issue is observed.
-
-        required:
-          - reg
-
-        additionalProperties: false
+        allOf:
+          - $ref: dsa-port.yaml#
+          - properties:
+              qca,sgmii-rxclk-falling-edge:
+                $ref: /schemas/types.yaml#/definitions/flag
+                description:
+                  Set the receive clock phase to falling edge. Mostly commonly used on
+                  the QCA8327 with CPU port 0 set to SGMII.
+
+              qca,sgmii-txclk-falling-edge:
+                $ref: /schemas/types.yaml#/definitions/flag
+                description:
+                  Set the transmit clock phase to falling edge.
+
+              qca,sgmii-enable-pll:
+                $ref: /schemas/types.yaml#/definitions/flag
+                description:
+                  For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
+                  Signal Detection. On the QCA8327 this should not be enabled, otherwise
+                  the SGMII port will not initialize. When used on the QCA8337, revision 3
+                  or greater, a warning will be displayed. When the CPU port is set to
+                  SGMII on the QCA8337, it is advised to set this unless a communication
+                  issue is observed.
 
 oneOf:
   - required:
-- 
2.32.0

