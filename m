Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C52C6D39C5
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjDBSVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 14:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDBSVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 14:21:05 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F6A902A;
        Sun,  2 Apr 2023 11:21:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C6D3C5FD04;
        Sun,  2 Apr 2023 21:21:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680459662;
        bh=Q1dSLV0WkKrQTTWvKTXPk9LEK5CXRc1NRkFMGJRvt8g=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=L9rZiVGfJ95fTbxzIIkvOl8IJi2ZE6dOPiQlg4pX/Edmzu2YdQO0CuXO0gKOI9cLf
         +FXYDaXBpT52O9K76uJ1dAtghF0/mn9GDSXYwc+KDi2ax22wUg2EACvvYnQbAOTZjg
         gvcinolzqAeNzeiNg+qiRF+i5mrQ84csiE8Q6g0Us1P4Wzni9wtGFf+Nn2rvvEwNgm
         EX0USqHQqtODl34fLdz60VM7MhXf4Qc/9wMjWl+bXx06qaivBCxkacn5Oa3js/gk0+
         w7Y40IByyQRDvnzYf3aWQd3U3kh6xdsWZ7ZVK4BlicHU8WE9K4Mxbo6id/RS7raFeX
         JVom+Ztaf27GQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  2 Apr 2023 21:21:02 +0300 (MSK)
Message-ID: <5a180d34-ac70-0750-a2e8-d01750fad68e@sberdevices.ru>
Date:   Sun, 2 Apr 2023 21:17:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <5440aa51-8a6c-ac9f-9578-5bf9d66217a5@sberdevices.ru>
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
Subject: [RFC PATCH v4 3/3] vsock/test: update expected return values
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/02 13:52:00 #21029650
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
