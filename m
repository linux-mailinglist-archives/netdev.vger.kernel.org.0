Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32EE34B2BF
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhCZXSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZXRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:11 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF24C0613B1;
        Fri, 26 Mar 2021 16:17:10 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id v70so6970505qkb.8;
        Fri, 26 Mar 2021 16:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBYGTUK8GYavuLf/iCHVhrCnO9daOXoNPQjuEkTzcq0=;
        b=QYr8bXwQlBsDkgreDPZCy4z8pbbVjLDzNjBhd36uop2xbAvo/I8K/lnYzmvP0KYfZR
         OfeGpsti5UTS3FBeWZMb+S+uwhwuBxtO/gcau5thPnV3GwFz4wFCQrxGXk/+gqMn+DTI
         /ymtjki1SPUDAjBxSbkMHZUIYMRkg6VEuRQM/UJDiKH7H8oB6KR81DqcuWQlz4vG9Gls
         LiCORk7CgQeIKf7x0Tw2kO0GpB5Rf8kn5Ub89VtCqtBNUFcSXGPusSRanc4nP28+tDae
         F8yq9G/xkAgSCIPFx4URf0CBjKyR8ngZ96RzzFxQdepcGcx/MhFV839SutxzrbHjL7jr
         iyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBYGTUK8GYavuLf/iCHVhrCnO9daOXoNPQjuEkTzcq0=;
        b=gMKwNr0LhHtzelnsYxyiKJqk1ZiQfksue6B+QrfZse+mAtYO/nZcw177kkAsrpNdf8
         BRhrYXkoq1nmibJY2gzt477aOqE5+I3ppMAyFn+LdfhW6A/EiuERZpZ/vCDmchQPVsai
         tNmn7qeQxlrmjWAokMUEXr69j3tsBLl4COvEOpASCvdh14jqKO26/a13u8Du0iOOM5MA
         ER5vRUPC3hc9ohdN4C6lG87WZyki/m4bu8DA2Mjz21/0DkFKavnl9N+OY93jtuigah5v
         PekN2HJI+bB7n9GX993RDGt6ehNfvVvBeDBYN+1rbPjOdsXCpYVNpyNnXbm2aSL0bzrZ
         va9A==
X-Gm-Message-State: AOAM5324/VNzkgm2MlJqfcqFoQaQYclAbtKgWp6SpIAA5QVUflf72O7U
        cB9l1Vv8wyb7UFDDixw3cHs=
X-Google-Smtp-Source: ABdhPJzKxmzeLHn8OhEOe/1oy7MBBEnAReoeckBj3SaC0F2Gk3Kt2H994nLkjehto6zykLSOkt07YA==
X-Received: by 2002:a37:b206:: with SMTP id b6mr15537098qkf.275.1616800630086;
        Fri, 26 Mar 2021 16:17:10 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:09 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] reg.c: Fix a spello
Date:   Sat, 27 Mar 2021 04:42:51 +0530
Message-Id: <20210326231608.24407-16-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/ingoring/ignoring/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 21536c48deec..68db914df642 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3404,7 +3404,7 @@ static void restore_custom_reg_settings(struct wiphy *wiphy)
 }

 /*
- * Restoring regulatory settings involves ingoring any
+ * Restoring regulatory settings involves ignoring any
  * possibly stale country IE information and user regulatory
  * settings if so desired, this includes any beacon hints
  * learned as we could have traveled outside to another country
--
2.26.2

