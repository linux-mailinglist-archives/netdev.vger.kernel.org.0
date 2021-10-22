Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDBA437533
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhJVKBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 06:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhJVKBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 06:01:35 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F802C061764;
        Fri, 22 Oct 2021 02:59:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h193so2871152pgc.1;
        Fri, 22 Oct 2021 02:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFk/unDSLeN6Zd2YH9wtowdJH9wzXmq91/MwWlpCQJE=;
        b=cFnt1qhhWpeOXRNTDuUSjSMo3dFyGY+C5QZ97og1qwnYMtSrMPWt9UJDnJifPFIh1H
         1IgHTPwJ7yZF8xsHIuSPfar1JSnQalD+on7A2QH+s4MI2WUBh+Wb26D4feFN4jxPY9wQ
         w/oDYod4oDjFnov0BAhO3krLfgHbaNdRcryuxPpRfZ7uyNApZx8hdI8U5g+rWfhArBc7
         4GS3ZPWERELZtR2JRSB7aESuEdKO1hceZapmD6hyVfeaO9sH99oMagYX0jLuhvBVbQ1n
         XFRDQbMCIDfP6yPjyH1UxNhCdmP3xc9KUahTxBXB6ildohSRXB9/bTS3M5HbC6DHnl65
         fodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFk/unDSLeN6Zd2YH9wtowdJH9wzXmq91/MwWlpCQJE=;
        b=UsPj8voK8POZERbVu/l21SQCWokH597QXBxRppm21WYYmB9KfeW9fs5YJ3L+ZDZQHV
         XcaJUaZY2+HBpx7GCFZ17fgxJ7aTVcQXKueWWWEWTSnmofJbOPaAuMm0ftXDtoEaaczl
         d0ARg60PV99q6ADZPkADTR5vYv+kTYXI2BWWFyF47mWNsny6tPrg4pnVgvxGAluBTcb2
         6vzW0t6eqs3D4xIcSREIUlL0NasCkHKWIvj4Y7liUzn6UcAlJpre2U1jMvQchbyfO2r5
         ibwR6OJPUBFyiNFqcveBA95uEezOKT4vhXYqxful992+0qoMI4G9Nz8F9eSY+dm20GYf
         3AuQ==
X-Gm-Message-State: AOAM5312K5qs3UX9MSowyN4QWmjbicyUsEC0GQhyR7KDDD98EEZnlc07
        DCURuSS/YqqCDvamSMTz2hfHD/+9hqo=
X-Google-Smtp-Source: ABdhPJxUyN7O3+WgKI8PIt0fvXk/1fgMbV2lMQbIsYOkrxbDgaOYzSDOIe4OFyBr5+qF1IuFJzLwig==
X-Received: by 2002:a63:b502:: with SMTP id y2mr8535285pge.214.1634896758188;
        Fri, 22 Oct 2021 02:59:18 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y3sm8929028pfo.188.2021.10.22.02.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:59:17 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     SimonHorman <horms@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] xfrm: Remove redundant fields and related parentheses
Date:   Fri, 22 Oct 2021 09:59:11 +0000
Message-Id: <20211022095911.1066475-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable err is not necessary in such places. It should be revmoved
for the simplicity of the code. This will cause the double parentheses
to be redundant, and the inner parentheses should be deleted.

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


