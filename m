Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0AA1AF659
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 05:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgDSDIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 23:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgDSDIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 23:08:55 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D16C061A0C;
        Sat, 18 Apr 2020 20:08:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 2so3279167pgp.11;
        Sat, 18 Apr 2020 20:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fimWZgjU4nYcjINsJ9VPZKF4HX+n2Gcou0MLoHNd/vU=;
        b=JPZM61HUVUAXFJ508lbinQCLJXorqvSUIIW0BANuJHwfcw0zd3wSBZ0gZ8pvggTzRW
         sjcKteQtUL9vc4zVZw8Wi4q6TimRx/aNDuvVymXpdTjPhNimRS1qHJ2+BGrr92Iqm8/t
         GHZhWSUT6ueZG7XDWofyQ/OdS4OknI7ZNUu0/aOthc7w1HvbMaYTszttb/upd6AXcAX3
         lA18oIqbHYWQGYlfW2l4vbSSkYM+uVctFgdfDUA4KKuegy34/YvZCeCq6QFnON69758d
         R4g7G8eK1ya8xyunoNyvhK1+bVcqZXJJOB1W5WOsfKA61Zq3N+v5EQymx6y5CMi0xP59
         Yjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fimWZgjU4nYcjINsJ9VPZKF4HX+n2Gcou0MLoHNd/vU=;
        b=hZfOQLz42EqtE6DOwLyD6aqO7VoZmPmQKGkQaP0UR/9WtpNN3AZDq0+4zr9ujVBUiV
         Khj/gryBfQ4pxprhE2GIZpKNV16Qkh2OnmIGdWrUgbJIWbTFOlxaUqO/7a0GPH6NF4iE
         F6L/ugTS8fKlzbl/QmZt6Xl/QU7OtPgGTVaxVdWaqKfdH/Fxkl6d2aubxnM4EbYmDKrk
         AUXV71BWeVTUvPcohTfDJJnQub2EDpUvkd8qVSi1UTeqeWXSrITLARgsoV9aX6Qo2DVJ
         lZp6VRlHfVKpNyp8C2AP7KeEwOHHAwojSgYOHcuX38QmKV4+FgXRkHcp6dvkA3DMplb8
         N8UA==
X-Gm-Message-State: AGi0PuZdn6kEDE5sDRLFt9i3BcJiX1e3EJ+yIBR/SpNdztZj3c4JmJjK
        JuIJZmyd0LBS96VwhQVjUoQT78eZ
X-Google-Smtp-Source: APiQypKpmvWN0SnL72c9Fu1U7jCrf8EKGtjFMFZpaFLAjA3mVyhqgxGLTujxOEMfbWcdKeFEl2pMUg==
X-Received: by 2002:a62:1950:: with SMTP id 77mr10512221pfz.326.1587265733896;
        Sat, 18 Apr 2020 20:08:53 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g12sm8686146pfm.129.2020.04.18.20.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 20:08:53 -0700 (PDT)
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
Subject: [PATCH net-next v2 2/2] dt-bindings: net: mdio: Make descriptions more general
Date:   Sat, 18 Apr 2020 20:08:43 -0700
Message-Id: <20200419030843.18870-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200419030843.18870-1-f.fainelli@gmail.com>
References: <20200419030843.18870-1-f.fainelli@gmail.com>
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

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index d268ed80bb77..7ea0b5510bc3 100644
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

