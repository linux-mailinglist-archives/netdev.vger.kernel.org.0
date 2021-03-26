Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC2534B29F
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhCZXRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhCZXQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:41 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B11BC0613AA;
        Fri, 26 Mar 2021 16:16:41 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id t16so3763967qvr.12;
        Fri, 26 Mar 2021 16:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gelfyaOHjBFi2yNRi24rGl9gt7cmGiX9dM643pGMFZE=;
        b=Nb34cYV/PZXjf2om9fAtHic79kvt0E6mYWfo6tuQNnB7VnZDceXEyBJbeE/uEeqlBq
         lGgm5z4nZvkFnohRv4Myn78jc1Lpb6qjZhqri8Kgg6IdoCqFYxt9pqbbqUw+ysINukSI
         ueat4JlG8gujgkIo5ZT/9Jpu788QEFPsUtR3rh55zY6rEoKIC+OlOg4GPmDqchoVr730
         TWU/E5XOFI4LQpwa4QWun3AjM6GEjIXsaioG/oBs8kOyR+/HV6uS2W2SbIlsGZKerFi+
         mrE+27MdEgkMqPLrX8x4PYrqBozYVKZYs6Dp7fTNvHFdyUEYMe2dHrtuzj5NF1Ea3vCU
         /LMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gelfyaOHjBFi2yNRi24rGl9gt7cmGiX9dM643pGMFZE=;
        b=pynnd4fvFNoWiGdf/4vzcUTjkqZTZGyiA51DhmrgkskB042kpVV/Z4Cts6rilwF/8J
         6CSLB5+lCCJFCqoxVLQStVX8G6ba/Y0K+MTkKBtGXk/yGhc8ZZ95Yj+UiQb0IzlS5cO0
         67RjZx1V/3sdYk9ZAp109nef1HNjgMYUkEGWv0ObW/3RnP/aybiO9Zk2+LEFtHEMsy1y
         9nMT1TSeIth3YFrqxwxjaxe+SpmG3MiI32VonXxTHNyFAD6o5C4741sNYrtM0KXoynFB
         THGa3pJ+4f+5CFmXXN5i4JvaEmB+uGWBP/TC/chn3H3eI1of+eoDdyBPCSpzXTpAtlO2
         51gg==
X-Gm-Message-State: AOAM530EjKjF1B1ANHHfbktJJl+J5kK0spRnA9RJ8jm095+p1P1L+m45
        R6AhFuWe95ls0nHjSt9Gv7QIpbIBUK9gbzGt
X-Google-Smtp-Source: ABdhPJx/pYEjwIgQVnsaBiTPjRAralQX9ibMMbsMHZVTweZYS0RAe92O4Bmz4DZgqBvtGNqFjmC6/w==
X-Received: by 2002:a0c:f890:: with SMTP id u16mr15718984qvn.21.1616800600357;
        Fri, 26 Mar 2021 16:16:40 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:39 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] kcm: kcmsock.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:42:43 +0530
Message-Id: <20210326231608.24407-8-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/synchonization/synchronization/
s/aready/already/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/kcm/kcmsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index d0b56ffbb057..6201965bd822 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -663,7 +663,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)

 				/* Hard failure in sending message, abort this
 				 * psock since it has lost framing
-				 * synchonization and retry sending the
+				 * synchronization and retry sending the
 				 * message from the beginning.
 				 */
 				kcm_abort_tx_psock(psock, ret ? -ret : EPIPE,
@@ -1419,7 +1419,7 @@ static int kcm_attach(struct socket *sock, struct socket *csock,

 	write_lock_bh(&csk->sk_callback_lock);

-	/* Check if sk_user_data is aready by KCM or someone else.
+	/* Check if sk_user_data is already by KCM or someone else.
 	 * Must be done under lock to prevent race conditions.
 	 */
 	if (csk->sk_user_data) {
--
2.26.2

