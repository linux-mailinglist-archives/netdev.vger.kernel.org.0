Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089416D4383
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjDCL35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjDCL3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:29:55 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ABFFF09;
        Mon,  3 Apr 2023 04:29:51 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 350B45FD22;
        Mon,  3 Apr 2023 14:29:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680521390;
        bh=Q1dSLV0WkKrQTTWvKTXPk9LEK5CXRc1NRkFMGJRvt8g=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=j2qzNll/6/dpzx/30RXAHTNPRE9oE6UumpNtp+olyKJef2hhZe4rvWSwSB7+m7PiM
         PaFtiCYpc8JFGkLU/vMER89UN/Uf8unbGIcvFS4YnuYJE4gsAxf16vb4PYM9mm4cih
         wYErFyXFdgzMk4llX009YDO0uUgdC/qAR3k9k+h1FxBgn76jA4xC3HcnUyHObrCkdY
         QEVy4flZTOVuuBKgV0njrsck+7mokGmFLcVc0XCWlJDUbqUWfcQPAYngo02showNkD
         yiOLwigGwcDZJpa/n34XHOS597DTi5R8Zcgi8NYwkPzRZbG4pagP3JYKymKijL5dE8
         Q8hQ3xnbynw3Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  3 Apr 2023 14:29:49 +0300 (MSK)
Message-ID: <0c4d433d-104d-f3e6-94c7-297c2ed557c0@sberdevices.ru>
Date:   Mon, 3 Apr 2023 14:26:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <0d20e25a-640c-72c1-2dcb-7a53a05e3132@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>, <pv-drivers@vmware.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [PATCH net-next v4 3/3] vsock/test: update expected return values
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/03 05:35:00 #21028078
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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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
