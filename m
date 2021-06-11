Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E883A38F7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFKAng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:43:36 -0400
Received: from m12-13.163.com ([220.181.12.13]:34787 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhFKAnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 20:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AhPpV
        fv7B9WklPn9o3YVBYYVlRebfLQtig3SsQelQUU=; b=QtCwsJlsc6us73Oum1gVy
        MEJH7xvTE0sSq8JnY0BDC2MV5Asn+SOERhr/jGOP/q7lCujBRHzCDufGmD3kzDwg
        lqH0XQLL0eBM3SgDJ17yn9cr9LLJZkkyff7OXYDYYYe0sJ80D/c5qXofVHMBgI4B
        Bb3f5GeiYcOz4ANB6suaL4=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowABnbJAqscJgforHFg--.31626S2;
        Fri, 11 Jun 2021 08:41:15 +0800 (CST)
From:   13145886936@163.com
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] xfrm: policy: fix a spelling mistake
Date:   Thu, 10 Jun 2021 17:41:13 -0700
Message-Id: <20210611004113.3373-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowABnbJAqscJgforHFg--.31626S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFW7ZFykZw1DXFy3KF18AFb_yoWfJwb_Ww
        1fXryDWry5trs2y3WrJr4DZrWfXr4ruF97u3s7t3Wqg348JrZ5K3srWrZ8Wr47WryUuFnr
        XF98W392yw1UKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU52fO7UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBzgyug1QHM2vH7gAAsN
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


