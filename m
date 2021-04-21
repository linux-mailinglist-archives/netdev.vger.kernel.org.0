Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA483665C7
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhDUG7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDUG7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:59:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A58C06138B
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 23:59:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lZ6pC-0008ER-0X; Wed, 21 Apr 2021 08:59:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:f256:d952:a8:74c8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DD8AD612D81;
        Wed, 21 Apr 2021 06:58:57 +0000 (UTC)
Date:   Wed, 21 Apr 2021 08:58:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Erik Flodin <erik@flodin.me>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] can: add a note that RECV_OWN_MSGS frames are subject to
 filtering
Message-ID: <20210421065857.rliinkphrzrllkci@pengutronix.de>
References: <20210420191212.42753-1-erik@flodin.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7jj7b47l3flytpb2"
Content-Disposition: inline
In-Reply-To: <20210420191212.42753-1-erik@flodin.me>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7jj7b47l3flytpb2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.04.2021 21:12:00, Erik Flodin wrote:
> Some parts of the documentation may lead the reader to think that the
> socket's own frames are always received when CAN_RAW_RECV_OWN_MSGS is
> enabled, but all frames are subject to filtering.
>=20
> As explained by Marc Kleine-Budde:
>=20
> On TX complete of a CAN frame it's pushed into the RX path of the
> networking stack, along with the information of the originating socket.
>=20
> Then the CAN frame is delivered into AF_CAN, where it is passed on to
> all registered receivers depending on filters. One receiver is the
> sending socket in CAN_RAW. Then in CAN_RAW the it is checked if the
> sending socket has RECV_OWN_MSGS enabled.
>=20
> Signed-off-by: Erik Flodin <erik@flodin.me>

Applied to linux-can-next/testing

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7jj7b47l3flytpb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB/zS4ACgkQqclaivrt
76nMbAf/RpY8aEaWPpzJlUX8s9lLdi1bCLXcdQIsemiUny7GFT230Mnyx+7CusZW
n9oFINWwLdvtDbDdemN0kNHx+d61dU8NJhSSf0IDRHhUBTMI/wpnOegh8trz786L
skedUxSmsPvDfK8ecubT31GLV62v1VsHUUqaLHJd7ETQXdwmjIU/uxghQiLG82D5
0J4MIuOlReUAJ4iFcjw9QUAq/k3p53yI/lqwcX0B6vmgfxnLYXfHV6ilCXpOuhEh
bvM4cAMD1Adg6ySnrAs8+1YVftCqyeN97StTmGJ6bzdwpOvrUZOhjhaJ+xtOzwRT
BOAMNhV59lddut8/RoG36A+QhQPzBw==
=bc3f
-----END PGP SIGNATURE-----

--7jj7b47l3flytpb2--
