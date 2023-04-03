Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E426D3D06
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 07:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDCFwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 01:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDCFwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 01:52:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D365B9
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 22:52:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pjD7L-0001pP-ES; Mon, 03 Apr 2023 07:52:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pjD7E-008c3n-JV; Mon, 03 Apr 2023 07:52:28 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pjD7D-00A8u9-Ub; Mon, 03 Apr 2023 07:52:27 +0200
Date:   Mon, 3 Apr 2023 07:52:21 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Eric Dumazet <edumazet@google.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 02/11] net: stmmac: dwmac-visconti: Make
 visconti_eth_clock_remove() return void
Message-ID: <20230403055221.xugl42vub7ugo3tz@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-3-u.kleine-koenig@pengutronix.de>
 <ZCm1InKDMQERLsK3@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="melvyq3rlaozpvm2"
Content-Disposition: inline
In-Reply-To: <ZCm1InKDMQERLsK3@corigine.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--melvyq3rlaozpvm2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Simon,

On Sun, Apr 02, 2023 at 07:02:26PM +0200, Simon Horman wrote:
> On Sun, Apr 02, 2023 at 04:30:16PM +0200, Uwe Kleine-K=F6nig wrote:
> > The function returns zero unconditionally. Change it to return void
> > instead which simplifies one caller as error handing becomes
> > unnecessary.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> ...
>=20
> > @@ -267,9 +265,7 @@ static int visconti_eth_dwmac_remove(struct platfor=
m_device *pdev)
> > =20
> >  	stmmac_pltfr_remove(pdev);
> > =20
> > -	err =3D visconti_eth_clock_remove(pdev);
> > -	if (err < 0)
> > -		dev_err(&pdev->dev, "failed to remove clock: %d\n", err);
> > +	visconti_eth_clock_remove(pdev);
> > =20
> >  	stmmac_remove_config_dt(pdev, priv->plat);
>=20
> err is now returned uninitialised by this function.

Good catch. Indeed err must be removed in this patch and return err
replaced by return 0. I'll send a v2 later this week, waiting a bit for
further feedback.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--melvyq3rlaozpvm2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmQqaZUACgkQj4D7WH0S
/k6Vggf/SvSUiYJNVJwbm16DWHGCYpXWtTC1Uback2St9/MjlFrbHyDdIhdSyHAE
pMaEIR4EwG6hnhOo3W3zHArrMWlX74bsBRHV/Fe8D7YTLmbn4Y0tdec4OnSd7JJE
bkzwDwnQlN+7TfK7coPW1ei2kuhpMWZB1KEvDsha6RLdlB+AACnmsIHEc6kfuGZ+
Oh2oXWy6VsxF/leIxrBV59vh0LrWVlQRVJioH/bdBywJY+NdRupBjiPYM38rcO45
xyle+7dB93ntVrVZt9x1XkSytkQBSh0aVzwlv3FOhsKXc8/if5F4b+8s0o780u2Y
vjkWOGjjvH9ed/uwCYH9h5tFA5hkwg==
=gDbX
-----END PGP SIGNATURE-----

--melvyq3rlaozpvm2--
