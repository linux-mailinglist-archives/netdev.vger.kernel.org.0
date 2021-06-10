Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BEB3A22C7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 05:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhFJDbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:31:10 -0400
Received: from m12-15.163.com ([220.181.12.15]:50520 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhFJDbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0rMiR
        hFoYek8AdOPejaWM/afzFRqF9uUoQp9AMFi+O8=; b=ToLxDQXeFVtAfrW9NV8S9
        xBqvowbvVtsHUL1vjncalLdP/w3npEHRcNk28s7P7K/ljdXb+O2vBon8U9KLsyPM
        9ZIpUbJS3k+AJ52zyf7HP9ZNNMlZL4A/MoAIQd23jsuZME3Rmf7impZbBh0m4Gws
        btbcHGBqwC9YErCvVMnyOw=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowAB3LttxgsFg+ox+AA--.103S2;
        Thu, 10 Jun 2021 11:11:14 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] af_unix: remove the repeated word "and"
Date:   Wed,  9 Jun 2021 20:09:35 -0700
Message-Id: <20210610030935.35402-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowAB3LttxgsFg+ox+AA--.103S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZryfAF1UXrW7Cw1kXFW3GFg_yoW3Wwb_WF
        92yr17W3yUCrs3Z3yDA3yfXa4aka1DWa4Iga1DZF1xG348WF45A34rWrs3KF15WFyjkr98
        J3s5K3yayr1fKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeRMKtUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiyhKtg1QHMWGL1wAAsp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Remove the repeated word "and".

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76..4d4f24cbd86b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1392,7 +1392,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	unix_state_unlock(sk);
 
-	/* take ten and and send info to listening sock */
+	/* take ten and send info to listening sock */
 	spin_lock(&other->sk_receive_queue.lock);
 	__skb_queue_tail(&other->sk_receive_queue, skb);
 	spin_unlock(&other->sk_receive_queue.lock);
-- 
2.25.1

