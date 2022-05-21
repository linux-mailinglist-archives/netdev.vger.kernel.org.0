Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93BC52FB51
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbiEULON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354921AbiEULM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:57 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5CB5A0A3;
        Sat, 21 May 2022 04:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vki7c+Z/XcQTedYYjJ9Z0HiIFJR55lVzHQlQz/ICUmA=;
  b=AePPL+2rg5Fzf39quers+bpIAxjl2WaizQ6BU0sMPrYyzt+/p589nV/t
   gnKH3S/XeEH2Pvqs3xffsreaWCdK+ughutTD20g9D2Yoe3nym2weVkogr
   VbFle9whGw6JqibuwhXFY5ey6/5ILOTADthgl4ukAdXX7HECKOF1Fc4Be
   Y=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727979"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:04 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-janitors@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libbpf: fix typo in comment
Date:   Sat, 21 May 2022 13:11:21 +0200
Message-Id: <20220521111145.81697-71-Julia.Lawall@inria.fr>
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

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 tools/lib/bpf/libbpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ef7f302e542f..e89cc9c885b3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6873,7 +6873,7 @@ static int bpf_object_load_prog_instance(struct bpf_object *obj, struct bpf_prog
 	}
 
 retry_load:
-	/* if log_level is zero, we don't request logs initiallly even if
+	/* if log_level is zero, we don't request logs initially even if
 	 * custom log_buf is specified; if the program load fails, then we'll
 	 * bump log_level to 1 and use either custom log_buf or we'll allocate
 	 * our own and retry the load to get details on what failed

