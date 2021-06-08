Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F639F244
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhFHJ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:28:57 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:36376 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhFHJ24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:28:56 -0400
Received: by mail-ej1-f44.google.com with SMTP id a11so30791728ejf.3;
        Tue, 08 Jun 2021 02:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LtHzVONJbpZbZApFXMxcxVJqOUerILij542DGNpFpcM=;
        b=oQgnDAH8v4SIbcMS9+zOEF8L2zargCTWYmRSiQTta7VV7mPGWTqRaamd3hReo/b9v2
         1YHhspt2HFSfnAIhN3bvHI57ioc69xuWOOU4WzRr8jirM0584VeBTgF5Zk3HNj8xBz/I
         fETkT3t5lpLT+Vw5RzD54rzxT4D7EhrVhm6taXY4cTDEeEYSgiBeO3UDf+ieqUSXodU4
         2NrODxfvlUN2CnS3aXrsyWTkFFiHKuZME9oJo+X2zV6EKvETlBoy+gm8C6X5emvD9V1b
         BDUCKpOTVGIV/djZBnlGmtUX5qm+m249ogmjp3U7+KLNxMThPh1/2x1WvRh4u3QA6VS0
         JqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LtHzVONJbpZbZApFXMxcxVJqOUerILij542DGNpFpcM=;
        b=pYxWHL1/TxIOWXrjcMIXv13NXiAdElv14g88QfBoUSOVLJ9abinCKrXRHd6cH1ilxf
         AaWwHr9pXqPyi42TgQXSQ7x0+E0NXHoNRCyYA06/33dXA7CNZ+/nn3a779DwpSvLfUQI
         /iXlIXfj33USL0RcNACDiyHQaESSacj41dUqNGGTWXyXhqMvrVp0eFIvY+bCxmSl5QrI
         Rx3a6FBSOmKo/jcsGo1Ewcijn/BeuUKGz1+51tIR2HA5w8kjShihGAoSZmRYxxmASI6u
         NG+V25oJwobVH3TC6KCpxzFj4C46wkkjfDyVPn2BPdbsaS3VJt2USWvu+C8n13nu1cHl
         VrTQ==
X-Gm-Message-State: AOAM533+gY+VWdHpdKVkY6NkqAGI1DAlHK1viGmkeUfg1r7va2qV5ihB
        +v6PRlyxnd7u3lSAdP7pKyA=
X-Google-Smtp-Source: ABdhPJznvpFKZU/0QlPXzW+ij3KZLnP3JxjbyfhnVNk5OHiK9DAeJZ6Ba2s7gDaN+7Yf3Bhb+qTrIQ==
X-Received: by 2002:a17:906:ca54:: with SMTP id jx20mr21816223ejb.380.1623144349315;
        Tue, 08 Jun 2021 02:25:49 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id x9sm639783ejc.37.2021.06.08.02.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 02:25:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 1/4] dt-bindings: net: dsa: sja1105: add SJA1110 bindings
Date:   Tue,  8 Jun 2021 12:25:35 +0300
Message-Id: <20210608092538.3920217-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210608092538.3920217-1-olteanv@gmail.com>
References: <20210608092538.3920217-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are 4 variations of the SJA1110 switch which have a different set
of MII protocols supported per port. Document the compatible strings.

Also, the SJA1110 optionally supports 2 internal MDIO buses for 2
different types of Ethernet PHYs. Document a container node called
"mdios" which has 2 subnodes "mdio@0" and "mdio@1", identifiable via
compatible string, under which the driver finds the internal PHYs.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: Patch is new.
v2->v3: None.

 .../bindings/net/dsa/nxp,sja1105.yaml         | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index d6ac9a0c1b04..0b8a05dd52e6 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -27,10 +27,53 @@ properties:
       - nxp,sja1105q
       - nxp,sja1105r
       - nxp,sja1105s
+      - nxp,sja1110a
+      - nxp,sja1110b
+      - nxp,sja1110c
+      - nxp,sja1110d
 
   reg:
     maxItems: 1
 
+  # Optional container node for the 2 internal MDIO buses of the SJA1110
+  # (one for the internal 100base-T1 PHYs and the other for the single
+  # 100base-TX PHY). The "reg" property does not have physical significance.
+  # The PHY addresses to port correspondence is as follows: for 100base-T1,
+  # port 5 has PHY 1, port 6 has PHY 2 etc, while for 100base-TX, port 1 has
+  # PHY 1.
+  mdios:
+    type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^mdio@[0-1]$":
+        type: object
+
+        allOf:
+          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
+
+        properties:
+          compatible:
+            oneOf:
+              - enum:
+                  - nxp,sja1110-base-t1-mdio
+                  - nxp,sja1110-base-tx-mdio
+
+          reg:
+            oneOf:
+              - enum:
+                - 0
+                - 1
+
+        required:
+          - compatible
+          - reg
+
 required:
   - compatible
   - reg
-- 
2.25.1

