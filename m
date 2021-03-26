Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3634B2D9
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhCZXUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhCZXS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:26 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FDDC0613B7;
        Fri, 26 Mar 2021 16:18:22 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id f12so5455056qtq.4;
        Fri, 26 Mar 2021 16:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0l8V7CorvAnPcg1qRBB8D9DXTn4It7jrKHFbMzdYRA=;
        b=XP1olMsmyMwZL9XNOcUEXoXTAO2PQAApLZhWY7Uz1y+JK/G5eYJeT18hxDxtcvpiT/
         AfjP0LkwNxxbgaMIHCBzTWR/mJEW0NDEmDx2oQn/4qM86D/oOdWSdsM8BGbRNBE6TY0x
         zDNiWK02rN/JlniFOhOTrKUnIQs2RLPvEJILFwOt2lN+VDc0/ka1bXJqNPNrX3x/PoEp
         inkJWR2Da5J0+zY8h2sE8yKIUT+x8pjzx8cLIcojxHmy1pnou4w/yCisdKCW7dcGGTbj
         9SmkOVPrJzqAcJyI+pTVYWv+bOTwzavkvowvdzxqjv1yZQQhNGAcxmQSUrQ0uM4Ql9++
         wtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0l8V7CorvAnPcg1qRBB8D9DXTn4It7jrKHFbMzdYRA=;
        b=H5BJI/Qk4gJ541KQDXmQ7TD8rrTKvrfsnDuPK317pcqXsrddLbGUw9ECF1a0Ir6fNp
         9tkjRU1R0EAkdoSur3nSGbHYnzW/tYBgXMW3/+WMYRI4j3cY+Zh/ZZcDV1NWsi/HV+PC
         fJzJWxv46cwNvSpqAgO1i9o6LAN8cvny0ISth2ch0u3cz58P9O62hZRSDj9Vdx3MljWz
         8XlhXGd8cq0EEniLIYz46HXGIcy3i2Id0T1jzwVy4q84zpQYV2I7RHB6LWMBbq2oHldx
         OUrhovbwU3v/Evgl9f/636FLLveVd9qRWWT1RBhBPSHFxfMbKwVC59IME6kJ1Sn6Na75
         85qA==
X-Gm-Message-State: AOAM5315F0d6/eCak3jqGkiIWCye4ee0VkyY5ka0rfY8Ojp4QqNjyDik
        GXRq4Yj//TJHIk+2Pp2FcTc=
X-Google-Smtp-Source: ABdhPJyfRnN7sVMYqP4cZzzxMB09PdSR3iCeGPG+cgzgW0Ie8dEbroMKj6HWKlU7PlpV5THuIu+LQw==
X-Received: by 2002:a05:622a:1704:: with SMTP id h4mr14526124qtk.30.1616800701961;
        Fri, 26 Mar 2021 16:18:21 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:21 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 17/19] ipv6: addrconf.c: Fix a typo
Date:   Sat, 27 Mar 2021 04:43:10 +0530
Message-Id: <aba66c9b74a9f2763a61794dc67345fdcb42619d.1616797633.git.unixbhaskar@gmail.com>
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

