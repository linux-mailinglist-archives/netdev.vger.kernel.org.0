Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6DB51E5B7
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446144AbiEGIvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344519AbiEGIvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 04:51:12 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DA848380;
        Sat,  7 May 2022 01:47:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a11so8150330pff.1;
        Sat, 07 May 2022 01:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ccfTY95+psHCY6He+eK67UQqmYafold9pHrglmLvAmo=;
        b=a0c+PxeyYec6iuI72OoPUUxOdZemThLnOXunZERwdu1npZzTEHdmVXp3DZFbeM/kd0
         4ELSCLd2hwArfQvPcmuuNpExoQXLBYZQ/2sKLQ9mQ4ePwOL9x4mHLwtScbUmhfcpygFT
         doEAhVK8vp9iylie7nfmGvdqefo9L7hXHK6HUwGchFeHMoyHg5gdu7TZjGljXZfJiCla
         JaXr4zACb9C/GrlgyiFi3w2APlDcPjHM5kf2SSeNSlq38G+PRxB5LqBE2mlc0uRMRY/d
         1AecSIIHKBW7pw4kvm4Q3dKzL3irJIutJEVsd4JVt2QPVqOvHwpTKHlLCqcjyORyEWvH
         ZdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ccfTY95+psHCY6He+eK67UQqmYafold9pHrglmLvAmo=;
        b=iSGt2AQdR6n8ANe/heB5VMpplxVxHdcrn3PX7+yuUgj7Jgken6Yzfms2R96sr9NBdS
         oJwMpLZ7UDfNYFXGGdKFQQ7lzRbYGPwFJvxj2Zf60orR2S23atrQq9BUVbMM2oMMPkLs
         R4T14oQYnpCCayA+gQkRBGN28EBtwtk4w1CUwzojx763stQqCPagiSW2QWLLLrnt8QCz
         ZIXr6y+hCoLIZzdUjFwaf9IWekuRgU4p1hflw1RHTV8WAWU+g2uaw8aSkmo/m8xRDOqQ
         Lt0eubR4iuysE3REt6tUG238tSH/6fff2H9C7A8xNG8sHMKsjkTwz5oSY1rIZGOCZpCI
         RRow==
X-Gm-Message-State: AOAM532eYq0YAhbHGJvuq1X/Rb5ymMpCOpT1fCxTfEcXq9sM1SYDpk0G
        BGT6uIAoDs5zwyFbn1Ra16Z5FNombVUVgQ==
X-Google-Smtp-Source: ABdhPJw98tTxONDGUaX/2zcjqg4/YagwX+3tFePd02L85CION61ElJstk4CmLbKdovWuk9L6C2Zy2Q==
X-Received: by 2002:a05:6a00:21c8:b0:4fd:f89f:ec0e with SMTP id t8-20020a056a0021c800b004fdf89fec0emr7123513pfj.83.1651913245215;
        Sat, 07 May 2022 01:47:25 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-9.three.co.id. [180.214.232.9])
        by smtp.gmail.com with ESMTPSA id ot16-20020a17090b3b5000b001dc4d22c0a7sm5055729pjb.10.2022.05.07.01.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 01:47:24 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3] net/core: Rephrase function description of __dev_queue_xmit()
Date:   Sat,  7 May 2022 15:46:44 +0700
Message-Id: <20220507084643.18278-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()") inlines
dev_queue_xmit() that contains comment quote from Ben Greear, which
originates from commit af191367a75262 ("[NET]: Document ->hard_start_xmit()
locking in comments."). It triggers htmldocs warning:

Documentation/networking/kapi:92: net/core/dev.c:4101: WARNING: Missing matching underline for section title overline.

-----------------------------------------------------------------------------------
     I notice this method can also return errors from the queue disciplines,
     including NET_XMIT_DROP, which is a positive value.  So, errors can also

Fix the warning by rephrasing the function description. This is done by
incorporating notes from the quote as well as dropping the banner and
attribution signature.

Fixes: c526fd8f9f4f21 ("net: inline dev_queue_xmit()")
Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Greear <greearb@candelatech.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Akira Yokosawa <akiyks@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Changes since v2 [1]:
   - Approach the problem by rephrasing (suggested by Jakub)
   - Explain that inlining in the Fixes: commit triggers the warning
     (suggested by Akira)

 [1]: https://lore.kernel.org/linux-doc/20220505082907.42393-1-bagasdotme@gmail.com/

 net/core/dev.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f036ccb61da4da..75c00bb45f9b46 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4139,22 +4139,20 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
  *	have set the device and priority and built the buffer before calling
  *	this function. The function can be called from an interrupt.
  *
- *	A negative errno code is returned on a failure. A success does not
- *	guarantee the frame will be transmitted as it may be dropped due
- *	to congestion or traffic shaping.
- *
- * -----------------------------------------------------------------------------------
- *      I notice this method can also return errors from the queue disciplines,
- *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
- *      be positive.
- *
- *      Regardless of the return value, the skb is consumed, so it is currently
- *      difficult to retry a send to this method.  (You can bump the ref count
- *      before sending to hold a reference for retry if you are careful.)
- *
- *      When calling this method, interrupts MUST be enabled.  This is because
- *      the BH enable code must have IRQs enabled so that it will not deadlock.
- *          --BLG
+ *	This function can returns a negative errno code in case of failure.
+ *	Positive errno code can also be returned from the queue disciplines
+ *	(including NET_XMIT_DROP). A success does not guarantee the frame
+ *	will be transmitted as it may be dropped due to congestion or
+ *	traffic shaping.
+ *
+ *	The skb is consumed anyway regardless of return value, so it is
+ *	currently difficult to retry sending to this method. If careful,
+ *	you can bump the ref count before sending to hold a reference for
+ *	retry.
+ *
+ *	Interrupts must be enabled when calling this function, because
+ *	BH-enabled code must have IRQs enabled so that it will not deadlock.
+ *
  */
 int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {

base-commit: 8fc0b6992a06998404321f26a57ea54522659b64
-- 
An old man doll... just what I always wanted! - Clara

