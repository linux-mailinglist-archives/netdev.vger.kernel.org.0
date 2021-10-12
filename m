Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6941242A4A5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhJLMjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbhJLMjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:39:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E2C061765
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:11 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w19so20635330edd.2
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 05:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=INDYqtUols/uVG+LIBQeijVm3kwPp6AgjgHg2loetxk=;
        b=mqfcPMuE9S4mXDkJQXAK+8J0ecbnyDA92UApMbqkVadP7nIOOp5cC2WiW8gXmidpJN
         mND/2SLjs4IJT77Ca5vAZ+EsSHd7EXidHVvHJHLGMB83o+kjprPH+FDtXqJf0BDyEsdX
         BzHugoBn1Oe3bXeyKHvAiRGrLy8T/ISAkX9oM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=INDYqtUols/uVG+LIBQeijVm3kwPp6AgjgHg2loetxk=;
        b=ULakdDlz0rkjkNJUgnAKtsihAgp42T3FnJIsDIB8z7mhhgcg073Uj+1A868yqLjSHA
         T0dxWXfO4J/MLgkTENRxOCHh3MHlB9vw4IOPRuiIgaYys3hyjt79BpRfXx385XZBARmm
         ecEklXQ4icREVRauoLJaD9b1yKE488S69CDj5D0mzYefwerCsmPGZ0uTtT965cU6It5X
         GTuHTfLO3FpsAcAAUoOswAHtE351uHaZsbHYHYwrwrG0UdeV3zVlS1wyqfTrW5illchn
         mZccoX/5q2OHepBZJEOEOfj3ua5fa6Wt5qV55dC6c3kl+pmC8JWgbRehPy5Edoe4vHZE
         maDA==
X-Gm-Message-State: AOAM530wGTIs3KRlyUNCsXlb/aaBPyElgaDPu+Vt5uMnB9O1veSl8qXk
        yTL2BDJhPelu+9k1uGrk5f/M2A==
X-Google-Smtp-Source: ABdhPJxs0V9OZqWxQlU/9Dpl6E9pFhEQkhfEImHdkPNMA3JYcF/sdTfjJSAEJvEjYZXY68/QNI+xJw==
X-Received: by 2002:a17:906:1f49:: with SMTP id d9mr32664491ejk.150.1634042230410;
        Tue, 12 Oct 2021 05:37:10 -0700 (PDT)
Received: from capella.. (27-reverse.bang-olufsen.dk. [193.89.194.27])
        by smtp.gmail.com with ESMTPSA id b5sm5763629edu.13.2021.10.12.05.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:37:10 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
Date:   Tue, 12 Oct 2021 14:35:52 +0200
Message-Id: <20211012123557.3547280-4-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012123557.3547280-1-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

rtl8365mb is a new realtek-smi subdriver for the RTL8365MB-VC 4+1 port
10/100/1000M Ethernet switch controller. Its compatible string is
"realtek,rtl8365mb".

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---

RFC -> v1: no change; collect Reviewed-by and Acked-by

 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index b6ae8541bd55..ee03eb40a488 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -9,6 +9,7 @@ SMI-based Realtek devices.
 Required properties:
 
 - compatible: must be exactly one of:
+      "realtek,rtl8365mb" (4+1 ports)
       "realtek,rtl8366"
       "realtek,rtl8366rb" (4+1 ports)
       "realtek,rtl8366s"  (4+1 ports)
-- 
2.32.0

