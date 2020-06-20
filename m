Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4DF20262F
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgFTT2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 15:28:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40220 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728565AbgFTT2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 15:28:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id p18so10465444eds.7;
        Sat, 20 Jun 2020 12:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scA6CqquoWk914rmLn3+nLtaspjuXK54NYNT8t78XLk=;
        b=qbC+poHvs39ZVCGTzMyJeIJUpytQ6pFd5qeGE3oFWIyiMKZEs3zbCIIiubSaxryjqV
         fHZRmmlzPFxZAmT4fjc315VsprFu9yXwFVTZN0vi4+ogvLhR+DUhLmUmDWlARfH4lqP0
         r6IiIGw2ywL+HM32SWPgf681lb9qGq8eGvDXWEeP7vGDUbWHKB4A3orCW0P0W8Y6nkSZ
         OgbgK/AvNr8N2kaXrsvn/ZibEN+NvJI3DnlZF4FJWQZOu5Cuhzmm1vvW9LZurAgweB8C
         cz7vBuOmkMsfWs5srbSEo67PGDoGURRN6jPG9y+GnpFnomPdS9ocuZVCOabSLdFbm0uZ
         2lHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scA6CqquoWk914rmLn3+nLtaspjuXK54NYNT8t78XLk=;
        b=RcqOrpg4NMSnAd+yvC74ESuwPsJ3FSUIm2PhPhyzN8LsLkiXV8+dva8lp8RnaHUdeh
         pyKhnZNku0XpaTwaQpEBpmhYBC+VjubfEp9szS5e3zEpsTVZ8vhJTFFDnDszJB8UShUW
         gAUiNmD4d9zmOcFEXQGGI4j/G6rkd8a1CL8Eteft9aKmryiqk9uGhDqKyW/uwFS7/nDE
         sxUkqVkcFmmH0iYyrlNiGb3jBR2b+V6F0XSQuVw9o763hzvMDj+6s2DCYvh1U+UL3Cyf
         P8SzlydAxDvwZJsd4OxlbTrGbI+8S+kV1KLEZ3qFdNtJMxnDIIIKqZV4woQnX5zYAqIN
         f15Q==
X-Gm-Message-State: AOAM531lmSTf+mfqCCWK8X+qyBWgFePNK1WMg5L7FbI7nsOEmGDCsw9s
        XVKxsMqf4VV3I4DPovXW6i8=
X-Google-Smtp-Source: ABdhPJy+PKswvEJEFTPfiOtJ7Poy9kSHj4bTMlki+nCfU+FckH9OWUmHYVZxY191m6NdiJ0yfebZbA==
X-Received: by 2002:a50:d78f:: with SMTP id w15mr9700997edi.245.1592681224048;
        Sat, 20 Jun 2020 12:27:04 -0700 (PDT)
Received: from localhost.localdomain (p200300f1371df700428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371d:f700:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id gv18sm8034044ejb.113.2020.06.20.12.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 12:27:03 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] net: stmmac: dwmac-meson8b: add a compatible string for G12A SoCs
Date:   Sat, 20 Jun 2020 21:26:41 +0200
Message-Id: <20200620192641.175754-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
References: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 have the same (at least as far as we
know at the time of writing) PRG_ETHERNET glue register implementation.
This implementation however is slightly different from AXG as it now has
an undocument "auto cali idx val" register in PRG_ETH1[17:16] which
seems to be related to RGMII Ethernet.

Add a new compatible string for G12A SoCs so the logic for this new
register can be implemented in the future.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 234e8b6816ce..544bc621146c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -491,6 +491,10 @@ static const struct of_device_id meson8b_dwmac_match[] = {
 		.compatible = "amlogic,meson-axg-dwmac",
 		.data = &meson_axg_dwmac_data,
 	},
+	{
+		.compatible = "amlogic,meson-g12a-dwmac",
+		.data = &meson_axg_dwmac_data,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, meson8b_dwmac_match);
-- 
2.27.0

