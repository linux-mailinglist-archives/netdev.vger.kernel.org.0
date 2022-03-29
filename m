Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F2E4EB0FA
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 17:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbiC2PvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 11:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiC2PvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 11:51:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B75A5C640;
        Tue, 29 Mar 2022 08:49:29 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w21so20897919wra.2;
        Tue, 29 Mar 2022 08:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8rq03KLqvSovP38ixoaJUNwayv4xg9/TMu0iVALGThY=;
        b=HsqA4zfIYvhvLFMUfqiDi+L7VRyP55GTqldHeVzbpHWnqVYyM881EpE3johYU+M4qF
         P/Cz3ntzF9sHiYMlDp6gaK+agqFSVteyUIWNDwztCZmZvg7ZNd52332Rg1bd1UYH4wLT
         2+irv48Tp9CBNavfdZaIQppVNnOQpNFOVTH7LEX6nojcn43SzviMgcrnWAx1PUf0DFx1
         2QNLN6aK3rkUWzyKSPlQXJa422ZDHxkr6L5QNlpbaB4nf5Pn5LUNLXBzrozVDk/Ii37n
         Q0w8y+ND3p/J2vzd3NcBJGnG0vQ/N4PxU9EGeyapoZs6TES9j80rkp/IRri95tZIrH7E
         JTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8rq03KLqvSovP38ixoaJUNwayv4xg9/TMu0iVALGThY=;
        b=QiZry+wYuoPAAmODzXoWFNiuLIzRUfrXrsXyF2ylGwaFPxHw5THV6+52qt+iDYd/LZ
         M0TN2aep9e4OoTZRyrB9S5qjGzFipGRyOOfWPOJPDnflsYmXxpqY744M/PguFoSK1VRD
         NINOjLYYEl29bGZbj12kgJ3RELl7dO1V8vliP3JiI5gBP81wJuwgSUTki7B80PznaQjj
         0oXsHp/DXd+09DY9zUh0/sGJm1b40uG9InmA3JvoxXGOL9Y/q74HaiqhyYnP5q/pVom8
         AyGMv5svyIJfMdbMk3T5r2O+9o3o6Mf1EY9HY+B8tHgpiBe5NT+N4KYxJS1p9RaHS3qP
         mANg==
X-Gm-Message-State: AOAM530UWfKy4kWMDwOmfmFRZoCwNFVfN7QqlWyj8bhV8tJnVqTrrc2u
        hSM++nIQO9NHdzKQ3Vk73iVBZBybjAw=
X-Google-Smtp-Source: ABdhPJypmJjtWPTKHmyNctrk7r4noAAwv3NcWp5HRV1zXReSIaUUGuf3Dphy8z6S6/akBtKtNfR0tA==
X-Received: by 2002:a5d:588a:0:b0:204:1f46:cf08 with SMTP id n10-20020a5d588a000000b002041f46cf08mr32645157wrf.133.1648568967495;
        Tue, 29 Mar 2022 08:49:27 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id v20-20020a7bcb54000000b0037fa63db8aasm2514242wmj.5.2022.03.29.08.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 08:49:26 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf] selftests/bpf: remove unused variable from bpf_sk_assign test
Date:   Tue, 29 Mar 2022 18:49:14 +0300
Message-Id: <20220329154914.3718658-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Was never used in bpf_sk_assign_test(), and was removed from
handle_{tcp,udp} in commit 0b9ad56b1ea6
("selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test")

Fixes: 0b9ad56b1ea6 ("selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 tools/testing/selftests/bpf/progs/test_sk_assign.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
index 02f79356d5eb..98c6493d9b91 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_assign.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
@@ -89,7 +89,6 @@ get_tuple(struct __sk_buff *skb, bool *ipv4, bool *tcp)
 static inline int
 handle_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 {
-	struct bpf_sock_tuple ln = {0};
 	struct bpf_sock *sk;
 	const int zero = 0;
 	size_t tuple_len;
@@ -121,7 +120,6 @@ handle_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 static inline int
 handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 {
-	struct bpf_sock_tuple ln = {0};
 	struct bpf_sock *sk;
 	const int zero = 0;
 	size_t tuple_len;
@@ -161,7 +159,7 @@ handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 SEC("tc")
 int bpf_sk_assign_test(struct __sk_buff *skb)
 {
-	struct bpf_sock_tuple *tuple, ln = {0};
+	struct bpf_sock_tuple *tuple;
 	bool ipv4 = false;
 	bool tcp = false;
 	int tuple_len;
-- 
2.32.0

