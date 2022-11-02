Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4A661641C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiKBNz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKBNzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:55:25 -0400
X-Greylist: delayed 512 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Nov 2022 06:55:21 PDT
Received: from mxus.zte.com.cn (mxus.zte.com.cn [20.112.44.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5F61006D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 06:55:20 -0700 (PDT)
Received: from mxhk.zte.com.cn (unknown [192.168.250.138])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxus.zte.com.cn (FangMail) with ESMTPS id 4N2SqB63hRz9tyDD
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:46:46 +0800 (CST)
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4N2Sq36x3lz5PkGl;
        Wed,  2 Nov 2022 21:46:39 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4N2Sq03SQJz4x5TB;
        Wed,  2 Nov 2022 21:46:36 +0800 (CST)
Received: from xaxapp03.zte.com.cn ([10.88.40.52])
        by mse-fl2.zte.com.cn with SMTP id 2A2DkUMV086818;
        Wed, 2 Nov 2022 21:46:30 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Wed, 2 Nov 2022 21:46:33 +0800 (CST)
Date:   Wed, 2 Nov 2022 21:46:33 +0800 (CST)
X-Zmail-TransId: 2af9636274b9ffffffffb20f7d44
X-Mailer: Zmail v1.0
Message-ID: <202211022146335400497@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <steffen.klassert@secunet.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhang.songyi@zte.com.cn>, <jiang.xuexin@zte.com.cn>,
        <xue.zhihong@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIG5ldDogYWZfa2V5OiByZW1vdmUgcmVkdW5kYW50IHJldCB2YXJpYWJsZQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2A2DkUMV086818
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at 10-207-168-7 with ID 636274C5.000 by FangMail milter!
X-FangMail-Envelope: 1667396807/4N2SqB63hRz9tyDD/636274C5.000/192.168.250.138/[192.168.250.138]/mxhk.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 636274C5.000/4N2SqB63hRz9tyDD
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From a09ddf4bd144610fd17bdbf07f0c27700d805e6f Mon Sep 17 00:00:00 2001
From: zhang songyi <zhang.songyi@zte.com.cn>
Date: Wed, 2 Nov 2022 21:05:39 +0800
Subject: [PATCH linux-next] net: af_key: remove redundant ret variable

Return value from pfkey_net_init() directly instead of taking this in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 net/key/af_key.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 213287814328..ec37825b1c15 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3863,14 +3863,11 @@ static struct xfrm_mgr pfkeyv2_mgr =
 static int __net_init pfkey_net_init(struct net *net)
 {
    struct netns_pfkey *net_pfkey = net_generic(net, pfkey_net_id);
-   int rv;

    INIT_HLIST_HEAD(&net_pfkey->table);
    atomic_set(&net_pfkey->socks_nr, 0);

-   rv = pfkey_init_proc(net);
-
-   return rv;
+   return pfkey_init_proc(net);
 }

 static void __net_exit pfkey_net_exit(struct net *net)
--
2.15.2
