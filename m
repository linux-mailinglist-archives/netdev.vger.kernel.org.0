Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7B69ABFA
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjBQM4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBQM4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:56:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED841717E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:56:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pT0I3-0000xm-18; Fri, 17 Feb 2023 13:56:39 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:f841:9dc3:753d:4a94])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 449BA17C056;
        Fri, 17 Feb 2023 12:56:38 +0000 (UTC)
Date:   Fri, 17 Feb 2023 13:56:36 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] pull-request: can-next 2023-02-17
Message-ID: <20230217125636.nyxws5dawyht5hqy@pengutronix.de>
References: <20230217123311.3713766-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tpcg7d6rabzbkwcm"
Content-Disposition: inline
In-Reply-To: <20230217123311.3713766-1-mkl@pengutronix.de>
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


--tpcg7d6rabzbkwcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.02.2023 13:33:08, Marc Kleine-Budde wrote:
> Hello netdev-team,
>=20
> this is a pull request of 4 patches for net-next/master.

Please ignore - Somehow this was send without finishing....

Sorry for the noise.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tpcg7d6rabzbkwcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPveYEACgkQvlAcSiqK
BOghygf8C8WFjkCUlLtvUPpsepVbMPnitG+uR2pGmYyMgq2Y6FRuTDoQ8B/RcHnI
WFqdS8ifgN3hhneyoCx/n7pETazpD4WcMC4T0njJu1dUuHkZu4FX3x+xfbWsNIUq
RJkaxWb1+6r1gOG8oQCWN1U6w2yWAOMh6qAsPu8J9cy7WjuNnn58betvAJMnhmm3
qE/yZVh0jha/g5GkIIxF3XMmmdmpGvVN4hZL9R29Vwh84L4sQTt4G2Jb+MBLyv+d
c9vcwV8MkoVSKad/UIXuhKA/Gt3GSfvae8q6pNAvuro4MIJQaLbvS+S6G39E+7rk
Fz+wMN0aAlmwYmW+/HeWF+X3IMhcdg==
=fgdH
-----END PGP SIGNATURE-----

--tpcg7d6rabzbkwcm--
