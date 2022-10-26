Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5060EBC3
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 00:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiJZWo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 18:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbiJZWnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 18:43:53 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE2FC108266;
        Wed, 26 Oct 2022 15:43:33 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 2979445F2;
        Thu, 27 Oct 2022 00:43:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1666824213;
        bh=peSt6Ngd9dQwG3mJMnSEDxxpVnYEqXKHKBMQf6O6+NA=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=uB03pUvQoQ3l89bCq8VZ6g43zIA1TozMbKO/u0r3royUEci2wPDbNtn3vTC0iMI21
         iCndnMA8JtnZzauiY126qxn+NyIZMQxeY4RS+MHwrMqH1GWWfc1L0una8VSjMpB+Mh
         DJl3ngRAkp8DnYCtewsTHQtsTvpAZYMXDsXFUz+KWBFCoIbw8pBlHoe8qhJEahBuIc
         faLTs5P/1pBg65cnzyf47L/YX8ahM5qhSyhl2RqypEcbaoxBkaqqe1Y637gaF1FNh4
         U/+I1ONvpF90+PTUYqnO8fWzLrHQ3KvKWs+QeLsSuaD90nS7XKacNqW2NZJFlNtfeu
         j5022/PL6pWIEeP+7XJN//kPECVciEkq9S6vQj2+1kwFGi960+vHz6IHYMunA9oVGf
         MXRKSnF6tTbimwHjNzz2fITmP8ZH1xUMduOzTBFlnHyfw+H6TT0Xz51ZWCfYer6rAe
         YX7KBMEtg9HLCePThFRZVxh9dVpDRc2XulO8gD7Mxj15eZNe/YDl4DJe185miwjEXb
         ps4G4AF9wGvcLopKivR+DGSq6O0cTkpUU2Cmche1a+CnPvQW/TgAUc9LDy6CuJMkVZ
         fO0SgvuNtKAuLm73p4MWZ0Wv5e1j0aXG/AY1eqPLHK6VweBP9P7ofIaZ4m8ErrMilC
         yrkEFPpOG5gssZUyUeXHZPsY=
Date:   Thu, 27 Oct 2022 00:43:32 +0200
From:   =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Huang Pei <huangpei@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 12/15] drivers: net: slip: remove SLIP_MAGIC
Message-ID: <f5f9036f2a488886fe5a424d8143e8f2f3fdcf3f.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="efpn7tap4shcrx3s"
Content-Disposition: inline
In-Reply-To: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        MISSING_HEADERS,PDS_OTHER_BAD_TLD,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--efpn7tap4shcrx3s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

According to Greg, in the context of magic numbers as defined in
magic-number.rst, "the tty layer should not need this and I'll gladly
take patches"

We have largely moved away from this approach,
and we have better debugging instrumentation nowadays: kill it

Additionally, all SLIP_MAGIC checks just early-exit instead
of noting the bug, so they're detrimental, if anything

Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 Documentation/process/magic-number.rst                |  1 -
 .../translations/it_IT/process/magic-number.rst       |  1 -
 .../translations/zh_CN/process/magic-number.rst       |  1 -
 .../translations/zh_TW/process/magic-number.rst       |  1 -
 drivers/net/slip/slip.c                               | 11 +++++------
 drivers/net/slip/slip.h                               |  4 ----
 6 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index 3b3e607e1cbc..e59c707ec785 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -69,6 +69,5 @@ Changelog::
 Magic Name            Number           Structure                File
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index e8c659b6a743..37a539867b6f 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -75,6 +75,5 @@ Registro dei cambiamenti::
 Nome magico           Numero           Struttura                File
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index 2105af32187c..8a3a3e872c52 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -58,6 +58,5 @@ Linux =E9=AD=94=E6=9C=AF=E6=95=B0
 =E9=AD=94=E6=9C=AF=E6=95=B0=E5=90=8D              =E6=95=B0=E5=AD=97      =
       =E7=BB=93=E6=9E=84                     =E6=96=87=E4=BB=B6
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index 793a0ae9fb7c..7ace7834f7f9 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -61,6 +61,5 @@ Linux =E9=AD=94=E8=A1=93=E6=95=B8
 =E9=AD=94=E8=A1=93=E6=95=B8=E5=90=8D              =E6=95=B8=E5=AD=97      =
       =E7=B5=90=E6=A7=8B                     =E6=96=87=E4=BB=B6
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
-SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 6865d32270e5..95f5c79772e7 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -426,7 +426,7 @@ static void slip_transmit(struct work_struct *work)
=20
 	spin_lock_bh(&sl->lock);
 	/* First make sure we're connected. */
