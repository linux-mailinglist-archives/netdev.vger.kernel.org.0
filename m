Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEED3A5D98
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 09:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhFNHXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 03:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbhFNHXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 03:23:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3443BC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 00:21:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lsgu4-0000nB-VQ; Mon, 14 Jun 2021 09:21:01 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6e7b:8685:3f6b:e23f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0186063A84F;
        Mon, 14 Jun 2021 07:20:58 +0000 (UTC)
Date:   Mon, 14 Jun 2021 09:20:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
Message-ID: <20210614072058.syvgyz7lexexsvxp@pengutronix.de>
References: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5ebr447p5guim6g6"
Content-Disposition: inline
In-Reply-To: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5ebr447p5guim6g6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.06.2021 23:09:26, Norbert Slusarek wrote:
> From: Norbert Slusarek <nslusarek@gmx.net>
> Date: Sat, 12 Jun 2021 22:18:54 +0200
> Subject: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
>=20
> On 64-bit systems, struct bcm_msg_head has an added padding of 4 bytes be=
tween
> struct members count and ival1. Even though all struct members are initia=
lized,
> the 4-byte hole will contain data from the kernel stack. This patch zeroe=
s out
> struct bcm_msg_head before usage, preventing infoleaks to userspace.
>=20
> Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
> Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>

Added to linux-can/testing.

regards,
Marc

P.S.: I think the gmx web interface mangled the patch and converted tabs
to spaces. Try to use git send-mail to avoid this.

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5ebr447p5guim6g6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDHA1cACgkQqclaivrt
76lzmAgAmu/oSlLt0zVQ/BF31mByNd1wOeJy5J/xML2hYePIvz7/VM8JoI6s/Mkl
z77C+BrNpjgbWcFM46Z08o3KrsnpgsDRcLsYZ7BU7dXDnPLu+50uFnFFWmnNNXX6
UxRDgyTWgebq4qSpfqZOnD3ONcEg68CjvNS8WvDl7TNgmGtxR4/MhGDj256zpsKI
6X6w0kP2H1ABvADFbyzlo88VzatTQ0IeaurfXEbEoVgEz2tNusjFkP10Xtl3eGY5
SUWGQxE5eKDE5QYvHt2JPHSi5kfF/ww1bIeS8QYVZ6Wih8IBkrRGkNhrir35lhwk
x9pifhsIoGDIeakGqTX2r5YyiFvKPQ==
=TdJI
-----END PGP SIGNATURE-----

--5ebr447p5guim6g6--
