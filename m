Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686725B5A2C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiILMdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiILMdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:33:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55151EAD7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:33:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXicR-0003yD-N1; Mon, 12 Sep 2022 14:32:55 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D44C9E1332;
        Mon, 12 Sep 2022 12:32:54 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:32:46 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 2/2] Revert "net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`"
Message-ID: <20220912123246.qul7br3tkitbphwe@pengutronix.de>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
 <20220912070143.98153-3-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xs63l5srlxqe5xhk"
Content-Disposition: inline
In-Reply-To: <20220912070143.98153-3-francesco.dolcini@toradex.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xs63l5srlxqe5xhk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.09.2022 09:01:43, Francesco Dolcini wrote:
> This reverts commit b353b241f1eb9b6265358ffbe2632fdcb563354f, this is
> creating multiple issues, just not ready to be merged yet.
>=20
> Link: https://lore.kernel.org/all/CAHk-=3Dwj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5=
WMj8eheb3A9WHw@mail.gmail.com/
> Link: https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengutr=
onix.de/
> Fixes: b353b241f1eb ("net: fec: Use a spinlock to guard `fep->ptp_clk_on`=
")
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xs63l5srlxqe5xhk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfJuwACgkQrX5LkNig
011Rngf8CAz7YcGCAmHHnItoLyjG5AHa6gOuwQQL3tKPgmsEy2TI5imH030JLWQQ
x/cFzA1EyAMpnIBoPYm6PSRdZrwlkUfOBkS/uZWVpcHg4Cu2QBSq5u9teQiGF0Nd
KHUDeXVd/T7RoR/MtX78dG4fGlJy2ct1i5jnqpzCxINM5Ov4h6nX3ObFhr6vR+eL
4w/TpnpSjAAkuoVjWX80UGYMvQ3IqE0ILhhEzSzGx/O7A7uH1aaf20orufC+6DB+
y882MXpaz7JO0Z4vt+hCXW7zNBYQHSeMEW2yf+Vq1r2gciuiEGl+C7wuN8aUgH0h
pYTIji8In43PFLJgUldkye188Izfbg==
=OKNQ
-----END PGP SIGNATURE-----

--xs63l5srlxqe5xhk--
