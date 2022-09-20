Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FE05BEDB9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiITT1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiITT1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:27:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1101554CBF
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 12:27:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaith-0007TS-Kv; Tue, 20 Sep 2022 21:27:09 +0200
Received: from pengutronix.de (hardanger-2.fritz.box [IPv6:2a03:f580:87bc:d400:2544:bef8:ba12:489b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6131FE7BE1;
        Tue, 20 Sep 2022 19:27:08 +0000 (UTC)
Date:   Tue, 20 Sep 2022 21:27:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net 0/17] pull-request: can 2022-09-20
Message-ID: <20220920192708.jcvyph3ec7lscuqj@pengutronix.de>
References: <20220920092915.921613-1-mkl@pengutronix.de>
 <20220920122246.00dbe946@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="afkmxdtmecqnwbxi"
Content-Disposition: inline
In-Reply-To: <20220920122246.00dbe946@kernel.org>
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


--afkmxdtmecqnwbxi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.09.2022 12:22:46, Jakub Kicinski wrote:
> On Tue, 20 Sep 2022 11:28:58 +0200 Marc Kleine-Budde wrote:
> > The next 15 patches are by Anssi Hannula and Jimmy Assarsson and fix
> > various problem in the kvaser_usb CAN driver.
>=20
> These are large patches which don't clearly justify the classification
> as a fix. Patches 6 and 8 for example leave me asking "what does this
> fix?" It's good to report errors, but the absence of error reporting
> is not necessarily a bug worthy of stable.
>=20
> Can we get the commit messages beefed up?

I'll talk to the authors, try to get better commit messages and distill
the minimum patches the need to be ported to stable.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--afkmxdtmecqnwbxi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMqFAkACgkQrX5LkNig
010/7gf/VFgqJZbWwkZeVtMmNgoy+vcLiF2k2+IuQF0XAYh9UI18DPFFba+TjXbI
X2baZxZkqZyXSRrtrnKBAMd3SP/t5M+GWiChEl38Rbeiu8vW95Eo40Y5XUlJ3hdm
TEoUe5Qq2Z4m7jJFX27u7eI+fBaAevRrd0hqHfD+AHReGrWCJNdt7cUNG3QVRfxG
rXUM8WNP/iaw4vUiOw67tGibozlkT8GFRmokF/5plXYmkK00uYPKMP5mNfRsJqwU
hUjRjhhaVdetpKAHCm+TpRgfTAyDVCPdTkqycZMQ8IcrYoY9OX9Qj9+zJ+sKEfpU
cspByqXiK92PyeO7l3LfMHUJ2FToig==
=xsIP
-----END PGP SIGNATURE-----

--afkmxdtmecqnwbxi--
