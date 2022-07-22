Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42DB57DC31
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiGVIUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiGVIUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:20:51 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 844419E295;
        Fri, 22 Jul 2022 01:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9rGVT
        KZCgVP5GWbgtbLzKr5CKnoplaDI6xwXj00AGQo=; b=ePHBgu4vNYmgVDmtmsi73
        U8fiptE7wxnXzndxiGwtbDjrIey5C6HkuspMvM7fvN+HRsln69lxT7ay8d5bF7Ah
        8GURkBUxA2saij6Dn2CKJUUxVs8eayM21CmJ//yFE5ZjmN5SWXI6ZgzF7JOiBWw5
        PEVMX62w6GdRQFaVzBLIOM=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp4 (Coremail) with SMTP id HNxpCgCHyHjMXdpiZcp1QA--.20845S2;
        Fri, 22 Jul 2022 16:20:30 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     simon.horman@corigine.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] nfp: bpf: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:20:27 +0800
Message-Id: <20220722082027.74046-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCHyHjMXdpiZcp1QA--.20845S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr1DJr1fCF48AFW5ZFb_yoW3uFcEkw
        1UuFyfGa15GFs0kw47Cw4Ygas2y3yDZF1fuFs3K3ySv34Ykr48Xasa9rZ8Xwn8ur4UAFZI
        q3sxJFyUAayjyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCrWo3UUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRw5GZFc7YxBofAAAsg
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index e31f8fbbc696..df2ab5cbd49b 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -4233,7 +4233,7 @@ static void nfp_bpf_opt_ldst_gather(struct nfp_prog *nfp_prog)
 			}
 
 			/* If the chain is ended by an load/store pair then this
-			 * could serve as the new head of the the next chain.
+			 * could serve as the new head of the next chain.
 			 */
 			if (curr_pair_is_memcpy(meta1, meta2)) {
 				head_ld_meta = meta1;
-- 
2.25.1

