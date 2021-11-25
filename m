Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E1445D260
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345285AbhKYBQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346695AbhKYBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 20:14:15 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C34BC0613A1;
        Wed, 24 Nov 2021 16:29:35 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r8so7605579wra.7;
        Wed, 24 Nov 2021 16:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cRnSRbzwvlHpqC/nnyQAXR+HDW69EqnOES3AQJQuO84=;
        b=m3AVOkrGm+t4KptrgXCRyXfkgjx/CryFsPh8So0b3SqBB4goPrIxXN3a+Q2tpWJx9a
         7qU14NdjAmhjagEPhd04dnLN7LnccblL0tQEpJTaf/eUEbNn+88kenffyFiJIQuzMLX+
         ddh28/XhPdav4Hoo17/hdExjRzK/A8JBqvXhDpRXs4L5/jonQO+cl2P14XkDzsLVZI5p
         UoNlacmJYjWn+VAHxcNETCfwpolaMfPoDyBlAS+TXTikD/brQmOsqzpsQsU4QYNYHEuM
         JCsIv1hmcJSkyhzL3IavgSu846diXOp0pGPENuhYibeInrMbNF8xdgg0mL3A5S7bR9SJ
         eyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cRnSRbzwvlHpqC/nnyQAXR+HDW69EqnOES3AQJQuO84=;
        b=V5SxJQY2Dg6O7oscvZaiS8xtmouNNEryn7itlBegLRngy/WQ1gRnPBhex9plf93eRt
         fHyogrbCjlraEkfbRWFvXwGqfMmcdDtR2z8PRAHAzAq7o07vbhslL5yEZapiceCCoN9F
         9p8kqb34UOOD9yS5tKjDpEs0uygGwFksRXfWHxn9iA4fjGzxN10D+OpYzB9u80i5mVlM
         Tsj2vW5pzukl2rnIsUzHmqbujHKjbOkr6PSWolHQ8YZxpMAu6nPcWhB/fD/9l2aB3pxQ
         IJwjjW+FUxlkf8o++eEZS2SadkHQCt+RlUwArHJZqRBY7E8fYECZb//K4jzPy8r6LO86
         K69A==
X-Gm-Message-State: AOAM5308HwhzZdUv+3UekO00dze/5oJP73ht2BP7Sk0kbMc6zk15hhA+
        /SWQgx/mQ9YiGallmcZX1tgD
X-Google-Smtp-Source: ABdhPJwEf9q7K+8fM095savkdZMyhlDjrRobkjZESbedR0oEQCTGZYAd3VKwC0os4Ga4JWS4ZrlQwA==
X-Received: by 2002:adf:fb4f:: with SMTP id c15mr1679508wrs.507.1637800173995;
        Wed, 24 Nov 2021 16:29:33 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id f7sm7784377wmg.6.2021.11.24.16.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 16:29:33 -0800 (PST)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: dsa: qca8k: Fix spelling mistake "Mismateched" -> "Mismatched"
Date:   Thu, 25 Nov 2021 00:29:32 +0000
Message-Id: <20211125002932.49217-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a netdev_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9e3825a7537d..55219f036741 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2281,7 +2281,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	if (unique_lag) {
 		priv->lag_hash_mode = hash;
 	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag, "Error: Mismateched Hash Mode across different lag is not supported\n");
+		netdev_err(lag, "Error: Mismatched Hash Mode across different lag is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.33.1

