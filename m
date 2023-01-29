Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D68680141
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 20:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjA2Txd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 14:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjA2Txc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 14:53:32 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67351CF65;
        Sun, 29 Jan 2023 11:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1675021994; bh=JYuBTGiyir1VWLkuLl5Eav+ldGQ3cPIiwUvVAojr1Aw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=OqPA+33d0cpLMalpPQcqXICXxjkdeNrcjukFgJigDUUN71QE1VtwqjGU79a+AlSwn
         Hzd4SuOujaM/CGmMsIwl/OOQ6/ojhZ1iXHQqrm9dt4SR4CZGcRzMaJLG8JobAw8UFa
         uvFz87c0H5cJRWLZaQb0S1NbUEf7y4D9/fO4e7HdBT+OgHI40M5zAwOZ8Dd4HXlKSW
         y5GdzE3EFiEy8XOCbjxLkBUISs8ng6Gt/r9JUqXIadd3Yo1Z6Bg9E6xCGOr/fypRR6
         dpuIXbBD3o1hHhWzvCYfZf4H/R0x4Jl8MzKKeBucH7HS9ckvRuYjfg/VUJVynwzGBe
         Uts5IBV5BmO+g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([95.223.44.193]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbRk3-1opLtI3ZP7-00bsfq; Sun, 29
 Jan 2023 20:53:13 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: tulip: Fix typos ("defualt" and "hearbeat")
Date:   Sun, 29 Jan 2023 20:53:08 +0100
Message-Id: <20230129195309.1941497-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+wsdahg7Mws6ODWFiGbtbV9FJzvOvKiRKERY/CAueVT8dS+c+QJ
 AzOxNLULMVXFNyLhDEH4wjfTo454RpUVgFCgbKw9PSv2F1FCzwbPmZX6U3bNauBT4mHZbOp
 e+8qsp2hImzNoncgITXOiHc+SHNGRIf2xOBsrjPIkh6x6s53Ec42/PcJVrEdfQBwgZH2RI5
 VTZ2c4Wat7tOC4tHSIKLQ==
UI-OutboundReport: notjunk:1;M01:P0:/O8x6w9sjM4=;otpRr11BCPUEGzeMvDiGWX08toM
 SBefsuv15bZJW1rHfI8gBprcNdOP5Otv/wcqpOBUj9cHd5znmFdZ9j1uQoCbDdrKRhy7tPSan
 UVnYVDGiYyAnDQFZsK81wDKXY+gKxFOSLLG6QZBv2DZKb3ewgMpgVdkBpUFZ6zGFfqeqRokTH
 SQvi5/iQlniSDAHqQpcpaTo4abzC+WMdCu3qpRc1YUvm/ws64EggQ3Qb6S/LVFQENFt7OwMyf
 eM92AfEFWneZqQT9P49Y//3y/PWdZ44iIdY564Qv3/koSUasnFKAuY4SNe07SK7rNT/MJNW11
 6Cc3GJm9Mjin8/wsJ80WbWvBAo64zEfYbUBoeWC+n3FTT2GMclwpMh6tpIWeVszWOIk19DKtW
 osLm9f5531yZwKJEGArpoAtIZsyJSS3ZCPKS1ZMpxOAxRiXr+bOdfjPdr8iGCFFqUtc1OXbLt
 mTeWo68isvHxd0Js2zF4pBuuTlhGkp6Dig3pUlBbBk1JM2Ht/ZyUOBWAw84KLz7HEh8I21K1t
 qsodYmoFO6dwGLS58656WlpPIwJyUwmSyDWo4vhp7XiJUGFT8gw8djvtDoonv5yMhMEFAuqsE
 CDrXniD1kcGcYxiPGYovvt1IuCGjQCL76AnosRNBCazUjTUDrYsCEy7jtySpUemUX7GfnjeaO
 +zx4ANiOKARCdWpsM8/RkQLkLSPGy4BEBgx4rZhEI5SqsUcwo4FbyCttSlGS2kvcyA1teqEtv
 AwdWy0tBTfNy50y8UJr5wsrh4CAcbjxfnUkbbkebxu+vXKGLo4PlrLyimQdBk1Z6JUZk0Wbcq
 ELrpCMdhRJlIUciexC9qB3jWDLZ5qGGX45GNWaFjiv47MJNVNSBJ8XtkBnUthRj4Dl/zpx9Gz
 X9dyPThOAEV80YowKQxvZfMirqS0XaEtQN+7ll1y9732P5mQeqyDWkmSB22Ljy5JleaqFvsCt
 OTh7PSepA2+XLMvg8hg+s4js1kI=
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spell them as "default" and "heartbeat".

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--

v2:
- also fix "hearbeat", as suggested by Simon Horman
=2D--
 drivers/net/ethernet/dec/tulip/tulip.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip.h b/drivers/net/ethernet=
/dec/tulip/tulip.h
index 0ed598dc7569c..10d7d8de93660 100644
=2D-- a/drivers/net/ethernet/dec/tulip/tulip.h
+++ b/drivers/net/ethernet/dec/tulip/tulip.h
@@ -250,7 +250,7 @@ enum t21143_csr6_bits {
 	csr6_ttm =3D (1<<22),  /* Transmit Threshold Mode, set for 10baseT, 0 fo=
r 100BaseTX */
 	csr6_sf =3D (1<<21),   /* Store and forward. If set ignores TR bits */
 	csr6_hbd =3D (1<<19),  /* Heart beat disable. Disables SQE function in 1=
0baseT */
-	csr6_ps =3D (1<<18),   /* Port Select. 0 (defualt) =3D 10baseT, 1 =3D 10=
0baseTX: can't be set */
+	csr6_ps =3D (1<<18),   /* Port Select. 0 (default) =3D 10baseT, 1 =3D 10=
0baseTX: can't be set */
 	csr6_ca =3D (1<<17),   /* Collision Offset Enable. If set uses special a=
lgorithm in low collision situations */
 	csr6_trh =3D (1<<15),  /* Transmit Threshold high bit */
 	csr6_trl =3D (1<<14),  /* Transmit Threshold low bit */
@@ -274,7 +274,7 @@ enum t21143_csr6_bits {
 	csr6_om_int_loop =3D (1<<10), /* internal (FIFO) loopback flag */
 	csr6_om_ext_loop =3D (1<<11), /* external (PMD) loopback flag */
 	/* set both and you get (PHY) loopback */
-	csr6_fd =3D (1<<9),    /* Full duplex mode, disables hearbeat, no loopba=
ck */
+	csr6_fd =3D (1<<9),    /* Full duplex mode, disables heartbeat, no loopb=
ack */
 	csr6_pm =3D (1<<7),    /* Pass All Multicast */
 	csr6_pr =3D (1<<6),    /* Promiscuous mode */
 	csr6_sb =3D (1<<5),    /* Start(1)/Stop(0) backoff counter */
=2D-
2.39.0

