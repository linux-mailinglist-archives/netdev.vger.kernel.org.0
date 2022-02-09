Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0854AE5B8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbiBIAEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiBIAEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:04:16 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E00C061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:04:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k17so772595plk.0
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 16:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1UR8Hoj++hLizXbkIm5wOyud8pL+F8/SV8OcvlCkhNk=;
        b=fj8+V+ZIJlwArR9RUm+UYtaBvHOz99DHFrvMrvUAC074WO5vMpVjx+uXICrsbgaibr
         ZSH0ArXZQPUWkoD9oTX7h/tcN+jCRjarsPXhnhGov/jaczeGDJ6i2mD2cbmPYB8Ygqgv
         VNTO/rFcfOJsEe8gknccj2Sf+uvOgCt7ZtHUkn6SN0HS3lE+kXqI4GKZZuvaI/XQxCrS
         z5Yy/Yq5yzlPEXi/6XQI4/BZBaywJyZETs3/OKMYPJMQGudSe/5XLzNeerAGlKE5gPFR
         x7c42epks5hkFkepxRz8Lg1797rws51Js+jOYpbQfqYaz6JLxfDszLZWbh3LPgZTveAC
         5z0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=1UR8Hoj++hLizXbkIm5wOyud8pL+F8/SV8OcvlCkhNk=;
        b=bOOet9f/7mBvDn/3nZUAH13E543FyepLfBJpX0kTgZ7lk37exedgMHOH/FZtgP0MD0
         L4n/GY0ae7fSN8SJ3uSHW/xduFR03V413sPXw4Hd8TZe9w/RCjkZCN+8UApZR+/VQU/t
         Xv+1/exO35EGfX+ePttKCG8YHR9PqYk1g8Fl0OLnzRLxxQzUQM2pamqDFfGSAuUTKZtK
         7YcdL3Ko1swpLOppNiWrFmyXbVNtaFzJX6NMHawa/NrySL9cUebAcaq6vUyrynlUSr82
         70ZKcBdZ0Q/xL5L+23ZqF9zeJnajfAij4uqplBj7iVXL2vPXUCwOEajxZkanc+tuKxf8
         B0nw==
X-Gm-Message-State: AOAM530hu68G/mG8qyKZQeUMOSdMPwWjImUm72soME9zjsKS45Zkbk3k
        wW/uTtEsxqIkhuAbfSfuYYocGJeshL5rng==
X-Google-Smtp-Source: ABdhPJzJBl/kUmdOmVBJaysJdFoZVb+5gQmDyBFDMp/vWuYKv3bc8M2D/TZXe7106RRHwDjADhcf5Q==
X-Received: by 2002:a17:902:f64a:: with SMTP id m10mr6813233plg.46.1644365053509;
        Tue, 08 Feb 2022 16:04:13 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id d21sm17984536pfv.141.2022.02.08.16.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 16:04:12 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH net] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
Date:   Wed,  9 Feb 2022 10:33:59 +1030
Message-Id: <20220209000359.372978-1-joel@jms.id.au>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix loading of the driver when built as a module.

Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 drivers/net/mdio/mdio-aspeed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 966c3b4ad59d..e2273588c75b 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -148,6 +148,7 @@ static const struct of_device_id aspeed_mdio_of_match[] = {
 	{ .compatible = "aspeed,ast2600-mdio", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, aspeed_mdio_of_match);
 
 static struct platform_driver aspeed_mdio_driver = {
 	.driver = {
-- 
2.34.1

