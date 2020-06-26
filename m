Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D750E20AB1B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 06:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgFZEKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 00:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgFZEKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 00:10:30 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46121C08C5C1;
        Thu, 25 Jun 2020 21:10:30 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m2so7391218otr.12;
        Thu, 25 Jun 2020 21:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiGoscDyaEFK2a4Hhbr5oo8EKClzH7wIyqZRrKV4JjQ=;
        b=NAUUdhfOaao8gFQRyvS+BVKpdzkwnAWjQO0msoPeaH+N59nmgmh8+cRU4X+85nL257
         CdVAmIszSqOjEL1DcPfXzbSap0JSIJUTRT3W85HflgSZyzpA1rWzibtEdEzWhyvFGIjA
         v/VspvwX0KXKEQZisE7l4xiRZywdeWyq5msgMw12SzM140IBoZnFvhgeG+CjO89OViPs
         lNZdP+9mf454BPIDt5kqllT/Z9VKGwGMdqXaWsRLfFxOaYulAjMEFNPJnPlFRtNpcm7d
         /TVzm8hhnSjVnyxl449qwNnw5Xqg/V2m0WJrS0s9jUNNpU02xr3mvV5RqfvlCH5GmRKu
         xWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiGoscDyaEFK2a4Hhbr5oo8EKClzH7wIyqZRrKV4JjQ=;
        b=cXH/BEZXaTRkUEaUXOFw8o2BERgoCejES3mTXJcPMb+JDYKRH0pzi2o+1NkjNKEmU4
         mx4jXhhlqB4j4YUbCiIOJDMagp/1ZIGe5jLmh/iHgRl19BV4ZXXD7dhw+ZtZXWI47zE3
         KCdyXCzyX7tMyoidXCZp0p1GuF32wQcgiLkqym55X3SC5ZwivTUNZDbFjLzwqzTJo3nJ
         /Oyhs4KFj+6xNeYnGGvphCXEpATwxfE9AObjNCOxXNOiFJJm+ZGN8lkE62Zk4m0Awvm8
         EddkMff063BA1jAKQjm4ShK7qMX152/0z0qlIwAwudJDpxk+xDlqrAeN/zJEOK2wc6Ha
         euyQ==
X-Gm-Message-State: AOAM531gKskPkfDDMqUFHYCRY8uRWk8in7nU2+uC91Yp+h3DBWJf0KuS
        UUwKRlk/dT12oMZu1qg1RA3+gwoY
X-Google-Smtp-Source: ABdhPJwE6OUco0cxeHwheCoA0H5zavZw/pkR82GqKYyvVUchqjjcZtx+m7BL89xHLARawT4LRnksGg==
X-Received: by 2002:a4a:a8cc:: with SMTP id r12mr785952oom.86.1593144629354;
        Thu, 25 Jun 2020 21:10:29 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id h22sm4165908oos.48.2020.06.25.21.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 21:10:28 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] bonding: Remove extraneous parentheses in bond_setup
Date:   Thu, 25 Jun 2020 21:10:02 -0700
Message-Id: <20200626041001.1194928-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/bonding/bond_main.c:4657:23: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
        if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
             ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~

drivers/net/bonding/bond_main.c:4681:23: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
        if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
             ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~

This warning occurs when a comparision has two sets of parentheses,
which is usually the convention for doing an assignment within an
if statement. Since equality comparisons do not need a second set of
parentheses, remove them to fix the warning.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Link: https://github.com/ClangBuiltLinux/linux/issues/1066
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/bonding/bond_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4ef99efc37f6..b3479584cc16 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4654,7 +4654,7 @@ void bond_setup(struct net_device *bond_dev)
 
 #ifdef CONFIG_XFRM_OFFLOAD
 	/* set up xfrm device ops (only supported in active-backup right now) */
-	if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->xfrmdev_ops = &bond_xfrmdev_ops;
 	bond->xs = NULL;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -4678,7 +4678,7 @@ void bond_setup(struct net_device *bond_dev)
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
 #ifdef CONFIG_XFRM_OFFLOAD
-	if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->hw_features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->features |= bond_dev->hw_features;

base-commit: 7bed14551659875e1cd23a7c0266394a29a773b3
-- 
2.27.0

