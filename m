Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4D624F67
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiKKBPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiKKBPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:15:01 -0500
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24EA964A0E;
        Thu, 10 Nov 2022 17:14:35 -0800 (PST)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 739CB740;
        Fri, 11 Nov 2022 02:14:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202211; t=1668129274;
        bh=Be1Pxakq207nlXxpQ89ncdamlPosjQkgXJViXRRlV10=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=eFoPT6Tau6WfPDeDdofL7X3GpraEEXez1hwa7ZE0Vq2fveMN6hCDcIIYxnLqh+UyX
         w8738D+TMvGM1TCxFto5oEKbCx0JFBCXPGh0uiwaE6eI+iyKt1NXU0aQ2GyWIsIO/0
         fzVbXmiXOJhwWI9TEoOiHYQVIA/NMqMqPNA/oTA8Gem4PbOp+bgOG/rRsqi/4xrzKn
         mNBq+1f0qr+j7Y7/nv+wNsVTTRE2gBcVPzhJi4QlcCrrPFjaoTIuKJ0tUfZ3J95fIp
         iRDq4/nr5O0nkCEDI0OUInPREqnCcHyrFjH1rWNTH/xMYqaITUjcVnTPrRBXKAXeuq
         1ylH8h88He7PA==
Date:   Fri, 11 Nov 2022 02:14:33 +0100
From:   Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 11/15] hdlcdrv: remove HDLCDRV_MAGIC
Message-ID: <fe1abc4cbe8a77841df7f2e99a77f3dc22579525.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="efa56i6635dya7aa"
Content-Disposition: inline
In-Reply-To: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        MISSING_HEADERS,PDS_OTHER_BAD_TLD,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--efa56i6635dya7aa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We have largely moved away from this approach, and we have better
debugging instrumentation nowadays: kill it.

