Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD54870F9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345738AbiAGDFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:05:30 -0500
Received: from mail-oo1-f54.google.com ([209.85.161.54]:34370 "EHLO
        mail-oo1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345713AbiAGDF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:05:26 -0500
Received: by mail-oo1-f54.google.com with SMTP id b1-20020a4a8101000000b002c659ab1342so1159645oog.1;
        Thu, 06 Jan 2022 19:05:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7y1aev8ChqP4pe7ktMQgFqy1ntirv5Tlf2ft2rIJbck=;
        b=MusDl/WGoul5zHJKdEfPnkRrOXHKbg0AS3tS1XXCxLsxn2fkj8W74nknIbawwzydu1
         AN4/LUBJuqoVA33HE1UyDkathjEZ1UJfXMZhEYypbo4PGQKVxJs4P+mQEXs+00B1T7Nd
         aDOb3KavF3l5f7uwUpmfmes5rv3QWAx0y4+cf/+mfTPoNu+STId72f/Fmp42rEWnEciN
         kSly4tUV1dqwuf6Ovn3y36yAJ5dr1B3U1RvgzXSEQFKGdF0S2YGJvWJXpBDnjFxGt17V
         OyzY/z8C0L3lmkH5SbMSeZSktltHUwIXM9d0UZpvHGx8RCXbGHqA3Twh4Z+Kxf8DSG18
         OSJg==
X-Gm-Message-State: AOAM530IjuEhFHN1P7jVPwsz080AzsOf+Ud9VcJqyQBgmPRwmu5Md6B8
        Gl5nkEmBj6LFdSGKbVusxA==
X-Google-Smtp-Source: ABdhPJwnMnAFs9Dek+rpN+JRDwEvUu10LYoPrDQwH8kVpzfSUG/b5w+Rtmp16fVhpGoTsPR6PGd01g==
X-Received: by 2002:a4a:d756:: with SMTP id h22mr36181533oot.11.1641524725346;
        Thu, 06 Jan 2022 19:05:25 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id r5sm666227ote.53.2022.01.06.19.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 19:05:24 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: ti,dp83869: Drop value on boolean 'ti,max-output-impedance'
Date:   Thu,  6 Jan 2022 21:05:13 -0600
Message-Id: <20220107030513.2385482-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DT booleans don't have a value and 'ti,max-output-impedance' is defined and
used as a boolean. So drop the bogus value in the example.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ti,dp83869.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index 70a1209cb13b..1b780dce61ab 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -92,7 +92,7 @@ examples:
         tx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
         rx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
         ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
-        ti,max-output-impedance = "true";
+        ti,max-output-impedance;
         ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
         rx-internal-delay-ps = <2000>;
         tx-internal-delay-ps = <2000>;
-- 
2.32.0

