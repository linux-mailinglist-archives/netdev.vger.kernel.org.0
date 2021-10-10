Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859C74280C7
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhJJLSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhJJLSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA62CC06177C;
        Sun, 10 Oct 2021 04:16:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g8so55476241edt.7;
        Sun, 10 Oct 2021 04:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0aDD0ZRLezKNP93hdNBNXpgtETt+h6AkeOIcfTrSqio=;
        b=a0GYtaCmJxa9QvSeXmcFPtSEZRPIxDosLeFAL0dkVbMHT8EJevMTRz5UHA2WIo1eN3
         Z4UjI7a8Pmw2mtH0aAO3qBcYVvcjERR75M+PaPWdcUTl/31YvhlD0QAHigSTTxkvCJe4
         /5ejwwGYtxY5CyVmDhq02J2F5YOkM2S/4uSo3ZeWtpQQ2Ue6IYnl7ZIpvPLE6HlMfrZq
         rnut9bvqoAwgOpTB0ceCDbhQY5j0K0drOEWqFgUgcKGjuax+2fZ7tj4WYrwW4A+cIZky
         orDjErTevkoj3wwUIkiLPcGcC4vLX73Vh4P/YrOQcIqBpeoQU8vhYEZmLxMrGuuCTV1S
         ItWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0aDD0ZRLezKNP93hdNBNXpgtETt+h6AkeOIcfTrSqio=;
        b=ruPVZxIlA/WmlfkhHEuQWEWpkWLmdsBRV8azihJWoOK0kYBx5hq1JsphNOfB+lcnjp
         cs9QQJ48ysv8k4b6wf6h1FA9tynx93buDH3e002Jo6nEqzwbRXmOO+xc58otOMcEW+LV
         nfSB846OoDbmAIB6Qa92WcyRCs1lcWsYLJplVa2jY5OKpYfkOFZr0llbcO8N1kTHjeQc
         ggd4+TM+uufHNEQ3tRMGHOagazu7ViQeNmfn2eUnaQpCk3yzRecD/DO1K1qeStBY9lbf
         gCbqiedc5epP62fHqxj7JU7dDpc0Ihcx/976k96dGFXRy9BRGzk1xxjRV4ZbV6BB+kSs
         Cl2Q==
X-Gm-Message-State: AOAM531ZCA1iiyup1UC9UrZAgP1/nIXswiekTtqZV7jHtcScpFbl6k9/
        hSmAhW0MzvjxJkuSzfS69J2J8Ce7Gdo=
X-Google-Smtp-Source: ABdhPJx400jtmaXJaIK/dQR3GSf1nPk7PIuMZOULSuPmisZaFxNY5Ire4ef5mpXe4tixQGfZP/pdsg==
X-Received: by 2002:a17:906:ce45:: with SMTP id se5mr15155969ejb.386.1633864578212;
        Sun, 10 Oct 2021 04:16:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:17 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v4 12/13] dt-bindings: net: dsa: qca8k: document support for qca8328
Date:   Sun, 10 Oct 2021 13:15:55 +0200
Message-Id: <20211010111556.30447-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8328 is the bigger brother of qca8327. Document the new compatible
binding and add some information to understand the various switch
compatible.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 71cd45818430..e6b580d815c2 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,9 +3,10 @@
 Required properties:
 
 - compatible: should be one of:
-    "qca,qca8327"
-    "qca,qca8334"
-    "qca,qca8337"
+    "qca,qca8328": referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
+    "qca,qca8327": referenced as AR8327(N)-AL1A DR-QFN 148 pin package
+    "qca,qca8334": referenced as QCA8334-AL3C QFN 88 pin package
+    "qca,qca8337": referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
 
 - #size-cells: must be 0
 - #address-cells: must be 1
-- 
2.32.0

