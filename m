Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2491B830D
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 03:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgDYBjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 21:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgDYBjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 21:39:35 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17D1C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:39:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f22so6809394pfk.7
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wiXHs4ys73TYcpblkpJXF4R0nHpb6JmY7Gjy5UoVLKE=;
        b=DgU6WDNKe3muRSTaeVzvhgT7qCrldRfzgvKqeSNxjcY7+Tf5g9O4/26Ju0nGy3GOuR
         QplO15q5mUWAKzghewCx/mYNdo0bs6NZjbBXDmDAbHyZNwv7OEtkzFs8uZpWX2fiTMkV
         LQZZuFzRC6am2tZJH7ZEwtWHuTXis9Yve8SvUTLxJdXmJTG+4qqkYp7GJbmiGmLPt6qo
         2pCSM7+c8fFxEhY1np4xb9kRmckzPuhB74O4p1JVLE/43iUAkgzkNaib4GWTenU8MbkO
         8D0smFxWR3A37ukk8BgDmpxbfHDTC/sT62wM6uVyW3wKB0vv4DtJfQqiwYF7i0ZagNGw
         kvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wiXHs4ys73TYcpblkpJXF4R0nHpb6JmY7Gjy5UoVLKE=;
        b=RS3CsNZhRtQr0R4QOO7acNvBlRTup9Z7nDq0+elPthAgDwz5y2fW/IruiQT2Bc3RLC
         dBRpumfx7y7jcAizdcfrZOoPKMEtAozz9707FrDwQkpMWdbSOwP3NRIvGciAd4vqVAof
         DoI6zu27sbH6e2QOGnjjtnjUpiAAF5ySeZfWJD9q9dVBdQBse/akf2ii7KGUQ0NjhVOh
         Fznl6pO5W5tW5O7Fd2qZXKNjP9wP+PNNQlIAQkyLnyMy3tmED1+/mS2nj68O1LPeg5sH
         Meh4bhinpAPk/Byj+R40skzupiQDXmMpxAHsp2xghLneftHh88xhoCQmvR25gktFGLkE
         vSmw==
X-Gm-Message-State: AGi0Pub4BF6B0bdK/6uJwfd5hgteGQTjrHemq+utf3Gw6y/31deR/f6a
        oaE+hDLzRPTvjf0eIdodEvP99q1XNvZ18A==
X-Google-Smtp-Source: APiQypICHQeBjuL4kYZWk/aCLvooZgGAdobTuPROVYNqwKiy6bCMiLBM0lpvUVCywyHp9Q/q8XK+uUfLNyNOAQ==
X-Received: by 2002:a17:90a:77c6:: with SMTP id e6mr10049233pjs.84.1587778773193;
 Fri, 24 Apr 2020 18:39:33 -0700 (PDT)
Date:   Fri, 24 Apr 2020 18:39:29 -0700
Message-Id: <20200425013929.44861-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net] net: remove obsolete comment
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b656722906ef ("net: Increase the size of skb_frag_t")
removed the 16bit limitation of a frag on some 32bit arches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 90509c37d29116b14b3b1849222c3a6148a0cb38..b714162213aeae98bfee24d8b457547fe7abab4f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2364,7 +2364,6 @@ static void sk_leave_memory_pressure(struct sock *sk)
 	}
 }
 
-/* On 32bit arches, an skb frag is limited to 2^15 */
 #define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
-- 
2.26.2.303.gf8c07b1a785-goog

