Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F059333871
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhCJJOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhCJJOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:14:25 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58196C06174A;
        Wed, 10 Mar 2021 01:14:25 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m22so32230821lfg.5;
        Wed, 10 Mar 2021 01:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lkb4fhMWbYfgcrHFjrq5Zx1jnIW2z6RnyfRiSQSgbwM=;
        b=ISD5+TIKgaWzeqmLlE2nsUOK7lcfqYFJKJSPe6V2gh63ZOeh2+POe3RQzHN6jVcxgV
         eHxUgIH9AUFR8H63Tpdq9YzBpmG3T1YrlE/hcEjdsmSKO7JeQkfcVqauvrkElnf8QKl3
         Epel1jkgYJMC/DmyLXGpU/vUGZRmifEeiIj+2/cpr/pXjO/F7PeufNlccPGijWCMb9Ur
         EPvMGNWG2TgsJhOpaSr1dEqhaEA1bKbdgoQusKrxOcDaaoywaZdLPWJjURRkY/qVtbFI
         ZBl34DWgRunWf0I2/yt8wTKClUV52i73dJT5FzM2Zh89Vcs9r5kJ9iO//PIPqe2zPzEf
         aZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lkb4fhMWbYfgcrHFjrq5Zx1jnIW2z6RnyfRiSQSgbwM=;
        b=uoZpHpdZgoyVsKt3Bo5kVdgphTQWKV95IsMMA7WA9QxtaV05E4WN+MiBRbkWOdCzMF
         xlpulvn6gEUBN+lJDVTMhLXSqUI48ICwSFyjDihXegtOmTFOiudBEPYo5Gv63A/vC9h2
         IoDZWtvBdEMfZVqWjPm6SCe8SfTZAO0D8oOWIe3XNW/Xvd3FWJJ/+Xn9Xm1tlNdk/d3v
         8hyfoBGrvDbEpK5A3t/bb/uRY01FlYUASIy9WpQsy8xcsVdz9QwF8vlp9IgCNA8jqdnX
         +m5IxfpQptorwSGk4jHSa4njG1mGI0mndLd/2o2kp3XLpZyKJO+I2mM9NM2lbW5x/SM5
         1FgA==
X-Gm-Message-State: AOAM533JAWSEYne0zpzLysrd8Z00LC4Gb1A3a1Fm1p0iUCleeJeebG3f
        1vp9NWrRDqjalH+wmAp2WVU=
X-Google-Smtp-Source: ABdhPJy6OLHy6cMZLclL+VF7U+Y4sY9wmA4Vi0wsjyRzsTn0/6MGqh7NxrcYmm0xo40HjgfAId+ECg==
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr1430412lfu.41.1615367663754;
        Wed, 10 Mar 2021 01:14:23 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id u25sm2951123ljo.98.2021.03.10.01.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 01:14:23 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 1/2] dt-bindings: net: bcm4908-enet: add optional TX interrupt
Date:   Wed, 10 Mar 2021 10:14:09 +0100
Message-Id: <20210310091410.10164-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

I discovered that hardware actually supports two interrupts, one per DMA
channel (RX and TX).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../bindings/net/brcm,bcm4908-enet.yaml         | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
index 79c38ea14237..2a3be0f9a1a1 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -22,10 +22,18 @@ properties:
     maxItems: 1
 
   interrupts:
-    description: RX interrupt
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: RX interrupt
+      - description: TX interrupt
 
   interrupt-names:
-    const: rx
+    minItems: 1
+    maxItems: 2
+    items:
+      - const: rx
+      - const: tx
 
 required:
   - reg
@@ -43,6 +51,7 @@ examples:
         compatible = "brcm,bcm4908-enet";
         reg = <0x80002000 0x1000>;
 
-        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
-        interrupt-names = "rx";
+        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "rx", "tx";
     };
-- 
2.26.2

