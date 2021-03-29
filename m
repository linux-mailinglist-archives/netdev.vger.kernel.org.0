Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9C634D20F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhC2ODm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhC2OD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 10:03:27 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709B8C061574;
        Mon, 29 Mar 2021 07:03:27 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 75so18645219lfa.2;
        Mon, 29 Mar 2021 07:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f/7ADjDN3atZgIWuqE5Bk51Ez/cZLcsar63PqAeAhJQ=;
        b=M2g/R1ODPmsRrBlJJqo9JSGBo5DFyyw5Td/d4j4CVXYWRxW+IWYWLkKBZQQNp/Z0zp
         RXa2yWszLtaOPhRaPJjRccAHM6tLgv81NQ1eKktC1/YVi8pkj+wwcLMa2GEG0ctNHvy6
         OPusulXl4qkxzS2dSYAIjrEBwuExhTkGN6HCmoKgMWuEGX6HnkuVlr/qY43zZZBFpKfc
         d9cuHl2wNdr2YFECL2hw4+Y5chsskDOwknmhqhCUaAAMfKlIIREbTzXYvPj4YJOocxQ1
         FV1kDONtkCCqqCIBHhY2rSK/XPcfdMUDdjn8hd49Ew5c/8KYEaFM4xBDCOFsjxlHImim
         JDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f/7ADjDN3atZgIWuqE5Bk51Ez/cZLcsar63PqAeAhJQ=;
        b=dFSyxX4MiVzSr00MPK5lIBUe+OdyHMf2+K6SlEs3Tywg7NU+qRvKRXCrnEANqH1Jre
         st/Mu9LiqGeL6uOWB5KBu/4WNafw8hQC6knVOs3N5AY03lmyZIZGCeTyQjOZ6c4rHGZ0
         VE/n2p2PWL1dxVHaNN49r6d+zGu4U/gBTzhFs77YXN5VxzynLolOneDPfvGhYSTH+53G
         Gp2S2EKO07Y6jVb4fiD8AHlKZnfEyA8rgIxwLF3w2o88xJH1AOG2ar+QOLvnwBgK+hub
         m59BxvuKR7ohWsvI7ipgP54PVL65hMtDKDOkqigA/XSRO8+3+rX287qiDplDfcR6jEOf
         5Fxw==
X-Gm-Message-State: AOAM531HrTbrJmM5VFQgNmKJrfUYYLjlsPEwtSzoVMmTwHKTQvhiHXi7
        uXp4eWvQfZ+kux+sKSqSflpFSPvr5UGMXw==
X-Google-Smtp-Source: ABdhPJx8yZLcAdBsVzvDkM2QSaT9ZqiHDE6T92GrRB51JCHZlHkuqUFL5VOR7SPK9Oxo2uk+G/GgEg==
X-Received: by 2002:a19:903:: with SMTP id 3mr16191868lfj.53.1617026605968;
        Mon, 29 Mar 2021 07:03:25 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id 200sm1849562lfl.2.2021.03.29.07.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 07:03:25 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Maxime Ripard <mripard@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net] dt-bindings: net: ethernet-controller: fix typo in NVMEM
Date:   Mon, 29 Mar 2021 16:03:17 +0200
Message-Id: <20210329140317.23343-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

The correct property name is "nvmem-cell-names". This is what:
1. Was originally documented in the ethernet.txt
2. Is used in DTS files
3. Matches standard syntax for phandles
4. Linux net subsystem checks for

Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4b7d1e5d003c..e8f04687a3e0 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -49,7 +49,7 @@ properties:
     description:
       Reference to an nvmem node for the MAC address
 
-  nvmem-cells-names:
+  nvmem-cell-names:
     const: mac-address
 
   phy-connection-type:
-- 
2.26.2

