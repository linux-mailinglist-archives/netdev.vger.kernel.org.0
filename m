Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6034D2A29E5
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgKBLsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgKBLpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:34 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62CCC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:33 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c9so7536729wml.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VNb8tUXKXaGPMudLrBc3JPhFZfoOGbf5hBAlPTwGRzw=;
        b=eGhBIevmjNMHiNEGCAcW9TKr7444xX6cMHtFbNgUtVJonOfdYHrUovSmSFG1OEgAVa
         DwSZ+s994nqhFWZDd/NY6vpfOvIYEKPU4jDfh0ai65XIkbJOzPiksZGwt0zvm2HghjfT
         rF7/XWxXygS5/ntS/iGGK9tNS3VKo3XkwuH0JvNBDlU7hCchd5vFUauYE2xgLjSX6sE9
         bJzat6Dk31BjZj6yJUZmqv1eym6NzeAjxWtHY9dLCAdujrwiBQIxn1YJRPO1lgMqRSgV
         kUFefB7DDqj8rDLNCz9qF2eSFKktdYRg49rc+faNAs8gYMJltDeKXtQD4OtckSpML4G/
         qxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VNb8tUXKXaGPMudLrBc3JPhFZfoOGbf5hBAlPTwGRzw=;
        b=s9swCkTGINsnbbDGLM+Mkrb6E/7K9dqAn52VKWlid745PObU5Osk+HyuZl0YT2J174
         ddwr74MO7bTdPXMIx0HnweOmiiS9ymM9m3oLvBC2O1HDCAU3NOYAqpxsx+1Kbsg+U0NK
         sz7bSwcUN1WNuI6JudOupIPSDBfTls05wFAaeu4A9xXlqfdtCWiVDtvw/LUZrdR5BkmC
         /gql4P+S/fjG+kss5Y8yTOkZLynqz/NnNdtcz1cH6o53ykiruDK2CRNyZ9haDgoJTRcB
         dQund+yQXQx/HlAtLN6T5PpTy2XvGryp74RQJg39Unb659L7WDT5Qmyh0nq9vzTEA7I3
         WMQA==
X-Gm-Message-State: AOAM533cmDv7eLhHyPwJPDWO4c4tkt5nFGarw4/ekGxlzcU8VMW5UwM8
        KBcT+feu0NrcNLhO5Xi2F8kwkgR62KTf9w==
X-Google-Smtp-Source: ABdhPJxg7UXmajOaGgu37gUYzDyNFKznZa8dzo2gwZyLGxCJ/DCj9KsQNdbHQK0/87ixIv7G2zhv/w==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr17296806wmd.48.1604317532592;
        Mon, 02 Nov 2020 03:45:32 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:32 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 10/30] net: fddi: skfp: smtdef: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:52 +0000
Message-Id: <20201102114512.1062724-11-lee.jones@linaro.org>
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

 drivers/net/fddi/skfp/smtdef.c:26:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/smtdef.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/smtdef.c b/drivers/net/fddi/skfp/smtdef.c
index 0bebde3c6cb9a..99cc9a549bd7e 100644
--- a/drivers/net/fddi/skfp/smtdef.c
+++ b/drivers/net/fddi/skfp/smtdef.c
@@ -22,10 +22,6 @@
 #define OEM_USER_DATA	"SK-NET FDDI V2.0 Userdata"
 #endif
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)smtdef.c	2.53 99/08/11 (C) SK " ;
-#endif
-
 /*
  * defaults
  */
-- 
2.25.1

