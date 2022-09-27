Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412AD5EBBA6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 09:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiI0Hgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 03:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiI0HgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 03:36:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713DC15A36
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:36:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1od58M-0000Oh-Jy; Tue, 27 Sep 2022 09:36:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AAF41EDC22;
        Tue, 27 Sep 2022 07:36:00 +0000 (UTC)
Date:   Tue, 27 Sep 2022 09:35:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] can: ucan: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <20220927073557.r5ivp4n2jjiwxgoo@pengutronix.de>
References: <YzIdHDdz30BH4SAv@work>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xb5k6n6k6ikpfklh"
Content-Disposition: inline
In-Reply-To: <YzIdHDdz30BH4SAv@work>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xb5k6n6k6ikpfklh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.09.2022 16:43:56, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> helper macro.
>=20
> This helper allows for flexible-array members in unions.
>=20
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/214
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xb5k6n6k6ikpfklh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMyp9oACgkQrX5LkNig
012zsQf/WO4Wqmxoc6z0SGE3Dh59i3mGc3x/ZHipNKIHZW5ysGGzkxJdn+eiASve
RN1kx4Ssw8CMvZ6LQxKrmVw9gYFJM3FQNEte7IaH4Gvuy4sQeZ9DAe6I/ZfnspRi
NCZK1uHWuy0O54xpyeE8Mi60og7Lf+GNBGOMTeE19n0YjqG6h2uyeyeCLyos0D+B
M5bsAwS8SSple0dloPvZKp4utVyv/VZEtC9DgcVwMAZVmezyes+y4a2EwQGippTA
iXzDsLps1gSPU501b7DVtZDgJKbPnYMFazHN7ohVC47+ACW4QelWRvwRysAs5wFg
18eYJw8DosjPGTCKgS4a2LmynhMbmg==
=0L/P
-----END PGP SIGNATURE-----

--xb5k6n6k6ikpfklh--
