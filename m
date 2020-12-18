Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD02DE79B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 17:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbgLRQqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 11:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgLRQqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 11:46:36 -0500
Date:   Fri, 18 Dec 2020 17:45:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608309955;
        bh=LUcLD6+xoJ+9/18Np/je+aO+EdueK1jrnCWL7CGjjo8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bz9yL2l36yyZOhI4KYWT8Im349JFQ2NJ0ZElpw+lR8jOi6SuuNNnk/xI/o7q4igxD
         ZIiwG1HgwK+L3BMfdh1e5qu5u0Gu32r0fwxN1wZL8QeuMUXO4Ue731Z2AF/odMHC2b
         8DhxyL7IrZ2TgijO1I/fplOcLubFnpkpwTi7MEFAx8ed/G0/2Yv7Eu4edOB2u2NDwN
         pXgKDEt1pb4vY3hrq8qzSlcFa8EI0HbdD2STC9oFckxLkMHYUSWw0mLogi39Gs6KHb
         QN+ocb5PsU87DE4tFNafme5gMwVDqEvgESflQJInjd8Arci0OFrbNDh7ntIzs371WB
         okZKoO3BIJroA==
From:   Sebastian Reichel <sre@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix JSON pointers
Message-ID: <20201218164553.w7bof2ua5wiqkb6z@earth.universe>
References: <20201217223429.354283-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dg5hw5w5ew24qk6p"
Content-Disposition: inline
In-Reply-To: <20201217223429.354283-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dg5hw5w5ew24qk6p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 17, 2020 at 04:34:29PM -0600, Rob Herring wrote:
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

[...]

>  .../bindings/power/supply/cw2015_battery.yaml |  2 +-

[...]

> diff --git a/Documentation/devicetree/bindings/power/supply/cw2015_batter=
y.yaml b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
> index ee92e6a076ac..5fcdf5801536 100644
> --- a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
> @@ -27,7 +27,7 @@ properties:
>        of this binary blob is kept secret by CellWise. The only way to ob=
tain
>        it is to mail two batteries to a test facility of CellWise and rec=
eive
>        back a test report with the binary blob.
> -    $ref: /schemas/types.yaml#definitions/uint8-array
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
>      minItems: 64
>      maxItems: 64
> =20

[...]

Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--dg5hw5w5ew24qk6p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl/c3LsACgkQ2O7X88g7
+praeA/+JEplN0yrKaSZjyhRa+L8AyAs3C6WQ4ksz2zVeIlilm+WnXuZG5x3+VO6
FxXldTLgMRfrxBMpPgj9oOVg2zc76IsbaVlpsDqGbsV8ifuD5nt9FvSmuOeR5uyU
aiGNbjLQEHjyH15/V/C7tEZDMNPFWa4o8dG3lYodQSbL8lDRFZzMQtJHxW4MHz3L
bGc2elxpd5xSxTDvduFvTYctmVqodF5i4zYMLTJ2t3TJACuZobaZf/iPEmx123Gi
+hlGQ/Di+LjOGhuSG0pdPKnruJXXReXc7hrw06KN/GPGDJ/iwWVR3JyPyYrFhw89
gUtvqiWjQA0DDBekoRRnIDaBm1BecAYRhw9hmPU18jCKjy2HMcZ2DHF03Rgco2O8
frI94OoMjFQq5BXJzZ7b6P0ok/0uDaAszEpfIM4ovNotd4rrOS/CnPMTlCnggZkU
UYHhqFy5b1hE12rBqXmwfOneCw0vMmIu9nrlzcdZ6NAdamxIzNrdv6/WbWlt0UuI
5rkTaJikukTYVUFZqWAAknoynXpQA3SOTkr1DzADl5nIdh9odNlv9cJ2BzgOwVsE
smWm4snBldV3IvXZur2TixXk7gHZF01y6GpjEGA5mhavHSEnM8ywrbzc3uNjnntB
QcqP5pyP8iHrhASq/aVXrb1ngE/i4Rr8knU+CBxLzNvofHwhJG4=
=6J+0
-----END PGP SIGNATURE-----

--dg5hw5w5ew24qk6p--
