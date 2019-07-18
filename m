Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8046D5A1
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 22:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391472AbfGRUO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 16:14:58 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:36539 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391319AbfGRUO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 16:14:57 -0400
Received: by mail-io1-f53.google.com with SMTP id o9so53724153iom.3;
        Thu, 18 Jul 2019 13:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=r2pTm0RwMQarnOMoV8lDgMG4J6XK5815xYl1WaBhWuw=;
        b=jXt46JwdBMPM4AF2MXHtgaUsQMs3wXwa8Ez4IImyYL5lK0RzY+Por1cwu6pd3tf1GK
         LrR59Z86usCvS5PmkGhF3DPyAYzBW9zSlJJMqBiO/DfbEJy4NJ+BGaB2eCH1E3ERB7it
         hf9/1kg5cy1KyOyY/PlWh63D5KRrr8tLDGxHLUH0gxkLR1rYP0+NHe4sRkS08I6N0XrV
         JU7TSwR1wWwxivUuoIpCQNY8YwM5drG9QWzXEwcQyhOrHW5HW7BGP0GICe9p6fZfIf1V
         9Mzjq9NaONVeWjIHfoGxtbcHJ/60e/CclfhDs0EBmZQcAJ8WmTyhYeV6q0a9825w6QF3
         Fa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r2pTm0RwMQarnOMoV8lDgMG4J6XK5815xYl1WaBhWuw=;
        b=SQHJuno+MXcY9P/5NzVi4mOA+gfuygpaXZkFSxrIKaaBo/tpoxJuh5pXit5rF4ZOeW
         9fKINWwcnZOy1bfWkRNfd0doOs7t51O/ZZj2itJIHJzL6KdxOOhc5+b/qfNNE0kRsRPH
         AhQ+mYmLl5eZ4OY5RhqIv0HnTWa84U8aj280YPSnQwCxLaOmXkp//oPl/xWVAYby2NN+
         PF9I0NVUWbWwJ6uMfsnRj5EUGW2Rj/GC9Fjqey0+JyWM5noJ/6zPPE1LoTJaxsqQz7o7
         XjJf0gTPQERs8xOvd0RaNSBWGCizvRoKe5GHauuYnjQgZZOkQSAVOqXHa/LOKKeRQW1S
         uJzg==
X-Gm-Message-State: APjAAAVGrcYiIwfciNqVz8x5MRkRVVzCK/pgzutKiNKs5rJNxJk+BANW
        Bvj401pAckoJDLVg9a9tCBo=
X-Google-Smtp-Source: APXvYqxSMTFdNpWMpK6BWoxyGer9NJ15j1T9DNe6DsnJeFmfcT3n3z8uenJp6lvRsFHRyu9jM7R6XA==
X-Received: by 2002:a5d:8b52:: with SMTP id c18mr44577354iot.89.1563480896915;
        Thu, 18 Jul 2019 13:14:56 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id p3sm31399170iom.7.2019.07.18.13.14.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:14:56 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH v1] dt-bindings: fec: explicitly mark deprecated properties
Date:   Thu, 18 Jul 2019 16:14:53 -0400
Message-Id: <20190718201453.13062-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fec's gpio phy reset properties have been deprecated.
Update the dt-bindings documentation to explicitly mark
them as such, and provide a short description of the
recommended alternative.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 .../devicetree/bindings/net/fsl-fec.txt       | 30 +++++++++++--------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 2d41fb96ce0a..5b88fae0307d 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -7,18 +7,6 @@ Required properties:
 - phy-mode : See ethernet.txt file in the same directory
 
 Optional properties:
-- phy-reset-gpios : Should specify the gpio for phy reset
-- phy-reset-duration : Reset duration in milliseconds.  Should present
-  only if property "phy-reset-gpios" is available.  Missing the property
-  will have the duration be 1 millisecond.  Numbers greater than 1000 are
-  invalid and 1 millisecond will be used instead.
-- phy-reset-active-high : If present then the reset sequence using the GPIO
-  specified in the "phy-reset-gpios" property is reversed (H=reset state,
-  L=operation state).
-- phy-reset-post-delay : Post reset delay in milliseconds. If present then
-  a delay of phy-reset-post-delay milliseconds will be observed after the
-  phy-reset-gpios has been toggled. Can be omitted thus no delay is
-  observed. Delay is in range of 1ms to 1000ms. Other delays are invalid.
 - phy-supply : regulator that powers the Ethernet PHY.
 - phy-handle : phandle to the PHY device connected to this device.
 - fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
@@ -47,11 +35,27 @@ Optional properties:
   For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
   per second interrupt associated with 1588 precision time protocol(PTP).
 
-
 Optional subnodes:
 - mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
   according to phy.txt in the same directory
 
+Deprecated optional properties:
+	To avoid these, create a phy node according to phy.txt in the same
+	directory, and point the fec's "phy-handle" property to it. Then use
+	the phy's reset binding, again described by phy.txt.
+- phy-reset-gpios : Should specify the gpio for phy reset
+- phy-reset-duration : Reset duration in milliseconds.  Should present
+  only if property "phy-reset-gpios" is available.  Missing the property
+  will have the duration be 1 millisecond.  Numbers greater than 1000 are
+  invalid and 1 millisecond will be used instead.
+- phy-reset-active-high : If present then the reset sequence using the GPIO
+  specified in the "phy-reset-gpios" property is reversed (H=reset state,
+  L=operation state).
+- phy-reset-post-delay : Post reset delay in milliseconds. If present then
+  a delay of phy-reset-post-delay milliseconds will be observed after the
+  phy-reset-gpios has been toggled. Can be omitted thus no delay is
+  observed. Delay is in range of 1ms to 1000ms. Other delays are invalid.
+
 Example:
 
 ethernet@83fec000 {
-- 
2.17.1

