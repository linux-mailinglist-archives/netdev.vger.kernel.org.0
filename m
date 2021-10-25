Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E6043974D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhJYNQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhJYNQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:16:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CC5C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 06:14:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mezo0-0001ED-JF; Mon, 25 Oct 2021 15:14:24 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-d7c8-7df6-a4ac-55f0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d7c8:7df6:a4ac:55f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DE5D269D683;
        Mon, 25 Oct 2021 13:14:23 +0000 (UTC)
Date:   Mon, 25 Oct 2021 15:14:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can <linux-can@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <20211025131423.q2o6oybl5mj5rq6x@pengutronix.de>
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
 <YXaimhlXkpBKRQin@lunn.ch>
 <20211025124331.d7r7qbadkzfk7i4f@pengutronix.de>
 <YXaqEk97/WcCxcFE@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lvk2bzg6xv455nw4"
Content-Disposition: inline
In-Reply-To: <YXaqEk97/WcCxcFE@lunn.ch>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lvk2bzg6xv455nw4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2021 14:58:58, Andrew Lunn wrote:
> > > struct ethtool_kringparam {
> > > 	__u32	cmd;
> > > 	__u32   mode;
> > > 	__u32	rx_max_pending;
> > > 	__u32	rx_mini_max_pending;
> > > 	__u32	rx_jumbo_max_pending;
> > > 	__u32	tx_max_pending;
> > > 	__u32	rx_pending;
> > > 	__u32	rx_mini_pending;
> > > 	__u32	rx_jumbo_pending;
> > > 	__u32	tx_pending;
> > > };
> > >=20
> > > and use this structure between the ethtool core and the drivers. This
> > > has already been done at least once to allow extending the
> > > API. Semantic patches are good for making the needed changes to all
> > > the drivers.
> >=20
> > What about the proposed "two new parameters ringparam_ext and extack for
> > .get_ringparam and .set_ringparam to extend more ring params through
> > netlink." by Hao Chen/Guangbin Huang in:
> >=20
> > https://lore.kernel.org/all/20211014113943.16231-5-huangguangbin2@huawe=
i.com/
> >
> > I personally like the conversion of the in in-kernel API to struct
> > ethtool_kringparam better than adding ringparam_ext.
>=20
> Ah, i missed that development. I don't like it.
>=20
> You should probably jump into that discussion and explain your
> requirements. Make sure it is heading in a direction you can extend
> for your needs.

Will do. I've added you on Cc.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lvk2bzg6xv455nw4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2rawACgkQqclaivrt
76l8rAf/ftPf0PHIfUtxgi1pSTEEL6t7HS8unn423bD847e5gsylA7rl44f3Xwrr
7EPEVSbTvD9Nvso1qDqaSuRmO12XPhSfGQVmtKVZEwk1BOLugazaj7JlT+6WM09D
vTujgno9eVMirZDSiyqFFh/hO48Z6icJRnwWP4mbQwJzn6pktZuh8fDfTfcP5Bv4
Jt9xkQW+do/Cpq/Dd1CZY/a58gW8C8O5klLjAEjv5HJP3j54zjyPxw588U9pTrv5
G0uv31zLEklUpmy7lx9Ud8i111Uo5LHqXHOPPw9slkwVssE6t9RRYCmAaOxSl/j/
n3pYkvxfOvbZhkEAS32nbYTnUpE71A==
=0Qqn
-----END PGP SIGNATURE-----

--lvk2bzg6xv455nw4--
