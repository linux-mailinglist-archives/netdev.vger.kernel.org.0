Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACEB5B5A44
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiILMi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiILMi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:38:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEDF275C5
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:38:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXiht-0004X6-OH; Mon, 12 Sep 2022 14:38:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 66CCEE133C;
        Mon, 12 Sep 2022 12:38:31 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:38:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Bence =?utf-8?B?Q3PDs2vDoXM=?= <bence98@sch.bme.hu>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 1/2] Revert "net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`"
Message-ID: <20220912123822.f6iulx4hw2dm7fnt@pengutronix.de>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>
 <20220912103818.j2u6afz66tcxvnr6@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qdsyx3ilxjs2ingq"
Content-Disposition: inline
In-Reply-To: <20220912103818.j2u6afz66tcxvnr6@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qdsyx3ilxjs2ingq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.09.2022 12:38:18, Marc Kleine-Budde wrote:
> On 12.09.2022 07:31:04, Bence Cs=C3=B3k=C3=A1s wrote:
> > From: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
> >=20
> > `clk_prepare_enable()` gets called in atomic context (holding a spinloc=
k),
> > which may sleep, causing a BUG on certain platforms.
> >=20
> > This reverts commit b353b241f1eb9b6265358ffbe2632fdcb563354f.
> >=20
> > Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Link: https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengu=
tronix.de/
> > Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
>=20
> This is not a 100% revert.

Better use the Francesco Dolcini's revert series

| https://lore.kernel.org/all/20220912070143.98153-1-francesco.dolcini@tora=
dex.com/

instead.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qdsyx3ilxjs2ingq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfKDwACgkQrX5LkNig
010OXwf8DsWcFx2IFDwOY1e1fmpdfY7t4F3t5Qqvm/NQ3KvGHBC6otw+xLglSAKS
o3RGrtVxHeGvhiPuZnzYUdc2NMwCaGQMmCn4ByJCHqaISyMc/QT5Ifo/IkGtrJlD
x3Ctr7psalYVuJPEBLwqIWZy8XVC7zB05/+tPfXyBMg+keRb696AYJAXDodaWHw5
V7uFv11oj8sSscgY6wkRMb7lQWZv6wJD0a7BI2NVvTj8NacBD/+I1m9G5hhEpF33
lDJA59isPHUBukMZI0rZZ1AitDVKne3Vi4qB6unOYhOdmWbCtZnb8PDh7iNLeuOg
59IHSHhYBeud7WeRXlLbjVeXTwKRrQ==
=lfCg
-----END PGP SIGNATURE-----

--qdsyx3ilxjs2ingq--
