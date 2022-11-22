Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E00633362
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiKVCe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiKVCeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:34:21 -0500
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097A8C6552;
        Mon, 21 Nov 2022 18:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1669084454;
        bh=y8dUXG0ahbuBDGFtK8vzBr0rki8EaISmtZV4JDV5Ex4=;
        h=From:To:Cc:Subject:Date;
        b=EzRLpXckSXsSHKZjCy1yekdLxaZdaJ5XS2PEsUSl0F8qptyTKMJJWYTmCHxABusbC
         pfKz0yCTbz3DKEcT4bpvVmR+buRGnto++i1IkByoSuu4LB4yjrssSzubJs8m5AKuS9
         D8QiBanNJfsHHX8rZcY3HtrK0TEBfx0IDIHRRZsc=
Received: from rtoax.. ([111.199.191.46])
        by newxmesmtplogicsvrszb1-0.qq.com (NewEsmtp) with SMTP
        id 839B8C0D; Tue, 22 Nov 2022 10:32:57 +0800
X-QQ-mid: xmsmtpt1669084377tei36yvy4
Message-ID: <tencent_F9E2E81922B0C181D05B96DAE5AB0ACE6B06@qq.com>
X-QQ-XMAILINFO: MR/iVh5QLeieyr2QbsunDongdfzrhGIJ+bLN3f9g6GP6VMWWTSIqSORQAwardf
         gyqdivnb8+TAgRm4HcBEvXm9JxHQdTYp1WMyqPqToc3Va9C9roGeL7LcV0zRiuFRXS7FSXPwhJYY
         0fEbD/938JUdWjr8AyvfLMU9d43oHhUymu4aucqj+VHQ90UhTMC5c7a43582b5h69/e/GwkEk1/t
         uv8sIBRHdU1o/H2EN1FdEnMlXLt3ou6xkR6SuyMOWPgx5xGv3KTHGk8Tl0IzQLi79+qLAvOKRvuX
         F3eogBbYxwCwnRNQtxezdWC18wCilxfo1PxU6ovvypvQUV48sFnnVGTOBSP+KfTJFX82z3mbTLuS
         jkFFoPD8hk4MKPc0Q69d1nU4ImAiLxAvaplLPt4Ve56K+JoD3mnptPviQD+46D1U9QctdcyGDsUq
         T1qtw7wFq4WGw/NyN34ky+hPCxf8a/W3l4WNA9rFEYW/OQK4UhkekCi2IosmCLV+csJipRls5IwE
         gOV3FjrqJW+520iiK/oml5MHdwBMVB4PgynawVEOdytwaVNvjudOgajJLO51CavsewSWTVMwJ9HB
         Gv9mRfIzxjiwyfSCedfChZvMlkwhhbWWTQPzlp+H2DJTFYGIjuIPaULLKdfPqO25WZdWFikjVNsg
         XKN4xiC87SIuRxWKqc6StxmNMj7jb58DcWpT0O755/HcczMsIYK/Fd3vbiehwQvV15PLrWSNhc9S
         NKUTeKc4IOeFcFIZU/i0t2PiHNgp2vOKUwyOO3wg6SMrbJsZFlN0FXenBLl0yhyST6y4vQ89G7Yr
         eS3iBTUvzPKb4ya5Dl4R8K3iocp35eZLfEMiQjAF6a4v+E0XcjlE9fdgoWHHpOlI18iKwW5XolRu
         TbGTlNZKfbiZS51f/l8pdW/FujIHcZ8yROq/0kIKJCblzUYcgxt7aL7RK5kIl4FgVCLM5unveBP5
         kTiicu+VMOpR9415xBm1IhGLVKm9FoUPLLybhh4aNZyWghbCmtLyg89v1ghVAgPAHvK8CvoPk=
From:   Rong Tao <rtoax@foxmail.com>
To:     ast@kernel.org
Cc:     Rong Tao <rongtao@cestc.cn>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf-next] samples/bpf: xdp_router_ipv4_user: Fix write overflow
Date:   Tue, 22 Nov 2022 10:32:56 +0800
X-OQ-MSGID: <20221122023256.386424-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

prefix_key->data allocates three bytes using alloca(), but four bytes are
accessed in the program.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 samples/bpf/xdp_router_ipv4_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 683913bbf279..9d41db09c480 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -162,7 +162,7 @@ static void read_route(struct nlmsghdr *nh, int nll)
 				__be32 gw;
 			} *prefix_value;
 
-			prefix_key = alloca(sizeof(*prefix_key) + 3);
+			prefix_key = alloca(sizeof(*prefix_key) + 4);
 			prefix_value = alloca(sizeof(*prefix_value));
 
 			prefix_key->prefixlen = 32;
-- 
2.38.1

