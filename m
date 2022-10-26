Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0860EBA7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 00:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiJZWmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 18:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJZWmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 18:42:45 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0A9B2609;
        Wed, 26 Oct 2022 15:42:42 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id A76FD4534;
        Thu, 27 Oct 2022 00:42:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1666824158;
        bh=aLDkrJ3n4mm7gAwDMQ1n4CJ0WOrIs4GD9cxoyIWSHEI=;
        h=Date:From:Cc:Subject:From;
        b=ewqx1vKtJ2h9Xs/DjWq85Dry86Wfew+vhiXIRdkzk86GMVDf+5li+FEsrHjL/9LLQ
         VBa55g4H2bKpmI4eeD8+RHLltFVX4lhzg3b4mdC9sq0rNxaPMeBfE7YREQMCjzlA0y
         JyoB5hXbZZNDx9UAgJ+xvTDm3qqumpKAhllTKnpj4a1wTFmmHS/7p9yrZm2gs9SxZ8
         zFwOabAb2vdLsdvUTQ6iWPqcEml5W2qiYpHzcXBoRL1x20N+rw0dtZhcBJ6kgfR8f+
         1clFKDBwenPDRIsvKwWqrEv5QkqJjTgT+0kT5ItEZmB5NX97+IRv/c4h19jY9kW4Z5
         +1UEWBoqTnKEYM5pBrNuVNUAFJFLukNajVU82LMOCFM0Bd9GPgIH+OhnN3t7kgUgOz
         MUa+O7E6gkYrKbFpm7FWrxaQQ3hlTI7n2cLaWgXH9k8dA+K1fndkigwNYYT9/+RdLR
         1RMHEEtyQHvb3JQX+DNzz1pVbJxU9qEjgltYWFFwq9uyHavqgJUurW/kFhdi/1TFle
         /QCuw7sl+fRIu8Cj8tva28JAQZATa0IiRaaHGsS2NfVh+OrdgYV0jUDuBnQPeNYxPa
         RnCRBN4HkomBC9QABLw0d+lCY9NyLzgFbNpuZ9SJsscvu5cpF86yvwEF43j0OCKe0c
         Qme2WH7/5D+X9ytYjVPPRb68=
Date:   Thu, 27 Oct 2022 00:42:37 +0200
From:   =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sytvmb6uz4rwgbsu"
Content-Disposition: inline
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,MISSING_HEADERS,PDS_OTHER_BAD_TLD,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sytvmb6uz4rwgbsu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Since defanging in v2.6.12-rc1 it's set exactly once per port on probe
and checked exactly once per port on unload: it's useless. Kill it.

Notably, magic-number.rst has never had the right value for it with the
new-in-2.1.105 network-based driver

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
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

--sytvmb6uz4rwgbsu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNZt8kACgkQvP0LAY0m
WPGRmxAAnnnbG62iAw/PfP9r+ZHYqdnEFENpFaX9KRGhqzFBv2jO2yMPcQkudAo8
nj03NcYNz4YZoRp/rePJ4xjNQ9XZuQAeqjltLETPTQZJfWtvHIj5A9XtXiYC+0ML
frso4drfEZSMM70pSWqcl76VI4ZrYA/DT6xaML22PNiGZBsIf/EFPLvjvjTxliwA
Ac3ndKjv/z9PbbjW8IPlw1QDQn6Tivm6ETqjkPW+MifeJJ9N26yfTEalP5AIeaGt
ZLr9VhxFRaEiZI1kIDKWcEoZtDutDTmkwC4wo5OaDcWUIjA8jVuECoptaciQ8eqC
n2MYUH8RCu3n5kmlzPFoK7uiHuv/AGwl4S5nyH8TnfQYXcDxGzUVv3slhmWfTpGC
H1lTDjtCgpln+T6tF21l3WoCD5T5GAeRG5qCB8hxJgl9oN0Rr3iVcUfZJ8GBY+OT
0kV8OSyE+zKf61xTuFSYG5nkwkxTTt0HJ/XjvYVRVnAVLaxi5rprVae+xFDMZvxc
z3dge0UrBEa1k0xqD8kseVDCzXZyrp2juEsDNxT+76zdUK9G8thB18nDHutQU/dy
JQNcWuY9zP1+aGyKXOqclo3PVOX0KbgNPkpLfrTHsSJp2rW13+lAvXVRRbsEY3yA
bSZKyKCLloPepcBWUvwqPb/BH6VVPhSzNuSUPyZh12mclYKIytI=
=MxEi
-----END PGP SIGNATURE-----

--sytvmb6uz4rwgbsu--
