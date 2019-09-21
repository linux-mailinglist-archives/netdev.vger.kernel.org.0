Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E6DB9E13
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394184AbfIUNaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 09:30:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35665 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388184AbfIUNaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 09:30:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id y10so3181933plp.2;
        Sat, 21 Sep 2019 06:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pnn04qHgevTZaK5kdgCA3YAP8U2O8x1F8lJgHFkitVw=;
        b=n9ZCCpbMb0yv3UVdQB64Ec7uqVsdphLLr1Jt8WdehwWA2syqElc1ZnTdMAsUjD+nfH
         0J4dUUqRQ2jfGnbKuqZzvaOXsmA0fzypUx2gbAxQEu0lnJGkrtIxwWhpTjmqGiqthoOA
         lm16AKf/64n7eHeoZ7vB5Fmyg8ht/DotYXz3O6b1gIq+Wbk+hkpjAB3LK5mR86fSsaKE
         CHhgW3vJr08798TPR0Tv6bU4EGgEyMpsz9iZcBjJCkOVommXf16IrwWggC0Aqb+O33Tb
         azpRQF5d9ZKGaHAQMS6+09DMXwIR+jmZxKB/e5qsfYVAyUk6RBdsXERrXihb1XJqw0LH
         huiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pnn04qHgevTZaK5kdgCA3YAP8U2O8x1F8lJgHFkitVw=;
        b=rvxUeLbiN2MEnrWLlVeZcHSbkuYYvhRHG2lXJ/S2FAy6klUFVQnJbPCMEMr6tWNQ3S
         KRd0LdU5a+tWsdOw5IISHaQf7aWVfRnohOOsQaMQ6TZd2dyGL+98TV5nqoOBcglH2dgF
         U0wrphboaH0lWq07xxQgo/5Bw8NKX6IoMc60RDruQJPOiw9NCQhbB11mR78258qCDguQ
         jA+IV4XPlOiXPFUiN9YZJ7ENFqAWVjj3ArhSb+KGpZ1MKNbz43VLba/9oqMoNzo0Pboj
         gJ4SQRvlx9LOcKiih70TDGfpEB26Ue2MV33K/uwEdWx/IX+IB7fyUM93l+R0IXV7yXBU
         M5Pw==
X-Gm-Message-State: APjAAAVc2gor2miPMVC0aHbxdC6gkzUlsq0HDr+ZXFrXCC6fXhYOXIWU
        z7SyP/4/5DcID81VqtzGnf4=
X-Google-Smtp-Source: APXvYqwAENgKAuvMjGpBkgbWHLJUDjgPLY9ufYxVrWK2AyiG9onKbWYP7yEfY0FEzH3qbZAIevHB5w==
X-Received: by 2002:a17:902:aa43:: with SMTP id c3mr21423928plr.11.1569072624145;
        Sat, 21 Sep 2019 06:30:24 -0700 (PDT)
Received: from nishad ([106.51.235.3])
        by smtp.gmail.com with ESMTPSA id 69sm6656632pfb.145.2019.09.21.06.30.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Sep 2019 06:30:23 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:00:16 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: b53: Use the correct style for SPDX License
 Identifier
Message-ID: <20190921133011.GA2994@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header file for Broadcom BCM53xx managed switch driver.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/dsa/b53/b53_serdes.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index 3bb4f91aec9e..55d280fe38e4 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0 or BSD-3-Clause
- *
+/* SPDX-License-Identifier: GPL-2.0 or BSD-3-Clause */
+/*
  * Northstar Plus switch SerDes/SGMII PHY definitions
  *
  * Copyright (C) 2018 Florian Fainelli <f.fainelli@gmail.com>
-- 
2.17.1

