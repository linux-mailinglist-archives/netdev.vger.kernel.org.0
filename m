Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C17A60EBA8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 00:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiJZWmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 18:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJZWmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 18:42:46 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 584DD15FC9;
        Wed, 26 Oct 2022 15:42:45 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 8C76C489A;
        Thu, 27 Oct 2022 00:42:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1666824164;
        bh=jNoxRVdm3VuLTQW8ZXbhrbrxzP5u0X1eFmEP42xyPEw=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=Haqz2ZBzsh+Jl1+IFXYjMl5ZH9zqy6r2e9vFJ/0gASL2UmeLSV76EJGhSqdvsZCQC
         tylCmVInrFF13IwmNkkeQUYX7SunAbTq+mkP5gJiYJd8wUJZkZjwG2NagF80f842TC
         PhCyizqgHCE4F/i1Sy12+84rETqN7uWVBfKoiEAXGXdBrl4WAyp0nKEAjsno5Osl7f
         HgfB94NpgOIGSaqFVqDLnCK9v5oKk+ZioSzh40y0mDxmah4ECxUrILygeSvCA3q0HP
         /uF5hGjOu/a/lSKcSeRMGt3ooCRBdG24vnibiglDFeV4rJUTwnGWEuyu+YPdL9Gn9K
         bTDkeB+1iWh5XcR2l1Umd2/zi8wSnNrFDtnIDcseWnxaAoAArdj5SVp7aADvFKoRAw
         bt9704/LqzxScH+b52PUCPzVai1SbeamrfsI0Q8y1ea1eVfBY7l7BRx0DFw5DKpykm
         41ZVdmmWpJNC+vfEd0Fifk1554D87zlggjrYSwArkKk9V5pWG+lJtsx+pXfXUPNbdd
         NfEjiDsHAUfQoPWOQhYt9Nb3FEH+BZjlWQWYRuy9heJ9+IcLfMpYvcrCr0QDf8Ri3e
         OSglN2vyNpph+KPYVJHMP9NTAtodk9boQ4hCA87krHpqL0sRKWQd6n1sPadXMbiLh2
         QWLUCT7y7EYZ0A0MQkmAUsos=
Date:   Thu, 27 Oct 2022 00:42:43 +0200
From:   =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 02/15] hamradio: yam: remove YAM_MAGIC
Message-ID: <e12d4648a757b613a2ecf09886116900fba1c154.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6vptsdzoc53t6szb"
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


--6vptsdzoc53t6szb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is checked inconsistently, only in contexts following directly
=66rom the module init, and returns an error to userspace/ignores
the condition entirely, rather than yielding remotely-useful diagnostics

This is cruft, and we have better debugging tooling nowadays: kill it

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
---
 Documentation/process/magic-number.rst                    | 1 -
 Documentation/translations/it_IT/process/magic-number.rst | 1 -
 Documentation/translations/zh_CN/process/magic-number.rst | 1 -
 Documentation/translations/zh_TW/process/magic-number.rst | 1 -
 drivers/net/hamradio/yam.c                                | 8 +-------
 5 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index 87353e0207c1..a4414b7e15aa 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -76,7 +76,6 @@ MGSLPC_MAGIC          0x5402           mgslpc_info       =
       ``drivers/char/p
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
-YAM_MAGIC             0xF10A7654       yam_port                 ``drivers/=
net/hamradio/yam.c``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 QUEUE_MAGIC_FREE      0xf7e1c9a3       queue_entry              ``drivers/=
scsi/arm/queue.c``
 QUEUE_MAGIC_USED      0xf7e1cc33       queue_entry              ``drivers/=
scsi/arm/queue.c``
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index a96712bd8a68..f51c5ef9d93f 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -82,7 +82,6 @@ MGSLPC_MAGIC          0x5402           mgslpc_info       =
       ``drivers/char/p
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
-YAM_MAGIC             0xF10A7654       yam_port                 ``drivers/=
net/hamradio/yam.c``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 QUEUE_MAGIC_FREE      0xf7e1c9a3       queue_entry              ``drivers/=
scsi/arm/queue.c``
 QUEUE_MAGIC_USED      0xf7e1cc33       queue_entry              ``drivers/=
scsi/arm/queue.c``
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index 44f3a29fce57..3b53bd67e41b 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -65,7 +65,6 @@ MGSLPC_MAGIC          0x5402           mgslpc_info       =
       ``drivers/char/p
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
-YAM_MAGIC             0xF10A7654       yam_port                 ``drivers/=
net/hamradio/yam.c``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 QUEUE_MAGIC_FREE      0xf7e1c9a3       queue_entry              ``drivers/=
scsi/arm/queue.c``
 QUEUE_MAGIC_USED      0xf7e1cc33       queue_entry              ``drivers/=
