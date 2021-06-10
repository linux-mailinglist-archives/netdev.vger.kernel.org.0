Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB26C3A2129
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFJAJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:09:31 -0400
Received: from m12-11.163.com ([220.181.12.11]:45508 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhFJAJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AhPpV
        fv7B9WklPn9o3YVBYYVlRebfLQtig3SsQelQUU=; b=C0C49bdcVkYoKdta3EBIZ
        oWq+rDaoGXrtQfiK+Bv63Bm7XB9Dh2BuvAagfiUw8nGEkAY5zNNThD7sGfJkzNGD
        DgOLpPLfGOr3s7x3ELOrn2oC5tkqX4kz9JtzzrTf19ec+cKnuTWAyLWQwkPaowof
        jl2AL3MPZc/cKsc7VRBUbs=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowABXf4+0V8Fg8yqphA--.14559S2;
        Thu, 10 Jun 2021 08:07:17 +0800 (CST)
From:   13145886936@163.com
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] xfrm: policy: fix a spelling mistake
Date:   Wed,  9 Jun 2021 17:07:15 -0700
Message-Id: <20210610000715.32647-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowABXf4+0V8Fg8yqphA--.14559S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFW7ZFykZw1DXFy3KF18AFb_yoWfJwb_Ww
        1fXryDWry5trs2y3WrJr4DZrWfXr4ruF97u3s7t3Wqg348JrZ5K3srWrZ8Wr47WryUuFnr
        XF98W392yw1UKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU52fO7UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiGhmtg1aD+D3ChAAAs7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a spelling mistake.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ec84d11c3fc1..827d84255021 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3252,7 +3252,7 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
 
 /*
  * 0 or more than 0 is returned when validation is succeeded (either bypass
- * because of optional transport mode, or next index of the mathced secpath
+ * because of optional transport mode, or next index of the matched secpath
  * state with the template.
  * -1 is returned when no matching template is found.
  * Otherwise "-2 - errored_index" is returned.
-- 
2.25.1

