Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21A5327F96
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhCANei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235748AbhCANdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:33:31 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A20C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:32:51 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e2so12222428ljo.7
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wQalGovUJHUxAGD0LzoropIg8ifJImgRXYB/UBdo/FM=;
        b=EcfV03XOGJFa9Su6i6rEg7ozmay2Y73SCwaXy9mUdFcf8VZB9iqoLYtxN1eJ0TZMyv
         GiIuYkz9/oeMG/srJECF6wVRcmfw2T7N7jg8MtFawuKNqscHpDP7gsl6JgXBl/k4s4Wi
         0TugNsfm0WtHV7xLute+ltCZkoCPfuX5AxJuseCPTWO73hFfRV7h9/jCIh97tlRz8a23
         fLlHUATlHqnuHUVVrCWkt5dSZa153HOQ/VK49Wjv1pFffmJtrt6P2HI2yyq1XerJKGs2
         CqLC+JYqhzzYhhiUNKGXTXgUFCGONenhdiwhJBh8D2++tRe2wILIX2H1hwpJ/sk5bjgM
         12VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wQalGovUJHUxAGD0LzoropIg8ifJImgRXYB/UBdo/FM=;
        b=B9iFO1DzOzAN9sVXIAl7kkF+Ap/mDD0bHYAKl9me+nHaDvHJ5TQU4vQX2p9ias3h+J
         3tWE9lD25DQjb4HbqR4ZeSqf2p/ZJcXxf+mhEPVoAfJAaYGxsZTzjBy1esPb5KJpDqUH
         JRe4Cl4IsEOr8hs1JQ3SbIvJkeDjPa7YUbNM223Q+q7HR0iHixsEgZffENJnRsbvdSEd
         v84TCCSZJody+RDLKYOIjnZmte9SM0OOM3qZInsalVDQtFsywIW4QivraJ3Hm7wsQH7m
         hfvEhTBkNHdyv2YQ/5z0Ud+nsErIKqvW+sQeZDtThCpZXUlD4XOCwfvss456z/M3fPaS
         OxYw==
X-Gm-Message-State: AOAM531cs8Woq54y3Phl4xSozUI9uqFRzMcpZTe5ZGzm3xYXP20bhqWc
        /iUgxAlAafSjN8MR6qOwJGNRMw==
X-Google-Smtp-Source: ABdhPJxR/s/YeU6BHx10y93yXvwFOHeXlqvVnTk3eN0xnU8qd6k8rKSlKypTE52EJrnMhmlamjGZag==
X-Received: by 2002:a2e:9b90:: with SMTP id z16mr9190897lji.71.1614605569686;
        Mon, 01 Mar 2021 05:32:49 -0800 (PST)
Received: from localhost.localdomain (c-d7cb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.203.215])
        by smtp.gmail.com with ESMTPSA id c9sm2310066lft.144.2021.03.01.05.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:32:49 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [PATCH net 3/3] net: dsa: rtl4_a: Syntax fixes
Date:   Mon,  1 Mar 2021 14:32:41 +0100
Message-Id: <20210301133241.1277164-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301133241.1277164-1-linus.walleij@linaro.org>
References: <20210301133241.1277164-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some errors spotted in the initial patch: use reverse
christmas tree for nice code looks and fix a spelling
mistake.

Reported-by: Andrew Lunn <andrew@lunn.ch>
Reported-by: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/dsa/tag_rtl4_a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 8098d81f660b..9da56c5ea9dc 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -36,8 +36,8 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *tag;
-	u16 *p;
 	u16 out;
+	u16 *p;
 
 	/* Pad out to at least 60 bytes */
 	if (__skb_put_padto(skb, ETH_ZLEN, false))
@@ -55,7 +55,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	*p = htons(RTL4_A_ETHERTYPE);
 
 	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
-	/* The lower bits is the port numer */
+	/* The lower bits are the port numer */
 	out |= (u8)dp->index;
 	p = (u16 *)(tag + 2);
 	*p = htons(out);
-- 
2.29.2

