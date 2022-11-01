Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1545B6155DC
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiKAXH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiKAXGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:06:16 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 079A12098A;
        Tue,  1 Nov 2022 16:05:51 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 356824E34;
        Wed,  2 Nov 2022 00:05:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1667343951;
        bh=DTGJTbh0Y3OZJ4sMCmhd7AQI6rV6WGDqYy9+7OtkP0g=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=jRaknn+SVS7PT5GviE9Sxf2OAtvKhNWKfthc8UvaNxbB/SWX54frattUzN3lvGPAw
         c8XZJjH165y6r7hcYSAvh2tSkEIeEbMeiRgJXxyS0kkHliwNxvexRKW8JUPDRx8BKq
         JtGxag4wGnoKneMN+jQ0gl7A6o8t9kFks7vLTaPvAL5WrULIf6aKCI+PND2q0NHnT4
         3uvcAd1xHm68J7j0m2a0tkvwh/WfjMWAbTClhppRpK6Nipw3uHuT0KHtposJXKR8+w
         iAaCIE5u0pZO2dwtpEag/Jy5fbEegDuWozvZMIM4byIOwq/E/PTKB0ABWB8sHMtI21
         jtQGh9QyAGtnU65X77KX+xqk8/FSnM6ljxOmOgV3G1ERkhMefA1BkXUbD+nPpbVt2a
         vWzJUzd1AZ8MffL7KtCQP3VqRvkHsDw2cnEQ0Fu2PiiU8Y9OES+WHvwHp6I4GcpAaK
         uENUpqg/7agizU8LSK9DgLulwzWvPd/a4D/HQ/+5BqBclpWb1iRhiG+Y9BnqcrewrZ
         y8vp+Zyre1ob7cBipUh05Iz8fh7keNXvTMiEi/3yCwplnUuLU93irXdJwtJ4aGs7HN
         vPCSnVE9/BP+gr7EZJB8m/SRL1r1Qa2MBTfsqVlXxQ3v0jz0xH5W/umhycNLNO20xb
         mydErc6Nm7kfRBFK4ExBbDnE=
Date:   Wed, 2 Nov 2022 00:05:50 +0100
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
        Kees Cook <keescook@chromium.org>,
        Yury Norov <yury.norov@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 11/15] hdlcdrv: remove HDLCDRV_MAGIC
Message-ID: <ca973973144224fca9116649345f3f6d91445ce6.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bd5stcneyxpl7kt2"
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


--bd5stcneyxpl7kt2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We have largely moved away from this approach, and we have better
debugging instrumentation nowadays: kill it.

Additionally, ~half HDLCDRV_MAGIC checks just early-exit instead of
noting the bug, so they're detrimental, if anything.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
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

--bd5stcneyxpl7kt2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNhpk0ACgkQvP0LAY0m
WPHaVw/+Jpqv2S/Gm1y9XYwoQNE9fnQpwuNa1/LMgRlP+ZAWi4qh+hH1E6iWu3WS
5mEeqdhQ6jAn5cHaqjQ72SW4EG7KEFq2lYednVSxBv1BtrOGKUFv0sK8Nti7yyey
CokCSvr/D6a65c9CdAQT6QBjKPOzhhr0sVjZAqmgPr86c+RVWC/e+VKFIEbQQZNZ
OEzDBvyHqllnlSUhf8DzMZ/yTJTkbiJ215Ez0zrZRQNo25R3iund4+j75bQUzqWY
fvIrCh7Qhfni9oLKuCoBs7kiJkXIwME3Jt4z/jcdctxbG+W/dwiV3CE3d9udEp62
MRsLeprLC63betf14NhXUQrzQFexAMAz/bKIA/GwzrsjE/qHCKzjUeuvEw2BK8gL
tIlE5TyotK1NKp1MbiSIEfKCGJOqnoSZxkiJr5gD3QGx/18Jb/of2HIW104Of8ZS
dGaSIycFKeRUA6G6H4tTEQ5qJU9VrD4G+ukl9aUFsdkNaswbE9u4TTpDxhRSmTpm
BHJ4OIAgDxTSIN81kHh7hcZOX/aJhnpDsfA91pYa4K6JgSXvSIJdS7PSqebvL+IU
QwllDIFlM9t4GApUS7YdIKDulWtBz3AAtsJ/lab83r7n27+QgUTZGsIo8eZPJtIu
hCGjAEVO4ELO2xJmJrfXpHMxCTLZJmehmM3wO/3u3P1qW9+omxA=
=VAnv
-----END PGP SIGNATURE-----

--bd5stcneyxpl7kt2--
