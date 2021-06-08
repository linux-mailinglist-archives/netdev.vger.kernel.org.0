Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00BE39EC30
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFHCh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:37:29 -0400
Received: from m12-12.163.com ([220.181.12.12]:47907 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhFHCh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 22:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=vBfoD
        FhRZOQeoKzLCTLgdEeQ+4ROpT8Mh1h0z2ZY8iI=; b=oqj/mwbhyqXVaGsM1iK18
        PWDP3zxIxz9qqVlK7nCUHxD3fVlCBQ6cCjYMU5ocOVV8C2PzsM1w5wit5r/zT4b1
        snQvKppMtABmIAQ03vWk+iq7/YL1XIz/LpV0qu3vjsrzIRxU8Z6r511Ms+IUNEHf
        4utzZUjjL19TypuC6Ec/YE=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowABHQs63075g0GO3Ig--.16270S2;
        Tue, 08 Jun 2021 10:19:36 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: appletalk: fix the usage of preposition
Date:   Mon,  7 Jun 2021 19:19:32 -0700
Message-Id: <20210608021932.7308-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABHQs63075g0GO3Ig--.16270S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWktw1fJrW3GFWkCr1fXrb_yoW3Xrc_uF
        48KrWvgw4DJ3Z2vw4Sga13tr9rt348uF40va1Dtryfta4UJw48Cw4kXryrury3W3yUCFy3
        XFykurWYyr1S9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5jeHPUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiGg+rg1aD+CSL-QAAsC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

The preposition "for" should be changed to preposition "of".

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/appletalk/aarp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index be18af481d7d..c7236daa2415 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -768,7 +768,7 @@ static int aarp_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (a && a->status & ATIF_PROBE) {
 		a->status |= ATIF_PROBE_FAIL;
 		/*
-		 * we do not respond to probe or request packets for
+		 * we do not respond to probe or request packets of
 		 * this address while we are probing this address
 		 */
 		goto unlock;
-- 
2.25.1


