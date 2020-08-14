Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048ED2448FB
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgHNLkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgHNLkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D6FC06134A
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a5so8067239wrm.6
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q/FqIBvN+0t9cxA9lwdZNhMsYA5WtnJIGQaoCfh6kvU=;
        b=A4lGPF1qqK/RBPApsZIFq57DhGKlB1PAjwNHo/P9mkGoWhYVX2FUFDB3X6YgvnfJJ2
         RcdCitWbbFxdfmNq0Sa/GrH9nUBC4ynez6bbnunyyQP6QTiO4erJqN6e5BJFWaYGhS+G
         FUFc+eX7o3H1MTuWVjUdKmOSXehxLnjWbzMahw4+DGLu4aCkTBOZaGF7NA+UQ9Q6kTrV
         1hszVBGy0R+zA4+TEkE2u9M5hluxntA1k7qEqbL+TXsYfOmxWPuF/MYDU+GIdzg2bZEE
         D6NHZJAbxG1S5zUc53w1FRqMYKYAJyxuVvYRKO5T4mGG0EfDpfaA+LW3X/47qL3EctUM
         EJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q/FqIBvN+0t9cxA9lwdZNhMsYA5WtnJIGQaoCfh6kvU=;
        b=imE9PapXmGKBhBgPxjMgxg16x3gjRqpa0EJ9qjvcpEwwXx/mVdzsnIckDKBkCrmgvC
         LwtJ0RpGjfHFHOVCKN5E+Kh4mSw6W4qFnfHEC0Zp0zf1pzu61ZZPAMr0DAkB3f9UMz7R
         bdgwaE3LT0OFG2KttqgX19GdLz+PL8uS4hitHHmL6o/rM/eoFrSFX2ri4aTLM39fdkT6
         /uXdtzBMFXfts7ldl6IoXt4g3PfwL+qIv4EiR2gs62AcmGNrqQcnBCAjsOy5bATTP8aK
         dkVcKbv4Zx/CktSGFYy3Wh3WG9vf5E+YBe2u+nBRiIr2AX9HQEHdTI5HqWknv+SZORoJ
         sXwQ==
X-Gm-Message-State: AOAM530D/jPFKl44nUeaPAaqhkf18tUvUvzF70feT/Moo5r3iE9E+R9R
        Sxrh6zmH1ux4Bkj+DD34rgdsbQ==
X-Google-Smtp-Source: ABdhPJyogUeYk5/qsdEeYYnSqznYEWxbRW72A4UIroawVH0GTeV1KZwjfpT083upB00uThs9eWNPkA==
X-Received: by 2002:a5d:6345:: with SMTP id b5mr2595294wrw.204.1597405222493;
        Fri, 14 Aug 2020 04:40:22 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        netdev@vger.kernel.org
Subject: [PATCH 27/30] net: fddi: skfp: smt: Remove seemingly unused variable 'ID_sccs'
Date:   Fri, 14 Aug 2020 12:39:30 +0100
Message-Id: <20200814113933.1903438-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable is present in many source files and has not been used
anywhere (at least internally) since it was introduced.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/smt.c:24:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/smt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/smt.c b/drivers/net/fddi/skfp/smt.c
index a151d336b9046..774a6e3b0a67f 100644
--- a/drivers/net/fddi/skfp/smt.c
+++ b/drivers/net/fddi/skfp/smt.c
@@ -20,10 +20,6 @@
 #define KERNEL
 #include "h/smtstate.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)smt.c	2.43 98/11/23 (C) SK " ;
-#endif
-
 /*
  * FC in SMbuf
  */
-- 
2.25.1

