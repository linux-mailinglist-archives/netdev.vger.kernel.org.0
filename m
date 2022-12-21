Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBF6530DF
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiLUMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiLUMgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:36:36 -0500
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643F71A3A6;
        Wed, 21 Dec 2022 04:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1671626191;
        bh=PHssQIIcG/OnBIFPY5sJXgvOu5LyKV2Mnt7w1hnvoCI=;
        h=From:To:Cc:Subject:Date;
        b=x8n4JebP+71sEC4bXG/vG9hukn+cawsYg7Rhx2O257iSrhrikB8n7ns0qi/l+Eo9w
         c2R/2VnFoZqVBqWCWzbFn2BvLJHquDZaM6psq1ElF/2dM0gYDi2+hxUDv6FhNVs5SP
         XpTENkEbwdOu9j1aFtz0E2lzD2bCwLWtn2DnxpAo=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrszb1-0.qq.com (NewEsmtp) with SMTP
        id 91D036C0; Wed, 21 Dec 2022 20:36:29 +0800
X-QQ-mid: xmsmtpt1671626189tbjc771wu
Message-ID: <tencent_F1354BEC925C65EA357E741E91DF2044E805@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvT47z0yqmb0dSmYife1iARkf2zJMgpZ92GOKz7EDdfQ54KVYWztz
         9sE+iUREtzczPfMx+TkaaJVTc8Y4epsu2vQGFbPFlPo7N9q/K32+RtxBq5B91h53sxXf3GNhceEE
         gVP8xis9VPZ4gLOJ77TMqEeOKTbqisNFrR8hY72mb/Oho1rFY049klmWX2QBz6XP7ZGzQJXf1QQp
         FSXpQRD0Z4IfNGYgfVx3x34s+P0arpW3PSIHROXzfGiNbLSbdMGi01dqcsdEu3bY/qSRApS6Z3Dx
         fq3XFgHipShh9kt4RUrEf84DjuTm1cF88ghf4HVYwSDoZFeB8KQrTN2DjsIhNCpPP8339t0SM3AV
         n3xPUNEp6LdD/V9PqHTS6sFzupah4tRprped/7EeppL2xp/Rv7y0C1I6ErRRn7hUyjqSxwUA0Caj
         k7BVlLIF2OzwoZhOQPDfhDipRDkOPfrmLScwV8rmVQWL+StxHNo0irhsKiqhjHbTJH6HwefbkLsC
         JzPDqgpbVziW0Ji03k9x37sfqqsPWMAh2X7T2JQZSQGXkvHGWRKpB9O0f34SgZ4Rj3wtSVEgYRBL
         MMLiLIKDS2bgK4DdRwqsYTJZlKELJq3JE9/5ADYkbOlIvNh2Qrc7U1QI9y2bwP9KtGwWd2q3fM7O
         MvdgqBg2VoCw+BAAJsZUYXhuU/3iq1ziwDZQOo696AEpUfaptQDUxpDo7Pap79zSSUonPo7qGIGj
         uW56GIdXxhL2zIpCQ2wGBbhxx9mJutANCbqicgill10XU098W2Hi9ULjEP0yE5Io/h96NOo8+9ap
         L5BeNH6kxLP8TiCpyE3mnO+HyzTBVJoxeSVS3KG7qenF84IgXLrhZ3fVF1JlI/W16eFaQLTFQTYu
         P5y3VKolVjZhApmLk03uHm1mRaef1iGkT72/GCmqFDDeLVMm4LgO/DarXOZFOAQTZ2EU2zs5BCCm
         niyGqIvhYUwRyGk56zu6IhoBzAfaQfb5raJ8PmurwerqQC5O4tiQ==
From:   Rong Tao <rtoax@foxmail.com>
To:     3chas3@gmail.com
Cc:     Rong Tao <rongtao@cestc.cn>,
        linux-atm-general@lists.sourceforge.net (moderated list:ATM),
        netdev@vger.kernel.org (open list:ATM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] UAPI: fix spelling typos in comments
Date:   Wed, 21 Dec 2022 20:36:27 +0800
X-OQ-MSGID: <20221221123627.82584-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Fix the typo of 'Unsuported' in atmbr2684.h

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 include/uapi/linux/atmbr2684.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/atmbr2684.h b/include/uapi/linux/atmbr2684.h
index a9e2250cd720..d47c47d06f11 100644
--- a/include/uapi/linux/atmbr2684.h
+++ b/include/uapi/linux/atmbr2684.h
@@ -38,7 +38,7 @@
  */
 #define BR2684_ENCAPS_VC	(0)	/* VC-mux */
 #define BR2684_ENCAPS_LLC	(1)
-#define BR2684_ENCAPS_AUTODETECT (2)	/* Unsuported */
+#define BR2684_ENCAPS_AUTODETECT (2)	/* Unsupported */
 
 /*
  * Is this VC bridged or routed?
-- 
2.39.0

