Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE5A3F826F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbhHZG11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbhHZG1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 02:27:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7586BC0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 23:26:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mJ8pO-0006Yt-6y; Thu, 26 Aug 2021 08:25:30 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-b2ee-1fdd-6b26-f446.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:b2ee:1fdd:6b26:f446])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AB6A066FE3E;
        Thu, 26 Aug 2021 06:24:53 +0000 (UTC)
Date:   Thu, 26 Aug 2021 08:24:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Luca Coelho <luciano.coelho@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-crypto@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-can@vger.kernel.org,
        bpf@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Keith Packard <keithp@keithp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 2/5] treewide: Replace open-coded flex arrays in unions
Message-ID: <20210826062452.jekmoo43f4xu5jxk@pengutronix.de>
References: <20210826050458.1540622-1-keescook@chromium.org>
 <20210826050458.1540622-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mnmsc5sxlpdvk3xn"
Content-Disposition: inline
In-Reply-To: <20210826050458.1540622-3-keescook@chromium.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mnmsc5sxlpdvk3xn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.08.2021 22:04:55, Kees Cook wrote:
> In support of enabling -Warray-bounds and -Wzero-length-bounds and
> correctly handling run-time memcpy() bounds checking, replace all
> open-coded flexible arrays (i.e. 0-element arrays) in unions with the
> flex_array() helper macro.
>=20
> This fixes warnings such as:
>=20
> fs/hpfs/anode.c: In function 'hpfs_add_sector_to_btree':
> fs/hpfs/anode.c:209:27: warning: array subscript 0 is outside the bounds =
of an interior zero-length array 'struct bplus_internal_node[0]' [-Wzero-le=
ngth-bounds]
>   209 |    anode->btree.u.internal[0].down =3D cpu_to_le32(a);
>       |    ~~~~~~~~~~~~~~~~~~~~~~~^~~
> In file included from fs/hpfs/hpfs_fn.h:26,
>                  from fs/hpfs/anode.c:10:
> fs/hpfs/hpfs.h:412:32: note: while referencing 'internal'
>   412 |     struct bplus_internal_node internal[0]; /* (internal) 2-word =
entries giving
>       |                                ^~~~~~~~
>=20
> drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_m=
sg':
> drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscrip=
t 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka=
 'unsigned char[]'} [-Wzero-length-bounds]
>   360 |  tx_can_msg =3D (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[ms=
g_len];
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
> In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
>                  from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
> drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing =
'raw_msg'
>   231 |   u8 raw_msg[0];
>       |      ^~~~~~~
>=20
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Cc: Rohit Maheshwari <rohitm@chelsio.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> Cc: linux-crypto@vger.kernel.org
> Cc: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/can/usb/etas_es58x/es581_4.h          |  2 +-
>  drivers/net/can/usb/etas_es58x/es58x_fd.h         |  2 +-

For the can drivers:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

BTW: Is there opportunity for conversion, too?

| drivers/net/can/peak_canfd/peak_pciefd_main.c:146:32: warning: array of f=
lexible structures

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mnmsc5sxlpdvk3xn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEnM7EACgkQqclaivrt
76kN7Af/X372HVlb+QqkjppsRpwpNYqhBsuZx17Ly+If1NlY7bxjdbRsOVskRV0a
zEmr21eyBZFMHhrQ4+CPzjkv8AMTA9dfjFViAemjlC9mP6NR63oty7R+Ae0a/pbe
T0EDxGooHMTU7H702xrzo8CzTCJM01TTmriW+YM3pZC4DfhNfqYFVx6hgGrah9U5
HWD8HH3NTi9GLBk8caCqNlZVNv7lJbM7ygt5hxm2EdEy+aJGezlpS4LMpZScF9c9
p7YOev4usm+X08379kFnX7T8IympuH51b4uhaUIbsekkjACT5rJtj3cKbupp0i2X
X8w2WKQ8P+u+4VA9+tgBqpt731LPIA==
=1VPl
-----END PGP SIGNATURE-----

--mnmsc5sxlpdvk3xn--
