Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7851A2A29E3
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgKBLsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgKBLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:49 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEB3C061A4F
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:39 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so7536992wml.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=36SrPi/Z2LVhG8V20mNI11V0afy1ameNG58Hej6I4Oo=;
        b=AB2ZomZbif0Q6E/h+qi/uD+jIDq9XFrk8/x/i2O0bgc0EsIuTeU0R222cQVKaR/yFu
         qZ+BomF0Ybbpq/xNxAzGhgLtK/wzWcklZ8UVjxMISTA2AqMuAGXFq0yqYil6P2cWUu2R
         jl5KqOF5pdEjiYzeTKWML4c0yuC1cO27E82Z9t/xXJrZxh/njlIjEeRrnrjyPCPP5wYA
         cGMWu9K7dGNuCOy0k/2hwTeUh+V/oeJ4IPhF7jT/PRWVhFhLkHhDUerdVZ04Eja7IYT4
         etZN4Y4TZBYtIEN05X5PZ6DrmjWNTuu4UxL8vOiMSF3exx18bw/y31aOxrSjX7jYDUre
         ymEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=36SrPi/Z2LVhG8V20mNI11V0afy1ameNG58Hej6I4Oo=;
        b=JNxHRcpV6REJFkRVwtXSp22jrXyFrTgh7HKnEtUiFRVcbH/+FXE46kSi8rWGN3L251
         eLk+zLqXP4l6Q3fwrk2r6bkGa/HOjpFZH7pZZRcv+Wip+6gctruoHmaem6O0RsBKKdS5
         wX/TKDo5ReZYnh9RrFuadjUC4bP3eKoDW3liGvQx0yV/zHZPv4xJpAUNhTbo2rhgMoag
         TV5ax96U0hU49M8QSNC35TNCFIaSuyGMWr26iqjzeHAuzAVk6PTXz34RKPd/UrlfcuvG
         tdH5y4Klqke2nseWaGno8M/mQcSSyYHGxE1AZWfNSpyegAWUA0o1RXLeZgbeUETA5lkR
         mNJQ==
X-Gm-Message-State: AOAM530M4DjeAHYzJkZfpJZsElqCR6FYwYWTwvooI2ehqD9twxTzq2tO
        cIRT6eZI0p1iEJ7d9ONu58AcXg==
X-Google-Smtp-Source: ABdhPJwm8ITipl9QL4iWbgcu9PJNZKX9oUy+oy/ZSMx70JgSyeS21Ego42oSY50uPy8ab0M3rtaQ2g==
X-Received: by 2002:a1c:2ece:: with SMTP id u197mr17571890wmu.58.1604317537981;
        Mon, 02 Nov 2020 03:45:37 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:37 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 15/30] net: fddi: skfp: hwt: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:57 +0000
Message-Id: <20201102114512.1062724-16-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/hwt.c:31:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/hwt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/hwt.c b/drivers/net/fddi/skfp/hwt.c
index 32804ed049cdd..5577b8e14b736 100644
--- a/drivers/net/fddi/skfp/hwt.c
+++ b/drivers/net/fddi/skfp/hwt.c
@@ -27,10 +27,6 @@
 #include "h/fddi.h"
 #include "h/smc.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)hwt.c	1.13 97/04/23 (C) SK " ;
-#endif
-
 /*
  * Prototypes of local functions.
  */
-- 
2.25.1

