Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27754FAA23
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbiDISYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbiDISYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:24:46 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA5727AD7D;
        Sat,  9 Apr 2022 11:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649528525;
        bh=S+JIsUWtPOwYWYyB2E9KgSEzbhqzWkIfhvyksSh185M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=RtcSzWZrFFr3F6HMnJBTOTQyJ54eC+eE+Kw9yORmhIkuzLJWOlGygzyH0Qnez1d/t
         6uFFK9j+C4I/iqBTqA5lUfknz+rOEXHxu2attjXnIe8neWal6njGOjlFp7pDrx+hTb
         tu1RT/Ry2/O0iNC9KFfi5KOU9+rjA1OEF7tfSg9M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([78.35.207.192]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MLiCu-1nLaJR225I-00Hfti; Sat, 09
 Apr 2022 20:22:05 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yang Shen <shenyang39@huawei.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: calxedaxgmac: Fix typo (doubled "the")
Date:   Sat,  9 Apr 2022 20:21:45 +0200
Message-Id: <20220409182147.2509788-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MzRYXerfuQKo4NMjt0teyY17AoArObCa0ia0c5JtBjtduSkasTB
 3+4xi0ufqPNYCaJCEo1MEDuYtSjfCbRE8jyVyxvCLX0qj52pkA5JkNRnc2frZ9l7ksPcC/F
 Za+I/i7d/nFfxtjLnkbgy4PsAxBWbi4mWkAR5DE/8qjYcbvz53cprKO6V1nuYnpiwBDA/5f
 t+Icw8MevJRpPDBhZ4fxA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zoOWCozI0+4=:jSLjqHTVCVVjeiF4j0kBxa
 d9nFxUu+WcMZdVoKmUHwCWOOh8DtnQbRqz1zAkvECTeH51Au+A/Qzuidpk2o1152N4AJ6fQ+s
 KBt3gNLSv4W/37xStYv9F+Yd8sWAEU48hybzoVG3OvdQtOvr4s93KVnbWGHp7gmilD40oNdhP
 bQVu6GA6CNtuh1EClDC1p9QNAmnuseQmLGvjNh3CwocckKf+/PU98EOvzV1kjk1jIiDVREXAb
 kY4wyy8TSv6Q+JjAq++LBJOm9yighLeOinUP1qs1DAXF87PoY6v+QQL+hRED11fdenOghbM0Y
 C7iK6/yz7sG1X8XoZMdRyKHsGEAfQmNJsFQwDGb8pYoVCwJbBCoLtQoV1TY42e1tSnKfmB6Og
 gc0QMa86ZUuwjU8C7nIkgXxgqOYNrgybI7SqoySWg2H6o2DjOakaWcDNkPyTuHj4v9xkqEwgt
 pTVbitbjhTCLDXtUqqd4fu+Jo2QUC4gKv2GYgjDB6f56HzUpHBtZmpBiFeCP+LMSnQagzCQP1
 fYUiEm1vKe4ncsLwpjK/r5irhSsPD4aEFKqoF8bdlGAmCNOFcZK3TPv19fdrlXvRE95qYIi/s
 WMeABOMtyBicz7zKqMYUrz/WaeiN/PaEP9w4/QyC6BEOwoxr6HYidbdrgoSR2aKY6QtoMJD3F
 6hphDQI9mlJPdY65/PIudb+FkzgQeMN6OUwbt+Y7eAXRZIwBS6so/n939e9vCQVsmhlP8Riuq
 I85QzpHD/TURD6+nBIiF78QzROHtLdU1p6Ke0daFgNP2nPw01aQ99DTl2cD9wSJqVR5teApw1
 fHKzaLw54IHwWFh5szU8glhcjNskzMu64jTCPinCh+nqtODRAOu+rbdsbzJRu4V5cemqzNV8x
 UcF7tGim9ddhQNLlV2vQqf4VEkS2F45uq8MAIlkGuvi3+CS4rMLQrKUikS9ZtWFKPuo1jgY1Q
 QRMD+Hws6KXzkp9qFTjz9AGES86rg/2MiAhtZiji6OTirEkXDOMsWyYNOgs0J4E1r/no1zPaX
 NPZKsNSh3HPhqBxAghOk/kNIIx/SxRrlT+T1QyxeReigcl8uWtUmKGBDobRSW69+BKllZYOzY
 Bj2GwzWPNHI2w0=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a doubled word in the comment above xgmac_poll.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 drivers/net/ethernet/calxeda/xgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/c=
alxeda/xgmac.c
index 457cb71210003..1281d1565ef84 100644
=2D-- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1224,7 +1224,7 @@ static int xgmac_rx(struct xgmac_priv *priv, int lim=
it)
  *  @budget : maximum number of packets that the current CPU can receive =
from
  *	      all interfaces.
  *  Description :
- *   This function implements the the reception process.
+ *   This function implements the reception process.
  *   Also it runs the TX completion thread
  */
 static int xgmac_poll(struct napi_struct *napi, int budget)
=2D-
2.35.1

