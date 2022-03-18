Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350DE4DD82A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbiCRKjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiCRKjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:39:06 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C082D9D62;
        Fri, 18 Mar 2022 03:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nFaergNcBPUJhO8DBhWFLEOX7hoSf2bn68A0m5x3R8s=;
  b=JBHk4PExvNffj6VKnNBv2MivlRozRfYGkxUut8VYfpQGg/Hr82Epw2sE
   nspUSq7YpyCUbzrB6VZkR54EGCURv6X0DcU6CKri8Ksh29jnB1wsnditG
   DZY7WcAh3qKEuaSYoORS4kGd+TuJVaPQm+IJx4xkVodRFjlQPzoHyO0pG
   A=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,192,1643670000"; 
   d="scan'208";a="8935641"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 11:37:36 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Shubham Bansal <illusionist.neo@gmail.com>
Cc:     kernel-janitors@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: net: bpf: fix typos in comments
Date:   Fri, 18 Mar 2022 11:37:04 +0100
Message-Id: <20220318103729.157574-9-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 arch/arm/net/bpf_jit_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 10ceebb7530b..9e457156ad4d 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1864,7 +1864,7 @@ static int build_body(struct jit_ctx *ctx)
 		if (ctx->target == NULL)
 			ctx->offsets[i] = ctx->idx;
 
-		/* If unsuccesfull, return with error code */
+		/* If unsuccesful, return with error code */
 		if (ret)
 			return ret;
 	}
@@ -1973,7 +1973,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	 * for jit, although it can decrease the size of the image.
 	 *
 	 * As each arm instruction is of length 32bit, we are translating
-	 * number of JITed intructions into the size required to store these
+	 * number of JITed instructions into the size required to store these
 	 * JITed code.
 	 */
 	image_size = sizeof(u32) * ctx.idx;

