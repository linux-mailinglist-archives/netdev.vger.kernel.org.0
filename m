Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3EF6155BD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiKAXF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiKAXFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:05:22 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E26DF01A;
        Tue,  1 Nov 2022 16:05:02 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id C936D4ED6;
        Wed,  2 Nov 2022 00:05:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1667343901;
        bh=sqF6M40mTe+GMCjQFaEsJ1ZjHEHltPKbbHcjSmMmLiQ=;
        h=Date:From:Cc:Subject:References:In-Reply-To:From;
        b=M+LDVQoZbugRpd3IJ7349nnHdg1XnBeovSVBRsUGuJKds/1CCK56zXFaPbBluGHPc
         8OPrWZC0r4y7tkIsZXa7BTGiaGEsLNo1Mn0itPa5PtLPnPn3U6Un/P270AGXwDoHlz
         MW1ivjN27FAeeM+fUXPwtwkPysSnZVbUnf2AHdoYsp7E6WltF70SxZeGg/ZU8ikiAn
         BSXDPbRwrWkFDGuYN9Bm0Dy7xZh2T8aOfxqG2244o7O4XgR/pPDkViocfDi3Hm5vvh
         iHTRjOYqX3MG315jfifJaku+UrJGNChtIRCCy949L+rpVeCX7nY7zic82qbhWAFYYc
         n8T0yKlhHA/Lf+b9wjPW1sm59p0RElFeLnpPQXDIgN1CCEFEMuU9IdaDRqS0usQ8Ol
         00mVM4kJxoD0PorJvEaV61VLW8OjSFPm/dyG5CvB2R3Eq7F/+NK4pPlkrGcazxaIuA
         WsfRgZgOZKs0oqa5XckglMb3nxUijj2N4SNSJ5Te9u7Hchg5y7XOYz0aufwHIBTg47
         0pnVZqIRN+z+gKJ19xJWyv5QbvmjYYYRU600F1t5WnqHB3oLYAYaEdtncQQAc2SHcr
         ZDP1WW0wRgx4UpjaABuJKXkr9YDenmFdrXd8NzwSi0LsdawXZ8qc6YdSBno7ciGBxK
         5LFevY0MwNnnriJBzwg3OTbQ=
Date:   Wed, 2 Nov 2022 00:05:00 +0100
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
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <da617ec5a1dd5196c0b4b4a4895caf7838620abf.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
References: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t44h2yodatck72g2"
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


--t44h2yodatck72g2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Before being defanged in v2.6.12-rc1, the magic was validated on each
netdev_priv() invocation; after, it's set exactly once per port on probe
and checked exactly once per port on unload: it's useless. Kill it.

Notably, magic-number.rst has never had the right value for it with the
new-in-Linux-2.1.105 network-based driver, rendering this documentation
worse than useless.

Link: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 Documentation/process/magic-number.rst            |  1 -
 .../translations/it_IT/process/magic-number.rst   |  1 -
 .../translations/zh_CN/process/magic-number.rst   |  1 -
 .../translations/zh_TW/process/magic-number.rst   |  1 -
 drivers/net/hamradio/baycom_epp.c                 | 15 ++-------------
 5 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index 64b5948fc1d4..87353e0207c1 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -73,7 +73,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index 02eb7eb2448e..a96712bd8a68 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -79,7 +79,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index 0617ce125e12..44f3a29fce57 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -62,7 +62,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index f3f7082e17c6..0fde3183e82a 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -65,7 +65,6 @@ APM_BIOS_MAGIC        0x4101           apm_user          =
       ``arch/x86/kerne
 FASYNC_MAGIC          0x4601           fasync_struct            ``include/=
linux/fs.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/=
net/slip.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
-BAYCOM_MAGIC          0x19730510       baycom_state             ``drivers/=
net/baycom_epp.c``
 HDLCDRV_MAGIC         0x5ac6e778       hdlcdrv_state            ``include/=
linux/hdlcdrv.h``
 KV_MAGIC              0x5f4b565f       kernel_vars_s            ``arch/mip=
