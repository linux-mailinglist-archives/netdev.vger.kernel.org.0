Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C197C561E27
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbiF3OhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiF3Ogx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:36:53 -0400
X-Greylist: delayed 192 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 07:31:12 PDT
Received: from gmmr-2.centrum.cz (gmmr-2.centrum.cz [46.255.227.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A2F13E8D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 07:31:12 -0700 (PDT)
Received: from gmmr-2.centrum.cz (localhost [127.0.0.1])
        by gmmr-2.centrum.cz (Postfix) with ESMTP id D721824E86AF;
        Thu, 30 Jun 2022 16:27:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=atlas.cz; s=mail;
        t=1656599278; bh=vlhxEe8srxoyYwFAEgaB16uc4WpIlbHnozTguOSAmvU=;
        h=From:To:Cc:Subject:Date:From;
        b=iviVYsyfKb5aj2ljdklUBpohpa22A0sJaXkPoiEmxwMnSlcuofSZGIUfdfoMF2q74
         od/ZgayM0DveqBHFEbCBDZMFihvq6BIpnqk1Hq8tu7VFE2Ea4C2eRjrGWxs94scJmb
         NkEO4oQ3JUlvrbPUaA/SjpmRi/Pxftvjz905JPBw=
Received: from vm2.excello.cz (vm2.excello.cz [IPv6:2001:67c:15a0:4000::b])
        by gmmr-2.centrum.cz (Postfix) with QMQP
        id D636A2457DA2; Thu, 30 Jun 2022 16:27:58 +0200 (CEST)
Received: from vm2.excello.cz by vm2.excello.cz
 (VF-Scanner: Clear:RC:0(2a00:da80:1:502::7):SC:0(-1.5/5.0):CC:0:;
 processed in 0.3 s); 30 Jun 2022 14:27:58 +0000
X-VF-Scanner-ID: 20220630142758.530909.10951.vm2.excello.cz.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
Received: from gmmr-2.centrum.cz (2a00:da80:1:502::7)
  by out1.virusfree.cz with ESMTPS (TLSv1.3, TLS_AES_256_GCM_SHA384); 30 Jun 2022 16:27:58 +0200
Received: from gm-smtp11.centrum.cz (unknown [10.255.254.25])
        by gmmr-2.centrum.cz (Postfix) with ESMTP id 79E14238C8B6;
        Thu, 30 Jun 2022 16:27:58 +0200 (CEST)
Received: from localhost.localdomain (unknown [213.220.225.64])
        by gm-smtp11.centrum.cz (Postfix) with ESMTPA id 57FE918054D46;
        Thu, 30 Jun 2022 16:27:58 +0200 (CEST)
From:   =?UTF-8?q?Petr=20Van=C4=9Bk?= <arkamar@atlas.cz>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Petr=20Van=C4=9Bk?= <arkamar@atlas.cz>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] xfrm: improve wording of comment above XFRM_OFFLOAD flags
Date:   Thu, 30 Jun 2022 16:27:20 +0200
Message-Id: <20220630142720.19137-1-arkamar@atlas.cz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have noticed a few minor wording issues in a comment recently added
above XFRM_OFFLOAD flags in 7c76ecd9c99b ("xfrm: enforce validity of
offload input flags").

Signed-off-by: Petr Vaněk <arkamar@atlas.cz>
---
 include/uapi/linux/xfrm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 65e13a099b1a..ee8862d4335e 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -511,9 +511,9 @@ struct xfrm_user_offload {
 	int				ifindex;
 	__u8				flags;
 };
-/* This flag was exposed without any kernel code that supporting it.
- * Unfortunately, strongswan has the code that uses sets this flag,
- * which makes impossible to reuse this bit.
+/* This flag was exposed without any kernel code that supports it.
+ * Unfortunately, strongswan has the code that sets this flag,
+ * which makes it impossible to reuse this bit.
  *
  * So leave it here to make sure that it won't be reused by mistake.
  */
-- 
2.35.1

