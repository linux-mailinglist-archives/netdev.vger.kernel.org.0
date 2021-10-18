Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDDA4312F4
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhJRJOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhJRJOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:14:43 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515DEC061765;
        Mon, 18 Oct 2021 02:12:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d5so1400801pfu.1;
        Mon, 18 Oct 2021 02:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL8MKdaHHltkSLJJhEgpOYC4/+7FPpkVJIhEqgGDpIo=;
        b=O52pp1i619tV72LxRafKcU/l6BgSPZD2vdSaBkMYV4kBLQ1gbywFeo5JzDXly3E4aW
         Ij3dMvqaUHZBNdZ6PwtJWzGwdVRqwHdhMVPLYdSfvkfuI+4Rta6oTk4d85G2rJf6fgQ/
         8P8FzY2Fhfr583u05f2VZ1FkScMO0DOJCBZwk7rBNL7O8GGysjbRzBYhCeTCYoaP8aQO
         Hqvs8hPN04AUHLVJqu/Uzx8oHOaHM4auwsCtnyIEbkRwex6R9phVZGMxcUnsoYSvE3QN
         0kRlqtt/Q5zr7pJpym99kZVbIdwtqruTKARcbexhjoVGBy+xlOh1FSk1vWgd7u98C+gT
         LQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL8MKdaHHltkSLJJhEgpOYC4/+7FPpkVJIhEqgGDpIo=;
        b=SOQeLu6L8tlsu93EA6uWOLZox5/xEAzPh2QusUKQzsB3Tt61H2VmstNQFMBCj7JsSt
         UMnlYlo/nDOlvFL9J1MZFB2fiADxdIPaKH1m3dSEqt0mR24aoaWmT/cgAZLWstFnN75w
         qwb05zbcpiFK9HWRx0eox5Z2NvaTdouvqz22GR3L+Obc5L94QSGbBditScVokMd7+PyZ
         hnMC/pAx5cB+3laBycC5Aci/LYa0kqhtE20Z4Go3vELlB2UFrc7LL4mGI+iifk1A1ENd
         paVSZ5ps2GeqynhoxjFWvbZXkPwNKit1Lkr2gNfg2EF61h7j90rFZcVXnRty4vycbMF/
         H4+Q==
X-Gm-Message-State: AOAM533v34fuRIoYBSQSj9apPECHLZ8HUHFi1i99HsgkGOdfhgGOgIOJ
        4lOFrV755bb+oY/xL2dycV+VAdsFUMc=
X-Google-Smtp-Source: ABdhPJwvpkJj2xN8gB9RP+uNESZGw+3UVY7Ctg4j9k+Q0ZHpTwztfBTl4ymMBWEDjh+/ObEJ4WfWBw==
X-Received: by 2002:a62:31c5:0:b0:447:b30c:9a79 with SMTP id x188-20020a6231c5000000b00447b30c9a79mr27633142pfx.67.1634548351932;
        Mon, 18 Oct 2021 02:12:31 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id q73sm13055021pfc.179.2021.10.18.02.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:12:31 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] xfrm: Remove redundant fields
Date:   Mon, 18 Oct 2021 09:12:27 +0000
Message-Id: <20211018091227.857733-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: penghao luo <luo.penghao@zte.com.cn>

the variable err is not necessary in such places. It should be revmoved
for the simplicity of the code.

The clang_analyzer complains as follows:

net/xfrm/xfrm_input.c:530: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
---
 net/xfrm/xfrm_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3df0861..ff34667 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -530,7 +530,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 				goto drop;
 			}
 
-			if ((err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+			if ((xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 				goto drop;
 			}
@@ -560,7 +560,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	}
 
 	seq = 0;
-	if (!spi && (err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+	if (!spi && (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
 		secpath_reset(skb);
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 		goto drop;
-- 
2.15.2


