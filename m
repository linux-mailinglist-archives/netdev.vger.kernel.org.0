Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AE4517EEA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 09:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiECHdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 03:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiECHdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 03:33:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43BB366AA;
        Tue,  3 May 2022 00:30:09 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j70so2507887pge.1;
        Tue, 03 May 2022 00:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dCHiolDCrvWhPfPBdVy2NNQvhf7col2O52oDSi5J+HM=;
        b=fKRXoiUdX9bK33lZYxOHszpqI/ifjAxGXDUQCEfq1txgEZoluJLwoJHvCpm8ZaHbcS
         3qJWLICh6fa3rkczaJk2oP+XIw1F4OFjCmuxbrffL0ENJ19SZOfqdYN6jJYTtbVmErNI
         gvSCarY+CMwXehYEkmxc8u5OqThFIhDDH/W7w9/ihUmYshT9E+3YoKIqMJ8j7b8HusRJ
         GqS/od1HUgCN8iJ34srdfgwC8Im6zFOxYJjy1Y3fZg0Wz48wHsmLb4VWGyvnZyHgilIq
         SfWh7I2BvxIFKk8MQNwIK/mCmQ325GTxEHIvE7iaeDQ00i6e4w+3eTE6Nq3A00npsrrV
         3k6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dCHiolDCrvWhPfPBdVy2NNQvhf7col2O52oDSi5J+HM=;
        b=o0NjS7jsDHUHvZLJi8zdD57o75uzrqwigXJoKUP5RwC/LvFH+/cP3G2ZEqf66dQAu2
         D0AsHgyzjaRFzF8M0eofFD+h82ODxr/mAs0zp0/6+hZZ3aWlbUMZP8/MXnj0gzsqjEaK
         GmBENXeYeCkAcdmxOq8HZv0sSIylRFqQbp4gSy67II5+YaunohQPsC46PDJPvo9xLV4k
         6vHxJ1EyzL8Sh5Rw2PpSGWESYuzvMWurnYCskonyccifLf8Nu0IojYef8/oEA/wojcCn
         vuVvFls+X2e4Xd+IR2d1yp8WzWRSvhrDRdN5M6HBRinxCkH4iDVs1HvziQlLG6eC7Ts4
         bLsQ==
X-Gm-Message-State: AOAM530KyCk+gJ0zpomZIEcZI/7oaH6LN5w+QWLCxWckmgbqLaNOsmQs
        j8QqzJdGMWMLUzef91qi43XUAzfgBQQ=
X-Google-Smtp-Source: ABdhPJwz5BQ/RPAjdHYborqmdtvWEmLaDh9m+p+WNhFXGG3ctA5E8bP7vcxppfNxbO/OHe7xC0b/xQ==
X-Received: by 2002:a05:6a00:16c7:b0:4f7:e497:69b8 with SMTP id l7-20020a056a0016c700b004f7e49769b8mr14716676pfc.6.1651563009017;
        Tue, 03 May 2022 00:30:09 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-55.three.co.id. [116.206.28.55])
        by smtp.gmail.com with ESMTPSA id i4-20020a170902e48400b0015e8d4eb1edsm5733929ple.55.2022.05.03.00.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 00:30:08 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <davej@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pavel Begunkov <asml.silence@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net/core: Remove comment quote for __dev_queue_xmit()
Date:   Tue,  3 May 2022 14:29:49 +0700
Message-Id: <20220503072949.27336-1-bagasdotme@gmail.com>
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

The warning is due to comment quote by BLG, which is separated by a dash
line above. While it is fine in the docbook days, current documentation
framework (Sphinx + kernel-doc) complains about it, so the documentation
for __dev_queue_xmit() is not generated.

The commit containing the quote is actually d29f749e252bcd ("net: Fix
build failure with 'make mandocs'."), which interacts with commit
c526fd8f9f4f21 ("net: inline dev_queue_xmit()") that Stephen reported.

Fix the warning by removing the quote and adjust the method
documentation accordingly.

Fixes: d29f749e252bcd ("net: Fix build failure with 'make mandocs'.")
Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Jones <davej@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 net/core/dev.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d127164771f222..b5273f820ca840 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4098,18 +4098,13 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
  *	guarantee the frame will be transmitted as it may be dropped due
  *	to congestion or traffic shaping.
  *
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
+ *	This method can also return positive errno code from the queue
+ *	disciplines (including NET_XMIT_DROP).
+ *
+ *	Note that regardless of the return value, the skb is consumed
+ *	anyway, so it is currently difficult to retry sending to this
+ *	method.
+ *
  */
 int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {

base-commit: 0530a683fc858aa641d88ad83315ea53c27bce10
-- 
An old man doll... just what I always wanted! - Clara

