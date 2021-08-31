Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A723FC4DD
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbhHaJKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbhHaJKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 05:10:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AC2C061575;
        Tue, 31 Aug 2021 02:09:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id n18so15994163pgm.12;
        Tue, 31 Aug 2021 02:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ruYftc1JWeVoKKcfbA7HEXx0YC09WyAU0r86mDYsBhI=;
        b=N/pBVrwX7AdT9rcC3hgqE5o9sJ8arcIbRqrJU0spLdoFJ8KY0Yx4sNF/b+5pG0KUe2
         ziaKN1AbNQMgSyzpW5icnh0AlVbqlbhw/sZAUf+EgNfnTolt7TbeZ6GowIVvT+ywLLqf
         B4AnsA3sU9VfTT3695EQ6Qn9BNnJ7oQLtLnZqsDnk3yb2NEhQpBzs/6VG0/KDIvnIHuv
         dstgBLnqQMKiROn21Z16Vpz6IPkX1XA+H3PCpouYG/u/3vKD1JP03YscGt9vD2srmgnb
         DrZqmoXiJMNQcMAe+GJBjnZn7hjPNugYlDsGpk56djcQG9F0oEECh+lCpvmThUBdBJrB
         O70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ruYftc1JWeVoKKcfbA7HEXx0YC09WyAU0r86mDYsBhI=;
        b=kVxiIUsmRIAXuisQcPYs5KtACYdHjLeRBJqg5rZSe9wBMUGizO40UMDLbxPVVECIME
         cyM2NEdk71uZHPBHQpvJy6oaxhJvGc3i5ZLEpJP9pxEUkfS3SQQK8i3k4pog267JMSkJ
         EoEzeovy71Lc9YvGh58mJ/wkou94rVQ17TRjcRVN+BBR0YKwOZnYc09oZCRqJssh9kTP
         om3d9CMvF27zCO8wn0ETWjvqmQLEreWoFJQKTwl+rmt3UKW/y9vxnXUhTDR2XMOy7YCI
         jVbxeyUHwNBd8iWEjuh0dZezaM27jTWUzMADINxV8+PX1N/AZi6Ww6TBK0LZfjrsRUA/
         8lGA==
X-Gm-Message-State: AOAM530joiefKIiz++LNRP1YFwGYZQ9h/pczMvEmOyzUG0JMFBBdvz4y
        PQCW0LTP/Cw00lO7QzgZCM8K+mBvu9o=
X-Google-Smtp-Source: ABdhPJyKjsxAemWS/pltAEikzHmgoiie3Xx4Cmk7qlWYkbKeAdCOLVJi3hAP4teEFdASKombX195vw==
X-Received: by 2002:a62:5297:0:b0:3f4:263a:b078 with SMTP id g145-20020a625297000000b003f4263ab078mr21679863pfb.20.1630400956687;
        Tue, 31 Aug 2021 02:09:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 15sm16814087pfl.186.2021.08.31.02.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 02:09:16 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ipv6: remove duplicated 'net/lwtunnel.h' include
Date:   Tue, 31 Aug 2021 02:09:06 -0700
Message-Id: <20210831090906.15612-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

Remove all but the first include of net/lwtunnel.h from seg6_iptunnel.c.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 net/ipv6/seg6_iptunnel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 6ebc7aa24466..1bf5f5ae75ac 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -26,7 +26,6 @@
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
-#include <net/lwtunnel.h>
 #include <linux/netfilter.h>

 static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
-- 
2.25.1

