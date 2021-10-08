Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA6426120
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242779AbhJHAZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242209AbhJHAZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910B5C061570;
        Thu,  7 Oct 2021 17:23:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v18so29883401edc.11;
        Thu, 07 Oct 2021 17:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rqO0yPNBy5TWB1TUeZd4pFzS3JsFbEWZgR5hHP+FSk8=;
        b=gVKHp9xp2Ka5kd3iYD0qfWQnlMHvLiBDUg71dufHUlLBoVcVKLPNqpxt3jTzFovxWT
         VS5EdjOnbf4BnewZLAX3MHKemC1iscsK/w4u6QQsJPdkWrfi/av021TxxFFXQhTQIey1
         35ZI3D1xQerrv4DtcoVfWK/hauZUynO/RWBGM+M+SskjYE21SKHaEeZnYGvr4WiwfmFs
         0XwJft9Ut0DxY5dZBxsA6JqRGaouMcnmGY1bLwT6/WKyN8WSl522TsHS08uTdagnS7BX
         jTsFEbY8BHIhI5qskgg6GIqeFgmzm5/Qy9PP3T1ViuIAH3pLi0cvqduzYMtm//86slMB
         sINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rqO0yPNBy5TWB1TUeZd4pFzS3JsFbEWZgR5hHP+FSk8=;
        b=1TkNJT2hZZfQXddNclWKTj4ukNHRGM48JXw11qBJXXAM4XWsNeSk01DMg4aSktNfKA
         JGX0rLa3qoUia0exKLOmOMO9YPBkG3lV6Tpv2lvNrJYZlMV8sfYR+CunuiSDT7w0WSdL
         F+I/0BZcNVtsQKMiSR3Gb/I7Fw03FEBfGcxnXZrMA86SjI2WUvbFT/AXWfldmE7acA+X
         4G9t2jXfMDWmI2QaE1qKoSEFvyvHo5Enlt+VJojkLBPi5MBUoxftqxxN5B7RPdaV2fwZ
         upWX6Mb+T+gb+VUrmtjYmXXIqWKa1iGHNZAF4yULqNRdH/ixV1B2razp2SiGJPlVL1bO
         xyew==
X-Gm-Message-State: AOAM530UcUK5Cn3UtJKW25wWtum25w5CZLbBPipTAVla5mKKLBQq7AG2
        b7+N1CiV3dtuuzWHU1w7POY=
X-Google-Smtp-Source: ABdhPJyTx6syZ3ET42u53ZhlzuNJDeJjevq5fFXt46yW0HAbEqozQAeZfE1enBikfidqWcBUQ1delQ==
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr10400115edb.91.1633652586094;
        Thu, 07 Oct 2021 17:23:06 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:05 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 06/15] dt-bindings: net: dsa: qca8k: document rgmii_1_8v bindings
Date:   Fri,  8 Oct 2021 02:22:16 +0200
Message-Id: <20211008002225.2426-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new qca,rgmii0_1_8v and qca,rgmii56_1_8v needed to setup
mac_pwr_sel register for qca8337 switch. Specific the use of this binding
that is used only in qca8337 and not in qca8327.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 8c73f67c43ca..9383d6bf2426 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,14 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port.
+                   This is needed for qca8337 and toggles the supply voltage
+                   from 1.5v to 1.8v. For the specific regs it was observed
+                   that this is needed only for ipq8064 and ipq8065 target.
+- qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port.
+                    This is needed for qca8337 and toggles the supply voltage
+                    from 1.5v to 1.8v. For the specific regs it was observed
+                    that this is needed only for ipq8065 target.
 
 Subnodes:
 
-- 
2.32.0

