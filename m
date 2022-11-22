Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50E36338B3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiKVJjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiKVJiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:38:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992C14FF9C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:38:51 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxPjp-0006Gd-Vq; Tue, 22 Nov 2022 10:38:46 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxPjn-005p9I-Of; Tue, 22 Nov 2022 10:38:44 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oxPjn-000lfQ-Uz; Tue, 22 Nov 2022 10:38:43 +0100
Date:   Tue, 22 Nov 2022 10:38:43 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, uwe@kleine-koenig.org
Subject: Re: [PATCH net-next 00/12] net: Complete conversion to i2c_probe_new
Message-ID: <20221122093843.ph5prj7thbxds5n7@pengutronix.de>
References: <20221121191546.1853970-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pckmndphi6im6mzp"
Content-Disposition: inline
In-Reply-To: <20221121191546.1853970-1-kuba@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pckmndphi6im6mzp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jakub,

On Mon, Nov 21, 2022 at 11:15:34AM -0800, Jakub Kicinski wrote:
> Reposting for Uwe the networking slice of his mega-series:
> https://lore.kernel.org/all/20221118224540.619276-1-uwe@kleine-koenig.org/
> so that our build bot can confirm the obvious.
>=20
> fix mlx5 -> mlxsw while at it.

What is the relevant difference that made the build bot consider your
resent but not my series? Is it "net-next" in the Subject?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--pckmndphi6im6mzp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmN8mKAACgkQwfwUeK3K
7AlcgQgAhsM0yRxxrMFx+bXl4n8XJRE1dU/QfeVK0WhF3PNDvSX3401aGJP2G4I/
GpisNchryy7ypTL3ByHPtx/NyesiRvZhP5ip71WircczwXCa51Cov7bbdx7EQrLQ
INvdDICs3iPRzBLdCsZ5LGF0sqvQDn1SMkjHYm/3VpXjworjTBU116Lo93hqg+ts
cGfRUZOTCg2UnylK35NGMcBy3Mkv6SQnfTx24PFU4d1AyeLnP1DsQWqWMflDGdzT
zAJ4fOp4eZ1OSvKn9+QV8jM0mmxU5b5oL250GQfbyk01YusicSDy3/oR04MyxKq4
uVRo6p2FKrRZr9TOHAsgbDJpYskFRQ==
=Nz5i
-----END PGP SIGNATURE-----

--pckmndphi6im6mzp--
