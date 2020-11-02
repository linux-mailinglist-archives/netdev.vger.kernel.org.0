Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9E52A29E6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgKBLsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728623AbgKBLpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:33 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B12C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:32 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id b3so8305828wrx.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2KZ3fjSfA5rxM50Oa10TVdHu/XQWkPodLQYHhtQcE0=;
        b=bUWQy+kCDkS/NX4JSWWFlkB2qfE5HPUBe+REeZUWKsu/r8ZQBAJZBkMvpvYuQ5kwpr
         q6fP8WNfRHW7dKZDf1G5OCRzTOQZJqtky6GDsfmiX0Oh/cXv6jmWI8Wc8RUnKxXHipIY
         TTeWNg8I8GhuiBcMojie8Z9SrcB+2kgJZg7nJa+3xG/v9zz6t/P2ySJ6/RD449Lc526N
         W6hFcr4N/rdH+GNT1WTtCx0M1pNZDleJfMTCiP+Fw9JoSIUHvz3ISg5kZEoPxaf67u+9
         b7bjBot3HFWvcF74XXvJOZdCLMLD90MLKgIlTNVbALIAju/+SMZrtNmD4GKMKJDVIoSW
         BdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2KZ3fjSfA5rxM50Oa10TVdHu/XQWkPodLQYHhtQcE0=;
        b=tcdCJjznvAplHnuHkxvGLTrV5tHHKRQOdHpy0D8QUPNbe+gMGpFFkXz1MJ137l2omi
         pjYkmUoLibXnaMs+2zSfzREUr7S53XYsLLaMA/6mk64vkbvodLHgJqibXgtwtbW4m3oi
         SebNK7jndD/IHGPteNJkFe0ObKmlhWaBQvF3qS+iL5HGgp9ckyFvOJPOjphAUxy304wN
         eTlWiVTxEOqfehbct5i2wEs3Ji6Y1LoTv0xUGo39ZFnhLcdRt94cWaXZbIn/0vUK5WE5
         JpX1Xdzwlt+2zi80QFxAYy24rqJwnyDAWRjuOGCkfYh6Ty/cOGay2mN2igyNVvMm62EZ
         PzqQ==
X-Gm-Message-State: AOAM533XCdcYHn7dndcEHKsxcI6iywxkbd9rJpkCq9ZJw06efwt7MJzS
        sOA99lDM4t1U2ObTGXRnTMXlZg==
X-Google-Smtp-Source: ABdhPJxnYbxqwLRNHyRJSGfG7OmLrUKnO0ZLPWJGqwZCxUdzeRjJDy57NtJo9lLeu1yt+VB4xlT/hQ==
X-Received: by 2002:adf:8bce:: with SMTP id w14mr19173150wra.242.1604317531478;
        Mon, 02 Nov 2020 03:45:31 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:30 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 09/30] net: fddi: skfp: rmt: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:51 +0000
Message-Id: <20201102114512.1062724-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/rmt.c:49:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/rmt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/rmt.c b/drivers/net/fddi/skfp/rmt.c
index c0e62c25332cd..37a89675dbeb3 100644
--- a/drivers/net/fddi/skfp/rmt.c
+++ b/drivers/net/fddi/skfp/rmt.c
@@ -45,10 +45,6 @@
 #define KERNEL
 #include "h/smtstate.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)rmt.c	2.13 99/07/02 (C) SK " ;
-#endif
-
 /*
  * FSM Macros
  */
-- 
2.25.1

