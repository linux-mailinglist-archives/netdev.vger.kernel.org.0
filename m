Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D288A66A9A7
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjANGjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjANGjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:39:39 -0500
X-Greylist: delayed 588 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 Jan 2023 22:39:37 PST
Received: from 8.mo552.mail-out.ovh.net (8.mo552.mail-out.ovh.net [46.105.37.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1014ED2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:39:37 -0800 (PST)
Received: from mxplan6.mail.ovh.net (unknown [10.109.143.236])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 6F51A2C518;
        Sat, 14 Jan 2023 06:29:47 +0000 (UTC)
Received: from jwilk.net (37.59.142.108) by DAG4EX1.mxp6.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Sat, 14 Jan
 2023 07:29:46 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002d69caf9b-cd2f-4ed3-8732-77c5d6512af3,
                    B1E680D09F85797F29E7873D36850E2DCD85CED7) smtp.auth=jwilk@jwilk.net
X-OVh-ClientIp: 5.172.255.115
From:   Jakub Wilk <jwilk@jwilk.net>
To:     <netdev@vger.kernel.org>
CC:     Peilin Ye <peilin.ye@bytedance.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2] man: ss: remove duplicated option name
Date:   Sat, 14 Jan 2023 07:29:44 +0100
Message-ID: <20230114062944.3246-1-jwilk@jwilk.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.108]
X-ClientProxiedBy: DAG2EX2.mxp6.local (172.16.2.12) To DAG4EX1.mxp6.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: d2723418-3c7b-42e9-92df-7ccdeaee638b
X-Ovh-Tracer-Id: 5465962574890457056
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrleelgdelkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgtghisehtkeertdertddtnecuhfhrohhmpeflrghkuhgsucghihhlkhcuoehjfihilhhksehjfihilhhkrdhnvghtqeenucggtffrrghtthgvrhhnpeefhfetfffhffehtedufedvfeehfffgudeljeehieetiefhfeffjeevleejveehieenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehjfihilhhksehjfihilhhkrdhnvghtqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpphgvihhlihhnrdihvgessgihthgvuggrnhgtvgdrtghomhdpughsrghhvghrnheskhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jakub Wilk <jwilk@jwilk.net>
---
 man/man8/ss.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 996c80c9..d413e570 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -156,7 +156,7 @@ the number of packets dropped before they are de-multiplexed into the socket
 Show process using socket.
 .TP
 .B \-T, \-\-threads
-Show thread using socket. Implies \-p.
+Show thread using socket. Implies
 .BR \-p .
 .TP
 .B \-i, \-\-info
-- 
2.39.0

