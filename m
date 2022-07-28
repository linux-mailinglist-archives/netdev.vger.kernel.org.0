Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DAD583788
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiG1D3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbiG1D3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:29:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD03D313B8;
        Wed, 27 Jul 2022 20:29:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w10so722623plq.0;
        Wed, 27 Jul 2022 20:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IgmuXFdC4z/43Rc7Q9cgxFfqgAnSJN8111kFQ443vyQ=;
        b=ADaO62z8vkrGxtk6GnMjJ4r3VcgvYkwTs0rhcJvfxh8h/g8TstyKIs/GlktD9f6YFh
         32QEtS/BRYEZSRq3mPNyAGoOzM+B1kluJs1OZAabfwc/XelJBKy1fCZPkKvbjD+fU4Yg
         hVLiibV1j89DADxLRUqghdQeqBcCEL7hNy7n7/w1YS/ul+50ZZV3Iryj1vRkW99hJXaE
         JOT0W4Qn0/zGBtFUAqb/95/bNmjvbjQxme7tlbMwFx3BXPdRdJidpxXJb6+loduJ2P6+
         Dq2cwRhdztrNOuLZHSpy+ZrHJV2fo4OBh5ea8HRbu9PCd9Em4sgpsQMHHD0kkN5e0X+7
         nTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IgmuXFdC4z/43Rc7Q9cgxFfqgAnSJN8111kFQ443vyQ=;
        b=V7vHQOPanihUitOKexWGzI+jskCm6iTnraHc2hAinKmxTXQ7p1Yt5n9pMZiyHEnp93
         8856ohEJxieUct+1ahDxewOQ7wcHND1PLlcO+VQhpeWo1thyuD/MFgCMTWcgWaqjFAtd
         pH7D6KYr2VNA7sk2+yIIF4/hsVZPlmROfLG0RyjM4D2i8ZiKoDsSakYETOuTfmwHHwrw
         xnyfVc33Is2zi1LY5GlSVgRSO+5QIrozxXqlXqr6JKp9xwWEyYixqFD+SR8ZVrEBtEbO
         8x+YllS7WYkjff3ePtw4Z0GJ0s7n8Ap+cIAKWDsDEehJaunoFmqkco+V1ppIbolu7lID
         GibQ==
X-Gm-Message-State: AJIora83d1nmoVJDeyvrRNsve/BJvFQqVqRH7IGyIRtoxBnMJdoXPrtO
        v/9dDkbQFTQ+APwLhEvPXxbgyMVkWZPdsw==
X-Google-Smtp-Source: AGRyM1t5DmGKZQbXkEwWJ6MjAHHdslXBLZ7TGeBz6KKNyDZJhJrvYdFseujyktImww8HVxr7gsrCJw==
X-Received: by 2002:a17:90b:3502:b0:1f3:550:5f6f with SMTP id ls2-20020a17090b350200b001f305505f6fmr8173822pjb.49.1658978943363;
        Wed, 27 Jul 2022 20:29:03 -0700 (PDT)
Received: from rfl-device.localdomain ([39.124.24.102])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090a4bc500b001ef7c7564fdsm2571214pjl.21.2022.07.27.20.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 20:29:03 -0700 (PDT)
From:   RuffaloLavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: RuffaloLavoisier <RuffaloLavoisier@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     RuffaloLavoisier <RuffaloLavoisier@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] amt: fix typo in comment
Date:   Thu, 28 Jul 2022 12:28:54 +0900
Message-Id: <20220728032854.151180-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct spelling on 'non-existent' in comment

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
I wrote about the commit message in detail and modified the name.
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index febfcf2d92af..9a247eb7679c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -449,7 +449,7 @@ static void amt_group_work(struct work_struct *work)
 	dev_put(amt->dev);
 }
 
-/* Non-existant group is created as INCLUDE {empty}:
+/* Non-existent group is created as INCLUDE {empty}:
  *
  * RFC 3376 - 5.1. Action on Change of Interface State
  *
-- 
2.25.1

