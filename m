Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587FC5BA2FB
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 00:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIOWtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 18:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiIOWta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 18:49:30 -0400
X-Greylist: delayed 624 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Sep 2022 15:49:28 PDT
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B237B2F;
        Thu, 15 Sep 2022 15:49:27 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 602FE1780;
        Fri, 16 Sep 2022 00:39:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1663281542;
        bh=9LsAriyg/v8KRDWcGoxpt5EInCN4szvRf6df46hf4n0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRbpVyliiCo9uK6YDde4vcF7fniX5J4CChUbVT7l1q3DxRFHL+bzHD7ufclN+98rt
         wcINjU6L/x0eXf4BNn26+NwXfSWPhtBB50u7Or7RAgEJfnvOhJX/QDMqYGN7fgAeMV
         o/MCgNU5u28+UCF2ZJbNOqfsiXkqOIeTJyznDqK1kEUbFGgSbSj2tYqi2lCwbaRSIu
         ZB7KMEt511LEvYiG1/jJd+gdFQCwroMOiIJBnGkbkXH6eOS0ZA5OjLPbAVox51Ibyr
         rxAISLcOESvoKyzrHWJvWWTG7BHRUB0AktbPgVNbqp3M9t8Pu1HjTm2mRp3Bbs7PGp
         GXUbnodOujtPrkS03G23KuIa3ybFHOGvG2KNOPE0j9G9P8pblHC7poifFTN2WgsLSQ
         X7XJXzfgXkcFF7xA5DXy1KfrjCPG31MzCvWsqAdvn/fa2pNv0dheWhDi1M8iaBFkrc
         D33CRFi5snFQE+l9LON1U0tg4GnBAt35VQlmAq23KYeVyRJRYcxgdsfYNc/7yXZta3
         OymRa7etgA+k54DwCrEwgVMKfAl+Y4nZ8oonuEQEYCJkedgX4MZmv5lkiUMPSZ36vr
         sSbSnsS9Wo2cPrsU7n+xJbPXkvmgE0qT1kpw8AxDfC0fcwNaqpxbEgBBgN0Fe7V9DA
         tOl93fuKEpjzydGi8NtsvmaM=
Date:   Fri, 16 Sep 2022 00:39:01 +0200
From:   =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 03/18] Bluetooth: RFCOMM: remove define-only
 RFCOMM_TTY_MAGIC ex-magic-number
Message-ID: <f6d375201dfd99416ea03b49b3dd40af56c1537e.1663280877.git.nabijaczleweli@nabijaczleweli.xyz>
References: <YyMlovoskUcHLEb7@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a6k63ixd4da7layj"
Content-Disposition: inline
In-Reply-To: <YyMlovoskUcHLEb7@kroah.com>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a6k63ixd4da7layj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Appeared in its present state in pre-git (2.5.41), never used

Found with
grep MAGIC Documentation/process/magic-number.rst | while read -r mag _;
do git grep -wF "$mag"  | grep -ve '^Documentation.*magic-number.rst:' \
-qe ':#define '"$mag" || git grep -wF "$mag" | while IFS=3D: read -r f _;
do sed -i '/\b'"$mag"'\b/d' "$f"; done ; done

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 Documentation/process/magic-number.rst                    | 1 -
 Documentation/translations/it_IT/process/magic-number.rst | 1 -
 Documentation/translations/zh_CN/process/magic-number.rst | 1 -
 Documentation/translations/zh_TW/process/magic-number.rst | 1 -
 net/bluetooth/rfcomm/tty.c                                | 1 -
 5 files changed, 5 deletions(-)

diff --git a/Documentation/process/magic-number.rst b/Documentation/process=
/magic-number.rst
index f48c6c6efaf7..f16f4e2cc48f 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -78,7 +78,6 @@ MGSL_MAGIC            0x5401           mgsl_info         =
       ``drivers/char/s
 TTY_DRIVER_MAGIC      0x5402           tty_driver               ``include/=
linux/tty_driver.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
 FULL_DUPLEX_MAGIC     0x6969                                    ``drivers/=
net/ethernet/dec/tulip/de2104x.c``
-RFCOMM_TTY_MAGIC      0x6d02                                    ``net/blue=
tooth/rfcomm/tty.c``
 CG_MAGIC              0x00090255       ufs_cylinder_group       ``include/=
linux/ufs_fs.h``
 RIEBL_MAGIC           0x09051990                                ``drivers/=
net/atarilance.c``
 NBD_REQUEST_MAGIC     0x12560953       nbd_request              ``include/=
linux/nbd.h``
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Do=
cumentation/translations/it_IT/process/magic-number.rst
index 27f60133fbe5..5366cad4a4ea 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -84,7 +84,6 @@ MGSL_MAGIC            0x5401           mgsl_info         =
       ``drivers/char/s
 TTY_DRIVER_MAGIC      0x5402           tty_driver               ``include/=
linux/tty_driver.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
 FULL_DUPLEX_MAGIC     0x6969                                    ``drivers/=
