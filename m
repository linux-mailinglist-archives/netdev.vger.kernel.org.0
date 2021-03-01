Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EED4327DAB
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhCALxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbhCALwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:52:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA0AC06178B
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:51:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGh4t-0006Kn-7h; Mon, 01 Mar 2021 12:51:07 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6e66:a1a4:a449:44cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EEF755EB1B2;
        Mon,  1 Mar 2021 11:51:02 +0000 (UTC)
Date:   Mon, 1 Mar 2021 12:51:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210301115102.j5qwmiy2on3ezd4d@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-6-dariobin@libero.it>
 <20210226083315.cutpxc4iety4qedp@pengutronix.de>
 <1564374858.544328.1614507493409@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2dhc5sepxjp7dlct"
Content-Disposition: inline
In-Reply-To: <1564374858.544328.1614507493409@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2dhc5sepxjp7dlct
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.02.2021 11:18:13, Dario Binacchi wrote:
> > > +	u32 msg_obj_rx_mask;
> >=20
> > Is this variable big enough after you've extended the driver to use 64
> > mailboxes?
>=20
> Yes. I have kept the message assignment policy unchanged, they are equall=
y=20
> divided between reception and transmission. Therefore, in the case of 64=
=20
> messages, 32 are used for reception and 32 for transmission. So a 32-bit=
=20
> variable is enough.
>=20
> >=20
> > If you want to support 128 message objects converting the driver to the
> > linux bitmap API is another option.
> >=20
>=20
> Do you know if any of the hardware managed by Linux use a D_CAN controlle=
r=20
> with 128 message objects?

Even the am437x only uses 64 message objects. Ok let's stay with 64 as
max for now.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2dhc5sepxjp7dlct
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA81SMACgkQqclaivrt
76nyPQf/aaa/oKtyI9yNhbSa5NQXHNe7o/CjFKpk5OCavnNpKh0eTRSxmdip+sDT
PReCAnYwfvQAa4o2zMuW8xR4igotXas/6o2JXY/RLWmihXp3zTHVAuku0aRJlNiE
ePSAVAof3SdenghvekzLu+y7gk1qgFULQkHyp6AZxY8ABJUowTOrarK5rhD9U8xy
g8ERGLxVOObBqbDh9yEarTv0mY1PC224uZToSK4v94Bfyh4gUD97iYLknbtHdKhK
gugf8iOvLfIVB1H2EUvxWL4SzPASF/IGJCKVzyuY3HPMmt31RIGiD14yYoKqBHJB
/0yOSFgRkH6E24iHYGeP9co18gY0Bw==
=4J6b
-----END PGP SIGNATURE-----

--2dhc5sepxjp7dlct--
