Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2BF2E6C07
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgL1Wzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729527AbgL1VdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:33:04 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C2CC061799;
        Mon, 28 Dec 2020 13:32:23 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e7so6843118ile.7;
        Mon, 28 Dec 2020 13:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pd9JDNXSanSEISdKkZD+jfC3tgahpgbgsLxkysRm1fc=;
        b=bQjaIIbKvOO7VMApQrS6uW2u1Fx0FB6FCFuiBmSLco7mfI0ScIscF/W96hLlx0rPsJ
         XXgWyTyP2ny3mjX8Gfxc/piIGaSWzcuuFZyo+5uI9KC+x6IRunBtmWrDC7uNSf/6ouzK
         J3VZaC6sKJqNI9Tr/IUE/9jSv+8ff1DvLF90XnXGe+GKAeW/I16K6ZGukCw1+XJ1N3Rt
         UzAx5shA36DWE88Rzyyx4VeqwGyLMuNpLiOow1dYpdbEy4PapPctc8X7vKg98j/H22jF
         rSresmHaHkapAoyAstwZ9wmoFEyoWMUmpQPKFyWnqQ8T4rKwnFVUtt6OukutCd9Ondub
         +Dcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pd9JDNXSanSEISdKkZD+jfC3tgahpgbgsLxkysRm1fc=;
        b=NjEFwl/Z/sYtWcd/jUhv7PK6p6w/UL5ptwK5A7FIh74GKxZt4PmdhrWF53o0IxqAcV
         PezsFqmzqcQo22i0zg4Ux38Z2fp6pWoUf/9n3N75QB1GjmHz25BNakLHii/Y3xEDDEP7
         mPLrzKTPl7VNKwEJUsiSg2KMnyw4e8gLlqWKMaVhkli8ee18wipl+1Rsk9dlK7rvfvTq
         iIq/GHTZjQ4mGrbfD1eTLWr+Lt6m4q5lmrBRR9Xi2HUR+31Ea/ts0+kF52fxfktvwKWX
         Ni+0eFD5vABmu5KtOuTvOAOYuw5jBLl+x6OwLZ9VkuZcRpQ+Yx/11cCWsgNTeVKHId87
         wM6A==
X-Gm-Message-State: AOAM533OSMUwnC6FKQ1IG3dTGfLDy3k6FpjZFt/x6Shc0slbra65r2lv
        ygmXSwyvqISHjPziJVuvZQbbdqYrIfiQ7Q==
X-Google-Smtp-Source: ABdhPJwQk5EldEbD49R9I1pl8Sj17DXV1DdXh74DVmOsYmJXmDTAdxw+eJZGzTlF3jzV3yIDB5MGtA==
X-Received: by 2002:a05:6e02:1192:: with SMTP id y18mr46127975ili.58.1609191142798;
        Mon, 28 Dec 2020 13:32:22 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:f45d:df49:9a4c:4914])
        by smtp.gmail.com with ESMTPSA id r10sm27671275ilo.34.2020.12.28.13.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:32:22 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: ethernet: ravb: Name the AVB functional clock fck
Date:   Mon, 28 Dec 2020 15:31:20 -0600
Message-Id: <20201228213121.2331449-4-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201228213121.2331449-1-aford173@gmail.com>
References: <20201228213121.2331449-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bindings have been updated to support two clocks, but the
original clock now requires the name fck to distinguish it
from the other.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index bd30505fbc57..99a6ef9c15c1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2142,7 +2142,7 @@ static int ravb_probe(struct platform_device *pdev)
 
 	priv->chip_id = chip_id;
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	priv->clk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(priv->clk)) {
 		error = PTR_ERR(priv->clk);
 		goto out_release;
-- 
2.25.1

