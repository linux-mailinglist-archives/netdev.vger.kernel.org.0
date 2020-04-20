Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55311B13F9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgDTSHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgDTSHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:07:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0BEC061A0C;
        Mon, 20 Apr 2020 11:07:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g6so5439332pgs.9;
        Mon, 20 Apr 2020 11:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hCbMM0D7i6YG6HvspVDq+pAvNtlnjXVbn+ZZ1wJutFE=;
        b=ZM6D/un48AwAPsz+8hAY1e8kioWexA88QEj+MR4X5XITJLdENUdDkNLOTpAghYLcox
         BfpbOd/4ftkpYDmvCqIkX25RtUwoUhr6w7WzzETGs+7jjbw1jCbnQ+QQ0Dc6wtjb6Iny
         w4eDfVUGcNASH9/9ZGv1slXcw6XJVHLJPO/CJgjVgc8hychdHXbbXmHOPN2Y3Brq9KmH
         XWNUzhZ629fYCkXb04+8dpQBygRCFi31yqXvAmBz4Agmxw4S8RsuWGNOTOOMmKlR56MA
         4tHMJAx404rfzh5x5TrWyP5a7bY48R2GKntiSIkpvYmlYpz9GSpSLD5d1N+6y1XK8FYU
         3Eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCbMM0D7i6YG6HvspVDq+pAvNtlnjXVbn+ZZ1wJutFE=;
        b=Jq76vYsJ0VaDs8cGI/ygKM6YK30Pbb5t+QdH4GuFodfCHgCO7Qstc3urHGxIbCYZxu
         mpcEOgPDj/rgx0tZGzoCp+BFHk9AOc+GFVpbw0Gc7o5xq8xNdJlfscAF3eKiGRcFFwLj
         8qMQUUUuyo3dvcktH3b/PVSaC8DBbiJ52eX4yG3Zn/FNgE5KM4DHPbpIfc0O2DZFhrlp
         fHYiexYm7BFBaZi4edjYP1dp3Bw7/n2/M26IE54Q9nXbYFbFmvHvxQlzqSnkS68HlP+s
         3blgjAXDp9XNlcVX3BclsikHo2oNKMlcoeX6/N0wjhTCj1A073HIGIzBultBcWcWj7sZ
         ejbQ==
X-Gm-Message-State: AGi0PubG07L1h1VRqccM2FwbE2Or6XCZKXv/LS5twbO8d+zcA85bVgAX
        7eIaow95FnFkMyLUTb9zun/B2R0q
X-Google-Smtp-Source: APiQypKFEI724jV0xrw4WG7w2t9npeZtaAZdpnvz5LXHZxLB09nUrb6VGcnnzCCOu3ESpGOfktp5wA==
X-Received: by 2002:a62:3545:: with SMTP id c66mr15248027pfa.217.1587406052889;
        Mon, 20 Apr 2020 11:07:32 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e7sm131193pfh.161.2020.04.20.11.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:07:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3 3/3] dt-bindings: net: mdio: Make descriptions more general
Date:   Mon, 20 Apr 2020 11:07:23 -0700
Message-Id: <20200420180723.27936-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200420180723.27936-1-f.fainelli@gmail.com>
References: <20200420180723.27936-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of descriptions assume a PHY device, but since this binding
describes a MDIO bus which can have different kinds of MDIO devices
attached to it, rephrase some descriptions to be more general in that
regard.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index 9efb7d623f0e..d83fe5980fb8 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -31,13 +31,13 @@ properties:
     maxItems: 1
     description:
       The phandle and specifier for the GPIO that controls the RESET
-      lines of all PHYs on that MDIO bus.
+      lines of all devices on that MDIO bus.
 
   reset-delay-us:
     description:
-      RESET pulse width in microseconds. It applies to all PHY devices
-      and must therefore be appropriately determined based on all PHY
-      requirements (maximum value of all per-PHY RESET pulse widths).
+      RESET pulse width in microseconds. It applies to all MDIO devices
+      and must therefore be appropriately determined based on all devices
+      requirements (maximum value of all per-device RESET pulse widths).
 
 patternProperties:
   "^ethernet-phy@[0-9a-f]+$":
@@ -48,7 +48,7 @@ patternProperties:
         minimum: 0
         maximum: 31
         description:
-          The ID number for the PHY.
+          The ID number for the device.
 
       broken-turn-around:
         $ref: /schemas/types.yaml#definitions/flag
-- 
2.19.1