scsi/arm/queue.c``
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index 0fde3183e82a..7d176a87ec3c 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -68,7 +68,6 @@ MGSLPC_MAGIC          0x5402           mgslpc_info       =
       ``drivers/char/p
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
-YAM_MAGIC             0xF10A7654       yam_port                 ``drivers/=
net/hamradio/yam.c``
 CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/=
scsi/ncr53c8xx.c``
 QUEUE_MAGIC_FREE      0xf7e1c9a3       queue_entry              ``drivers/=
scsi/arm/queue.c``
 QUEUE_MAGIC_USED      0xf7e1cc33       queue_entry              ``drivers/=
scsi/arm/queue.c``
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 2ed2f836f09a..0f43411a6ca5 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -73,7 +73,6 @@ static const char yam_drvinfo[] __initconst =3D KERN_INFO=
 \
 #define YAM_1200	2
=20
 #define NR_PORTS	4
-#define YAM_MAGIC	0xF10A7654
=20
 /* Transmitter states */
=20
@@ -94,7 +93,6 @@ static const char yam_drvinfo[] __initconst =3D KERN_INFO=
 \
 #define DEFAULT_PERS	64			/* 0->255 */
=20
 struct yam_port {
-	int magic;
 	int bitrate;
 	int baudrate;
 	int iobase;
@@ -604,7 +602,7 @@ static void yam_arbitrate(struct net_device *dev)
 {
 	struct yam_port *yp =3D netdev_priv(dev);
=20
-	if (yp->magic !=3D YAM_MAGIC || yp->tx_state !=3D TX_OFF ||
+	if (yp->tx_state !=3D TX_OFF ||
 	    skb_queue_empty(&yp->send_queue))
 		return;
 	/* tx_state is TX_OFF and there is data to send */
@@ -930,9 +928,6 @@ static int yam_siocdevprivate(struct net_device *dev, s=
truct ifreq *ifr, void __
 	if (copy_from_user(&ioctl_cmd, data, sizeof(int)))
 		return -EFAULT;
=20
-	if (yp->magic !=3D YAM_MAGIC)
-		return -EINVAL;
-
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
=20
@@ -1079,7 +1074,6 @@ static void yam_setup(struct net_device *dev)
 {
 	struct yam_port *yp =3D netdev_priv(dev);
=20
-	yp->magic =3D YAM_MAGIC;
 	yp->bitrate =3D DEFAULT_BITRATE;
 	yp->baudrate =3D DEFAULT_BITRATE * 2;
 	yp->iobase =3D 0;
--=20
2.30.2

--6vptsdzoc53t6szb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNZt+MACgkQvP0LAY0m
WPHSjxAAqUOuJNgFbm6yxmZX4x3lfPDr7jH7/7TeA8dIiNd4xpe2deT4KjHFX5f5
7B4gduLHp8p5uBxOct3tqVxWmR3WUZKQq74PHlkH9kzjQGqnXen7jiVtMhTOv7ly
gfiOVXYFH6PNfjM8RnhIA705exsDq8s+wVF7ryRIjajPYBXQpPW3Szrhvym6z1NO
f6Sw4WormDbYTBViSNhM6VW0+p/jZeICliVa/TcDtvD1Orsq7Ez4CNQs6GfcXf+S
O7B0yx+tZaJJ2xWfooF7Zdi4Qs0SkIJbLmhJpW+o25DphP9oO5/qmgmG/iQhqqxE
6BQRVM/IXOWFbrEqSJ6Ip97BkYgJlJjDFIINXmDVIjgo0K+DNRr7/HvmehJz7Kst
XmHeAi9wK51y1a5DNxfKg/ZnzKvEHGqxPb+wv4VATtEPy3PzNbf3bDjHsy62uN3G
WVgdWAFyM/asGOJl2YEWvRSkwgdaVm3VEP6+jMlpDeBnbi1CvPBSy6mtAv4Eu8pv
ag91Xx7sZdWAGAFJWWXwZjs9xT8SqaM5A6RmPesaLJwU1DTpiyxlizVMZ0PXEpYK
fT6lTove5vqUlgLvOOjWY+I2QBlhVWz5CluKAeuKCR4q0jEFxj39trnvN+biDpBZ
fRotkeEq2cy3orDHiTgE2S1W+PIuQcihMsPzbomgBWnOq6XXHfU=
=KfbL
-----END PGP SIGNATURE-----

--6vptsdzoc53t6szb--
