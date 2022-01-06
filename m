Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEBF4869D0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbiAFSZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:25:45 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:41594 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242817AbiAFSZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 13:25:38 -0500
Received: by mail-oi1-f169.google.com with SMTP id j185so4885309oif.8;
        Thu, 06 Jan 2022 10:25:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0GqoTWktQCAeb/b2q3miftVXfpqdRPH7Wi0Ph2/me+8=;
        b=d0RQCgzXIEX0YxqURDpRGyDwXeZBuSwXxOAiabNZsuI+XpICNmRP8Tz6HxXwJbDmbK
         ciAhX8pvggfycZIL9wi+o4+mngrMItPy0PdfU6Ez1/KFa1DCHnEwbDid/0ekA/mo9AF9
         6t3QV83MZSYcItTchE0F2bgVoUIHxe6lRIQbZ1a4ixjysHuqmVeX/YeWM9SibZtL2LeH
         xbmxDZJJfkosgSYnLllHC3kIcoLq0BpHuuPCh6WdiZpNiQdSOedaZUeb680O2c7CuT9v
         pbJBwEOMBio7d4fy5BMGK5vMemJTnlr9RDyfkiQIUWQMT3ODfjEQedIsWf1SO9ue3DMj
         Ibow==
X-Gm-Message-State: AOAM53164GhH6VA4s7sUkBTp5xu0OPQ9l4DfN7c9mSVQWLIj0nmbrXyI
        R62PbHMJhMSHe7xE5SroHA==
X-Google-Smtp-Source: ABdhPJx0/7FuhIt5ZofcvReC3m8vHWsc5MYNpHeEWkedihlt3E7Ykuzt1p4+IbAXWN4jmADlwgW3Aw==
X-Received: by 2002:a54:450b:: with SMTP id l11mr7108210oil.139.1641493537898;
        Thu, 06 Jan 2022 10:25:37 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id r13sm484949oth.21.2022.01.06.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 10:25:37 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: stm32-dwmac: Make each example a separate entry
Date:   Thu,  6 Jan 2022 12:25:16 -0600
Message-Id: <20220106182518.1435497-8-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each independent example should be a separate entry. This allows for
'interrupts' to have different cell sizes.

The first example also has a phandle in 'interrupts', so drop the phandle.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/stm32-dwmac.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index 577f4e284425..f41d5e386080 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -102,7 +102,7 @@ examples:
            compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
            reg = <0x5800a000 0x2000>;
            reg-names = "stmmaceth";
-           interrupts = <&intc GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
+           interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
            interrupt-names = "macirq";
            clock-names = "stmmaceth",
                      "mac-clk-tx",
@@ -121,6 +121,7 @@ examples:
            phy-mode = "rgmii";
        };
 
+  - |
     //Example 2 (MCU example)
      ethernet1: ethernet@40028000 {
            compatible = "st,stm32-dwmac", "snps,dwmac-3.50a";
@@ -136,6 +137,7 @@ examples:
            phy-mode = "mii";
        };
 
+  - |
     //Example 3
      ethernet2: ethernet@40027000 {
            compatible = "st,stm32-dwmac", "snps,dwmac-4.10a";
-- 
2.32.0

