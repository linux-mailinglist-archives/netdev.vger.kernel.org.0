Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5A5313A0
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiEWQRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbiEWQRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:17:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8364D66C93
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n10so14497713pjh.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iPgV0XKVA7CN/1GtqSgXFmgmjxLYIDCCIxwiYiTCOt0=;
        b=oGs4qQZexHkc7tfWnkq4TqIJjsY3Oh66/ArhUO2nd4WliRSG3+JpFmk51aTDd777OL
         OYfZ/DTIw8HFfY+Smu9yUqqJmZRPPrjEDVP32HVFHPzgrN8PH5Yyb8pG4pL6DIXVJmvw
         e/m/6Cw6yo6dGji9llesX/A6PMSNsmfqxtTU2W/mqsRRygII9IrdLUB7LQrG/8fGWY1V
         ntWFszzQvZfixC3hDUsV/9JxhW2whatl9SITh00Woo9dllFA4JeDlNmR5SEQP9M2kDw0
         NXMRAqZAyhmYOu+Za68z2oNP0h0iRXzq6AYF3d5vRgQxiVBVlRXpK2kPYVa71iq8jTFj
         Dg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iPgV0XKVA7CN/1GtqSgXFmgmjxLYIDCCIxwiYiTCOt0=;
        b=DIkerCSb9+S4f2GQj0gUFnt2R6/3ICKh9faq7h2xpdtuwZYlWa1oJdxPxfU74ncaTm
         MG17h2b/LnUWgQAxgb6/NvI36sAaoWBzghhzCif4YLTMDswmsR3+cVxYv1h0DNFuZ65i
         HtVW7x6o9tcadn1hGjHlO2GkCLEjn1g+42TATnlye3YyrnZHpmD15m6b0i6yGIDq70SB
         6kv3iyCzM4s8EnaR6i0omSA/gRKZTiJRvwfIcXRTtUecvldtfELdepOE8wgS5Hjgd9Em
         8mp9zOjw4KUwX+MgWLyBu5nBuBhxvnl/mSUTzH2CTEvco+dpfOgQNfbW9923KkNwYp1G
         ORnw==
X-Gm-Message-State: AOAM533YXSGbxCLE3LiJeOywSG1sBUGZrSDdvKtqBxmtYKBWHx2FP7fm
        Mj7n9QBJamiMBoZjjCbAAVo=
X-Google-Smtp-Source: ABdhPJx1pYp5LHavbro1zZvs7qudPnaTDzarZ6Fpxb/roTJAegw8W3JKKY6vLBADitBwYTRSuVrLyw==
X-Received: by 2002:a17:90b:1c92:b0:1dd:10ff:8f13 with SMTP id oo18-20020a17090b1c9200b001dd10ff8f13mr27048505pjb.54.1653322640606;
        Mon, 23 May 2022 09:17:20 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c8-20020a170902c2c800b0015e8d4eb2ccsm5252127pla.278.2022.05.23.09.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:17:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/3] amt: fix typo in amt
Date:   Mon, 23 May 2022 16:17:06 +0000
Message-Id: <20220523161708.29518-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523161708.29518-1-ap420073@gmail.com>
References: <20220523161708.29518-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AMT_MSG_TEARDOWM is defined,
But it should be AMT_MSG_TEARDOWN.

Fixes: b9022b53adad ("amt: add control plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 2 +-
 include/net/amt.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index de4ea518c793..f41668ddd94a 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -57,7 +57,7 @@ static char *type_str[] = {
 	"AMT_MSG_MEMBERSHIP_QUERY",
 	"AMT_MSG_MEMBERSHIP_UPDATE",
 	"AMT_MSG_MULTICAST_DATA",
-	"AMT_MSG_TEARDOWM",
+	"AMT_MSG_TEARDOWN",
 };
 
 static char *action_str[] = {
diff --git a/include/net/amt.h b/include/net/amt.h
index 7a4db8b903ee..0e40c3d64fcf 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -15,7 +15,7 @@ enum amt_msg_type {
 	AMT_MSG_MEMBERSHIP_QUERY,
 	AMT_MSG_MEMBERSHIP_UPDATE,
 	AMT_MSG_MULTICAST_DATA,
-	AMT_MSG_TEARDOWM,
+	AMT_MSG_TEARDOWN,
 	__AMT_MSG_MAX,
 };
 
-- 
2.17.1

