Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D586C913A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjCYWRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYWRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:17:20 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A45BCDC4;
        Sat, 25 Mar 2023 15:17:19 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id AFF515FD02;
        Sun, 26 Mar 2023 01:17:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782637;
        bh=1oACndxCCde0aJy+xLw/9NS5XuY78gvhoxVybxqB3oo=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=a7LEw/XzC36S/rkCWBxjy3X14M/lU2wLOXDrEgMg7A6QzUtOqlOXZrPeLSXCO2eIO
         7YDiCSIUUckEI1f6F8i+/AUDxmo/a1Tpaw3FxkFKzVstc1U4rk6hd9zbf3Xb4Q3kCC
         fC/jJ4NzVWkAbWCrqOSa5Gssq2k7MzFviLDSsNBfx/e1IqVN+6++QGguPNbDIy6Ari
         U7CFIuhNdvCUJXvFA2A7nX3DgWLMXpqwBgvSer7gpbinQ5LmUVs3iAsAiu+/zEjMrj
         hktjdq+LC0vCudqUYMXafgmQeHDHyk+9HO8kLeAQds9QAz5S3O9ZwewQ3Gg8efzbAE
         9li1VSMJuysuw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:17:17 +0300 (MSK)
Message-ID: <f302d3de-28aa-e0b1-1fed-88d3c3bd606a@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:14:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 2/2] vsock/test: update expected return values
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 20:38:00 #21009968
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates expected return values for invalid buffer test. Now such
values are returned from transport, not from af_vsock.c.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 3de10dbb50f5..a91d0ef963be 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -723,7 +723,7 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
 		exit(EXIT_FAILURE);
 	}
 
-	if (errno != ENOMEM) {
+	if (errno != EFAULT) {
 		perror("unexpected errno of 'broken_buf'");
 		exit(EXIT_FAILURE);
 	}
@@ -887,7 +887,7 @@ static void test_inv_buf_client(const struct test_opts *opts, bool stream)
 		exit(EXIT_FAILURE);
 	}
 
-	if (errno != ENOMEM) {
+	if (errno != EFAULT) {
 		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
 		exit(EXIT_FAILURE);
 	}
-- 
2.25.1