net/ethernet/dec/tulip/de2104x.c``
-RFCOMM_TTY_MAGIC      0x6d02                                    ``net/blue=
tooth/rfcomm/tty.c``
 CG_MAGIC              0x00090255       ufs_cylinder_group       ``include/=
linux/ufs_fs.h``
 RIEBL_MAGIC           0x09051990                                ``drivers/=
net/atarilance.c``
 NBD_REQUEST_MAGIC     0x12560953       nbd_request              ``include/=
linux/nbd.h``
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Do=
cumentation/translations/zh_CN/process/magic-number.rst
index 520cc5cf4d63..08f5a83eed92 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -67,7 +67,6 @@ MGSL_MAGIC            0x5401           mgsl_info         =
       ``drivers/char/s
 TTY_DRIVER_MAGIC      0x5402           tty_driver               ``include/=
linux/tty_driver.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
 FULL_DUPLEX_MAGIC     0x6969                                    ``drivers/=
net/ethernet/dec/tulip/de2104x.c``
-RFCOMM_TTY_MAGIC      0x6d02                                    ``net/blue=
tooth/rfcomm/tty.c``
 CG_MAGIC              0x00090255       ufs_cylinder_group       ``include/=
linux/ufs_fs.h``
 GDTIOCTL_MAGIC        0x06030f07       gdth_iowr_str            ``drivers/=
scsi/gdth_ioctl.h``
 RIEBL_MAGIC           0x09051990                                ``drivers/=
net/atarilance.c``
diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Do=
cumentation/translations/zh_TW/process/magic-number.rst
index 7d6debd0117e..8a30da3d36b2 100644
--- a/Documentation/translations/zh_TW/process/magic-number.rst
+++ b/Documentation/translations/zh_TW/process/magic-number.rst
@@ -70,7 +70,6 @@ MGSL_MAGIC            0x5401           mgsl_info         =
       ``drivers/char/s
 TTY_DRIVER_MAGIC      0x5402           tty_driver               ``include/=
linux/tty_driver.h``
 MGSLPC_MAGIC          0x5402           mgslpc_info              ``drivers/=
char/pcmcia/synclink_cs.c``
 FULL_DUPLEX_MAGIC     0x6969                                    ``drivers/=
net/ethernet/dec/tulip/de2104x.c``
-RFCOMM_TTY_MAGIC      0x6d02                                    ``net/blue=
tooth/rfcomm/tty.c``
 CG_MAGIC              0x00090255       ufs_cylinder_group       ``include/=
linux/ufs_fs.h``
 GDTIOCTL_MAGIC        0x06030f07       gdth_iowr_str            ``drivers/=
scsi/gdth_ioctl.h``
 RIEBL_MAGIC           0x09051990                                ``drivers/=
net/atarilance.c``
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index ebd78fdbd6e8..27898d49e68e 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -35,7 +35,6 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/rfcomm.h>
=20
-#define RFCOMM_TTY_MAGIC 0x6d02		/* magic number for rfcomm struct */
 #define RFCOMM_TTY_PORTS RFCOMM_MAX_DEV	/* whole lotta rfcomm devices */
 #define RFCOMM_TTY_MAJOR 216		/* device node major id of the usb/bluetooth=
=2Ec driver */
 #define RFCOMM_TTY_MINOR 0
--=20
2.30.2

--a6k63ixd4da7layj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmMjqYQACgkQvP0LAY0m
WPHBJBAAqbXxKBkEwpY3k4nI16D2D0lN5w4pBdOmVZ+EFnU9eQjhoX3ojCd02Cy+
BlM4fK1egJIjwwExHI1np/7V0RL5eEnV0F+1kIHivibxr/UFk2eXN5YgmKob/tht
xWq1Y6VDspfzuhRD32lBfeV/PAKwDuUNyEwPIi003ByriG0NNbk6BFfn/k/KX/f7
oYnpuSL0g7wcVkAt9kfyksAQed6lAa3ymutm/+Wa5ldWeAmu8i2ja+ZkM625lYUo
bwJ9dzeJSmglMurespONIzO41VhvnKbZ+LaCs74W3/am+jBVRMt2GgdVtvaVMiOc
5GOSGAF8jxxaNRDG8nwtHy8y6fTKGgNtblnRt0Ki8slDD9L774pr9ilmcuSwEXMz
y8CrHPWb3hB5ua0Jpu9DctbrtktLl9JdaW+D4cj1ezEPBk9on8AGhg5szg9aR4dR
xrZxl52vvQ1ewl/9iFUJtBU17zDMdUeJKJN7vPD0sgzH18RAM7Pbmc8IUfMBKpwF
BiM65+DqOB6DPnp7He8hry/zJy/+tyO79grqAo2v8s2fXwGFOCKtmPHXS1+afd27
qiCFr9Lpjlkc78Cn556+vqllXVImNhbey6SH9Vz7H+VRhcHHCBwOG1xJTfmMe6iv
gpLt2SZesJL9AWcTTWw09B8reZiD6jpQeYEyDS8qQnKQv8MjldU=
=Vrti
-----END PGP SIGNATURE-----

--a6k63ixd4da7layj--
