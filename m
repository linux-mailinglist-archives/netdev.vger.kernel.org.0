Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AEC1AF657
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 05:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgDSDIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 23:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgDSDIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 23:08:53 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F21C061A0C;
        Sat, 18 Apr 2020 20:08:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a7so2703786pju.2;
        Sat, 18 Apr 2020 20:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2+QdpxFKrFwhKW0bmHBS7uRMRc4g6WYQHclqiw5AqA=;
        b=GzcEwPJBkKZcqtxkJTDMKKv70MwpnUMzt+2mb0QmcR+xkk2csEdoIUiHSDvlRUcHFW
         7BaqOKq5QFwt0r09rM+92ry6CrPSNHDV2LCCcIaDkXNljgCjBNx5ph3c+mixEM6gLuQC
         ey/iAssKHR18kgSVTHN5pcRJhl6BLrml+A+tjSsopAsYcNGuhZ8d3qHgRdUpgKviTfkk
         6YZ8mWRnpcym4NaUWWfwS6Fg+ZFuvziCD/LEVamouioGHrrfDWC0gyN4V718jgNAKT22
         Kkf+LIRehaV2H+7VMJNjdrA4hQwlom14zjPsO+sIqplNsKxXEadK7DRx+gZxFnLFfHlP
         U/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2+QdpxFKrFwhKW0bmHBS7uRMRc4g6WYQHclqiw5AqA=;
        b=K/kthXEaWhB87v9O0JgSEXZLehMVs7bTKWru0/TZi9OPFKy+YCdcvS3NtGpgfbTCjR
         4BtADSU1zITZELorEKSKL6MCG3sRsbr89FAb4GGUB8BJej71ZpURsAk1iI91ikv7L6FS
         CJyQU1LS/WUdWmteh5+O89f0MTOODPCXvANrBQyyHgthx/0sdy+mq37FTiMdTRRgbiyy
         BJB5SznoEzoACSgEYc5FSkZGvxyzxXBlr3x09vd8OjLTZAQOb/+PVIfXlkd0Rl2pPrqq
         oBfQiVovZzzoEpQ3CsalSftkgfPmm97g46zvZoMwJMtiNaapHYrGS85fZ+qhZpr96mPu
         f0bg==
X-Gm-Message-State: AGi0PubMfvr25RCwj9Azkv6ybMeRUIhSQZ4QLVE9r88wPIUUWyAGXp/m
        TFcX8uFjxR1QS9SzcHxC5A5gWcdm
X-Google-Smtp-Source: APiQypJ/bG/EOTTtpkHSEVlZRrr8R83BFGL30hXaHT7YwQyLuRQsHsaZv1Oyt2iIdWwUzzYLNMZjOg==
X-Received: by 2002:a17:902:8f87:: with SMTP id z7mr9682562plo.342.1587265732102;
        Sat, 18 Apr 2020 20:08:52 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g12sm8686146pfm.129.2020.04.18.20.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 20:08:51 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/2] dt-bindings: net: mdio: Document common properties
Date:   Sat, 18 Apr 2020 20:08:42 -0700
Message-Id: <20200419030843.18870-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200419030843.18870-1-f.fainelli@gmail.com>
References: <20200419030843.18870-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the properties pertaining to the broken turn around or resets
were only documented in ethernet-phy.yaml while they are applicable
across all MDIO devices and not Ethernet PHYs specifically which are a
superset.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/mdio.yaml         | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index 50c3397a82bc..d268ed80bb77 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -50,6 +50,33 @@ patternProperties:
         description:
           The ID number for the PHY.
 
+      broken-turn-around:
+        $ref: /schemas/types.yaml#definitions/flag
+        description:
+          If set, indicates the MDIO device does not correctly release
+          the turn around line low at the end of a MDIO transaction.
+
+      resets:
+        maxItems: 1
+
+      reset-names:
+        const: phy
+
+      reset-gpios:
+        maxItems: 1
+        description:
+          The GPIO phandle and specifier for the MDIO reset signal.
+
+      reset-assert-us:
+        description:
+          Delay after the reset was asserted in microseconds. If this
+          property is missing the delay will be skipped.
+
+      reset-deassert-us:
+        description:
+          Delay after the reset was deasserted in microseconds. If
+          this property is missing the delay will be skipped.
+
     required:
       - reg
 
-- 
2.19.1

