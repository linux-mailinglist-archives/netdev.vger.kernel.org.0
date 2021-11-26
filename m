Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD36245EF3F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377523AbhKZNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349096AbhKZNi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:38:28 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF726C061D63
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:50:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g14so38508084edb.8
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E6gc/iXvmbRrUDszUUb8MtmwmsqV6ey1Bi7NnMGnsnw=;
        b=UactvcOihoWUziFH/JtXkc+NRMNeNNikiIn0DCjDSghPQLBcYKmFgkDF451wYdHt1Z
         aslyuBtr7ZA3WTCoZWYofZrmzZdmfnG5/+kXNNxZ0X8aTMBKr+GjuIWuN/YkzbT0j/Ja
         DDJeRbOQvCel5LFkg9SGRFAWitIf+YW2D6Bn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E6gc/iXvmbRrUDszUUb8MtmwmsqV6ey1Bi7NnMGnsnw=;
        b=SoLsmZKWcHm3yEDoWrNHuHaFCVAHx2uEBXz4WYt+p/Sy5u9gCsZNqx1lVDLIMLYyCO
         BY14o/+j7LVMaV71lf9yOpvt3LcSh6R2xaMR/AQw3CRiVGh2tI+czX3YNOKItWO/kh8f
         sUqfjKL7v2PkfMTJOTO2fJsaEs8Vnud7Jx01MzRZtlVZS8fshhugpNP7mrJxgc3w4fyb
         a/ARrAbSv5qNHVtlDL5K3+CVqjzl7Qec7GdS8b6Yqgh91yQBF2G98hIQ0+pNh8H9mBOO
         rzANkC9tRqWjzQDLMQJri2201815BAkDvjJG7teGdGQaq5QXT81BEZq5qnqvYfP1X3je
         Lt1g==
X-Gm-Message-State: AOAM532T/QUt8tAaIY7nkuUnsPnfaxM7HFisbY9YGbE+NcZsJg8osmuE
        aTo++rJmJYvGtRpOnh6GkFtFY1f7M+9wsw==
X-Google-Smtp-Source: ABdhPJwIUuCRQR5xcf5jxhTPHFBcBQ2mDfbJXFdyoVbICtMIDH94c/Om2aF5aPQFVLgw1EGs89QxLA==
X-Received: by 2002:a17:907:3f24:: with SMTP id hq36mr38192008ejc.390.1637931028435;
        Fri, 26 Nov 2021 04:50:28 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id b7sm4435378edd.26.2021.11.26.04.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:50:28 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net 2/3] net: dsa: rtl8365mb: fix garbled comment
Date:   Fri, 26 Nov 2021 13:50:06 +0100
Message-Id: <20211126125007.1319946-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211126125007.1319946-1-alvin@pqrs.dk>
References: <20211126125007.1319946-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index baaae97283c5..c52225d115d4 100644
--- a/drivers/net/dsa/rtl8365mb.c
+++ b/drivers/net/dsa/rtl8365mb.c
@@ -276,7 +276,7 @@
 		(RTL8365MB_PORT_ISOLATION_REG_BASE + (_physport))
 #define   RTL8365MB_PORT_ISOLATION_MASK			0x07FF
 
-/* MSTP port state registers - indexed by tree instancrSTI (tree ine */
+/* MSTP port state registers - indexed by tree instance */
 #define RTL8365MB_MSTI_CTRL_BASE			0x0A00
 #define RTL8365MB_MSTI_CTRL_REG(_msti, _physport) \
 		(RTL8365MB_MSTI_CTRL_BASE + ((_msti) << 1) + ((_physport) >> 3))
-- 
2.34.0

