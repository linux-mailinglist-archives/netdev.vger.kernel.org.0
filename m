Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1373734B2D7
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCZXUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhCZXSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:22 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C938C061356;
        Fri, 26 Mar 2021 16:18:15 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y18so6945059qky.11;
        Fri, 26 Mar 2021 16:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3LZcU5hMZHl4FiodgPug7X7lOkYA6hwhJ+JtabrI8+I=;
        b=oQrfpU9PNPAB3vzntBMJF4XdJJVg8anr8Ks3mSDvOg/p3TJTKqOxvgHiXBixyzhqqg
         DEZdEFoVMNgaBBUluHJKhHTMuKSb//W1bwXK8gCNp1h2vIsY5bb49m+sFnaJlcavWZrl
         2zhHrW7b7n/mNX0rfjHsjiAiv5LbnW1rHIpwGk4qmCw451wzahkjbS+ys2+mvdw3XhlF
         kk8yi0lawqojIQq2dnCc8QcJTKTQqx6xPNjBWGV0LyAUBuAddnq18lD5+ATq2TjFfSxf
         +Nw5A58m3x8/URKsBG75m0/gTLbWnrUi96h9vEf6VwVXPNpic9Nt36qCj0ttXposwAq1
         2A/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3LZcU5hMZHl4FiodgPug7X7lOkYA6hwhJ+JtabrI8+I=;
        b=P7mYOnDSfJa606q+1yZfdKnlbT+Qz6JX6jlz/B4igsNv23Tzb2YOZ4FXSGDM5TIvTT
         NjZL0VQp5ZGWl5nnbEIInReyD5j9fle1tRnqpKKNSLbV2MiWvkiLSR4lTcK0b3adP2+i
         k+Z0q+tyiCa3ei5fXl1P9fCo+MKWajnSG8BlM9DIs2H8OUOIcEmf13B6cu/WdIamzdvy
         EI7/AJmYSIF2LwZsUo/WM7EhVuI4CeLARXl2rSQ5CWDs6UNiVyDFY2nwTCVJiSIlz885
         /JcPt5q22tfWOZTFAoGWsEm9hLK08T8JWYtInp/iJquMCq36297YiGfFPkpblpqE9VV/
         tXuw==
X-Gm-Message-State: AOAM533OFZsb0vCpMRfysVB/7kQz/Lb1kUv8nkd9RiF/MGglxSAjHe9Q
        11qu5EDcIfZ1Py0iF5Ywb7g=
X-Google-Smtp-Source: ABdhPJwX+x65rOraBIqEv+ONDDQYkGHhJKejpc4gEsoryVpVuLT/fHuJX/CrZRA0UhzfksZf2FlBjg==
X-Received: by 2002:a37:86c6:: with SMTP id i189mr15520427qkd.149.1616800694511;
        Fri, 26 Mar 2021 16:18:14 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:13 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 15/19] kcm: kcmsock.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:43:08 +0530
Message-Id: <ae0af362e80a736a78c2ddb355c2b7c9dc0ff659.1616797633.git.unixbhaskar@gmail.com>
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

