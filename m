Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B37F43D962
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhJ1CjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhJ1CjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 22:39:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9BCC061570;
        Wed, 27 Oct 2021 19:36:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f8so3353310plo.12;
        Wed, 27 Oct 2021 19:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CTo9MfxKH55wjLtTMJ/Hiz4KcpnE5YN1Fli+g0csIAI=;
        b=cmbCEmBFoVPY3oPTrZnlc4Cw0MXrYRaG7wxKL+MZHUSYA5jYkUBa0liCtFkbMvBeUP
         1IULk061tq/MDo+hfHblPX9gTCWVz1nBppI6qDgqZgoHHsTIY+e4MMs47gR7E9rWA0dp
         CEAClX0loM0lnpKgNCkXr5r+RbkYMdDAgkjKC0TMjlWYBnu+FCjPY8W4wvRpt3jXP7JC
         hJC6sp2+xQnlo4Fo4QpcsZyboqbTfEHnkJhZEp1AkfoNNtbEpSMbruoXZnxF835lTwCB
         WENGO2Q5U93rFzQuiooRDLVjTfeZlwWc/vLj56sqBrCTp8fqVbMhW4rXvH5pOrPLbWJv
         JGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CTo9MfxKH55wjLtTMJ/Hiz4KcpnE5YN1Fli+g0csIAI=;
        b=ggf0zJsMlmzwhsQpAjt0OJsYcd9vT3oqFbt84pjonlfVHT46jmC9G1s3eBow5MaOr3
         3oKgouP0fX4gMe/4CazhAR/eZ6WyXw4iSG3Cqt7GDzkVO0rJEjyeaRcVpkfApk1ilNDZ
         Ou240xuYPiDj91qszmhUu9u3CkRIFC0+2LL4dxIB5T4M9Zlgms+SBozTakhJjwpzmtOC
         Y1wZI79ljf/jLJ2evYWGu3e8qB4EJTAtVupdxg6g/Ygio0aQDR4sAL4h2d+Yvc42t6Aj
         Q0pMVlewOKTFX8+QOnkgzGOL5p1ahWe+PQjSChWEvtFlHSgf8jwCKhWCF/QJAZQhx5pM
         KkDQ==
X-Gm-Message-State: AOAM530poYScM0k5mIHLcLqyIJ0IUjKRvRBKKBq14lO2tYbTNFZuRFEd
        uDtZbWrSYfzSdYLh3Ojc+cI=
X-Google-Smtp-Source: ABdhPJy6GB3GsP2bVUUkb8NLWLqRwVu5sBtlJy3usQqlgXVpcnrbkPnzzIcn/J0oze34el3DI6dEgg==
X-Received: by 2002:a17:902:7101:b0:140:3e2c:1cbe with SMTP id a1-20020a170902710100b001403e2c1cbemr1194574pll.83.1635388608285;
        Wed, 27 Oct 2021 19:36:48 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id r14sm949155pgn.91.2021.10.27.19.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 19:36:48 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH ipsec-next v2] xfrm: Remove redundant fields and related parentheses
Date:   Thu, 28 Oct 2021 02:36:39 +0000
Message-Id: <20211028023639.9914-1-luo.penghao@zte.com.cn>
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

Changes in v2:

Modify the title, because v2 removes the brackets.
Remove extra parentheses.

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


