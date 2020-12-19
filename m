Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2F12DF0C1
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 18:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgLSRup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 12:50:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48894 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgLSRuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 12:50:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 952E11C0B77; Sat, 19 Dec 2020 18:49:46 +0100 (CET)
Date:   Sat, 19 Dec 2020 18:49:45 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix JSON pointers
Message-ID: <20201219174945.GA25643@amd>
References: <20201217223429.354283-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20201217223429.354283-1-robh@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-12-17 16:34:29, Rob Herring wrote:
> The correct syntax for JSON pointers begins with a '/' after the '#'.
> Without a '/', the string should be interpretted as a subschema
> identifier. The jsonschema module currently doesn't handle subschema
> identifiers and incorrectly allows JSON pointers to begin without a '/'.
> Let's fix this before it becomes a problem when jsonschema module is
> fixed.
>=20
> Converted with:
> perl -p -i -e 's/yaml#definitions/yaml#\/definitions/g' `find Documentati=
on/devicetree/bindings/ -name "*.yaml"`
>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
http://www.livejournal.com/~pavelmachek

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/ePTgACgkQMOfwapXb+vIsEwCgoqapZig1frJsLt79Dd1jHccN
75EAoLe+6pWK3uzfpcvabTuRJpWKz3ku
=1T8V
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
