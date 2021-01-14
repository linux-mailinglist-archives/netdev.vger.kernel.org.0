Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237912F6BA5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbhANT6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbhANT6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:58:31 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07488C0613CF;
        Thu, 14 Jan 2021 11:57:51 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id d8so6346214otq.6;
        Thu, 14 Jan 2021 11:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dxs0NJvJmBAu/+s8TLnC3MeVApUdCV36QEczfzjAyAs=;
        b=TDOKLdG1JiORcaEvujEda4d7gbP+3DlFUYMRJ2BZuNuJsysDGyO8e8yi3sFyO19Ey7
         5wNzZk0Tf5Xis5LNaLBPBwT6PoLzIXMIJ+vjub5t+bD0GJ5FE4NXNcfdhDDghHCxcP2i
         87SChiH3OicsTv62jdUdzYj7vxyuFcoCxFNHM84WjrMhLKek/r0Mg8PuH68miK0vQu0q
         VdStts7H4kUOVWvVxW2DBFhHbV+rtm9Kr7i7IOIzKQZMns9SK9DOGOKjSNjUEuDkqQO6
         0VSXmb61uqF3ZkqV2UsILU7qSwYHQxfyEVUp8F/vgtMCltH01SddCkRBIhzlHxZ6ZLYJ
         7uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dxs0NJvJmBAu/+s8TLnC3MeVApUdCV36QEczfzjAyAs=;
        b=l+LASobem6EmrU3fc5olyp1ZvMNivS1LSoyAnjfptziexhq6mosEq5X57DojV/jHMi
         YSOmG9NPeOoQQA3PVRT28QTsqYpo8zOUcPm917OdWRBFWNd+MJCaMEkD/+hdQAYvaY7E
         eB16FqeM6GwR05xH/+LkUErJ1gyCqXBP+/sdQhqV+lT7WFCwpnUVCll3cMWZ9YR5GG/K
         l/LRtN1Jm1uRwrZKVzqwnbTe32tdn7MXDKBNU3TvPhqarLFHOJTk5+7c3ON5JoM7+FEm
         B3FIbl/nKT6NNzUO3Ej5CS9GS+qilYyetHHRCHnjQZJUL2mGTlzvmePLvitk78qGh6mp
         ga8A==
X-Gm-Message-State: AOAM5302P9VCkXBzuVf2dbt2x9hs2rvZQlg+z2TheKV3Do5Zll6YkJD4
        m0voYmwOncMxwKYIT/TWgQ==
X-Google-Smtp-Source: ABdhPJzKj/0R/rHQ0pxJhY/M/H2MK/o84pXllHej8SCaSJxoDjllYNy+EF822dCcfq5JOtdJHkWxVQ==
X-Received: by 2002:a05:6830:12:: with SMTP id c18mr5944650otp.283.1610654270484;
        Thu, 14 Jan 2021 11:57:50 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id e17sm1244820otk.64.2021.01.14.11.57.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 11:57:49 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v5 3/3] dt-bindings: net: dsa: add bindings for xrs700x switches
Date:   Thu, 14 Jan 2021 13:57:34 -0600
Message-Id: <20210114195734.55313-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210114195734.55313-1-george.mccollister@gmail.com>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation and an example for Arrow SpeedChips XRS7000 Series
single chip Ethernet switches.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 73 ++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
new file mode 100644
index 000000000000..3f01b65f3b22
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -0,0 +1,73 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/arrow,xrs700x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - George McCollister <george.mccollister@gmail.com>
+
+description:
+  The Arrow SpeedChips XRS7000 Series of single chip gigabit Ethernet switches
+  are designed for critical networking applications. They have up to three
+  RGMII ports and one RMII port and are managed via i2c or mdio.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - arrow,xrs7003e
+          - arrow,xrs7003f
+          - arrow,xrs7004e
+          - arrow,xrs7004f
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        switch@8 {
+            compatible = "arrow,xrs7004e";
+            reg = <0x8>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                ethernet-port@1 {
+                    reg = <1>;
+                    label = "lan0";
+                    phy-handle = <&swphy0>;
+                    phy-mode = "rgmii-id";
+                };
+                ethernet-port@2 {
+                    reg = <2>;
+                    label = "lan1";
+                    phy-handle = <&swphy1>;
+                    phy-mode = "rgmii-id";
+                };
+                ethernet-port@3 {
+                    reg = <3>;
+                    label = "cpu";
+                    ethernet = <&fec1>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
-- 
2.11.0

