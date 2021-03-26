Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D621834B299
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCZXQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhCZXQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:30 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0639C0613AA;
        Fri, 26 Mar 2021 16:16:29 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id t16so3763803qvr.12;
        Fri, 26 Mar 2021 16:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lz9mVRBka3iu8jrnsXV0mpLo0L+lu8XxwUnfqgBKhvM=;
        b=oh+yyihuDYRkQhnU6nBIUtBEXmSWZiZx4INK1Ijc9w3Y6YVk0U2+qaJcMCfGF7LE86
         Qny1W3Zm8XXKU7JEwdwipqS2ctZjGR8o4Qf6xS+4+6YgN7fDv6fdD5MMC1eQwmKiyBZj
         fhnMv6weeheuBszMWYmo4hLNbOmkTFcRI6/UFVZqb76ot4H3WpCWO6rdanJqsz1owcEw
         CFqaFksX9ZDcV0qbkN3ihykaaDsBmWGzEdQmMi+hh5AZJKhMtzIAgagzK7ELNGA6EokS
         CnR2N//JjTrqnYTVepIRcXC6gV2DNszHiW/h/L4ds2WY+WYaG7U+h7qDZxuCtc1LV9AY
         L5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lz9mVRBka3iu8jrnsXV0mpLo0L+lu8XxwUnfqgBKhvM=;
        b=KIsz/NNgiM+F8OZ9j1PNhq3R0pUJlTbcVrXjeuPhgH/O4y+ZujDv6iGjAqOu26MK+1
         E1u3MjgYnTQoSwJWRqobh7SeAKEKIoQZOcoGm+fhF1/PziwE2EsIMZr5EoRb9UwLPtss
         z5H5DXVDBlJ6ejMzGk34v/pCRTYmTFlnwABMXeCGfqQEoa0tu/QqH3QhjkfVf9dNnJki
         P3QQ2+7ecqsgWPF6dsz4nm3skZsEhyxpJv3iICqPZ8bpjh/e1Tribj+vPT2+fVTVp3vA
         ZDfiZ9n9zumA319hMmsk7di63gqwUO6LfW1SPo069dn9n3dxlAdH29gMh95duyzOJBPt
         C99g==
X-Gm-Message-State: AOAM533OFXLTVvhKCFtw11VweGB1EKGH8p0id8DRAqgpxYMs9IgZ4s2T
        XrtnmXuulT8kzDzFo8i7iYqckyBpbQtYBF9t
X-Google-Smtp-Source: ABdhPJz+CKsj5kGuf3Al2uth9frFXvoXdJKRF4PJVRxcPFg0xJYmgT2q9eQDWQCp81U6qCmK6CY5ug==
X-Received: by 2002:ad4:44b4:: with SMTP id n20mr15594943qvt.19.1616800589268;
        Fri, 26 Mar 2021 16:16:29 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:28 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] ipv6: addrconf.c: Fix a typo
Date:   Sat, 27 Mar 2021 04:42:40 +0530
Message-Id: <20210326231608.24407-5-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/Identifers/Identifiers/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f2337fb756ac..8421f58ea6ea 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2358,7 +2358,7 @@ static void ipv6_gen_rnd_iid(struct in6_addr *addr)
 	/* <draft-ietf-6man-rfc4941bis-08.txt>, Section 3.3.1:
 	 * check if generated address is not inappropriate:
 	 *
-	 * - Reserved IPv6 Interface Identifers
+	 * - Reserved IPv6 Interface Identifiers
 	 * - XXX: already assigned to an address on the device
 	 */

--
2.26.2

