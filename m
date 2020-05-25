Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA71E09AC
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 11:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbgEYJHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 05:07:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57094 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388611AbgEYJHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 05:07:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 925E81C02B1; Mon, 25 May 2020 11:07:19 +0200 (CEST)
Date:   Mon, 25 May 2020 11:07:18 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        robh+dt@kernel.org, andrew@lunn.ch,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/8] dt-bindings: net: meson-dwmac: Add the
 amlogic,rx-delay-ns property
Message-ID: <20200525090718.GB16796@amd>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
 <20200512211103.530674-2-martin.blumenstingl@googlemail.com>
 <20200524212843.GF1192@bug>
 <d3f596d7-fb7f-5da7-4406-b5c0e9e9dc3f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <d3f596d7-fb7f-5da7-4406-b5c0e9e9dc3f@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > On Tue 2020-05-12 23:10:56, Martin Blumenstingl wrote:
> >> The PRG_ETHERNET registers on Meson8b and newer SoCs can add an RX
> >> delay. Add a property with the known supported values so it can be
> >> configured according to the board layout.
> >>
> >> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> >> ---
> >>  .../bindings/net/amlogic,meson-dwmac.yaml           | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac=
=2Eyaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> >> index ae91aa9d8616..66074314e57a 100644
> >> --- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> >> +++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> >> @@ -67,6 +67,19 @@ allOf:
> >>              PHY and MAC are adding a delay).
> >>              Any configuration is ignored when the phy-mode is set to =
"rmii".
> >> =20
> >> +        amlogic,rx-delay-ns:
> >> +          enum:
> >=20
> > Is it likely other MACs will need rx-delay property, too? Should we get=
 rid of the amlogic,
> > prefix?
>=20
> Yes, there are several MAC bindings that already define a delay property:
>=20
> Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml:
>      allwinner,rx-delay-ps:
> Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml:
>      allwinner,rx-delay-ps:
> Documentation/devicetree/bindings/net/apm-xgene-enet.txt:- rx-delay:
> Delay value for RGMII bridge RX clock.
> Documentation/devicetree/bindings/net/apm-xgene-enet.txt:       rx-delay
> =3D <2>;
> Documentation/devicetree/bindings/net/cavium-pip.txt:- rx-delay: Delay
> value for RGMII receive clock. Optional. Disabled if 0.
> Documentation/devicetree/bindings/net/mediatek-dwmac.txt:-
> mediatek,rx-delay-ps: RX clock delay macro value. Default is 0.
> Documentation/devicetree/bindings/net/mediatek-dwmac.txt:
> mediatek,rx-delay-ps =3D <1530>;
>=20
> standardizing on rx-delay-ps and tx-delay-ps would make sense since that
> is the lowest resolution and the property would be correctly named with
> an unit in the name.

Seems like similar patch is already being reviewed from Dan Murphy (?)
=66rom TI.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7LisYACgkQMOfwapXb+vJCzACfcW9RZlns94NhbAXsafn1CBvX
orcAoL3pNyoH5KhUL0FoV+EGTKQVEBDM
=yjue
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
