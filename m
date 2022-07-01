Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866CC562F98
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiGAJNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiGAJNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:13:51 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AA2440E68;
        Fri,  1 Jul 2022 02:13:50 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id EBAE81E80D22;
        Fri,  1 Jul 2022 17:12:20 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KGUK4whbTKxV; Fri,  1 Jul 2022 17:12:18 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 3E7AF1E80D21;
        Fri,  1 Jul 2022 17:12:18 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] net/cmsg_sender: Remove a semicolon
Date:   Fri,  1 Jul 2022 17:13:45 +0800
Message-Id: <20220701091345.2816-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the repeated ';' from code.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 tools/testing/selftests/net/cmsg_sender.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index bc2162909a1a..75dd83e39207 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -456,7 +456,7 @@ int main(int argc, char *argv[])
 		buf[1] = 0;
 	} else if (opt.sock.type == SOCK_RAW) {
 		struct udphdr hdr = { 1, 2, htons(opt.size), 0 };
-		struct sockaddr_in6 *sin6 = (void *)ai->ai_addr;;
+		struct sockaddr_in6 *sin6 = (void *)ai->ai_addr;
 
 		memcpy(buf, &hdr, sizeof(hdr));
 		sin6->sin6_port = htons(opt.sock.proto);
-- 
2.18.2

