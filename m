Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCFA2C3E9B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 12:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgKYK6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:58:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37066 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKYK6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:58:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C89711C0B7D; Wed, 25 Nov 2020 11:57:58 +0100 (CET)
Date:   Wed, 25 Nov 2020 11:57:57 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev <netdev@vger.kernel.org>, linux-leds@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20201125105757.GF25562@amd>
References: <20200927004025.33c6cfce@nic.cz>
 <20200927025258.38585d5e@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GV0iVqYguTV4Q9ER"
Content-Disposition: inline
In-Reply-To: <20200927025258.38585d5e@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GV0iVqYguTV4Q9ER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > What I am wondering is how should we select a name for the device part
> > of the LED for network devices, when network namespaces are enabled.
> >=20
> > a) We could just use the interface name (eth0:yellow:activity). The
> >    problem is what should happen when the interface is renamed, or
> >    moved to another network namespace.
> >    Pavel doesn't want to complicate the LED subsystem with LED device
> >    renaming, nor, I think, with namespace mechanism. I, for my part, am
> >    not opposed to LED renaming, but do not know what should happen when
> >    the interface is moved to another namespace.
> >=20
> > b) We could use the device name, as in struct device *. But these names
> >    are often too long and may contain characters that we do not want in
> >    LED name (':', or '/', for example).
> >
> > c) We could create a new naming mechanism, something like
> >    device_pretty_name(dev), which some classes may implement somehow.
> >=20
> > What are your ideas about this problem?
>=20
> BTW option b) and c) can be usable if we create a new utility, ledtool,
> to report infromation about LEDs and configure LEDs.
>=20
> In that case it does not matter if the LED is named
>   ethernet-adapter0:red:activity
> or
>   ethernet-phy0:red:activity

Or simply ethernet0:... or ether0:... I'd avoid using eth0 to make it
clear that this is different namespace from ethX.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--GV0iVqYguTV4Q9ER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl++OLUACgkQMOfwapXb+vJRwACeOs8CHFEX3LHMVsuVyZMRrle9
HnoAoIsTx4vpQDFVGqMs7hFYKO7T8Sp4
=p60e
-----END PGP SIGNATURE-----

--GV0iVqYguTV4Q9ER--
