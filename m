Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4714BF9C4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiBVNtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiBVNs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:48:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1021B7C67
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:48:30 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nMVWd-0001Dt-9Y; Tue, 22 Feb 2022 14:48:19 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-1557-4bd7-bf13-be70.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:1557:4bd7:bf13:be70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AD67E3A83C;
        Tue, 22 Feb 2022 13:48:16 +0000 (UTC)
Date:   Tue, 22 Feb 2022 14:48:16 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH] can: rcar_canfd: Register the CAN device when fully ready
Message-ID: <20220222134816.35ny6t5cdsvhvii6@pengutronix.de>
References: <20220221225935.12300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20220222134358.GA7037@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3z4alxagzctmwssi"
Content-Disposition: inline
In-Reply-To: <20220222134358.GA7037@duo.ucw.cz>
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


--3z4alxagzctmwssi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.02.2022 14:43:58, Pavel Machek wrote:
> On Mon 2022-02-21 22:59:35, Lad Prabhakar wrote:
> > Register the CAN device only when all the necessary initialization
> > is completed. This patch makes sure all the data structures and locks a=
re
> > initialized before registering the CAN device.
>=20
> Reviewed-by: Pavel Machek <pavel@denx.de>
>=20
> I guess it will go to mainline and then -stable so that we don't have
> to do anything special?

ACK

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3z4alxagzctmwssi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIU6Z0ACgkQrX5LkNig
011hDAf/aReUn3ah3dFZrZofsymFFwAOExW572D7xSVj5799brs9K2Fqx7+rlVZL
V3iJSvXWOen6IEDyLGtT5UUv+KSGIa+nfir7J6XYyABWOfq+vaGz0PSbguxDqciE
YWWvkVb5u1wvIkkdbPtW6/PkgExc28sOKS8dSVt0s1McQzK5VcrItWShhLF5wMC2
pjY9u3SUR8OMKpbacjP429FLt+JHJaMvn+ahW1Y96QCmyVoxfdAK48uNiCG6Crw7
u91y2GCeEcLa+Zr3HFNMYEikV3BaMHp2a/A6wpySqKo5TeBvU7hbLRx5SIa1Vlr3
PkMJI2gcH3tiVMos4xjfBRyzKCfuqQ==
=T5jZ
-----END PGP SIGNATURE-----

--3z4alxagzctmwssi--
