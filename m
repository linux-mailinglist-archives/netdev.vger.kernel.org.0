Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EE96155C0
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiKAXF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKAXFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:05:25 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48C6B2035C;
        Tue,  1 Nov 2022 16:05:10 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 886E04EDA;
        Wed,  2 Nov 2022 00:05:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1667343909;
        bh=1C2PA3CPeOAdYlYDjeuzEbLN4NuRAcpssYiDt09L1oo=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=ik/mbhUbQpJG7TCVAGlObFN62AVvNN2lkaAWCb2/g7csdiNi85awwxYFqEmw+JME8
         11rqLMfv9CiZ8W4xHSqPPaH2KsFpH46nrV9s0lTIXZbJ6Q8eEjfrJVw/jzNBjvMfnx
         5xHlEFx/tg6V0haiTl2HiG2gPHbAD2vnFYiyVSpGYzB2iWzAaelhDRACWGNayU1qzq
         Px9N9SoZKKmgoE0n1I7ySClfoQvxU/K8NbbJCkqIZUhU+ZV+JNWtw5XJ/FppyS68eg
         e5Otg7sfOw0RVGpVnZ01KAadIW2S/OnBSpO3RvslyzMYe/MQi6mh4obQQxAHcOOzKs
         Xl9B8B5p+VrYI7JdDZtJPtbgZfgnD7kNjsBWmmwTTeGNmXD166Bhmz92GLeJ3WQvKt
         UYssTFHFnROrwwqEqGTEQAouTP7TYNjhXHW7wARCd8r18abDA63TeroPY1K4e/JiNO
         pKDcnJ8A+aDx4YXlRy160HKC8iqOhn8VfXeOvi9yxtYdo2GXcTrh2txrMamMRbEc6b
         gDSyG/pVO+C0vZnSF25Z1Nq6Es9UTm+WlcCE8/9Jg/WprCmk5DEC+MZQeP29GtMeAP
         fNUfWOksyCgqU9QGpjuYukr3ZBIB1zdPezdRP0X+8a3UAVo7hJ/LxUKA/6OfkbORko
         T7I8wKdO5MFx+DV91Qb/uUWo=
Date:   Wed, 2 Nov 2022 00:05:08 +0100
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
Subject: [PATCH v2 02/15] hamradio: yam: remove YAM_MAGIC
Message-ID: <a6f2e6b429170d9fdbbed6d3cea77ec60804f2d8.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kiiph3skcyfwyofc"
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


--kiiph3skcyfwyofc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is checked inconsistently, only in contexts following directly from
the module init, and returns an error to userspace/ignores the condition
entirely, rather than yielding remotely-useful diagnostics.

This is cruft, and we have better debugging tooling nowadays: kill it.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
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

--kiiph3skcyfwyofc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNhpiQACgkQvP0LAY0m
WPGePg/8ChqU4VIF4t7om1gGzOmY1DhHtjq03TjoeS7pGOSlqw+/zTUint2pghOn
RlhQf7uB6pDmVsXw4exdV/thcyvQNQzy0KkOitsyK/nd41E9nQfiDjwGjTAyq+dv
KktpJSkHyngTFv9EARP7QTq2yNeDvQhJWw7QhX00B+11+n22CMO7WL1Wf69xaPmL
VB2StU2TXAKmhS6AqCzE7F+E4ooMuP+KXuh3oyZdn3DS+gSGvgdJGwwhUM1bW4F6
NA0TltCtt6aEFXssio3SuVm95wk/bMlJzqe4w2zAl+kcrFKUQFFSJIA7bZu+2LcP
ygzzSnPUAObgte/vS5P03oORE1JyFXnxl+YiGvmJrUcW7Bokn+YvvwzB8LfSRkhm
0lplEd1ctLw0US8m9jH5dIWATKd6Cr2xwnp1Q5PNXDu9gDW89w1Tyg4mo+GbQJNY
+vHh7n/lcbBwFM6dc1zUDu/EDDFLuIFbFDNW3Q9xV/Mxiq47QVGsx79b8DnKmpCe
fgH0G+jkg2zqAey7lw5au0myEBa24Afjy2dqRZFUc464d/S5sDf/XtuutAC8Pz0I
X1XpYLGPmGOp4LDGFp+893YVMpie8c1IkxiucZdd0uN0E2b+8oDHQsL7a9O0e7/H
eIfNcmKP22Bqdm17dL/60MMzpnUSfhqUUowAW9Esq0KwjHPFsAQ=
=/Hwl
-----END PGP SIGNATURE-----

--kiiph3skcyfwyofc--
