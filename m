Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767B11AE904
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 02:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDRAvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 20:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725856AbgDRAvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 20:51:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05298C061A0C;
        Fri, 17 Apr 2020 17:51:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so1848400pfc.12;
        Fri, 17 Apr 2020 17:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RG4zLqgfOd5eFwxQ5MLT79PGcVvleEGHuNZIiiWI3A8=;
        b=UHRsxs3dACIIwT+uMU1k+HYIiaao56103YAWtZ9T82lMH2/6k+1bzrxddlKocwAjuh
         uUYH05uZKQ/aA7TG+yPLJz/F9RRFyz34bHILVNLhPocsTu5vQe27bOkgo0lGXU+f5Hld
         nYZVkck9WAKiSUmfozmvA3+ZDMGtDnBU3FHIsFFiNALSwlpJ9oaf2hs46yzarnOE51Mz
         MmaNR2ZcuWpUnxCR4+Jqgka9loe6D29S1Kp+ROZ5vCvht+C9hlBqx9Q7+liIxjqnqe6b
         LQiA2/u+bXiGy5nyrNjaZim8ba1qfsvrXjYz84IhmEPVbiNdhWcOrjqs9hXKvjygObHM
         fcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RG4zLqgfOd5eFwxQ5MLT79PGcVvleEGHuNZIiiWI3A8=;
        b=syxAx19uOK5HQlAmsdra+0svwPVe6iMYhuhEhzHJtX/6FRe4pceEb2jHjH5zrejEWz
         WWZ/QXJ19FRJuMM4BmosNrXKLa2k3jP8GYtMfJ2gx/l9vijK8iWS/dYHhWnw+IgIDMnG
         yGGfajfc6aEz+8NHFmPqEog3RqjHHPMwigeNu3qYHtiGRwT5R9L+On79u9GtXDGNPrgB
         /fWODvQvlh59RN/ueRWa7L9v7eQ/oAiRN+LUuNFZCwwaUQ6vC7WGkfZAzuie9bLfLiLL
         ig9GlZrzf72lz2K0v15OpGQC2iRPun/pRF6tzlWOos7TJtyc5qlXkz31tmyVTTjoFvt8
         tWsQ==
X-Gm-Message-State: AGi0PuaBLXj84MLeI7vE8WvjrmoBMqH8GrU7ERAehCIZJznQNhL7BVKS
        NWLJwCFWg3pTpPk31tABK5xdWKq7
X-Google-Smtp-Source: APiQypL2znwCrCCrcxp1psP1Dxfxox0z8Es+9X/HyrMLS38/612Hq3MCaqcTnox76tSZZnkAxv3jqg==
X-Received: by 2002:a62:404:: with SMTP id 4mr6267992pfe.110.1587171089817;
        Fri, 17 Apr 2020 17:51:29 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a18sm6714082pjh.25.2020.04.17.17.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 17:51:29 -0700 (PDT)
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
Subject: [PATCH net-next] dt-bindings: net: mdio: Document common properties
Date:   Fri, 17 Apr 2020 17:51:26 -0700
Message-Id: <20200418005126.15305-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
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
index 50c3397a82bc..58d486db5651 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -50,6 +50,33 @@ patternProperties:
         description:
           The ID number for the PHY.
 
+      broken-turn-around:
+        $ref: /schemas/types.yaml#definitions/flag
+        description:
+          If set, indicates the PHY device does not correctly release
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
+          The GPIO phandle and specifier for the PHY reset signal.
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

