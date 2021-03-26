Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EDA34B2B9
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhCZXSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhCZXRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:33 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A36DC0613B2;
        Fri, 26 Mar 2021 16:17:33 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 7so6969754qka.7;
        Fri, 26 Mar 2021 16:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBYGTUK8GYavuLf/iCHVhrCnO9daOXoNPQjuEkTzcq0=;
        b=fIeQqmKyGG4YXJ6gQh/3Vwy97gRpJBf50tC2oaSCDhWjACG4qgL3s2olrbtRoy0ynC
         76oGj/hEoNeGPpJDO69TEtqhBvhy2cUDOTlc8R1iQkbM3SwsrdMVv8X70Beo8cAQZ6Q3
         JgvF/lnxRdWEPjI+QksbGta6qnoLXvfnhlS75TUrtoAQid1a9X7HmvCregKJ0Jr+IYUS
         DTDhieH+d8j6FOkEqU3uUGOY/2bnEmeWaejHO5kQAf6V85l/NyHf4tNXaG+d0U0QZe6A
         Q5pCLphKmKU7yhNTnv+mBXyukX42ASxcSXitmF0TgeaJFLYg1EfTKzta9zCW0Dqg2Vsk
         0DwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBYGTUK8GYavuLf/iCHVhrCnO9daOXoNPQjuEkTzcq0=;
        b=CncPKIjTxrV9bwnW0YqG1d1KWndtLN25lcPetjrQ5STrDIMVgbSVcWPr29Y7mQTYA6
         WWbvYgP85sJH3tBEgxwTI7iIU7AYcDOPQY6ohJXDivRO6vEIzg6JzpQ0wOpSJBugluUv
         5UmmywK/GfYHKkCRsrgXKUk4E2CY8gG4damooExUWhHlGX+czckUgf4ZOoAOcmLkhAYW
         YE42RAUZUOliLwQTT19eVh8pcXpsXLMxxLlaeJyhMjBvpwDdYysLTKJTZZyC22hlLpZ4
         QdiZOOuzm6En7FH5hA/G2EtQ0wGmBSp/TGrCWfytZ8rtro5yHiBM30QyGhKgCCg5z1CA
         zRRA==
X-Gm-Message-State: AOAM5316ZqFFfTHXPKap1df2jj4Ksryj1wyHacdjj0bHc7RrFIVbZXIY
        hQTtPJTIBPbLoiOTEbRlizSoCCZ9EzaWynpP
X-Google-Smtp-Source: ABdhPJxT00qaBwp2BSFoDj/iZJvqRXjtfjdvb7jgnz2GZ7QxQgHjJyMrh/y6vBYkmrcNpXFdPz4jww==
X-Received: by 2002:a37:e16:: with SMTP id 22mr15196088qko.145.1616800652440;
        Fri, 26 Mar 2021 16:17:32 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:32 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 04/19] reg.c: Fix a spello
Date:   Sat, 27 Mar 2021 04:42:57 +0530
Message-Id: <340e0c3022c9af6fcf602b8b4f91a54b2b9d9dcc.1616797633.git.unixbhaskar@gmail.com>
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

