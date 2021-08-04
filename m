Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593363DFE1A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhHDJhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbhHDJhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 05:37:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D91C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 02:37:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDLA-0007Kc-2b; Wed, 04 Aug 2021 11:37:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F41AD660729;
        Wed,  4 Aug 2021 09:37:29 +0000 (UTC)
Date:   Wed, 4 Aug 2021 11:37:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH 3/4] can: c_can: support tx ring algorithm
Message-ID: <20210804093728.2pultlrysir4ffus@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-4-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cu4kdv4e2mm6hznx"
Content-Disposition: inline
In-Reply-To: <20210725161150.11801-4-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cu4kdv4e2mm6hznx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2021 18:11:49, Dario Binacchi wrote:
> The algorithm is already used successfully by other CAN drivers
> (e.g. mcp251xfd). Its implementation was kindly suggested to me by
> Marc Kleine-Budde following a patch I had previously submitted. You can
> find every detail at https://lore.kernel.org/patchwork/patch/1422929/.
>=20
> The idea is that after this patch, it will be easier to patch the driver
> to use the message object memory as a true FIFO.
>=20
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Dario Binacchi <dariobin@libero.it>

With the proposed change (see other mail). Looks good to me!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cu4kdv4e2mm6hznx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKX9YACgkQqclaivrt
76mx0QgAk0nOAIUFMHIVATu2mxaFB0Km6vsi4vVvQmw4eKKRXkiEwF/Wnip/ud0C
PBErWykKOeoUr5eNRsV08rrgkxXh2q0nFZqlmIPSPOTDAuZ2NslcnaKhqC7pzVGz
3x31mkUKjuucJufpj+FEeFB7yu8+6Ml9BY1EevYw2qJHBUB/Sk6xmMVTQcwTrWcI
HPK5hY0dhvhHfEv10wyW49pPfo4ETdug6T0safVXzbI/66cI8acYytTvRD7XRYOp
JPo8NehsVFUMybVC7BQkk7bGugACyLp5TA0KcoTOYAzRL4JoddVaez+gRSZCfHUB
YNo9Enqximm0HX5sZjicccjFzerhaw==
=YDKp
-----END PGP SIGNATURE-----

--cu4kdv4e2mm6hznx--
