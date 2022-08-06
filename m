Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A339B58B4FD
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 12:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiHFKNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 06:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiHFKN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 06:13:28 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2D112A81;
        Sat,  6 Aug 2022 03:13:26 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id v10so1857890ljh.9;
        Sat, 06 Aug 2022 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5buEkOG5SU9AwpY1A3SFs8pS1q6UuxaXzfG0OHWAVg=;
        b=Ee20urYg6Q5t8YFdUdLeIBgZPa8KFrTquVccZRj+EXlz86pyniz9P7oomOfeq5g5JH
         Vq+BHZJE7eAJcvF/zVTptoYaaBcsPZxwf1vn/YlaGc7FAyW5yv6OmQub3OCjq7Ach/1y
         HBlXwznvr6+XHWz1yhfEsVt61ZqAsOg8Seq36OOADBZAjxtZTygIXcjY8Y08nUHeBZop
         97jYwyMOUqXycSTwmXLZc3U6p10jQBFBjmQQPAudjjqkFZ9D1fYnM9nx5S3yO4nSlfCG
         Oe8Skmwn+LXyXl4n9fb7aJqFvFI2j3l+sqY/dkwqvyf/ndIsemJk5bzgAS6tqlKa5aai
         kV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f5buEkOG5SU9AwpY1A3SFs8pS1q6UuxaXzfG0OHWAVg=;
        b=YTrXtlWfQYhet+Q7WTqlAZ+yuM9MUpOILWatLgZXwrJHTEW/fzej5ch45x8ufDdDOC
         V6J0i4yj83+l1c4qDMIrBHWNzknKTCVeWuVXBHvzFZxJgLxW0WrnziO/nMVQrGeMqfBd
         +6pvYntH8GsxCU0iNZqgq+Ic85FIu5SMmqDxlYvQQebS8zz25UCKDgLaul7OECpogUwG
         gYjME1PWdxks5JXVVDnO1NMRqJ1DxT2tXDFcXuf63qFyaSlBE4l+1dFzkShyWSRu34Dl
         3xxD9yvXOt93DdVSoJr9VfsZUr2A85HGzgkJZvSjRve46lYNNRKVHIoG9CTyTdnoLtxn
         qm4g==
X-Gm-Message-State: ACgBeo3HGoyV7NAWEyt0bzrgGY90vvBZ970EYycvRd2HuwJD8qP3Ys2c
        bWOFW1aXLMVsWmTXCSx8qUI=
X-Google-Smtp-Source: AA6agR4o9F7TTNICeUag3oz7A3uJ2Xc2EiGmj/KS8IiH1fETqa/CKEMuYqDk5KO3ejLMLCBLikK0vQ==
X-Received: by 2002:a2e:9d91:0:b0:25e:dd34:f5d6 with SMTP id c17-20020a2e9d91000000b0025edd34f5d6mr31186ljj.501.1659780805056;
        Sat, 06 Aug 2022 03:13:25 -0700 (PDT)
Received: from localhost.localdomain (91-158-88-16.elisa-laajakaista.fi. [91.158.88.16])
        by smtp.gmail.com with ESMTPSA id g9-20020a2eb5c9000000b0025e87b1fdbcsm494461ljn.63.2022.08.06.03.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 03:13:24 -0700 (PDT)
From:   Topi Miettinen <toiwoton@gmail.com>
To:     paul@paul-moore.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH] netlabel: fix typo in comment
Date:   Sat,  6 Aug 2022 13:12:53 +0300
Message-Id: <20220806101253.13865-1-toiwoton@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'IPv4 and IPv4' should be 'IPv4 and IPv6'.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 net/netlabel/netlabel_unlabeled.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8490e46359ae..0555dffd80e0 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -885,7 +885,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
 	 * single entry.  However, allow users to create two entries, one each
-	 * for IPv4 and IPv4, with the same LSM security context which should
+	 * for IPv4 and IPv6, with the same LSM security context which should
 	 * achieve the same result. */
 	if (!info->attrs[NLBL_UNLABEL_A_SECCTX] ||
 	    !info->attrs[NLBL_UNLABEL_A_IFACE] ||
-- 
2.35.1

