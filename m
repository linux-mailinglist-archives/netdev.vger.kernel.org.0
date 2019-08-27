Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0022D9DCFF
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfH0FGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:06:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34889 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbfH0FGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 01:06:47 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so11153780plb.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 22:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xGYf3jT/OywcihGiyF5DuZOJxtPVxDOHX/P0bgLTLJc=;
        b=bgTanDysTxIvjBPOAptfkieUGdxGxP94KRoDugwTLGzJP4TXWmq18fatIv4CJ5hkjF
         6cB1s70XskgYvExXIuFERiMKnvZz7Kmclh/GC6dS04oECEoG56Wgtmclg6T5RcHxcuQM
         nxf+xWUqVtcZeQtrpd4LYPmS2P+v1XFduGiK9o86lVazMsCy+VtVWxLDP3OA9wbruKOM
         fnXUF73OpQdJqyNo82WuTSZu+gWo7svhNl8ywdWvb259klOLtpcUKOk1SsiM++cP2s7N
         xwQzFwCURx1JBmrHrYuWvugEA9iTS5j+IOWxwAROpMjxaM36lkPuTQU8Vt5jx+fUReRC
         fCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xGYf3jT/OywcihGiyF5DuZOJxtPVxDOHX/P0bgLTLJc=;
        b=YJa+SN2tGjmHjMWxjaWp1eGnqoChJeaBoycH45raar24hGxuCJuvD77TIC4GozAJP8
         SaOMaIT61Xv+LHpoI9kr8Uao4abP/FF3Asfxd5U1ApORFWvAoQSGZ+EQG/uBBWPAKt6p
         cQMptZSZlRQRPRr3bT4j8U57U6zgBE4pqDaB2JSf8EFKh0jUkW5afPHJKNQeydWnZv2a
         sddGv0DSIrEJU+9OKI0QJySXfTHfr4T3AmWrPE321ZFrTSW77UpaiYkNRRsEYGSWnJSZ
         peD9bYcwfaXLAQ4f0hyvngWCHS6AY1fZf8E0eFr7eM+Yx8lOZVSSLGlgJUtnE6jAYyaZ
         lyHg==
X-Gm-Message-State: APjAAAWGxBev9aEcRTU97nwHh1Bv72J7+i8dLrQP2Bs/HOEux9gpb8da
        iXVG/gVBXwjuKgHCCOEs1Fix0g==
X-Google-Smtp-Source: APXvYqzjLiuejY0DazschLAZMfhXglu+wZbQBz00aBmRwNg7xBm8uxbhlOxf9U8si4Lr0KVQVQntcA==
X-Received: by 2002:a17:902:a714:: with SMTP id w20mr22158808plq.135.1566882406319;
        Mon, 26 Aug 2019 22:06:46 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id q8sm896414pjq.20.2019.08.26.22.06.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 26 Aug 2019 22:06:45 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        paul.walmsley@sifive.com, ynezz@true.cz, sachin.ghadi@sifive.com,
        Yash Shah <yash.shah@sifive.com>
Subject: [PATCH v2 2/2] macb: Update compatibility string for SiFive FU540-C000
Date:   Tue, 27 Aug 2019 10:36:04 +0530
Message-Id: <1566882364-23891-3-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
References: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the compatibility string for SiFive FU540-C000 as per the new
string updated in the binding doc.
Reference:
https://lore.kernel.org/netdev/CAJ2_jOFEVZQat0Yprg4hem4jRrqkB72FKSeQj4p8P5KA-+rgww@mail.gmail.com/

Signed-off-by: Yash Shah <yash.shah@sifive.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Paul Walmsley <paul.walmsley@sifive.com>
Tested-by: Paul Walmsley <paul.walmsley@sifive.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5ca17e6..35b59b5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4154,7 +4154,7 @@ static int fu540_c000_init(struct platform_device *pdev)
 	{ .compatible = "cdns,emac", .data = &emac_config },
 	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
-	{ .compatible = "sifive,fu540-macb", .data = &fu540_c000_config },
+	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
1.9.1