Additionally, ~half HDLCDRV_MAGIC checks just early-exit instead of
noting the bug, so they're detrimental, if anything.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 Documentation/process/magic-number.rst                   | 1 -
 .../translations/it_IT/process/magic-number.rst          | 1 -
 .../translations/zh_CN/process/magic-number.rst          | 1 -
 .../translations/zh_TW/process/magic-number.rst          | 1 -
 drivers/net/hamradio/baycom_par.c                        | 1 -
 drivers/net/hamradio/baycom_ser_fdx.c                    | 3 +--
 drivers/net/hamradio/baycom_ser_hdx.c                    | 3 +--
 drivers/net/hamradio/hdlcdrv.c                           | 9 +++------
 include/linux/hdlcdrv.h                                  | 2 --
 9 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index c1c68c713cbc..3b3e607e1cbc 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -70,6 +70,5 @@ Magic Name            Number           Structure         =
       File
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
-HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index 5b609ca78a14..e8c659b6a743 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -76,6 +76,5 @@ Nome magico           Numero           Struttura         =
       File
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
-HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index ab4d4e32b61f..2105af32187c 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -59,6 +59,5 @@ Linux =E9=AD=94=E6=9C=AF=E6=95=B0
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
-HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index a6131d978189..793a0ae9fb7c 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -62,6 +62,5 @@ Linux =E9=AD=94=E8=A1=93=E6=95=B8
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
-HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/bayco=
m_par.c
index fd7da5bb1fa5..e1cf3ed42df6 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -418,7 +418,6 @@ static int baycom_ioctl(struct net_device *dev, void __=
user *data,
 		return -EINVAL;
=20
 	bc =3D netdev_priv(dev);
-	BUG_ON(bc->hdrv.magic !=3D HDLCDRV_MAGIC);
=20
 	if (cmd !=3D SIOCDEVPRIVATE)
 		return -ENOIOCTLCMD;
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/b=
aycom_ser_fdx.c
index 646f605e358f..65113cb6de8d 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -252,7 +252,7 @@ static irqreturn_t ser12_interrupt(int irq, void *dev_i=
d)
 	unsigned char iir, msr;
 	unsigned int txcount =3D 0;
=20
-	if (!bc || bc->hdrv.magic !=3D HDLCDRV_MAGIC)
+	if (!bc)
 		return IRQ_NONE;
 	/* fast way out for shared irq */
 	if ((iir =3D inb(IIR(dev->base_addr))) & 1) =09
@@ -507,7 +507,6 @@ static int baycom_ioctl(struct net_device *dev, void __=
user *data,
 		return -EINVAL;
=20
 	bc =3D netdev_priv(dev);
-	BUG_ON(bc->hdrv.magic !=3D HDLCDRV_MAGIC);
=20
 	if (cmd !=3D SIOCDEVPRIVATE)
 		return -ENOIOCTLCMD;
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/b=
aycom_ser_hdx.c
index 5d1ab4840753..df33e5cdb5c2 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -365,7 +365,7 @@ static irqreturn_t ser12_interrupt(int irq, void *dev_i=
d)
 	struct baycom_state *bc =3D netdev_priv(dev);
 	unsigned char iir;
=20
-	if (!dev || !bc || bc->hdrv.magic !=3D HDLCDRV_MAGIC)
+	if (!dev || !bc)
 		return IRQ_NONE;
 	/* fast way out */
 	if ((iir =3D inb(IIR(dev->base_addr))) & 1)
@@ -561,7 +561,6 @@ static int baycom_ioctl(struct net_device *dev, void __=
user *data,
 		return -EINVAL;
=20
 	bc =3D netdev_priv(dev);
-	BUG_ON(bc->hdrv.magic !=3D HDLCDRV_MAGIC);
=20
 	if (cmd !=3D SIOCDEVPRIVATE)
 		return -ENOIOCTLCMD;
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 2263029d1a20..60abd6008cc7 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -158,7 +158,7 @@ void hdlcdrv_receiver(struct net_device *dev, struct hd=
lcdrv_state *s)
 	int i;
 	unsigned int mask1, mask2, mask3, mask4, mask5, mask6, word;
 =09
-	if (!s || s->magic !=3D HDLCDRV_MAGIC)=20
+	if (!s)
 		return;
 	if (test_and_set_bit(0, &s->hdlcrx.in_hdlc_rx))
 		return;
@@ -257,7 +257,7 @@ void hdlcdrv_transmitter(struct net_device *dev, struct=
 hdlcdrv_state *s)
 	struct sk_buff *skb;
 	int pkt_len;
=20
-	if (!s || s->magic !=3D HDLCDRV_MAGIC)=20
+	if (!s)
 		return;
 	if (test_and_set_bit(0, &s->hdlctx.in_hdlc_tx))
 		return;
@@ -364,7 +364,7 @@ static void start_tx(struct net_device *dev, struct hdl=
cdrv_state *s)
=20
 void hdlcdrv_arbitrate(struct net_device *dev, struct hdlcdrv_state *s)
 {
-	if (!s || s->magic !=3D HDLCDRV_MAGIC || s->hdlctx.ptt || !s->skb)=20
+	if (!s || s->hdlctx.ptt || !s->skb)
 		return;
 	if (s->ch_params.fulldup) {
 		start_tx(dev, s);
@@ -701,7 +701,6 @@ struct net_device *hdlcdrv_register(const struct hdlcdr=
v_ops *ops,
 	 * initialize part of the hdlcdrv_state struct
 	 */
 	s =3D netdev_priv(dev);
-	s->magic =3D HDLCDRV_MAGIC;
 	s->ops =3D ops;
 	dev->base_addr =3D baseaddr;
 	dev->irq =3D irq;
@@ -723,8 +722,6 @@ void hdlcdrv_unregister(struct net_device *dev)
 {
 	struct hdlcdrv_state *s =3D netdev_priv(dev);
=20
-	BUG_ON(s->magic !=3D HDLCDRV_MAGIC);
-
 	if (s->opened && s->ops->close)
 		s->ops->close(dev);
 	unregister_netdev(dev);
diff --git a/include/linux/hdlcdrv.h b/include/linux/hdlcdrv.h
index 5d70c3f98f5b..809ad0f5c99c 100644
--- a/include/linux/hdlcdrv.h
+++ b/include/linux/hdlcdrv.h
@@ -13,7 +13,6 @@
 #include <linux/spinlock.h>
 #include <uapi/linux/hdlcdrv.h>
=20
-#define HDLCDRV_MAGIC      0x5ac6e778
 #define HDLCDRV_HDLCBUFFER  32 /* should be a power of 2 for speed reasons=
 */
 #define HDLCDRV_BITBUFFER  256 /* should be a power of 2 for speed reasons=
 */
 #undef HDLCDRV_LOOPBACK  /* define for HDLC debugging purposes */
@@ -84,7 +83,6 @@ struct hdlcdrv_ops {
 };
=20
 struct hdlcdrv_state {
-	int magic;
 	int opened;
=20
 	const struct hdlcdrv_ops *ops;
--=20
2.30.2

--efa56i6635dya7aa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNtofgACgkQvP0LAY0m
WPG4ow//VM1Atfl+btMcZSQMTLeQQsx1NyiTh1Lg8C4MhWWQt/qRKSgvBjs1aBdd
MqsuTpzTaVMijc/7IPHjMEDaHmKivtrCiLtNtpxmnmWWN9MKQEx6ATTe2euHqWtJ
FhiNBN5yOBiVb30ZTkf+D/IyCWROxyXgDuloNT+jhPdCiX4HXgAQBAdtf22LWzip
hqdQf8sYexSxTdoHkM6tOlF0e0Yolmxf1BlQDyAXQwHpeUWPRBPxPKPNPNtiWFdl
ltMn5JbmF2tHrb1vbNq5s0OEEsDiVso8tIwTIWhHyy5q759CVYaUk33LXzGo8WEv
aMhgejXeNFbwwD1D4T3MtDJNehbeMox76w7qYVjejmu0zR5vCC/VwTevV/SeuXBG
FdeSv3PLkZ1SLnkEBjinR3Wu7yOLQWbio7hn6emNTLqajVnCLKv9O88Wu11gZPNy
KqsdZ2+WGWkX2UwV3x7qhqhaMaRBPLoylsj7mmFAYy8qt3v48P/r5HKXMvrkLrW5
ClkixjD/h8DGsK9NOVZopoZ+lzZdPmoQ/CnXmOCvV7Sfs32TYK2uu9AvFwRdp+6X
Me33Tkt+gzGNGuPtaHLMdixOWw/h68yO6jBj01nlIzcjnXbL5RC7xh4QRBje70OS
P2nWms8VXCfoFBadUrVbkqWwapGyvewNgfVQOF8lVVs3xqVRJP0=
=6uHZ
-----END PGP SIGNATURE-----

--efa56i6635dya7aa--
