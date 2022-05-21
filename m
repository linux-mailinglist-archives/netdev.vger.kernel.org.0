Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF5D52FB50
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354981AbiEULN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242689AbiEULMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:06 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3730F2980B;
        Sat, 21 May 2022 04:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ysSCHxYUYI2fnvbvjl19r0L14v2vd2rA12vVrwVzVi0=;
  b=UqK5kh2EBbAGZipXfNg9E2KfKuDxjrFxb0oz0Ho0tGLgmOEKYhG4lkwD
   3M3Zc7SdrIYY8eKOLYmjLyUQp1i6YDnmV8YgSIZfqGlCdSIYPZAlxuq2k
   6Kun0ZXJw0CRqeGDpOM8Qhe3U+AsddizZOk4z1RJIQQfo4i2UoVO6GwGj
   4=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727919"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:56 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Wolfgang Grandegger <wg@grandegger.com>
Cc:     kernel-janitors@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: peak_usb: fix typo in comment
Date:   Sat, 21 May 2022 13:10:34 +0200
Message-Id: <20220521111145.81697-24-Julia.Lawall@inria.fr>
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
 drivers/net/can/usb/peak_usb/pcan_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 17dc178f555b..091c631ebe23 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -533,7 +533,7 @@ static int pcan_usb_handle_bus_evt(struct pcan_usb_msg_context *mc, u8 ir)
 {
 	struct pcan_usb *pdev = mc->pdev;
 
-	/* acccording to the content of the packet */
+	/* according to the content of the packet */
 	switch (ir) {
 	case PCAN_USB_ERR_CNT_DEC:
 	case PCAN_USB_ERR_CNT_INC:

