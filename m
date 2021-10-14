Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F46D42D725
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 12:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJNKbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 06:31:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50828 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhJNKbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 06:31:24 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 15E591C0B79; Thu, 14 Oct 2021 12:29:19 +0200 (CEST)
Date:   Thu, 14 Oct 2021 12:29:18 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-leds@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, robh+dt@kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: leds: Add `excludes` property
Message-ID: <20211014102918.GA21116@duo.ucw.cz>
References: <20211013204424.10961-1-kabel@kernel.org>
 <20211013204424.10961-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20211013204424.10961-2-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Some RJ-45 connectors have LEDs wired in the following way:
>=20
>          LED1
>       +--|>|--+
>       |       |
>   A---+--|<|--+---B
>          LED2
>=20
> With + on A and - on B, LED1 is ON and LED2 is OFF. Inverting the
> polarity turns LED1 OFF and LED2 ON.
>=20
> So these LEDs exclude each other.
>=20
> Add new `excludes` property to the LED binding. The property is a
> phandle-array to all the other LEDs that are excluded by this LED.

I don't think this belongs to the LED binding.

This is controller limitation, and the driver handling the controller
needs to know about it... so it does not need to learn that from the
LED binding.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYWgGfgAKCRAw5/Bqldv6
8tjGAKDEHgctZRD6mG5vf+QZs7ZcN+C3dQCbBqfqtZ5W+LSbVcGqw2RcIVq9FPk=
=HXa9
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