-	if (!sl->tty || sl->magic !=3D SLIP_MAGIC || !netif_running(sl->dev)) {
+	if (!sl->tty || !netif_running(sl->dev)) {
 		spin_unlock_bh(&sl->lock);
 		return;
 	}
@@ -690,7 +690,7 @@ static void slip_receive_buf(struct tty_struct *tty, co=
nst unsigned char *cp,
 {
 	struct slip *sl =3D tty->disc_data;
=20
-	if (!sl || sl->magic !=3D SLIP_MAGIC || !netif_running(sl->dev))
+	if (!sl || !netif_running(sl->dev))
 		return;
=20
 	/* Read the characters out of the buffer */
@@ -761,7 +761,6 @@ static struct slip *sl_alloc(void)
 	sl =3D netdev_priv(dev);
=20
 	/* Initialize channel control data */
-	sl->magic       =3D SLIP_MAGIC;
 	sl->dev	      	=3D dev;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slip_transmit);
@@ -809,7 +808,7 @@ static int slip_open(struct tty_struct *tty)
=20
 	err =3D -EEXIST;
 	/* First make sure we're not already connected. */
-	if (sl && sl->magic =3D=3D SLIP_MAGIC)
+	if (sl)
 		goto err_exit;
=20
 	/* OK.  Find a free SLIP channel to use. */
@@ -886,7 +885,7 @@ static void slip_close(struct tty_struct *tty)
 	struct slip *sl =3D tty->disc_data;
=20
 	/* First make sure we're connected. */
-	if (!sl || sl->magic !=3D SLIP_MAGIC || sl->tty !=3D tty)
+	if (!sl || sl->tty !=3D tty)
 		return;
=20
 	spin_lock_bh(&sl->lock);
@@ -1080,7 +1079,7 @@ static int slip_ioctl(struct tty_struct *tty, unsigne=
d int cmd,
 	int __user *p =3D (int __user *)arg;
=20
 	/* First make sure we're connected. */
-	if (!sl || sl->magic !=3D SLIP_MAGIC)
+	if (!sl)
 		return -EINVAL;
=20
 	switch (cmd) {
diff --git a/drivers/net/slip/slip.h b/drivers/net/slip/slip.h
index 3d7f88b330c1..d7dbedd27669 100644
--- a/drivers/net/slip/slip.h
+++ b/drivers/net/slip/slip.h
@@ -50,8 +50,6 @@
=20
=20
 struct slip {
-  int			magic;
-
   /* Various fields. */
   struct tty_struct	*tty;		/* ptr to TTY structure		*/
   struct net_device	*dev;		/* easy for intr handling	*/
@@ -100,6 +98,4 @@ struct slip {
 #endif
 };
=20
-#define SLIP_MAGIC 0x5302
-
 #endif	/* _LINUX_SLIP.H */
--=20
2.30.2

--efpn7tap4shcrx3s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNZuBMACgkQvP0LAY0m
WPHBqA//XU3DoTLoIVTAhV0jSFetXQoh71mqvk9CXpIcX9gEo4VYgu9DSRtAuIo6
4YkAL7U9yZvSv/css75T4RW3tAnmNBv2aQSgN/FmcK05f/4x+iG4L+1cSmUVPowk
RDJUz0MAZg/0VWaEEUupIVeXRcqReZun4+WIWW/qfSHP1Nirrsqu/Ayh63inRXnP
17FtL0U6RLRwiowrEgSTNote8rK5PPaXAML+6Q5ZaWNnR4VEaDPNDzX9z96UF9Rp
+h8V7t2Vgxbd0z1dTgA/uormaFJ2/X3Sj4GSE2QMZV4qUXwaWXzdK+jhNrqAKLat
ITzyMPd1vwdCZI0RTdE1Ml9vNpR+AAW/sqfxuKouqcyoEJIOsrd+vPWo5yzzPAAR
gJQBmKTJz2RmMszQtVeBRg8gtcmn9SBgUXmc+xIf5GzJM+JBjn1L9bwYfoZeditf
H7xaQFnkKymlggT+4mtquJYPRRqJSTLqFhgV1px3+T0y1mlaf57dt3qnGt+yc2U7
auodGh3vyyDhkZRlvFU72RuBAQ0UgG5zgnemw/kX0DP7f85q4WUW9NVTqEamyGoC
sOoNZ/JlBeCDK2CXM5x9yWrvbkrjb1UwD/QFf8FcxnwSIaEPB6xbnU7PJTAhe3Rn
FnOW/Sy64uc/ZBleFom5y16+kuoE5681HVOI9+niUhbso981GBg=
=YxRy
-----END PGP SIGNATURE-----

--efpn7tap4shcrx3s--
