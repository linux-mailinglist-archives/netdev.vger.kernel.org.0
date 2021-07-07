Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AC43BEE92
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhGGSWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 14:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhGGSWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 14:22:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6D1C061787;
        Wed,  7 Jul 2021 11:18:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso4280225pjc.0;
        Wed, 07 Jul 2021 11:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ixt+c2hw94PuELT3/7LW91LVqIKuIwXifyYu+SgDn8s=;
        b=aNp6OZBz05XG9tdnfsmjQ30v/Jill+KIBTCc9YFClH2qS8ognYKKHhpuqeG7sYUEkq
         bPWVU0ix2Hy+ULqA7z8ovcObtKSw+A8xRPY1vlTAFT905PLu3DKIVdm3sKooJRa7IiMs
         /wcwbxZeFIYnMjKr0Qfua3S0BEunS0JAr15WHJhia/0ImSV0AzEcBfV5ZYDmGujt5Ces
         1IxhcP1wAOgwtyNi+qkCeE6Ua53AwMvYJ6vjlFkljbVjzQScPEfVAhzYdzoZ8bKYerlT
         L1mD5axzlIo7W1JnJtFmcG1z06HFLKbcDsCEy3CkMX//tfA5fXwzoMq1tUMImmDXcP0U
         /PCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ixt+c2hw94PuELT3/7LW91LVqIKuIwXifyYu+SgDn8s=;
        b=GC6Uvb1Vi0QDiUJ2EBtygkJ4qEhs8qhE1AQH+TmuZ0BwgvE5UPwtmP1EnRBXMCPxwa
         qzYJvRd5Sj1UWM+uAGVHWcAIMLpbDmcrNPclXqG7h2FrvT3UUPixUg/GfJ5QnWFs+QIm
         he2OdxBoLmUsU3c79fKOeQtIeSL2w7D0nIedkafd8HtJ1FhwDjgN1KMnWSxrQjFHF1Ef
         d+NnHfi94q00P/LfuG/3GOgqfGIF1ERNwpXf+iz/eKQeC7hd7d89wEkz64thgQpZ4nTL
         +5UhN+z73RYwfkp2p0ust0cP6ydoEad+jx7w/14yGlMcFmoNwYj8DTd/LC4zcX4r4rCt
         xbiA==
X-Gm-Message-State: AOAM5334/NHYWpNB8AoToBULn1/H8YbRUcOPlX/vejMEy2LP4rmKXZDL
        cx4vzIteRJNIePUFXUbXnSiMFnKfXUHNqg==
X-Google-Smtp-Source: ABdhPJyGi99q0BU6Nf/cL8htYi+irf7Ncgxsa6LoGtLPZnCU+HUrAw2xLrulfdTRXmi4PByxEJqB9A==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr327411pju.51.1625681918112;
        Wed, 07 Jul 2021 11:18:38 -0700 (PDT)
Received: from BALT-UROY.maxlinear.com ([202.8.116.91])
        by smtp.gmail.com with ESMTPSA id b18sm7472598pjq.2.2021.07.07.11.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:18:37 -0700 (PDT)
From:   UjjaL Roy <royujjal@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipmr: Fix indentation issue
Date:   Wed,  7 Jul 2021 23:48:33 +0530
Message-Id: <20210707181833.165-1-royujjal@gmail.com>
X-Mailer: git-send-email 2.31.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Roy, UjjaL" <royujjal@gmail.com>

Fixed indentation by removing extra spaces.

Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
---
 net/ipv4/ipmr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 7b12a40dd465..2dda856ca260 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2119,7 +2119,7 @@ int ip_mr_input(struct sk_buff *skb)
 				raw_rcv(mroute_sk, skb);
 				return 0;
 			}
-		    }
+		}
 	}
 
 	/* already under rcu_read_lock() */
-- 
2.17.1

