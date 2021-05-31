Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60691395659
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhEaHlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:41:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60619 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhEaHlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:41:00 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncW8-000386-Le
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:39:20 +0000
Received: by mail-wm1-f71.google.com with SMTP id o23-20020a1c4d170000b02901988447856bso2063030wmh.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rqhoxm5CLlbJM/5GAddet7UbrdiBVjWGcbVsawnnnn4=;
        b=aYDlTOXgpQOWQmyD4UEBBTuZMVRk0f3HkDCCB+fdLe0derufBa9HatDOqVZd7ar3jb
         HwURxLcHiqQJBvccS9kuA7k9Cahy2MA8Wx1LYZeT2SCJ4fZ1rz18skg/rI6U2+ZkB8XL
         kkv3wv6VFt5EO4yz7rLaHnBAy1bz1gfgL4ozjbyzXSxaYUXadsirE2NTEDhp90smU1C6
         BoyBfu1HyC+q6lwk3PJa/kReHgYExhQZtQdtzXUBkZP6wugt21aSBtoKEiVcZbJzDcLs
         BxXIHTNh7DARgIfbYfs/XQN1TmUcFJhX4WYK36DMIs0ihWR11N+Bl4MsN0ItE0MPTIvp
         AYOw==
X-Gm-Message-State: AOAM5306Rdl2KjgMElvyV3jdrZOsCO8Q/TQZWmaDp4AA+nA7XUQplAZ6
        pBZupIH1hbmp1kwYPya1UIn5YxW0dRuTfYDoh+4FMyFBkPTM901SVJx/jaX1P110YR8vZIZdAAx
        xcOcJYsBnxTnd3jJbqgT6X7SeXFDVCy8IqQ==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr4723193wma.89.1622446760489;
        Mon, 31 May 2021 00:39:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3sisp3Wo09P8lmTnXy6HbSldTGXnsq3kSNvNn0N2+ZhFPrlfzfkHfeYDOg39Tl+QlYG3WJQ==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr4723180wma.89.1622446760345;
        Mon, 31 May 2021 00:39:20 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a1sm9168911wrg.92.2021.05.31.00.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:39:20 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 07/11] nfc: pn533: drop unneeded braces {} in if
Date:   Mon, 31 May 2021 09:38:58 +0200
Message-Id: <20210531073902.7111-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

{} braces are not needed over single if-statement.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/i2c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index bb04fddb0504..e6bf8cfe3aa7 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -192,9 +192,8 @@ static int pn533_i2c_probe(struct i2c_client *client,
 				phy, &i2c_phy_ops, NULL,
 				&phy->i2c_dev->dev);
 
-	if (IS_ERR(priv)) {
+	if (IS_ERR(priv))
 		return PTR_ERR(priv);
-	}
 
 	phy->priv = priv;
 	r = pn532_i2c_nfc_alloc(priv, PN533_NO_TYPE_B_PROTOCOLS, &client->dev);
-- 
2.27.0

