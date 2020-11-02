Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924A42A29E1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgKBLsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbgKBLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:49 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B12DC061A4D
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:38 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id g12so14189162wrp.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mjt3Wocbtw9EZVTr/SD4kz4Q1tcHUi3KMIhfsvCbBvE=;
        b=Gx0cov5nIz2x7yaN5HH8UOy8R2Ox8QzRdi3nQVVFyw4TSg/bSQd1WY//0r8FzVEH0M
         P0MkxGLBBqichSDYoAqV31dRFjy4zL/hS6XbsbS6tSmsPXxbY/n7E6bXpMGkD79pvQFA
         EgVZmzxbyLAO2ALuz5uVrdp2alHt69bdyKM2nxsCnyKz078+0DxQqAxbWyv3/R7OZWZc
         D0IKLZwblFzcG0iaekr3eTb2YL1crfZfG3l0eTGTMCBHwbC4SHEYDwgdzgqfepFlgEBE
         53l80cLjF/LR+karg/7Izz9Wbs8ocQN285JKixJtpdHE/QyXe4O/hzN/w01uP5FB4Sdg
         PbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mjt3Wocbtw9EZVTr/SD4kz4Q1tcHUi3KMIhfsvCbBvE=;
        b=tfyjuc/F67xu5hAtrhSGqtcklQM+hTwKS0o8OptwcGMda38/qcNQmXNswUYvdZDtSL
         dqSUHZl6QILDxzpXlbTWrKHTltKJB0ihfP67cqzJi0XfxKMiL4b8tjUTNmEOYpXoEWNF
         BtrDbMHPOmSge6D7v5MtIbbNUbB256o7a42wiXOHgMioxlo+gZxiZMlJVlcw+zTRsaqc
         duXGyduCndas2StjPRBjl1Ic2Po4SiLVjO5ksZzdERgdQFS4xgr2IifWamITxhi12Xcl
         VSimP+dauTC7gm2bne70nHTT9exgfXrADTmG4HIbfKzO2hypYaH6d/TCG+w4O+dbfb9J
         ssxw==
X-Gm-Message-State: AOAM532A+/8QrG2Nn+NInpob5sJtV8HVkdRfWKB6eLm/FEmahJTBA51U
        7iwOik1HVQkOnGIoSKC1fOHqMQ==
X-Google-Smtp-Source: ABdhPJzBTR2wxUkuzaQjDGPa5BFIgtswvxD1hxzpDSiggdg4iUOY1fnjalxAifHd9sWNrM8ylXaaEQ==
X-Received: by 2002:adf:e849:: with SMTP id d9mr21044794wrn.25.1604317536772;
        Mon, 02 Nov 2020 03:45:36 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:36 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 14/30] net: fddi: skfp: smttimer: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:56 +0000
Message-Id: <20201102114512.1062724-15-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/smttimer.c:22:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/smttimer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/smttimer.c b/drivers/net/fddi/skfp/smttimer.c
index 9d549bb14f07f..5f3e5d7bf415b 100644
--- a/drivers/net/fddi/skfp/smttimer.c
+++ b/drivers/net/fddi/skfp/smttimer.c
@@ -18,10 +18,6 @@
 #include "h/fddi.h"
 #include "h/smc.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)smttimer.c	2.4 97/08/04 (C) SK " ;
-#endif
-
 static void timer_done(struct s_smc *smc, int restart);
 
 void smt_timer_init(struct s_smc *smc)
-- 
2.25.1

