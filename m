Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C66F04E6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 13:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243686AbjD0LYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 07:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243709AbjD0LYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 07:24:10 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA9B5BAC;
        Thu, 27 Apr 2023 04:24:02 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 9D09BC01A; Thu, 27 Apr 2023 13:24:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594641; bh=WAcni6OXNNhfIsk21LRpOs0ssDNtEseYLnTlcemrY2g=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=yf/eyQK5ut+JO1qiFPve6ahEGOQVDHwu6RdIhT+iOyUTZQRDCjEZCE3a4iSkr7FOg
         /LNUJbVSIAjOM1q8bL0ZNB4t0iIoyO6bdkOgNyQb1lrWdgMi47MuaXK0dVMd2nEwAy
         aCO36BNaRBeSw10lapZsDMb5fv6OuqU1/Rg+V7yogrXOaBTAqH58rr02RuYk+tA4zX
         P9ide9MQ5zMR6vo56kHkjX4XtgdL01yoeAr6Nr83XwINNNl3s296M4G45j9+jRQtXX
         x37jnWNUkQ3CfUEij8wlxNCVvBh7trmMit9NoQyGW14Q9fW9ISIJEHp6cm+y0i0VQu
         FjdMP6gebicZA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 803C7C027;
        Thu, 27 Apr 2023 13:23:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594640; bh=WAcni6OXNNhfIsk21LRpOs0ssDNtEseYLnTlcemrY2g=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=Wt+7+6xvO9HpFj/9+TH6G66Z+k2kv/ZAxBqrO7vZuLcrXeBBpqIPZCrKilnbwH3iL
         rjxCDHyw3prxovaCXgbDEd+Bg+933sV1tqiur43VXCLZcdLrLZ0KI8JkcHCo4NvQsy
         ESK9exMRPQkoTeiaOV3JIATVreJr7FbH8Gzy/Ofu0vFOYWSoF4hBwM0V6ie80CFxov
         C5WIO/y4vCSvBVWwmxDWtrTPyyrmyPpAmWXLj0Zr0U4kcGG+NwaJ3sjbltAHlAVEPZ
         UBQiNsoEPocMRkY8iIm9fL/Ke7iS5ANVuG0xKXEf+vfvuiGVp3D4Oa9r5SYqcxnljJ
         4YqGDXoum1JCA==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 62ba5dfd;
        Thu, 27 Apr 2023 11:23:38 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Thu, 27 Apr 2023 20:23:37 +0900
Subject: [PATCH 4/5] 9p: virtio: skip incrementing unused variable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230427-scan-build-v1-4-efa05d65e2da@codewreck.org>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
In-Reply-To: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1446;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=ZMF8fKgy6MruQWkvDgsGF7Eu9N0vj7dpVoHPZqEHFx0=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkSls6JkS5vYc7mI/MehYXF+/hAVc7drQX7F6Xt
 Z8djcyEa4CJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEpbOgAKCRCrTpvsapjm
 cE7lD/45MIokCD08AcJcd9l8YjKbW6ivA5vwiktynC6acsoejS6D6tpmT3ajrzdUNajSO9e+4QH
 MJq1Xb3Zc4kDZanpyVRsZrtbtkRiaJgCYm4DPzf5AzBiz0LgMpY/Q2cM1Lm0zAfM7aMSSj8ieGh
 3ou6Ov9He5CG28Dx32MB5EUbpQb2w5WFZNvJXA0N+25uM2tS2PU0IGYjUGlDakTgp+xrWEMtrph
 G9kCoT78Zw2LKVVj3817dFqFAoZThsMJLAp8VrMkXVNm8ND63oNtUalPkAiuctQ3v8+j7GmFZQh
 UzkQqS7g+DHDoNKgBglWyOjyeyE7VtO6XYcHd0hSmQ71aUBko7Fps/8eUtx+YBXQc3ulqg5o06x
 3Ull4YF+3FUoWnmY+ShoOCZtYPzjcYXGrPTqJhs9tlSLmcJM+j2Ph8Z0v8iPd2n0yZ/4KOgLxb1
 EXhouUqQ32Ov9dY+PWWIavIkVaE52vDzuejOoLTrlQcztNGvAHXhnOZiD7RB09sq9qgvMupOPVG
 nxP6sS6oTObNmGRgruQzM44Ze2VEgniGpd/7dcCYOwwQt+dJs0EvsqlekArR+Wvx8qq0yquDPO/
 UIqf7a8cHvKmXr2oBK4CX9VTCCFFyDqBoucCtzj5boJS25FeS1X/TtqVh3zcMBjCrVVd5lvKIce
 ZDq4TbS5z4oB6AA==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following scan-build warning:
net/9p/trans_virtio.c:504:3: warning: Value stored to 'in' is never read [deadcode.DeadStores]
                in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
                ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I'm honestly not 100% sure about this one; I'm tempted to think we
could (should?) just check the return value of pack_sg_list_p to skip
the in_sgs++ and setting sgs[] if it didn't process anything, but I'm
not sure it should ever happen so this is probably fine as is.

Just removing the assignment at least makes it clear the return value
isn't used, so it's an improvement in terms of readability.

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 net/9p/trans_virtio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index f3f678289423..e305071eb7b8 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -501,8 +501,8 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 
 	if (in_pages) {
 		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
-		in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
-				     in_pages, in_nr_pages, offs, inlen);
+		pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
+			       in_pages, in_nr_pages, offs, inlen);
 	}
 
 	BUG_ON(out_sgs + in_sgs > ARRAY_SIZE(sgs));

-- 
2.39.2