s/include/asm/sn/klkernvars.h``
 CODA_MAGIC            0xC0DAC0DA       coda_file_info           ``fs/coda/=
coda_fs_i.h``
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/bayco=
m_epp.c
index 791b4a53d69f..8f018703e74d 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -45,13 +45,9 @@
 /* --------------------------------------------------------------------- */
=20
 #define BAYCOM_DEBUG
-#define BAYCOM_MAGIC 19730510
=20
 /* --------------------------------------------------------------------- */
=20
-static const char paranoia_str[] =3D KERN_ERR=20
-	"baycom_epp: bad magic number for hdlcdrv_state struct in routine %s\n";
-
 static const char bc_drvname[] =3D "baycom_epp";
 static const char bc_drvinfo[] =3D KERN_INFO "baycom_epp: (C) 1998-2000 Th=
omas Sailer, HB9JNX/AE4WA\n"
 "baycom_epp: version 0.7\n";
@@ -152,8 +148,6 @@ static struct net_device *baycom_device[NR_PORTS];
  */
=20
 struct baycom_state {
-	int magic;
-
         struct pardevice *pdev;
 	struct net_device *dev;
 	unsigned int work_running;
@@ -1210,7 +1204,6 @@ static void __init baycom_epp_dev_setup(struct net_de=
vice *dev)
 	 * initialize part of the baycom_state struct
 	 */
 	bc->dev =3D dev;
-	bc->magic =3D BAYCOM_MAGIC;
 	bc->cfg.fclk =3D 19666600;
 	bc->cfg.bps =3D 9600;
 	/*
@@ -1279,12 +1272,8 @@ static void __exit cleanup_baycomepp(void)
 		struct net_device *dev =3D baycom_device[i];
=20
 		if (dev) {
-			struct baycom_state *bc =3D netdev_priv(dev);
-			if (bc->magic =3D=3D BAYCOM_MAGIC) {
-				unregister_netdev(dev);
-				free_netdev(dev);
-			} else
-				printk(paranoia_str, "cleanup_module");
+			unregister_netdev(dev);
+			free_netdev(dev);
 		}
 	}
 	parport_unregister_driver(&baycom_epp_par_driver);
--=20
2.30.2

--t44h2yodatck72g2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNhphwACgkQvP0LAY0m
WPFuZxAAmkj8gNjxpP3uoVgEhHtMntYALIuqjzxQtp+RQRkc33KqHK88+As+DPTb
swGGUu3N2XjfDEPgFk7iRlDNPUsb0wcATFrzrZggucsoQ0hUzn3ZCm3nsGAdaWtG
zCdJP1iREYtLaqdNfArXkxKIoOowy9QsX+obDwy+KzZtd1rVsXygl17r1m/iSHWZ
wos2iAObCsCipRj09e4u/rka7CKgGgtmYpkHlpHNvNBjwF1RJZG/8/k6czXBJ54q
MKN8c8MJwvsYUtUbuZVUKcatU6SoFh1iGJTdcr4K5HWB7KOyfcURUlBa34GsDlMH
sYqWHQLCN93jG+/6luPoPYWmPGo9owfwGgiAjrMLl3frG1jAEzRrvnEqiOrZnnCM
tpkWIezJ5okdNMrJFk6mNzMDtGPyPTDXtcXXHx6tW0gUKgjLC+ofPVvuG24F1Lwf
PyiuOA0X03sFKzMyLQpeYn4lmmhgbPaGvZ51yzzC3zjsPT0TWX8h3N8eh9sLI/qF
DOGOejfCNirHh1AfoC69O1LalZDcbQenzEGWQERXexYyD9WkfznkS8tMrSeAJzdI
Gr4h/ExENY8duTnACEK4bqxpL7RM5h9989e7cho1MfhLDWxv1Mj2/5ouDPfnGnpJ
uoOkpuVJnsSaHBSHVlnY5Lq8s6OQpWSvzXugiJSH7xJ6ojx9LJ4=
=Z7wJ
-----END PGP SIGNATURE-----

--t44h2yodatck72g2--
