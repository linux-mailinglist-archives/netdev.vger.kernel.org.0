Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA92F617F9C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiKCObd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiKCObb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:31:31 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419961759F
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 07:31:30 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id z24so2453065ljn.4
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 07:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbpBkNKjyjf4HsFrFQItYANllVKYhwGwObTGhe25U0c=;
        b=BKGwlPsh+9rEJAx8Xt7pRS7d38DwAbMlALmoEgPpQ8RYdnz+W0vdRJCleAG+D9pAqE
         FVREfJ7GQ8AMGGnaNQIwXMwUgV6TCXdjuWq+IptSthAsgjiCRs3KmhRPEYx3fbZB+smD
         aeZLyCtpbU1dj4EFBZZPSDRRunZ4AUGQZZp+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbpBkNKjyjf4HsFrFQItYANllVKYhwGwObTGhe25U0c=;
        b=1+YvK/BaSl5cozmmQEcfT6DGuobBPlw5Jov8yhqMUdQPXovGdMOAg7n0B2qTp2LxiD
         /9VnCFgmluuDt+zib/aO608gOoHE87u5Efme0rjnNOOQfzFAKyxCo27vzPzYC9AqzBKo
         8Hqvs++3CbgK0H48ngXoeU2zFyt3LOIv5A4Au7FlFeZvRSCGXp5sAlmdx2kivfxZ2sYf
         rKs+qhVg0I/xF4esVhHQn1NWIfGcy77aPjaE7jkvXW+rEIpWVSi2CJwaS/vT1mKo250B
         OCZ3T+OhqfKqMJS1yw5UfTIA39yDSJjhB2c+J4KNJzW0qXOl3/ZGkZVqAhsYmtVxQQ9y
         Jyng==
X-Gm-Message-State: ACrzQf1ykSp66F+dYH1VGA3woVAprR6Mn4s0PVNfd3fsGxJHZoNGCPe6
        SgesZHYDk5121AqV7Zb32HyftA==
X-Google-Smtp-Source: AMsMyM5Ok4OuHh3TFSIu+iSHdWw2A0qeKq4N/XcWY7vib3gNaRTU+p6Tt7KMP7BUSuIQfGiRYSA4LA==
X-Received: by 2002:a2e:9d5a:0:b0:25e:2c67:edaf with SMTP id y26-20020a2e9d5a000000b0025e2c67edafmr11687044ljj.437.1667485888609;
        Thu, 03 Nov 2022 07:31:28 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a13-20020a056512200d00b00494643db68bsm151951lfb.78.2022.11.03.07.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:31:28 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/2] dt-bindings: dp83867: define ti,ledX-active-low properties
Date:   Thu,  3 Nov 2022 15:31:17 +0100
Message-Id: <20221103143118.2199316-2-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
References: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dp83867 has three LED_X pins that can be used to drive LEDs. They
are by default driven active high, but on some boards the reverse is
needed. Add bindings to allow a board to specify that they should be
active low.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 .../devicetree/bindings/net/ti,dp83867.yaml       | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index b8c0e4b5b494..8483544e28c3 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -118,6 +118,21 @@ properties:
       Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
       values.
 
+  ti,led0-active-low:
+    type: boolean
+    description: |
+      This denotes that the LED_0 pin should be driven as active low.
+
+  ti,led1-active-low:
+    type: boolean
+    description: |
+      This denotes that the LED_1 pin should be driven as active low.
+
+  ti,led2-active-low:
+    type: boolean
+    description: |
+      This denotes that the LED_2 pin should be driven as active low.
+
 required:
   - reg
 
-- 
2.37.2

