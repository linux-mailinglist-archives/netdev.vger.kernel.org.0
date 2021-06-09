Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808673A0A28
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 04:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhFICrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 22:47:12 -0400
Received: from m12-13.163.com ([220.181.12.13]:34450 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhFICrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 22:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AhPpV
        fv7B9WklPn9o3YVBYYVlRebfLQtig3SsQelQUU=; b=caWlzmbwo4nYa68SHBsWx
        oqd7ke4GeOmtHT3HdkDxijFrD6pjRf/ZGCj5/k5a8Bx7MXzmsQvih6K2jqcNzZf3
        kAedW6FJaEIQ4T9SVKkZxxFLFj1LHSz2Bfm1hFoxuPLcU0uc895dYAJV6Y4VRRiw
        u1YeGha0wjPuHrt+PgJIS0=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowAA3OnonJ8BgFCJgFQ--.855S2;
        Wed, 09 Jun 2021 10:27:52 +0800 (CST)
From:   13145886936@163.com
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] xfrm: policy: fix a spelling mistake
Date:   Tue,  8 Jun 2021 19:27:46 -0700
Message-Id: <20210609022746.16743-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAA3OnonJ8BgFCJgFQ--.855S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFW7ZFykZw1DXFy3KF18AFb_yoWfJwb_Ww
        1fXryDWry5trs2y3WrJr4DZrWfXr4ruF97u3s7t3Wqg348JrZ5K3srWrZ8Wr47WryUuFnr
        XF98W392yw1UKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5ouWJUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBRwusg1PAC-8h8gAAsX
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


