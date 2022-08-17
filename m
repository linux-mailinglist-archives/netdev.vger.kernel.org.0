Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DBE5966E8
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbiHQBk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237636AbiHQBkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:40:25 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD8C95E77;
        Tue, 16 Aug 2022 18:40:23 -0700 (PDT)
X-QQ-mid: bizesmtp86t1660700377tn416pav
Received: from harry-jrlc.. ( [182.148.12.144])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 17 Aug 2022 09:39:27 +0800 (CST)
X-QQ-SSF: 0100000000000060D000000A0000000
X-QQ-FEAT: znfcQSa1hKaB2KlE+v5lzICgo6c8CVEBiPhKwi69cBHnRXhUB0VZkEfsBjK9I
        q2U780xj15yzCP7ciTU8g84Ve+NW5PaG1nnkwPSBRGLyzHfx3rV8r2Zzp7QKpuKtwYXzq9t
        +TDCou31S6wMxrhevCwXnPYJ2nMOF/0oU3Plr8Ub+RCrk600tv2tlW5yNg6QYWCoj3Oes3O
        7ZEo+BWClMJO8pJzkHXbEmQtRXpmnSTu25vjdB8D1lLujrvpsJtUjQEldppxWXAQoYkKWAI
        PTlv6jNeVThmfhRKqj2YyR/FXrZvvsoqWXhzrK7oAXlEayR/su5k4hEVEwO5N+IqsLPLlUy
        SGn2GXdNTCBmckdaqFS4Fiap8BopuAfM0wAvoPAtyFCYtfDdaA0HvFzE2+dqQ==
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, joannelkoong@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] bpf: Variable type completion
Date:   Wed, 17 Aug 2022 09:39:25 +0800
Message-Id: <20220817013925.10714-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'unsigned int' is better than 'unsigned'.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 net/core/bpf_sk_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index a25ec93729b9..b3c0bb601167 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -732,7 +732,7 @@ EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_put);
 struct bpf_iter_seq_sk_storage_map_info {
 	struct bpf_map *map;
 	unsigned int bucket_id;
-	unsigned skip_elems;
+	unsigned int skip_elems;
 };
 
 static struct bpf_local_storage_elem *
-- 
2.30.2

