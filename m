Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E855D34B2B3
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhCZXRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhCZXRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:22 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AEFC0613AA;
        Fri, 26 Mar 2021 16:17:22 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id y18so6943466qky.11;
        Fri, 26 Mar 2021 16:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lf83NnvQNObreSlx4By/z6+uWxcteVnpmZrJaTZrSeQ=;
        b=Xf1icRGwyStLA53gzoLfTMVO59ECeVga5/E3y50ktJ7u0KbqHOG9jJfyx2J6g2WGwc
         ywEht17bKtPSrhBQm6xwy4gr+5mCw1G6Od0BGRQQqpw0S8RL/RN63W+p6hVPsljE+zuT
         02KlmIo2BsBCOY/SVmZQwekZRlIedCACRyhHPI+hW/bqNmTiKOOkjR39q9rFCsFrJnWc
         f3Yus7Vw1IG8F57S7ufkPddzmMq+m9Dvkbaw0/U4f4ZT22iFL0A8bo++HqRC/AV0T5dh
         dJ9Fkbt3RhAaBn/873jEIZC54MbDHwPHqo9JvjDI7v6hPgEDsLE67Rbp1z8goOaGmQdm
         gT/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lf83NnvQNObreSlx4By/z6+uWxcteVnpmZrJaTZrSeQ=;
        b=DhIrppAAkDvLx+YjZPMqrI58LKMCwGPktqpLVgLyYPNJk2DVlN1sPes71vJ4DW/8/u
         XR31jVgknqZ/hMpoUBOncm0+83Q5bNBSB1IAWK9vv4OwKUYfUJn2gRZnx56KkegSt1Aq
         IlBaazixr7ASNlLVJ/a2YCQX4/A/u5yp5HEIC6zZfL69yYrkSzRRGhbHb2mtzW44GDGO
         Am+e56y/VgE4lVCF0L//VhVcHF9t+BuBu8rZBXO4d4b2uzldPZR8w8SD32WZo+ICTTPd
         HUCh8GU9PGBwniv9waVzJIbWq/ncj/Y2haQdOqe4WbG+GXtdjX7QGnrxgXo8llctr3wn
         4zNw==
X-Gm-Message-State: AOAM532GWBFsiYghy6/GEjGrWpFroJYlcLhvEePlP5KwjUhMvRB1fRbd
        zXG/RcTVmPZXVzTJXlNYfzbZ4qG/olvodttz
X-Google-Smtp-Source: ABdhPJw5Je++KPQEqhjIDqHSKkj9+SfpAoUSf/cpcaPSiwAhvZftx5/wc36J9mSg9UEdxrblwfTAwg==
X-Received: by 2002:ae9:ebc3:: with SMTP id b186mr15033284qkg.335.1616800641508;
        Fri, 26 Mar 2021 16:17:21 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:20 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] xfrm_user.c: Added a punctuation
Date:   Sat, 27 Mar 2021 04:42:54 +0530
Message-Id: <20210326231608.24407-18-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/wouldnt/wouldn\'t/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5a0ef4361e43..df8bc8fc724c 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1761,7 +1761,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,

 	/* shouldn't excl be based on nlh flags??
 	 * Aha! this is anti-netlink really i.e  more pfkey derived
-	 * in netlink excl is a flag and you wouldnt need
+	 * in netlink excl is a flag and you wouldn't need
 	 * a type XFRM_MSG_UPDPOLICY - JHS */
 	excl = nlh->nlmsg_type == XFRM_MSG_NEWPOLICY;
 	err = xfrm_policy_insert(p->dir, xp, excl);
--
2.26.2

