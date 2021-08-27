Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EF03F9D50
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbhH0RKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbhH0RKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:10:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E594C0613CF
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:09:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mJfLX-00064y-Ny; Fri, 27 Aug 2021 19:08:51 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-4ac6-d86b-e43f-77c5.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:4ac6:d86b:e43f:77c5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A327F670F04;
        Fri, 27 Aug 2021 17:08:38 +0000 (UTC)
Date:   Fri, 27 Aug 2021 19:08:37 +0200
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
Message-ID: <20210827170837.mu4hql5bev2f5x2o@pengutronix.de>
References: <20210826050458.1540622-1-keescook@chromium.org>
 <20210826050458.1540622-3-keescook@chromium.org>
 <20210826062452.jekmoo43f4xu5jxk@pengutronix.de>
 <202108270906.7C85982525@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gkkaemaf4slct3pn"
Content-Disposition: inline
In-Reply-To: <202108270906.7C85982525@keescook>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gkkaemaf4slct3pn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.08.2021 09:08:19, Kees Cook wrote:
> > BTW: Is there opportunity for conversion, too?
> >=20
> > | drivers/net/can/peak_canfd/peak_pciefd_main.c:146:32: warning: array =
of flexible structures
>=20
> Oh, hrmpf. This isn't a sane use of flex arrays:
>=20
> struct __packed pucan_rx_msg {
> 	...
> 	__le32	can_id;
> 	u8	d[];
> };
>=20
> struct pciefd_rx_dma {
>         __le32 irq_status;
>         __le32 sys_time_low;
>         __le32 sys_time_high;
>         struct pucan_rx_msg msg[];
> } __packed __aligned(4);
>=20
> I think that needs to be handled separately. How are you building to get
> that warning, by the way? I haven't seen that in my builds...

If compiling with C=3D1, sparse will complain about this.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gkkaemaf4slct3pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEpHBEACgkQqclaivrt
76nZyQf/cQC8nVICmegw2Xx7F4e9MRmYJPNlM4CBOw9lsPVBDSn9GON+JkvMIfWI
gzsHT/fSQfAerrBnUGqaLqbI/HjEa1cgkevLmMY6SnSYZN1tYmiYUhhirVAUN07C
QchAwrLEtdk4fwE/PMvjCcsmw1BrM85bW5B9h/Ug5xhhZZGJu+0I1DSR9s4ERi1M
SGHegQvm8xGiPYDiYOOmXX75G9X4rtVGcpNWj9Iu9hscU0F2exWZz5wB1cZQSK4s
Ka+x3qrkGo4rP+qNov0TlUZEwY3YSmZWx4slMWhR53Shdzpo7H3aylw8JLIra1/i
YPgsmxiUEP6P9DiHmH2O5IVgUsy9kg==
=L8Rq
-----END PGP SIGNATURE-----

--gkkaemaf4slct3pn--
