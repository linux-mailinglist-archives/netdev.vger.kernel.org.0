Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516F3438BCD
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhJXU1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhJXU1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:27:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C89BC061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:25:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mek3Z-0004WZ-8J; Sun, 24 Oct 2021 22:25:25 +0200
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B674869C4BD;
        Sun, 24 Oct 2021 18:30:38 +0000 (UTC)
Date:   Sun, 24 Oct 2021 20:30:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] can: dev: replace can_priv::ctrlmode_static by
 can_get_static_ctrlmode()
Message-ID: <20211024183007.u5pvfnlawhf36lfn@pengutronix.de>
References: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
 <20211009131304.19729-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j2t56hliosb7bl7z"
Content-Disposition: inline
In-Reply-To: <20211009131304.19729-2-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--j2t56hliosb7bl7z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.10.2021 22:13:02, Vincent Mailhol wrote:
> The statically enabled features of a CAN controller can be retrieved
> using below formula:
>=20
> | u32 ctrlmode_static =3D priv->ctrlmode & ~priv->ctrlmode_supported;
>=20
> As such, there is no need to store this information. This patch remove
> the field ctrlmode_static of struct can_priv and provides, in
> replacement, the inline function can_get_static_ctrlmode() which
> returns the same value.
>=20
> A condition sine qua non for this to work is that the controller
> static modes should never be set in can_priv::ctrlmode_supported. This
> is already the case for existing drivers, however, we added a warning
> message in can_set_static_ctrlmode() to check that.

Please make the can_set_static_ctrlmode to return an error in case of a
problem. Adjust the drivers using the function is this patch, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--j2t56hliosb7bl7z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF1piwACgkQqclaivrt
76kLnggAoub6uxZSjw+RAuu+7oCV8QIq8RMmqNioSlIxS+ioE8a8cA/UOwuIE9Er
wYCqsiSeF45Hdw+UHM7Vo97STc4P+SiKNcvvEUfcrXK0bdt2rcHeG9TvcargTm4a
RJ99/EdATlozz5r0uHElYu3jpOX9retnf8OIAVfYgqpLKhmMDE+hnI0p30TWPxqy
g65v2IZjWtkWZwuhBUbcSVn+YfgMrorzPkKCTzt01twrV4x/9o0BiqDIjK+WXzP+
5T89refE08e1sclogONO5hUaVN1aQSYm6Kni2NAJciuYhzqyLG4nJVBBBZHZxH7W
fWwvIKN4BMwvNYE5rq89gcMmFDjeDQ==
=K7iG
-----END PGP SIGNATURE-----

--j2t56hliosb7bl7z--
