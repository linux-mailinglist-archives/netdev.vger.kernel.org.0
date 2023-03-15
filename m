Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25826BAF31
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCOL03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCOL0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:26:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7113910412
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:25:45 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pcPFq-0007N7-0Q; Wed, 15 Mar 2023 12:25:14 +0100
Received: from pengutronix.de (unknown [IPv6:2a00:20:3059:9eeb:8134:2053:cf60:de3a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1289F1939D4;
        Wed, 15 Mar 2023 11:25:09 +0000 (UTC)
Date:   Wed, 15 Mar 2023 12:25:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Markus Schneider-Pargmann <msp@baylibre.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: can: tcan4x5x: Add tcan4552 and
 tcan4553 variants
Message-ID: <20230315112508.6q52rekhmk66uiwj@pengutronix.de>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-2-msp@baylibre.com>
 <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xsnxip2xjomqa2cp"
Content-Disposition: inline
In-Reply-To: <680053bc-66fb-729f-ecdc-2f5fe511cecd@linaro.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xsnxip2xjomqa2cp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.03.2023 21:01:10, Krzysztof Kozlowski wrote:
> On 14/03/2023 16:11, Markus Schneider-Pargmann wrote:
> > These two new chips do not have state or wake pins.
> >=20
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > ---
> >  .../devicetree/bindings/net/can/tcan4x5x.txt          | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/D=
ocumentation/devicetree/bindings/net/can/tcan4x5x.txt
> > index e3501bfa22e9..38a2b5369b44 100644
> > --- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> > @@ -4,7 +4,10 @@ Texas Instruments TCAN4x5x CAN Controller
> >  This file provides device node information for the TCAN4x5x interface =
contains.
> > =20
> >  Required properties:
> > -	- compatible: "ti,tcan4x5x"
> > +	- compatible:
> > +		"ti,tcan4x5x" or
> > +		"ti,tcan4552" or
> > +		"ti,tcan4553"
>=20
> Awesome, they nicely fit into wildcard... Would be useful to deprecate
> the wildcard at some point and switch to proper compatibles in such
> case, because now they became confusing.

I plead for DT stability!

As I understand correctly, the exact version of the chip (4550, 4552, or
4553) can be detected via the ID2 register.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xsnxip2xjomqa2cp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQRqxEACgkQvlAcSiqK
BOghIQf/ZgV3avB8NtfGcBCaSkjb49+xElz9iVMO1MC38MLDBpE3gS6L153KLyDr
Nti7xNBDeSBDVNLtiRVAsY8YHKktFGoY48Gd7jttdEQT/eZHH9Suw0qLonmzVQvm
aHUTyNIVaQvP50l1E+SKRqprFfNRBtDT98NswxWCpPO9P+5xWUSrigH84sw+HRl1
Vc5C14Au9rOXy2hhrbNpD13HIM/IBWy1y3L+0tjPx2xIF+Rre5+59iR9qUxmvb1g
844EJUwgEEjbTP2jPztjgWAq+PReg9VuB3bv32lXBImsD0kCgFdKt0kqJ/AEWoqA
eiYFt7TUQwb5g0rJJ0wZNIFffmKs3g==
=csys
-----END PGP SIGNATURE-----

--xsnxip2xjomqa2cp--
