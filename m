Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE19435B30
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhJUG6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 02:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUG6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 02:58:48 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF97C06161C;
        Wed, 20 Oct 2021 23:56:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q187so1320115pgq.2;
        Wed, 20 Oct 2021 23:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H+3CzxFOqPdvxqbUZ+r6PKM91FxNXk6ExuAoJyO9bjU=;
        b=HvXL02Qbs/oooQAU7Cow+xBtShM4yYJrRED/jXGUxI0ihXg4cdLE696xfQSP0faH9v
         vsUijdvl4sMXXFK2ma/QPV4t6ztobLcaHn2OFfpb1FxcMkVz3VlV1Ok1M43A/flQJj4b
         FuxGUJicclBXmNZpO8F6FVZl+Wty3FEIYOgbBD2hZOANUP8IaLFOhKm1+qRSgj/141gM
         aea9H7z+nO+XPbpgDww+p7KH4SbAM5DVHgLFSM/OcmpWPa7bU3NjNBq7oe7dEvHyu4Tk
         HS2A/wXsYiGegaUewO6zTOnMbZPjy4c065Ot003e4JKsypHuo1CXw/LpdWNBpKQ0TteG
         U+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H+3CzxFOqPdvxqbUZ+r6PKM91FxNXk6ExuAoJyO9bjU=;
        b=r4eT3+jCzI3/PzllTjUURXw8JZA0YemPhMcq+0Ixrtaz+yNYzPy0gvB5U6ivVqoWA2
         ZnJLX83R5qJhhkTUwybLXQ+j4KRtCHIqe6U0jsS2m8zpiZ/j9lOoyIfJ7r1Og9aN8PlF
         8fLDufvd28MPYrmE34VSFhJE20ObIaaXi5Z1P1fJa6u9M/7Fi8I35l3PnYqeYW0Exs4C
         LbkR6E4X0YVQ6CKyRudt8HJEdptpHeoU9WPovaS3u7ooFuFWlu2of2o3BrCMF1aXCIf6
         HKYVbBLAET7ognP19wcuD1SLwvMj1809cNXScUoFII/Sr0kLF5FnAUKHFMY1ebtj7tIZ
         5YpA==
X-Gm-Message-State: AOAM5335kfGV8MHrbtBVNQQyKB/PfEBb4eLF1wtkO/pIPjW9Yu2lj34u
        75UmC2CP8amtofc5vbG3x24=
X-Google-Smtp-Source: ABdhPJx80Cwz4a6vmHSm1syu7bxTpyjMlXDRbO16nxEW+vQ5V9MY7bTKNwGFfG0kUOQfMBTLSbM+OQ==
X-Received: by 2002:a63:ac55:: with SMTP id z21mr3100078pgn.200.1634799392907;
        Wed, 20 Oct 2021 23:56:32 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h22sm4685257pfh.85.2021.10.20.23.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 23:56:32 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     SimonHorman <horms@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] xfrm: Remove redundant fields
Date:   Thu, 21 Oct 2021 06:56:27 +0000
Message-Id: <20211021065627.1059440-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable err is not necessary in such places. It should be revmoved
for the simplicity of the code.

The clang_analyzer complains as follows:

net/xfrm/xfrm_input.c:533: warning:
net/xfrm/xfrm_input.c:563: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/xfrm/xfrm_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3df0861..70a8c36 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -530,7 +530,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 				goto drop;
 			}
 
-			if ((err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+			if (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 				goto drop;
 			}
@@ -560,7 +560,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	}
 
 	seq = 0;
-	if (!spi && (err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+	if (!spi && xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
 		secpath_reset(skb);
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 		goto drop;
-- 
2.15.2


