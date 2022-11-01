Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879156155DF
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiKAXIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiKAXGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:06:41 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6675E20BD8;
        Tue,  1 Nov 2022 16:05:56 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 8F0025282;
        Wed,  2 Nov 2022 00:05:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1667343955;
        bh=rw3lhRXMa/Ho52bgtMfPJ8t0Tc28iEsnbyGMRu0CPRY=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=TdFzXwTzQpYqv6vHwSyvuPwqNeeBukttQEQCsTB+5IadCoOnkIlGepS0baOBPSVIM
         HJKckRzD1YVk5emJH4lWcknZlVLrepoIfloLtsRFXyplODDOS3lpib6crU8k1Ol0MX
         JaoZiFGaH6b9wE8LMb8U66cyzV8As+bD1pAmetdXsDmvOBWxeVllAYKwPzAst0yVtA
         TQHeTaoJW3tdeCoP/GvZICXJ7v5zxfiqPnYglHGfqRMoL7p4yqtzAVKZj4dAnRpF2p
         qrcSSrwHJdLrYbeGLm077/8NHaDBDknlSjINk0DKBByxNRYFbGJIRyJXk9ENXUeQyX
         /Jfmzsc5NepJX0nhzmE/0uuFYhIBcaFwZ1cUDbdgdQdkrWZTH1xsUbA767FC7/hQGg
         n24nDgodDd9jfNXrOsFA0aKn31J4j7kwQnkf19lagjSqf9NIhwwhaBqQ6h4IuKeI+c
         nN0udfZD400yybauHP86ro7Ky9peb3B5Fsy7lqY6bNaegBBHJIE0THO90aC9L6uN5K
         LWDIpEo+oKc+kaZVwV1iieOji33Wce9DG5xUeaeAGceJFtlEWbNRVh1jHuM6lwWoaA
         IsNrOH+TfcYxh2+KWRlH1Nk3miOOnMLDdPO//Q8eQmwlKdljnCnT/67XSpEOPlw8Sn
         zSFob41a31IF+6+LkLs2bnfQ=
Date:   Wed, 2 Nov 2022 00:05:54 +0100
From:   Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Huang Pei <huangpei@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH v2 12/15] drivers: net: slip: remove SLIP_MAGIC
Message-ID: <091907215b5f648e4e01f32e8902c1260101c1ba.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7jljyqo7aionvge4"
Content-Disposition: inline
In-Reply-To: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        MISSING_HEADERS,PDS_OTHER_BAD_TLD,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7jljyqo7aionvge4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

According to Greg, in the context of magic numbers as defined in
magic-number.rst, "the tty layer should not need this and I'll gladly
take patches".

We have largely moved away from this approach, and we have better
debugging instrumentation nowadays: kill it.

Additionally, all SLIP_MAGIC checks just early-exit instead of noting
the bug, so they're detrimental, if anything.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
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

--7jljyqo7aionvge4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNhplIACgkQvP0LAY0m
WPGyrRAAoHizvV5tKKgojJuUkIwAPYTLrYZ6/9SmNDpIBi0+LQDLjMmieWckQUnT
wddYPgvFGTFChs0NGcJOkM2ZD9oLB9M+yl08mbSAoPe82hLSONFn+yqwakFKx/UE
ebtnQ/clo4f8fm/J+JccJ3Q2ERUohTjzBfWNfzNDoowAuC8p6ZMY7lz5GcEUrcHf
pKT7BVn3cGUq/plx/6udosO0NTctJqyYs79hZ4spDlNAJbJ057xv29gPdrr0Clzz
fUXqGQo3amFdZ+2JKpiq4+4SEtPVdTBkbHd2eL/r5T56SPZ6riBo6Nu4GvJt/82D
Op4GzgYQy67d/6FxVZERyJT5Of39AkJGJbNodBHm+BSLiYQt5DiHC+XcvRXBtyQW
brHnjifkP6494StqryYAzH0KMUOsrjipTof9O+MBaPcLvP4eWJn597G39ZBrgoCV
GuukNvupNshB/GT+d+GL7hDCKUsaN90eN50rLFPEbjYwb12WVGbKUP7pLQnbPL+H
h2c9TBofwR59jj/NpHjo/YpCiZVL0OTaHgjXmsO6+xr9RbPWLtrlpLlXyo9KjRBP
BzmJKteCg0+B9xrJCGI2UbXpcr1ZJY/WhJxWglGON8ysNmfn1M9CcVEhFAEOfDGE
BPB/RlGwNdB/F69C195r89ZoaXhXXe1uHixdRXz5bcOmz5k6v8w=
=93An
-----END PGP SIGNATURE-----

--7jljyqo7aionvge4--
