Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D45139449F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhE1O6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:58:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47159 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbhE1O6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:58:01 -0400
Received: from mail-ua1-f70.google.com ([209.85.222.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmduT-0004C3-Sg
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:56:25 +0000
Received: by mail-ua1-f70.google.com with SMTP id f2-20020ab006020000b02902124881cdf4so2032575uaf.7
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rqhoxm5CLlbJM/5GAddet7UbrdiBVjWGcbVsawnnnn4=;
        b=PLYBA+yeBdMOW7Z1lbdCL3qvKZzIXoLzA6HN6d9/FFBIUeFYdf1+L0+oyhQ9kWV5+y
         dr5jPDXaiTfiPaP7RbD1UP0ZrIwebkbJzuRY7aHoEj2tZudVy0/f6jCMIa7EbQB0WJEp
         ndLpjtyI3RP3q3TVFvWzjZ6cQ6n0KufOT3SONHaNQkqMfosdD3SIvxsE2U4w2yk89sDw
         /I89qBdUukywumK0J+VBJkNN4PKcLlEn0eJmXsfrZTLsTtRI4JFVJ4AYg9MSYrHxi+gg
         1ODqLnTPdRJ3o1QeiL0//OPevmIXV0WES2EybBiAMB0Jp+61cJJRO1jCNAU7tIzmnmeo
         VcDA==
X-Gm-Message-State: AOAM532sSZEw0JNkAGAbxMOcZKId5fozP9Ya8BDlPqa4nxgwrYVoA7Xd
        pK73Q3aY2pceFXyfO1dyVoWbPcOktvnjWH+Mre2N4Z82GOTyzfSMlYYTEnBgiKYTaWB5eFCd+W9
        PYJx52e7o6Hb8HuIYTU/z3ky2Y9YMtFHq3w==
X-Received: by 2002:a67:1502:: with SMTP id 2mr7636623vsv.54.1622213785091;
        Fri, 28 May 2021 07:56:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb8OO4o34xFfvAGeZ0PYHDdIKkTWfBSnGw+mGLR8E4cGsVQB+Bf0IFKJj9Fq2M/cw1lgOsWw==
X-Received: by 2002:a67:1502:: with SMTP id 2mr7636598vsv.54.1622213784821;
        Fri, 28 May 2021 07:56:24 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id c15sm743661vko.15.2021.05.28.07.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:56:24 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/11] nfc: pn533: drop unneeded braces {} in if
Date:   Fri, 28 May 2021 10:55:30 -0400
Message-Id: <20210528145534.125460-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
 <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
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

