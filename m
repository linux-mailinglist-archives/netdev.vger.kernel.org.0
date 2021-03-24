Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526F03472ED
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhCXHpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbhCXHo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:44:56 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33D7C061763;
        Wed, 24 Mar 2021 00:44:55 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id o19so11886914qvu.0;
        Wed, 24 Mar 2021 00:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a5hVopg0FkUmV7gxxD+uFZ1eqADIArsa8hDbBGsoXQY=;
        b=Xsw6j6CvvVHij9yTWXDIhOkbMAF07q2iUVMdx5/6YG6K0minby4u/Px3s4Qra2E+gd
         +iK8GF1gvaSBVylANv6MV+CaNcBjhiCHzq3tbfy/AaptCnnx3No8LlGWtHAWZ8LELZnb
         tjMbcBF8VyjDy4eau4gXVCyi+rhhaSGY+NRBWGOKNjKD4cjPFbI5azXeJGdH5JsBrzYc
         cNz2YPxXfG+tXHDVy39segWJ36L6NQoA1D2zCfoRfaE9Z8xWDbH5zu3jYQZSNqneA3e2
         8pvVr/WMUz1+pETBXCVhVy+pcHPATSucXg5lSs3lqXmQ+Qbbb2dt8nLrrPYGqR/HyfZE
         HcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a5hVopg0FkUmV7gxxD+uFZ1eqADIArsa8hDbBGsoXQY=;
        b=UWae5DGXVLpLXrSp9e/8c5I1o4lks+WaCws+uT4ys+wB4nfV7T6DFH2D6lNMn0IVvp
         Loef+kDOTvSWDAr6m2Bsa4jkXaliLe4WMqTrNWFbCWpwP1wNk3HGTpGhCMISA3zeBq7v
         9aiRCDhTg0U8y2Ls1vnt4uSqpL4G1L65mMtTLRJSbldNmeyIc/cf3XnhE9YqYKkvuUn4
         MbB0PbqCf7FIqcUJvN+5v8b8JwWzycbqxnnoO/3RnUH7Z0EXtOVQRdP7Zf/GZnXEyQy3
         rK83w/e0cjlXO118buoYCvkfAVn/TS6w7+Hvo86algMXX121qPsKLZxxVigJKkwo3hLb
         pArw==
X-Gm-Message-State: AOAM532FuymKDngzuL7OCWNDM659Jg7htNn5A98/EV1RJDjyf9wmOT5f
        N3DXmwZwIjYqUvlutw3iSg0=
X-Google-Smtp-Source: ABdhPJyaWvd07nNBNqXZ/J8q/e64sDUILKovQT79bveFu1naEtRmYpqAlCcf7VfyPEZo1PSB9Xcnpg==
X-Received: by 2002:a0c:f7d1:: with SMTP id f17mr1625195qvo.38.1616571895231;
        Wed, 24 Mar 2021 00:44:55 -0700 (PDT)
Received: from Slackware.localdomain ([156.146.37.194])
        by smtp.gmail.com with ESMTPSA id s133sm1170575qke.1.2021.03.24.00.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 00:44:54 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: sched: Mundane typo fixes
Date:   Wed, 24 Mar 2021 13:16:37 +0530
Message-Id: <20210324074637.6038-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/procdure/procedure/
s/maintanance/maintenance/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/sched/sch_cbq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 320b3d31fa97..b79a7e27bb31 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -263,7 +263,7 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		/*
 		 * Step 3+n. If classifier selected a link sharing class,
 		 *	   apply agency specific classifier.
-		 *	   Repeat this procdure until we hit a leaf node.
+		 *	   Repeat this procedure until we hit a leaf node.
 		 */
 		head = cl;
 	}
@@ -859,7 +859,7 @@ cbq_dequeue(struct Qdisc *sch)
 	return NULL;
 }

-/* CBQ class maintanance routines */
+/* CBQ class maintenance routines */

 static void cbq_adjust_levels(struct cbq_class *this)
 {
--
2.30.1

