Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C25E52FAF9
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiEULMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241400AbiEULMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:01 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE192980B;
        Sat, 21 May 2022 04:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KmIV/3ghYTyKQheC6tXwJG/ENcBeirNooDVVS2YYG0w=;
  b=j8Li1hmCObiJw3BDel5bGGfwPhSNO1QRIkQrMyj2x260WI23OfPKcyi4
   ii3TltmEqulqN2iE7P8EMsgm3LCAZpNLVs6Sm+I/9ywaZp/90Xoz7peEM
   ciI/euU+mxiSGwz7J6TLQ2yc8uDch0zIC+Y8DJhRrBdQKyApS3LBlXioh
   8=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727899"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:53 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virt_wifi: fix typo in comment
Date:   Sat, 21 May 2022 13:10:18 +0200
Message-Id: <20220521111145.81697-8-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/wireless/virt_wifi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index 514f2c1124b6..ba14d83353a4 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -654,7 +654,7 @@ static int __init virt_wifi_init_module(void)
 {
 	int err;
 
-	/* Guaranteed to be locallly-administered and not multicast. */
+	/* Guaranteed to be locally-administered and not multicast. */
 	eth_random_addr(fake_router_bssid);
 
 	err = register_netdevice_notifier(&virt_wifi_notifier);

