Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D1C5338F2
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 10:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiEYI7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 04:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiEYI7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 04:59:54 -0400
X-Greylist: delayed 502 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 May 2022 01:59:52 PDT
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8558F6FD09
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 01:59:52 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4L7Ptk6SbTzvjfm; Wed, 25 May 2022 10:51:26 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
Subject: [PATCH] socket: Use __u8 instead of u8 in uapi socket.h
Date:   Wed, 25 May 2022 10:51:26 +0200
Message-Id: <20220525085126.29977-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the uapi variant of the u8 type.

Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 include/uapi/linux/socket.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 51d6bb2f6765..c272bfcfc479 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,7 +31,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
-#define SOCK_TXREHASH_DEFAULT	((u8)-1)
+#define SOCK_TXREHASH_DEFAULT	((__u8)-1)
 #define SOCK_TXREHASH_DISABLED	0
 #define SOCK_TXREHASH_ENABLED	1
 
-- 
2.36.1

