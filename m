Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B769DCF9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfH0FGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:06:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39617 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729254AbfH0FGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 01:06:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so11926311pgi.6
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 22:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VYL3HdVny3FjP/wO+XxHHdBUD9pdN47WSuHO2lt5w60=;
        b=WEt1MMvwgNdusrEbrNFjSez3tEixw//zKssAQYwRsRUKy/pgeg/u4i9C06/Oi7qw/Y
         iocKb9KvtvWV5pSKbamyUc7z3Z0XtMtSYlEUdHXnOBpCPbWxWNlewegjlpstjK+1OS0k
         /DMg7gErRDGB+q4puRCiCFGmqjpSHWzcFdSIf5LsvXFoNbinYMXR7PQWqlCdJW4Rjj8v
         mTg8x943ZLPfJplGvgY3vM2YTDzdWXQX7dYzpmoyzAtm4BJgq8s4/eqqwsuAGO416myf
         K+VvGzUn+WKqBXnOfB8V1hR6JOc5I4FkIkzbL4nhzfvuEovX+Ii43xs37BV2lQta8MOv
         r1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VYL3HdVny3FjP/wO+XxHHdBUD9pdN47WSuHO2lt5w60=;
        b=WITESwq0zp8lb3jrM8LBRd4Fa7/4cGWjyzLhiKH1sII6iGl0nzL5+Y6zvtuw+lEElW
         0JJl0p8pL1ISpt2Ew0oDlL1i2sMQoXevTfDvY9JKya6kBvfYuIzek/Xohey+7V0ulXhp
         Y/2nP/8zqychHC+UJjF7Tfmd8Gm3RJSv2BVYfWnVzxAXaD1Bxu9GE55gGVCSig1jIMIQ
         7do36b9kdnhoNc/GcIM849tlKW+7OmRDzWhORFZF4Yw5PFZrnKD8ZDCTchpvfcqOj3eb
         /lLeWTlH5h7Rx6/tszx6BkRInuDZkIBvSDGB7VIKkBJPVDcVZM+ifniPwRmw9VYYXW+T
         djgg==
X-Gm-Message-State: APjAAAUJN1JMH7BYQuf0Mq4V4FbZe2pJawGdT88En8LLBwlmhn4tFgJG
        CVuvuZNSPtpZ8rVTJTU9r4OwnQ==
X-Google-Smtp-Source: APXvYqw5XnLL4FU55AVh6pVhf3wlNoIftUqMrAB+AkrajMTqZ0ROSrHT3EwP1NqkPYcBj8Wltz8dYg==
X-Received: by 2002:a63:3046:: with SMTP id w67mr20111427pgw.37.1566882399562;
        Mon, 26 Aug 2019 22:06:39 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id q8sm896414pjq.20.2019.08.26.22.06.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 26 Aug 2019 22:06:38 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        paul.walmsley@sifive.com, ynezz@true.cz, sachin.ghadi@sifive.com,
        Yash Shah <yash.shah@sifive.com>
Subject: [PATCH v2 1/2] macb: bindings doc: update sifive fu540-c000 binding
Date:   Tue, 27 Aug 2019 10:36:03 +0530
Message-Id: <1566882364-23891-2-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
References: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the discussion with Nicolas Ferre[0], rename the compatible property
to a more appropriate and specific string.

[0] https://lore.kernel.org/netdev/CAJ2_jOFEVZQat0Yprg4hem4jRrqkB72FKSeQj4p8P5KA-+rgww@mail.gmail.com/

Signed-off-by: Yash Shah <yash.shah@sifive.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Paul Walmsley <paul.walmsley@sifive.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/macb.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 63c73fa..0b61a90 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -15,10 +15,10 @@ Required properties:
   Use "atmel,sama5d4-gem" for the GEM IP (10/100) available on Atmel sama5d4 SoCs.
   Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
-  Use "sifive,fu540-macb" for SiFive FU540-C000 SoC.
+  Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
-	For "sifive,fu540-macb", second range is required to specify the
+	For "sifive,fu540-c000-gem", second range is required to specify the
 	address and length of the registers for GEMGXL Management block.
 - interrupts: Should contain macb interrupt
 - phy-mode: See ethernet.txt file in the same directory.
-- 
1.9.1

