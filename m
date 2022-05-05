Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC6351BA73
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349308AbiEEIdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349307AbiEEIdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:33:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7AA48E7F;
        Thu,  5 May 2022 01:29:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x12so3113880pgj.7;
        Thu, 05 May 2022 01:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I8iVQ2ATolZdL4GQyg4h1Y4q3ydgZAtJB0uwbzpCqt4=;
        b=GTcOdExtfyRJhz8aDfh5mhtDoBS1Y93kgUCo55M4c/Z/BFRCdXjjdn6gPL6QFeM0Ly
         4iiHVpkQGFHhtr31Y0TNHbicHkQl1oM0iDRNduxdnxg7gLbIaaHHRjHXrmEJZbFZGOfX
         15eoI5xaKxuUAmiOuc2S215pU/T9qw9swnGFNlxXnaBrDdObLu0A/zTp8LjeQvQpFhr2
         Fpfb2qnC55dZa80kryYCU5b8bomWevgM39MXd4kdtmHAXuxgNPBPr/MiB2NmJrZ1VYt+
         iHdWUc3mI4IxtoCPrO0j6idWhQMzAsXC9QKneRgMaLXXeJINpNpDr7bM66Y/E0ui3qfM
         5kXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I8iVQ2ATolZdL4GQyg4h1Y4q3ydgZAtJB0uwbzpCqt4=;
        b=6xqPxasQ5jWUWulVxH8eGjAoMCBCgHbqvula8mNa++4CSLCIw9G3DhzmcHM+lIUqOn
         YzNXyjNcn06ryyW2XU7PplycfTZUu8RA7aqIuEnyXnqHkjCKqvwEyCCIs5xFnjY/Vmtx
         7MO9pFzxmuWOwR38ZnId/s2QejSblTcJXIhjmtP8yyndCjD2vf2wFDdhTx6gHRkwouna
         HujYZnh8dvGsv7Hl8DAtM8A98XJFONv6fwchbOaNUp5eUB4dJfbefKKQemt1rRMFozCW
         t3+pJYun2KRmZ7+6jP+ogqIEiTgNv6c7zl6d0hjVgsU6DodBk7bin2tZxInn70whiNau
         b/2Q==
X-Gm-Message-State: AOAM532NWiBSw3zrme2LfcGgDsalYK0WZAq22qiRVZtDFl9pS1WIwIqO
        Rak7rmZeFBW+hdaAd+MQNeu2n6GAIg0=
X-Google-Smtp-Source: ABdhPJwc55yYRNJ/FOrc+sUPpxXfL1QM4Xm2y7Gqhl3HqNsK60zzWpWzqeracH/TkfTiOGUFQzzLKA==
X-Received: by 2002:aa7:848a:0:b0:510:44da:223d with SMTP id u10-20020aa7848a000000b0051044da223dmr6083466pfn.66.1651739370043;
        Thu, 05 May 2022 01:29:30 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id x3-20020a17090aa38300b001cd4989febcsm4761861pjp.8.2022.05.05.01.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 01:29:29 -0700 (PDT)
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
Subject: [PATCH net-next v2] net/core: use ReST block quote in __dev_queue_xmit() comment
Date:   Thu,  5 May 2022 15:29:07 +0700
Message-Id: <20220505082907.42393-1-bagasdotme@gmail.com>
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

When merging net-next for linux-next tree, Stephen Rothwell reported
htmldocs warning:

Documentation/networking/kapi:92: net/core/dev.c:4101: WARNING: Missing matching underline for section title overline.

-----------------------------------------------------------------------------------
     I notice this method can also return errors from the queue disciplines,
     including NET_XMIT_DROP, which is a positive value.  So, errors can also

The warning is due to comment quote by Ben from commit af191367a75262
("[NET]: Document ->hard_start_xmit() locking in comments.") interacts
with commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()").

Fix the warning by using ReST block quote syntax for the comment quote.
Note that the actual description for the method will be rendered above
"Description" section instead of below of it. However, preserve the
comment quote for now.

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
 Changes since v1 [1]:
   - Use ReST block quote instead of deleting the comment quote
   - Mention the originating commit that introduces the quote

 [1]: https://lore.kernel.org/linux-doc/20220503072949.27336-1-bagasdotme@gmail.com/
 net/core/dev.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c2d73595a7c369..bcb47b889f5857 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4099,17 +4099,18 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
  *	to congestion or traffic shaping.
  *
  * -----------------------------------------------------------------------------------
- *      I notice this method can also return errors from the queue disciplines,
- *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
- *      be positive.
  *
- *      Regardless of the return value, the skb is consumed, so it is currently
- *      difficult to retry a send to this method.  (You can bump the ref count
- *      before sending to hold a reference for retry if you are careful.)
+ *        I notice this method can also return errors from the queue disciplines,
+ *        including NET_XMIT_DROP, which is a positive value.  So, errors can also
+ *        be positive.
  *
- *      When calling this method, interrupts MUST be enabled.  This is because
- *      the BH enable code must have IRQs enabled so that it will not deadlock.
- *          --BLG
+ *        Regardless of the return value, the skb is consumed, so it is currently
+ *        difficult to retry a send to this method.  (You can bump the ref count
+ *        before sending to hold a reference for retry if you are careful.)
+ *
+ *        When calling this method, interrupts MUST be enabled.  This is because
+ *        the BH enable code must have IRQs enabled so that it will not deadlock.
+ *        --BLG
  */
 int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {

base-commit: 4950b6990e3b1efae64a5f6fc5738d25e3b816b3
-- 
An old man doll... just what I always wanted! - Clara

