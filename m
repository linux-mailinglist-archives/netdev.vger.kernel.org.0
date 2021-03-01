Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDAD327C65
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhCAKkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:40:41 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55612 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbhCAKjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:39:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 114CA1C0B76; Mon,  1 Mar 2021 11:38:53 +0100 (CET)
Date:   Mon, 1 Mar 2021 11:38:52 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 3/7] leds: trigger: add API for HW
 offloading of triggers
Message-ID: <20210301103852.GB31897@duo.ucw.cz>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20201030114435.20169-4-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> If the trigger with given configuration cannot be offloaded, the method
> should return -EOPNOTSUPP, in which case the trigger must blink the LED
> in SW.
>=20
> Signed-off-by: Marek Beh=FAn <kabel@kernel.org>

> +
> +If the second argument (enable) to the trigger_offload() method is false=
, any
> +active HW offloading must be deactivated.

Are errors permitted in the "disable" case?

> +static inline void led_trigger_offload_stop(struct led_classdev *led_cde=
v)
> +{
> +	if (!led_cdev->trigger_offload)
> +		return;
> +
> +	if (led_cdev->offloaded)
> +		led_cdev->trigger_offload(led_cdev, false);
> +}

Set offloaded to false?

Let me check the rest to decide if this makes sense.

Best regards,
									Pavel

--=20
http://www.livejournal.com/~pavelmachek

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDzEPAAKCRAw5/Bqldv6
8nF+AJ0dEgQX8EyDrYeYcGLpQlphEAh3zgCgp/ylg5hBQbtC9IOIH5n1CYp7fW0=
=lg9m
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
