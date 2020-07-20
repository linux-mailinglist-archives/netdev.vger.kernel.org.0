Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF62225D41
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgGTLRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:17:09 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40780 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgGTLRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:17:08 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E3C261C0BE5; Mon, 20 Jul 2020 13:17:05 +0200 (CEST)
Date:   Mon, 20 Jul 2020 13:17:05 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next 2/3] leds: trigger: return error
 value if .activate() failed
Message-ID: <20200720111705.GA12916@amd>
References: <20200716171730.13227-1-marek.behun@nic.cz>
 <20200716171730.13227-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20200716171730.13227-3-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Currently when the .activate() method fails and returns a negative error
> code while writing to the /sys/class/leds/<LED>/trigger file, the write
> system call does not inform the user abouth this failure.
>=20
> This patch fixes this.
>=20
> Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>
> ---
>  drivers/leds/led-triggers.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 81e758d5a048..804e0d624f47 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -40,7 +40,7 @@ ssize_t led_trigger_write(struct file *filp, struct kob=
ject *kobj,
>  	struct device *dev =3D kobj_to_dev(kobj);
>  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
>  	struct led_trigger *trig;
> -	int ret =3D count;
> +	int ret;
>

Please check the code. AFAICT you need ret =3D 0 here.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8VfTEACgkQMOfwapXb+vIcJgCdHh0TI1uzEPqwM776e4oRvh/M
lNIAnA+KGNxSvpVuUFcl2Z9hP8ZQhxBM
=thG+
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
