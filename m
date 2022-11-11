Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CE7624F4E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiKKBOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiKKBOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:14:00 -0500
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D38C12AC7;
        Thu, 10 Nov 2022 17:13:47 -0800 (PST)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 88FCBA1A;
        Fri, 11 Nov 2022 02:13:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202211; t=1668129226;
        bh=ixdDLzJmpTxWbfhVg6Gc6gD5JwL8vejNHMAi6eeYrns=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=QQDqgPnPrgCKsWAjM5mqrzHpqDM7wJoH2yW8jeEJeDs7ac8hciVMV8iZll9/4CIAw
         XDeBUTZbBtAvZloNuQ/1CVWOtkEFYZlNz1S7sAkv7HRff20UDw4vsMgXoykCOmV/fJ
         u8BWwNOAmjT7Arhtw8tCUKlWlhDpHcVtGWcMmEVLonD+6JtmBRUdxa58Mz+fNX+GJz
         khDDynlWI0DJznfY0KGL7n8dNRJ5yrVvL9w2VeOSeDUYs3hTlO4cKEpTDVPSDoempU
         Jf2i8MYx4jKHQvNpvohV00Nf/CpbKrVGZ0Pc6Z8WBvbvcnNWb7pSdYUNt64KHwZUmM
         ArdBDuE6nxmwA==
Date:   Fri, 11 Nov 2022 02:13:45 +0100
From:   Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 02/15] hamradio: yam: remove YAM_MAGIC
Message-ID: <25af8e199860c8f3a33ea32abb77fbf54a6cfe64.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qfrkdivhvyi3t3a3"
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


--qfrkdivhvyi3t3a3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is checked inconsistently, only in contexts following directly from
the module init, and returns an error to userspace/ignores the condition
entirely, rather than yielding remotely-useful diagnostics.

This is cruft, and we have better debugging tooling nowadays: kill it.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
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

--qfrkdivhvyi3t3a3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNtockACgkQvP0LAY0m
WPFabA/8D/NA32ZmdugGOpD6obwoZrcSwlDLEPJ+LaR5WmuG2JsxmAP8fQL8yhGU
tPrhiXu5Xt7QXd6X3NMA17lKknBFAk1J1mMKcnVsNteJs8+d5ARLa/dRbdyV+++f
bwzVdDdS8EQ9lMM7kW8g1bLbEpGK51rZ64ed6Mbl3NVWlFRPeRx41/DHPQ9PeMQv
EhScplDdSAYoZOvAsrVw9wGz20c8mtj1tvYT7oAZOjL08lJOZdcqn5NYFWblusFR
n7huleh9bxsZ67lZwmhw7nt+7SxKMtXkSzWje4EjBNSoTCsSpSRTgRWtTYq191Ng
TXBhHTOeOxlSkNIa29X9mR3vn41iDUnewRbXMp/7SW9sKeAlyfDOR2tn8NlE+5Mx
R/xbNIvYVbe2MuD4nA2/uF1BQm3Xlj2aQnqNlf8gXAErVznMVAHlptIeLVRNoYIz
sokxzMfGMYnJ+z26N/ZayspTg55ix5ukPpLq824PkD+3oND1RhCZ2IZKJp3cQqGo
Am//svYk4mExoPV16ZKkZZiuONyaAkgpcT5rrdNo+jpyM07pe6a9V2PTT0SjDCrZ
jEB3D2BeqUKDqSg6NkHAUwMWUTrTScriLjqrhGyM/HdgjBsxZc8s/4XvlqmsIFqV
dWVTKqZmN4dNfIGOQ6JZiVzvrxI61YLH0IOmMNRcqGJnS6orBkc=
=EKl6
-----END PGP SIGNATURE-----

--qfrkdivhvyi3t3a3--
