Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EC349F63A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbiA1JZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbiA1JZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:25:34 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D7DC061714;
        Fri, 28 Jan 2022 01:25:33 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l25so9586909wrb.13;
        Fri, 28 Jan 2022 01:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HTEMhtkLQmd4ed8G8d5/FVhzNyFMM5Ov07otOvJHoa4=;
        b=eahuaOLGZUbqGuy1G7lOCOcEldwYmQSBLRZ66eFF1xOXR6Y9WuFqQ8tcl4riuL9T84
         6crGXHTz7oB9kBQdR3dD04tjbzz09JVUwSdjqUrH2wiowUrutf64F7UmjmjYoa3LZz56
         guPZK/uzEdhkE8P6Y4jzAaugVkKQVt0tyqRZIfm0RR51uCK0n6dojYjgdrkxQPqpNrbt
         7D8kZqGI4+C46qeeypwXOpQaAy9zYfIP5hYvTdvI/zu0Su9tpnKAenVAJyOm59NvOGU5
         1bE+10FSJVQH+mXV+GlcubyT5bQR7iWC5LSwLbQ2K4/YHb7vSpOueVb4yLAfXRk5u0hN
         bsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HTEMhtkLQmd4ed8G8d5/FVhzNyFMM5Ov07otOvJHoa4=;
        b=1K1+qBI8BwVUcrAZochTAvFHWY5nwi1GSEr/Jb2FUk9FC/HumqMMNtV1sGko1SIyYS
         wCOEX4KT0h4AFWtR98cHcVmPdwKsbeRl40l/9p9zgC9tSvpguvPqMrR1wy/nm08Us2Ji
         GLQltSSAlOwoj6jbkAeZbOiZ6AjEJgavgH5ZyXmSouz/h/jRbTy1qcOD/WiQopWsOI2f
         i4JXpUKh8uuNqZ0Dm7y934foqhUyvm4GY58OfUnJhVnyawXiW7DVeByLtTA/3SUhUNpE
         0Tb2i9591pk6Xl9z34glVqeRXFz6V5J0BMRGc1h51Iun50DJL2+C5UWWhXN2mmftlPmn
         rJGQ==
X-Gm-Message-State: AOAM532rt2t+qyDJqyKuSw8g1+qyESXzciGjZ3H8592SKQEpoH0GJ8WF
        oDdvMnu+OH4Xy7IipvEDyi4=
X-Google-Smtp-Source: ABdhPJx+1keOTAyc5h/RxCvfH6PuWjgEwGIFre90JR29Q83VJpgvov5lDwUnfIcWg9p8VjdjRnqYQw==
X-Received: by 2002:a5d:6d48:: with SMTP id k8mr6235506wri.669.1643361932396;
        Fri, 28 Jan 2022 01:25:32 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n10sm1425320wmr.25.2022.01.28.01.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 01:25:31 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/fsl: xgmac_mdio: Fix spelling mistake "frequecy" -> "frequency"
Date:   Fri, 28 Jan 2022 09:25:31 +0000
Message-Id: <20220128092531.7455-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index d38d0c372585..2243c8fcdee1 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -276,7 +276,7 @@ static int xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
 
 	div = ((clk_get_rate(priv->enet_clk) / priv->mdc_freq) - 1) / 2;
 	if (div < 5 || div > 0x1ff) {
-		dev_err(dev, "Requested MDC frequecy is out of range, ignoring");
+		dev_err(dev, "Requested MDC frequency is out of range, ignoring");
 		return -EINVAL;
 	}
 
-- 
2.34.1

