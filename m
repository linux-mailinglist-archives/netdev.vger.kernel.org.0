Return-Path: <netdev+bounces-8024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7BF722752
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCBA71C20BC4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339ED19E7B;
	Mon,  5 Jun 2023 13:26:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C48B6FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99161C433D2;
	Mon,  5 Jun 2023 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685971588;
	bh=7jvreSULTAW1dgm4KKjWd49Rumkiyi/ADlztxfIhpqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HSEWBQul/ibrJpxuKnHrM7PPPXULYqwQlh5aV06gtYuVUvbxKx6PdKk5az5fgPOiR
	 BVyoo7rT18zK9a6IWqdL5S7mllk2X18C5e0HKYhEa0cSzYfeuMopM0QqE0ZP6OskmM
	 SaQ1OGLILhXFBDTBOeOg367JhaCMWIXVEfj16Y0FfMeGJVJCr/0x/9WqokCPL2/SDZ
	 eSm9+SV7YKGrO2UVTxaQ4W8Hn5YMPXij2cm1dE5oOX/+8RrmfIvnd5j6agybPbasMZ
	 pq5QS+KrgPJJCDJ4eLHdMtOYs+RmNENiEPsAr8QCGwyOqMPJVGO6wHQuk427NlrTCd
	 D3/M7E2/NreIA==
Date: Mon, 5 Jun 2023 14:26:19 +0100
From: Conor Dooley <conor@kernel.org>
To: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Varshini Rajendran <varshini.rajendran@microchip.com>,
	tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, gregkh@linuxfoundation.org,
	linux@armlinux.org.uk, mturquette@baylibre.com, sboyd@kernel.org,
	sre@kernel.org, broonie@kernel.org, arnd@arndb.de,
	gregory.clement@bootlin.com, sudeep.holla@arm.com,
	balamanikandan.gunasundar@microchip.com, mihai.sain@microchip.com,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, Hari.PrasathGE@microchip.com,
	cristian.birsan@microchip.com, durai.manickamkr@microchip.com,
	manikandan.m@microchip.com, dharma.b@microchip.com,
	nayabbasha.sayed@microchip.com, balakrishnan.s@microchip.com
Subject: Re: [PATCH 17/21] power: reset: at91-poweroff: lookup for proper pmc
 dt node for sam9x7
Message-ID: <20230605-sedan-gimmick-6381f121cc0a@spud>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-18-varshini.rajendran@microchip.com>
 <2a538004-351f-487a-361c-df723d186c27@linaro.org>
 <c3f7c08f-272a-5abb-da78-568c408f40de@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qGD4Ahe9OQYksAQU"
Content-Disposition: inline
In-Reply-To: <c3f7c08f-272a-5abb-da78-568c408f40de@microchip.com>


--qGD4Ahe9OQYksAQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Mon, Jun 05, 2023 at 03:04:34PM +0200, Nicolas Ferre wrote:
> On 05/06/2023 at 08:43, Krzysztof Kozlowski wrote:
> > On 03/06/2023 22:02, Varshini Rajendran wrote:
> > > Use sam9x7 pmc's compatible to lookup for in the SHDWC driver
> > >=20
> > > Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> > > ---
> > >   drivers/power/reset/at91-sama5d2_shdwc.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/drivers/power/reset/at91-sama5d2_shdwc.c b/drivers/power=
/reset/at91-sama5d2_shdwc.c
> > > index d8ecffe72f16..d0f29b99f25e 100644
> > > --- a/drivers/power/reset/at91-sama5d2_shdwc.c
> > > +++ b/drivers/power/reset/at91-sama5d2_shdwc.c
> > > @@ -326,6 +326,7 @@ static const struct of_device_id at91_pmc_ids[] =
=3D {
> > >        { .compatible =3D "atmel,sama5d2-pmc" },
> > >        { .compatible =3D "microchip,sam9x60-pmc" },
> > >        { .compatible =3D "microchip,sama7g5-pmc" },
> > > +     { .compatible =3D "microchip,sam9x7-pmc" },
> >=20
> > Why do you need new entry if these are compatible?
>=20
> Yes, PMC is very specific to a SoC silicon. As we must look for it in the
> shutdown controller, I think we need a new entry here.

Copy-pasting this for a wee bit of context as I have two questions.

| static const struct of_device_id at91_shdwc_of_match[] =3D {
| 	{
| 		.compatible =3D "atmel,sama5d2-shdwc",
| 		.data =3D &sama5d2_reg_config,
| 	},
| 	{
| 		.compatible =3D "microchip,sam9x60-shdwc",
| 		.data =3D &sam9x60_reg_config,
| 	},
| 	{
| 		.compatible =3D "microchip,sama7g5-shdwc",
| 		.data =3D &sama7g5_reg_config,
| 	}, {
| 		/*sentinel*/
| 	}
| };
| MODULE_DEVICE_TABLE(of, at91_shdwc_of_match);
|=20
| static const struct of_device_id at91_pmc_ids[] =3D {
| 	{ .compatible =3D "atmel,sama5d2-pmc" },
| 	{ .compatible =3D "microchip,sam9x60-pmc" },
| 	{ .compatible =3D "microchip,sama7g5-pmc" },
| 	{ .compatible =3D "microchip,sam9x7-pmc" },
| 	{ /* Sentinel. */ }
| };

If there's no changes made to the code, other than adding an entry to
the list of pmc compatibles, then either this has the same as an
existing SoC, or there is a bug in the patch, since the behaviour of
the driver will not have changed.

Secondly, this patch only updates the at91_pmc_ids and the dts patch
contains:
| shutdown_controller: shdwc@fffffe10 {
| 	compatible =3D "microchip,sam9x60-shdwc";
| 	reg =3D <0xfffffe10 0x10>;
| 	clocks =3D <&clk32k 0>;
| 	#address-cells =3D <1>;
| 	#size-cells =3D <0>;
| 	atmel,wakeup-rtc-timer;
| 	atmel,wakeup-rtt-timer;
| 	status =3D "disabled";
| };

=2E..which would mean that the there's nothing different between the
programming models for the sam9x60 and sam9x7. If that's the case, the
dt-binding & dts should list the sam9x60 as a fallback for the sam9x7 &
there is no change required to the driver. If it's not the case, then
there's a bug in this patch and the dts one :)

In general, if things are the same as previous products, there's no need
to change the drivers at all & just add fallback compatibles to the
bindings and dts. IFF some difference pops up in the future, then the
sam9x7 compatible will already exist in the dts, and can then be added
to the driver.

Cheers,
Conor.


--qGD4Ahe9OQYksAQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZH3iZQAKCRB4tDGHoIJi
0k26AQCR+FNf+yO4bvvxn9btScRrtb3+MomV/4TeUvmr9kGqvgEAmNYYoMHrjOWk
oCe+utfYdl8cSw8Jvst3LU6J2uVlQQI=
=nGf/
-----END PGP SIGNATURE-----

--qGD4Ahe9OQYksAQU--

